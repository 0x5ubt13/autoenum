#!/bin/bash

# ---------- Colour constants ----------
RESTORE="\033[0m"
RED="\033[031m"
GREEN="\033[32m"
YELLOW="\033[33m"

# ---------- Installation ----------
# Making sure we're not SU
if [ "$EUID" -eq 0 ]; then
  printf "%b[-]%b Please don't run this script as root 💀, sudo will only be used to install stuff when strictly necessary.\n" "${RED}" "${RESTORE}"
  exit 1
fi

install() {
  # First arg is tool name
  tool_check=$(which "${1}")
  if [ -z "$tool_check" ]; then
    printf "%b[+] Installing %s...%b\n" "${GREEN}" "${1}" "${RESTORE}"
    sudo apt install "${1}" -y >/dev/null
  else
    printf "%b[+] %s detected as installed.%b\n" "${GREEN}" "${1}" "${RESTORE}"
  fi
}

# Detecting debian-based distro
compatible_distro=$(cat /etc/*-release | grep -i "debian")
if [ -n "$compatible_distro" ]; then
  printf "%b[+] Debian-like distro successfully detected. Updating apt-get's cache...%b\n" "${GREEN}" "${RESTORE}"
  sudo apt-get update >/dev/null

  # Rustscan
  rustscan_check=$(find / rustscan 2>/dev/null | grep /bin/rustscan)
  if [ -n "$rustscan_check" ]; then
    # Homebrew (for rustscan)
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Bind brew to shell
    if [ "$SHELL" = /usr/bin/zsh ]; then rc="${HOME}/.zshrc"; else rc="${HOME}/.bashrc"; fi
    printf "\neval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"" >> "$rc"

    # Install Rustscan with brew
    printf "%b[+] Installing %s...%b\n" "${GREEN}" "Rustscan" "${RESTORE}"
    /home/linuxbrew/.linuxbrew/bin/brew install rustscan >/dev/null
  else
    printf "%b[+] Rustscan detected as installed.%b\n" "${GREEN}" "${RESTORE}"
  fi

  # Using apt-get for the following tools
  install nfs-common
  install updatedb
  install locate
  install odat
  install "ssh-audit"
  install "ident-user-enum"
  install seclists
  install cewl
  install wafW00f
  install fping

  # Symlink autoEnum
  chmod +x ./autoEnum
  ln -s ./autoEnum /usr/bin/autoenum

  # Launch autoEnum help
  printf "%b[+]%b autoEnum %bis ready for you! Start enumerating now! :)\n" "${GREEN}" "${YELLOW}" "${RESTORE}"
  autoenum -h
else
  printf "%b[-] Debian-like distro NOT detected. Aborting...%b\n%b[!] To run autoEnum fast, simply make sure you have installed Seclists and Rustscan. Some ports won't be covered, like 1521, but the majority will be enumerated!%b\n" "${RED}" "${RESTORE}" "${YELLOW}" "${RESTORE}"
fi