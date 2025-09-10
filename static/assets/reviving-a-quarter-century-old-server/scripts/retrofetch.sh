#!/bin/sh
# retro neofetch for Slackware (Bash 3.0 compatible)

# ASCII logo as an array
LOGO_LINES="
      .--.
     |o_o |
     |:_/ |
    //   \\ \\
   (|     | )
  /'\_   _/'\\
  \\___)=(___/
"

# Collect system info
USER=$(whoami)
HOST=$(hostname)
OS="$(cat /etc/slackware-version)"
KERNEL="$(uname -m -r -v)"
UPTIME="$(uptime | sed 's/.*up \([^,]*\), .*/\1/')"

if [ -x "$SHELL" ]; then
    SHELL_VERSION="$($SHELL --version 2>/dev/null | head -n1)"
else
    SHELL_VERSION="$SHELL"
fi

CPU="$(grep -m1 'model name' /proc/cpuinfo | sed 's/.*: //')"
MEMTOTAL="$(grep MemTotal /proc/meminfo | awk '{print int($2/1024)" MB"}')"
DISK_ROOT="$(df -h / | awk 'NR==2 {print "/      "$3 "/" $2 " (" $5 ")"}')"
DISK_HOME="$(df -h /home | awk 'NR==2 {print "/home  "$3 "/" $2 " (" $5 ")"}')"

# ANSI color codes
BLACK="\033[30m"
RED="\033[31;1m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36;1m"
WHITE="\033[37m"
RESET="\033[0m"

INFO_LINES="
${YELLOW}User:${RESET}   ${CYAN}$USER${RESET}${BLUE}@${RESET}${BLUE}$HOST${RESET}
${YELLOW}OS:${RESET}     ${CYAN}$OS${RESET}
${YELLOW}Linux:${RESET}  ${CYAN}$KERNEL${RESET}
${YELLOW}Uptime:${RESET} ${CYAN}$UPTIME${RESET}
${YELLOW}Shell:${RESET}  ${CYAN}$SHELL_VERSION${RESET}
${YELLOW}CPU:${RESET}    ${CYAN}$CPU${RESET}
${YELLOW}Memory:${RESET} ${CYAN}$MEMTOTAL${RESET}
${YELLOW}Disk:${RESET}   ${CYAN}$DISK_ROOT${RESET}
        ${CYAN}$DISK_HOME${RESET}
"

# Convert logo and info to arrays
OLD_IFS="$IFS"
IFS="
"
set -- $LOGO_LINES
for i in "$@"; do
  LOGO_ARRAY="$LOGO_ARRAY$i\n"
done
set -- $INFO_LINES
for i in "$@"; do
  INFO_ARRAY="$INFO_ARRAY$i\n"
done
IFS="$OLD_IFS"

# Side-by-side print
LOG_LINES=$(echo -e "$LOGO_LINES" | wc -l)
INFO_LINES_COUNT=$(echo -e "$INFO_LINES" | wc -l)
MAX_LINES=$LOG_LINES
if [ "$INFO_LINES_COUNT" -gt "$MAX_LINES" ]; then
  MAX_LINES=$INFO_LINES_COUNT
fi

# Loop through each line and print side-by-side
for i in $(seq 1 $MAX_LINES); do
  LOG_LINE=$(echo -e "$LOGO_LINES" | sed -n "${i}p")
  INFO_LINE=$(echo -e "$INFO_LINES" | sed -n "${i}p")
  printf "${BLACK}%-20s${RESET}  %s\n" "$LOG_LINE" "$INFO_LINE"
done
