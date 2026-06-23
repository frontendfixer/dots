#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# for rainbow borders animation

function random_hex() {
    random_hex=("0xff$(openssl rand -hex 3)")
    echo $random_hex
}

border=""
for _ in $(seq 1 10); do
    border+="$(random_hex) "
done
border+="270deg"

# rainbow colors only for active window
hyprctl eval "hl.config({ general = { col = { active_border = '${border}' } } })"

# rainbow colors for inactive window (uncomment to take effect)
# inactive=""
# for _ in $(seq 1 10); do
#     inactive+="$(random_hex) "
# done
# inactive+="270deg"
# hyprctl eval "hl.config({ general = { col = { inactive_border = '${inactive}' } } })"
