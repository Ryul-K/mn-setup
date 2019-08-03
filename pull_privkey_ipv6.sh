#!/bin/bash

#COIN_NAME='safeinsure'
#COIN_DAEMON="${COIN_NAME}d"
#COIN_CLI="${COIN_NAME}-cli"
COIN_NAME='mastercorecoin'
TMP_FOLDER=$(mktemp -d)
CONFIG_FILE='mastercorecoin.conf'
CONFIGFOLDER='/root/.mastercorecoincore'
COIN_DAEMON='mastercorecoind'
COIN_CLI='mastercorecoin-cli'
COIN_PATH='/usr/bin/'
#COIN_TGZ='https://cdmcoin.org/condominium_ubuntu.zip'
#COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
#COIN_EXPLORER='http://chain.cdmcoin.org'
COIN_PORT=29871
RPC_PORT=29872
SET_NUM=6

BLUE="\033[0;34m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
PURPLE="\033[0;35m"
RED='\033[0;31m'
GREEN="\033[0;32m"
NC='\033[0m'
MAG='\e[1;35m'

#network ipv6 변수값 설정
tmpIPv6=$(curl -s6 icanhazip.com)
setIPv6=${tmpIPv6::-1}
for (( i = 1; i <= $SET_NUM; i++)); do  #NODEIPv6에 포트셋팅  /etc/network/interfaces에서 쓰일 변수 생성
  mn_IPv6[$i]=${setIPv6}$i            #mn_IPv6[1~6]에   IPv6:1 ~ 6 값 생성
  echo "mn_IPv6[$i] : ${mn_IPv6[$i]}"
done

function 7_pull_privkey_ipv6() {
   tmpIPv4=$(curl -s4 icanhazip.com)

   mn_key[0]=$(sed -n '/masternodeprivkey/p' $CONFIGFOLDER/$CONFIG_FILE)
   echo " "
   echo " "
   echo -e "${GREEN}`hostname` ${tmpIPv4} ${mn_key[0]:18:70}\t${NC}"

   for (( i = 1; i <= $SET_NUM; i++)); do
     #mn_key[$i]=$(sed -n '/masternodeprivkey/p' $CONFIGFOLDER$i/$CONFIG_FILE
     mn_key[$i]=$(sed -n '/masternodeprivkey/p' $CONFIGFOLDER$i/$CONFIG_FILE)
     echo -e "${GREEN}`hostname`-$i ${mn_IPv6[$i]} ${mn_key[$i]:18:70}\t${NC}"
   done
   echo " "
   echo " "

}

7_pull_privkey_ipv6
