#!/bin/bash
# Author:           Christo Deale                  
# Date  :           2023-10-03             
# rhel9_usbguard:   Utility to setup/list/decide USBGuard on RHEL 9

# Check if USBGuard is installed, and install it if not
if ! rpm -q usbguard; then
    sudo dnf install -y usbguard
fi

# Generate USBGuard policy
sudo usbguard generate-policy > /etc/usbguard/rules.conf

# Enable and start USBGuard service
sudo systemctl enable --now usbguard

# Check if USBGuard is active
if sudo systemctl is-active usbguard; then
    echo "USBGuard is active."
else
    echo "USBGuard is not active."
fi

# List connected USB devices
echo "List of connected USB devices:"
sudo usbguard list-devices

# Ask for user input
while true; do
    read -p "Enter action (ALLOW/REJECT/BLOCK) and device number (e.g., ALLOW 1): " action device_number
    case $action in
        ALLOW)
            sudo usbguard allow-device $device_number
            ;;
        REJECT)
            sudo usbguard reject-device $device_number
            ;;
        BLOCK)
            sudo usbguard block-device $device_number
            ;;
        *)
            echo "Invalid action. Please use ALLOW, REJECT, or BLOCK."
            ;;
    esac
    read -p "Do you want to perform another action (yes/no)? " continue
    if [ "$continue" != "yes" ]; then
        break
    fi
done

echo "USBGuard setup and device management complete."
