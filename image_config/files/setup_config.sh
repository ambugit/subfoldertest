# !/bin/bash

function set_username(){
  if [ -z "$1" ]; then
    echo -e "[\e[33mError\e[m] : [$0] : Need 1 parameter"; return 1
  fi
  echo "$1" > /data/config/user
  return 0
}

function set_userpassword(){
  if [ -z "$1" ]; then
    echo -e "[\e[33mError\e[m] : [$0] : Need 1 parameter"; return 1
  fi
  echo "$1" > /data/config/password
  return 0
}

function set_userlang(){
  if [ -z "$1" ]; then
    echo -e "[\e[33mError\e[m] : [$0] : Need 1 parameter"; return 1
  fi
  echo "$1" > /data/config/kibana_lang
  return 0
}

function set_ipaddr(){
  if [ -z "$1" ]; then
    echo -e "[\e[33mError\e[m] : [$0] : Need 1 parameter"; return 1
  fi
  echo "$1" > /data/config/ip_address
  return 0
}

function script_main(){
  case "$1" in
    username)     shift; set_username $*; ;;
    userpassword) shift; set_userpassword $*; ;;
    userlang)     shift; set_userlang $*; ;;
    ipaddr)       shift; set_ipaddr $*; ;;
    *) echo "[\e[33mError\e[m] : unsupported command($1)." ; return 1; ;;
  esac
  return 0
}
if [ -z "$1" ]; then
  echo -e "[\e[33mError\e[m] : [$0] : Need 1 or more parameters."
  exit 1
fi
script_main $*