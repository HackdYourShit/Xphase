if which iconer >/dev/null; then
    /usr/local/bin/iconer {{source}} -t {{target}} -x -p {{platform}}
else
    echo "warning: iconer is not installed, install it via homebrew."
fi