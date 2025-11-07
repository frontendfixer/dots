#!/usr/bin/env bash

# Define colors for output
R='\033[0;31m' # Red
G='\033[0;32m' # Green
Y='\033[0;33m' # Yellow
B='\033[0;34m' # Blue
N='\033[0m'    # No Color

# Check for root privileges early
if [ "$EUID" -ne 0 ]; then
  echo -e "${R}This script must be run with root privileges (or via sudo) to modify /etc/fstab and create mount points.${N}"
  echo -e "Please run: ${G}sudo bash $0${N}"
  exit 1
fi

# Check for jq (optional but highly recommended)
if ! command -v jq &> /dev/null; then
    echo -e "${R}Error: 'jq' is not installed. Please install 'jq' to run this script (e.g., sudo pacman -Syu jq).${N}"
    exit 1
fi

# ====================================================================
# 1. SCAN AND SELECT DRIVE
# ====================================================================

echo -e "${G}############### 1. Disk Selection ############${N}"
echo -e "${Y}Scanning available non-mounted disk partitions...${N}"

# 1. Use a custom separator (|) in jq output to prevent 'select' splitting fields.
# 2. Use the simpler, corrected filter.
DRIVE_LIST=$(lsblk -o NAME,UUID,FSTYPE,SIZE,MOUNTPOINT -J | jq -r '.blockdevices[].children[] | select(.mountpoint == null) | "\(.name)|\(.uuid)|\(.fstype)|\(.size)"')

if [ -z "$DRIVE_LIST" ]; then
    echo -e "${R}No unmounted disk partitions found to configure. Exiting.${N}"
    exit 0
fi

# Build an array and display the indexed list
declare -a DRIVES=()
SAVEIFS=$IFS
IFS=$'\n' # Set Internal Field Separator to newline for safe line reading

# Populate DRIVES array and print menu
INDEX=1
for LINE in $DRIVE_LIST; do
    DRIVES+=("$LINE")
    # Separate the fields for display, using cut to replace the pipe with spaces
    DISPLAY_LINE=$(echo "$LINE" | tr '|' '\t')
    echo -e "${B}$INDEX) $DISPLAY_LINE${N}"
    ((INDEX++))
done

IFS=$SAVEIFS # Restore original IFS

# Get user input for selection index
while true; do
    echo -e "\n${Y}Enter the number of the partition to mount (1-${#DRIVES[@]}):${N}"
    read -r SELECTION_INDEX

    if [[ "$SELECTION_INDEX" =~ ^[0-9]+$ ]] && [ "$SELECTION_INDEX" -ge 1 ] && [ "$SELECTION_INDEX" -le ${#DRIVES[@]} ]; then
        SELECTED_LINE="${DRIVES[SELECTION_INDEX-1]}"
        break
    else
        echo -e "${R}Invalid number. Please enter a number between 1 and ${#DRIVES[@]}.${N}"
    fi
done

# Parse the selected line using the pipe delimiter
IFS='|' read -r DEV_NAME UUID FSTYPE SIZE <<< "$SELECTED_LINE"
IFS=$' \t\n' # Reset IFS for normal command execution

DEV_PATH="/dev/$DEV_NAME"

echo -e "\n${G}Selected Device:${N} $DEV_PATH"
echo -e "${G}UUID:${N} $UUID"
echo -e "${G}Filesystem Type:${N} $FSTYPE"

# ====================================================================
# 2. CREATE MOUNT POINT
# ====================================================================

echo -e "\n${G}############### 2. Mount Point Setup ############${N}"

while true; do
   echo -e "${Y}Enter the name for the new mount folder inside /mnt/ (e.g., 'data' or 'backup'):${N}"
    read -r FOLDER_NAME

    if [ -z "$FOLDER_NAME" ]; then
        echo -e "${R}Folder name cannot be empty. Please try again.${N}"
    elif [[ "$FOLDER_NAME" =~ [^a-zA-Z0-9_-] ]]; then
        echo -e "${R}Folder name contains invalid characters. Use letters, numbers, hyphens, or underscores.${N}"
    else
        MOUNT_POINT="/mnt/$FOLDER_NAME"
        if [ -d "$MOUNT_POINT" ]; then
            echo -e "${R}Directory $MOUNT_POINT already exists. Choose a different name.${N}"
        else
            break
        fi
    fi
done

echo -e "${Y}Creating mount point: $MOUNT_POINT${N}"
mkdir -p "$MOUNT_POINT"

# 🔑 CRITICAL FIX: Ensure ownership is set to the user running the script via sudo ($SUDO_USER).
# If SUDO_USER is empty (i.e., script was run directly by root), default to $USER.
OWNER="${SUDO_USER:-$USER}"

echo -e "${Y}Setting ownership of $MOUNT_POINT to $OWNER...${N}"
chown "$OWNER":"$OWNER" "$MOUNT_POINT"

# Setting universal permissions for the mount point
chmod 775 "$MOUNT_POINT"

# ====================================================================
# 3. CONFIGURE FSTAB AND MOUNT
# ====================================================================

echo -e "\n${G}############### 3. fstab Configuration ############${N}"

# Get the UID/GID of the user running the script
USER_UID=$(id -u "$OWNER")
USER_GID=$(id -g "$OWNER")


# Determine optimal fstab options based on filesystem type
case "$FSTYPE" in
    ext4|btrfs)
        # For Linux filesystems, ownership is handled by chown above.
        FSTAB_OPTIONS="defaults,noatime,errors=remount-ro"
        ;;
    ntfs|ntfs-3g)
        # Use $USER_UID and $USER_GID for non-Linux filesystems
        FSTYPE="ntfs-3g"
        FSTAB_OPTIONS="defaults,uid=$USER_UID,gid=$USER_GID,umask=0022"
        ;;
    vfat|fat32)
        # Use $USER_UID and $USER_GID for non-Linux filesystems
        FSTAB_OPTIONS="defaults,uid=$USER_UID,gid=$USER_GID,umask=0022,utf8"
        ;;
    *)
        FSTAB_OPTIONS="defaults"
        ;;
esac

FSTAB_ENTRY="UUID=$UUID\t$MOUNT_POINT\t$FSTYPE\t$FSTAB_OPTIONS\t0\t2"

echo -e "${B}fstab Entry to be added:${N}"
echo -e "$FSTAB_ENTRY"

# Confirmation before modifying fstab
read -r -p "Confirm adding this entry to /etc/fstab and attempting a mount? (Y/n): " confirm_fstab

if [[ "$confirm_fstab" =~ ^[Yy]$ || -z "$confirm_fstab" ]]; then
    echo -e "$FSTAB_ENTRY" | tee -a /etc/fstab > /dev/null
    echo -e "${G}/etc/fstab updated successfully.${N}"

    # Attempt to mount the drive immediately
    echo -e "${Y}Attempting to mount the drive now...${N}"
    mount "$MOUNT_POINT"

    if [ $? -eq 0 ]; then
        echo -e "${G}Drive mounted successfully at $MOUNT_POINT.${N}"
        echo -e "${G}Configuration complete! The drive will remount automatically on boot.${N}"
    else
        echo -e "${R}Error mounting the drive. Check the fstab entry and permissions.${N}"
        echo "You may need to install the necessary filesystem tools (e.g., ${Y}ntfs-3g${N})."
        exit 1
    fi
else
    echo -e "${R}/etc/fstab modification canceled. Exiting.${N}"
    exit 0
fi

exit 0