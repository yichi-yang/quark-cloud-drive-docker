#!/bin/bash

set -e

# Find the window named $1, wait for at most $2 seconds.
find_window () {
    for i in $(seq "$2");
    do
        xdotool search --name "$1" && return 0
        sleep 1
    done
    >&2 echo "find_window $1 timeout"
    return 1
}

send_enter () {
    set +e
    output=$(xdotool key --window "$1" Return 2>&1)
    exit_code=$?
    set -e
    if [[ $exit_code -eq 0 ]]; then
        return 0
    fi
    # HACK: xdotool might complain but the click usually works
    if [[ $output == *"BadWindow (invalid Window parameter)"* ]]; then
        return 0
    fi
    >&2 echo "$output"
    return $exit_code
}

# Create prefix
wineboot --init

# Install CJK fonts with Winetricks
winetricks_path=/tmp/winetricks

curl -o $winetricks_path https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x $winetricks_path

$winetricks_path cjkfonts
rm $winetricks_path
rm -r ~/.cache/winetricks

# Download Quark
quark_exe_path=/tmp/quark.exe
curl -L -o $quark_exe_path $QUARK_URL

# Run installer in the background
wine start /unix $quark_exe_path &

# Choose the default option
install_mode_window=$(find_window '选择安装程序模式' 10)
send_enter $install_mode_window

# Choose the default option
install_quark_window=$(find_window '安装 - 夸克网盘' 10)
send_enter $install_quark_window

# Wait for installation to finish (and the main window to show up)
find_window '分享链接' 600

sleep 10

# End the session
wineboot -e

# Remove the installer binary
rm $quark_exe_path

# Wait for for the installer to exit
wait

# Make sure Quark Cloud Drive is installed correctly
test -f /config/.wine/drive_c/users/abc/AppData/Local/Programs/quark-cloud-drive/QuarkCloudDrive.exe

# Make a symlink to the icon so menu.xml works for all versions
find /config/.wine/drive_c/users/abc/AppData/Local/Programs/quark-cloud-drive/ -name "icon_win.png" \
    -exec ln -s {} /config/.wine/drive_c/users/abc/AppData/Local/Programs/quark-cloud-drive/icon_win.png ';'
