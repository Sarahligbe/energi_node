#/bin/bash

local user_info=$(getent passwd "$user")

if [ -z "$user_info" ]; then
    echo "User $user not found."
    return 1
fi

local groups=$(groups "$user" | cut -d: -f2- | sed 's/^ //' | tr ' ' ',')
local home_dir=$(echo "$user_info" | cut -d: -f6)
local shell=$(echo "$user_info" | cut -d: -f7)
local last_login=$(lastlog -u "$user" | awk 'NR==2 { 
    if ($0 ~ /Never logged in/) {
        print "Never logged in"
    } else if (NF > 1) {
        print $4, $5, $6, $7, $8
    } else {
        print "Unknown"
    }
    }')
echo -e "$user\t$groups\t$home_dir\t$shell\t$last_login"