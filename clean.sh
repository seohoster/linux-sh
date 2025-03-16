#!/bin/bash
# System cleanup script
# CLOSE ALL SNAPS BEFORE RUNNING THIS
set -eu

echo "Starting system cleanup..."

# Removes old revisions of snaps
snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        snap remove "$snapname" --revision="$revision"
    done

# Clear systemd journal logs older than 3 days
echo "Clearing old system logs..."
sudo journalctl --vacuum-size=100M

# Clear thumbnail cache
echo "Clearing thumbnail cache..."
rm -rf ~/.cache/thumbnails/*

# Clean bash history
echo "Cleaning bash history..."
cat /dev/null > ~/.bash_history
history -c

# Clear temporary files
echo "Clearing temporary files..."
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

# Remove old kernel versions (keeping the current and one previous version)
echo "Removing old kernel versions..."
dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs sudo apt-get -y purge

echo "Cleanup completed!"

sudo snap refresh

sudo apt-get install -y

sudo apt-get autoclean

sudo apt-get clean

sudo apt-get autoremove