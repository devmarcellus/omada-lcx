#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
   ____                      __     
  / __ \____ ___  ____ _____/ /___ _
 / / / / __  __ \/ __  / __  / __  /
/ /_/ / / / / / / /_/ / /_/ / /_/ / 
\____/_/ /_/ /_/\__,_/\__,_/\__,_/  
 
EOF
}
header_info
echo -e "Loading..."
APP="Omada"
var_disk="8"
var_cpu="2"
var_ram="2048"
var_os="debian"
var_version="12"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
header_info
if [[ ! -d /opt/tplink ]]; then 
  msg_error "No ${APP} Installation Found!"; 
  exit 1; 
fi

latest_url="https://static.tp-link.com/upload/software/2024/202402/20240227/Omada_SDN_Controller_v5.13.30.8_linux_x64.deb"
latest_version=$(basename "${latest_url}")

echo -e "Updating Omada Controller"
wget -q "${latest_url}" -O "${latest_version}"
if [ $? -ne 0 ]; then
  msg_error "Failed to download the Omada Controller package."
  exit 1
fi

dpkg -i "${latest_version}"
if [ $? -ne 0 ]; then
  msg_error "Failed to install the Omada Controller package."
  rm -f "${latest_version}"
  exit 1
fi

rm -f "${latest_version}"
echo -e "Updated Omada Controller"
exit 0
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}https://${IP}:8043${CL} \n"
