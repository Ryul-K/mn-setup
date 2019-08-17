#!/bin/bash

#COIN_NAME='safeinsure'
#COIN_DAEMON="${COIN_NAME}d"
#COIN_CLI="${COIN_NAME}-cli"
COIN_NAME='pointofpubliccoin'
TMP_FOLDER=$(mktemp -d)
CONFIG_FILE='pointofpubliccoin.conf'
CONFIGFOLDER='/root/.pointofpubliccoincore'
COIN_DAEMON='pointofpubliccoind'
COIN_CLI='pointofpubliccoin-cli'
COIN_PATH='/usr/bin/'
#COIN_TGZ='https://cdmcoin.org/condominium_ubuntu.zip'
#COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
#COIN_EXPLORER='http://chain.cdmcoin.org'
COIN_PORT=39871
RPC_PORT=39872
SET_NUM=9
#$COIN_PATH$COIN_DAEMON -datadir=$CONFIGFOLDER -conf=$CONFIGFOLDER/$CONFIG_FILE -reindex
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
PURPLE="\033[0;35m"
RED='\033[0;31m'
GREEN="\033[0;32m"
NC='\033[0m'
MAG='\e[1;35m'

#ipv6값 전역변수 설정
tmpIPv6=$(curl -s6 icanhazip.com)
setIPv6=${tmpIPv6::-1}
for (( i = 1; i <= $SET_NUM; i++)); do  #NODEIPv6에 포트셋팅  /etc/network/interfaces에서 쓰일 변수 생성
  mn_IPv6[$i]=${setIPv6}$i            #mn_IPv6[1~6]에   IPv6:1 ~ 6 값 생성
  echo "mn_IPv6[$i] : ${mn_IPv6[$i]}"
done
#프라이빗키 생성 / 배열값 mn_Privkey[1 ~ 6]
sed -i '10,$d' /etc/network/interfaces

function 2_digitalOcean_IPv6networkset() {

sed

for (( i = 1; i <= $SET_NUM; i++)); do  #NODEIPv6에 포트셋팅  /etc/network/interfaces에서 쓰일 변수 생성
  cat << EOF >> /etc/network/interfaces
iface eth0 inet6 static
${mn_IPv6[$i]}
netmask64
EOF

ip -6 addr add ${mn_IPv6[$i]}/64 dev eth0

done
echo -e "${GREEN} ==============================================${NC}"
echo -e "${GREEN} ======== IPv6 network setting is done ========${NC}"
echo -e "${GREEN} ==============================================${NC}"

else

  echo -e "${RED} =================================================${NC}"
  echo -e "${RED} ======== Already network setting is done ========${NC}"
  echo -e "${RED} =================================================${NC}"

fi
#추가했던 네트워크들이 확인되는지 체크하기
ip addr show eth0
sleep 3
#grep -n ^ /etc/network/interfaces

}

##초기화가 되어있어서 설치되어있다는 가정하에

#/usr/bin/pointofpubliccoin-cli -datadir=/root/.pointofpubliccoincore1/ -conf=/root/.pointofpubliccoincore1/pointofpubliccoin.conf getblockcount
#/usr/bin/pointofpubliccoin-cli -datadir=/root/.pointofpubliccoincore2/ -conf=/root/.pointofpubliccoincore2/pointofpubliccoin.conf getblockcount
#/usr/bin/pointofpubliccoin-cli -datadir=/root/.pointofpubliccoincore3/ -conf=/root/.pointofpubliccoincore3/pointofpubliccoin.conf getblockcount
#/usr/bin/pointofpubliccoin-cli -datadir=/root/.pointofpubliccoincore4/ -conf=/root/.pointofpubliccoincore4/pointofpubliccoin.conf getblockcount
#/usr/bin/pointofpubliccoin-cli -datadir=/root/.pointofpubliccoincore5/ -conf=/root/.pointofpubliccoincore5/pointofpubliccoin.conf getblockcount
#/usr/bin/pointofpubliccoin-cli -datadir=/root/.pointofpubliccoincore6/ -conf=/root/.pointofpubliccoincore6/pointofpubliccoin.conf getblockcount


2_digitalOcean_IPv6networkset     #이미 ipv6가 만들어진 상태라면 2번 함수 주석처리후 수행할 것
