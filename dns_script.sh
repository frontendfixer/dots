#!/usr/bin/env bash

# Define colors for output
R='\033[0;31m' # Red
G='\033[0;32m' # Green
Y='\033[0;33m' # Yellow
N='\033[0m'    # No Color

# ====================================================================
# 1. MAIN EXECUTION
# ====================================================================

echo -e "${G}############### Starting DNS Setup ############${N}"

# --- Get User Input ---
echo -e "${Y}Please enter your NextDNS Configuration ID (e.g., abcd12):${N}"
read -r NEXTDNS_ID

# Validation
if [ -z "$NEXTDNS_ID" ]; then
    echo -e "${R}Error: NextDNS ID cannot be empty. Aborting DNS configuration.${N}"
    exit 1
fi

# --- Configuration String ---
# Create the configuration string, replacing the placeholder with the user input
CONFIG_STRING="
##### NextDNS Configuration Start #####
DNS=45.90.28.0#${NEXTDNS_ID}.dns.nextdns.io
DNS=2a07:a8c0::#${NEXTDNS_ID}.dns.nextdns.io
DNS=45.90.30.0#${NEXTDNS_ID}.dns.nextdns.io
DNS=2a07:a8c1::#${NEXTDNS_ID}.dns.nextdns.io
DNSOverTLS=yes
"

# ====================================================================
# 2. SUMMERY & CONFIRMATION PROMPT
# ====================================================================

echo -e "\n${Y}### Summary of Changes ###${N}"
echo -e "Your NextDNS ID: ${G}${NEXTDNS_ID}${N}"
echo "The following configuration will be **appended** to /etc/systemd/resolved.conf:"
echo -e "----------------------------------------"
echo "$CONFIG_STRING"
echo -e "----------------------------------------"
echo -e "Services to be restarted: ${G}NetworkManager${N}"

read -r -p "Do you want to proceed and apply these changes? (y/N): " response

case "$response" in
    [yY][eE][sS]|[yY])
        echo -e "\n${G}Proceeding with configuration...${N}"
        ;;
    *)
        echo -e "\n${R}Configuration aborted by user.${N}"
        exit 0
        ;;
esac

# ====================================================================
# 3. APPLY CHANGES
# ====================================================================

# --- Apply Configuration ---
echo -e "${Y}Appending configuration to /etc/systemd/resolved.conf...${N}"
sudo sh -c "echo \"$CONFIG_STRING\" >> /etc/systemd/resolved.conf"

# --- Enable and Restart Services ---
echo -e "${Y}Enabling and restarting services using systemctl...${N}"
# Ensure systemd-resolved is enabled (it should be if running)
sudo systemctl enable systemd-resolved.service &> /dev/null
sudo systemctl restart NetworkManager

echo -e "${G}DNS configuration complete. NetworkManager restarted.${N}"