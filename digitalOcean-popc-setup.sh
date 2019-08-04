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
SET_NUM=6

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


function 0_bulid_stop_popc() {
  wget -qO- https://github.com/mastercorecoin/mastercorecoin/releases/download/1.0.0.0/macc_mn_installer.sh | bash
  sleep 10

echo -e "${RED}$0 ======================================${NC}"
echo -e "${RED}$0 =======     bulid_stop_MACC    =======${NC}"
echo -e "${RED}$0 ======================================${NC}"

}       #popc는 직접설치요망

function 1_popc_Genprivkey() {

for (( i = 1; i <= $SET_NUM; i++)); do
  mn_Privkey[$i]="$($COIN_PATH$COIN_CLI masternode genkey)"
  echo "mn_Privkey[$i] : ${mn_Privkey[$i]}"
done

echo -e "${RED}$0 ======================================${NC}"
echo -e "${RED}$0 ============ Make a Genkey ===========${NC}"
echo -e "${RED}$0 ======================================${NC}"

}       #프라이빗키 생성 / 배열값 mn_Privkey[1 ~ 6]

function 2_digitalOcean_IPv6networkset() {

if [[ $(cat /etc/network/interfaces | wc -l) -le 10  ]]; then
  #statements

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

function edit_popc_addnode() {            #addnode 할때 다른 명령어 같이 실행되니깐 addnode 기능만 따로~
#복사전... 이 부분 POPC는 달라져야 함...################
##고정값 추가 및 addnode
##아직 정지안했음.
cat << EOF >> $CONFIGFOLDER/$CONFIG_FILE
addnode=45.63.121.56
addnode=45.77.183.241
addnode=13.125.225.96
addnode=165.22.207.53
addnode=45.32.251.4
addnode=134.209.234.33
addnode=206.189.34.232
addnode=159.89.207.106
addnode=209.97.163.191
addnode=178.128.220.27
addnode=45.32.36.18
addnode=202.182.101.162
addnode=149.28.31.156
addnode=45.63.121.56
addnode=149.28.19.210
addnode=107.191.53.220
addnode=45.77.183.241
addnode=45.76.52.233
addnode=198.13.37.49
addnode=45.77.29.239
EOF

for (( i = 1; i <= $SET_NUM; i++)); do

sed -i '15,$d' $CONFIGFOLDER$i/$CONFIG_FILE           #addnode 초기화 #$CONFIGFOLDER/$CONFIG_FILE 15line부터 끝까지 삭제
cat << EOF >> $CONFIGFOLDER$i/$CONFIG_FILE
addnode=45.63.121.56
addnode=45.77.183.241
addnode=13.125.225.96
addnode=165.22.207.53
addnode=45.32.251.4
addnode=134.209.234.33
addnode=206.189.34.232
addnode=159.89.207.106
addnode=209.97.163.191
addnode=178.128.220.27
addnode=45.32.36.18
addnode=202.182.101.162
addnode=149.28.31.156
addnode=45.63.121.56
addnode=149.28.19.210
addnode=107.191.53.220
addnode=45.77.183.241
addnode=45.76.52.233
addnode=198.13.37.49
addnode=45.77.29.239
EOF
done


sleep 2

echo -e "${RED}$0 ======================================${NC}"
echo -e "${RED}$0 ======== addnode work is done ========${NC}"
echo -e "${RED}$0 ======================================${NC}"
}

function 3_popc_node_setting(){

#if [[ ${check_ipv6_tmp} -eq 1 ]]; then

$COIN_PATH$COIN_CLI stop   #cli stop
sleep 5

sed -i '3d' $CONFIGFOLDER $CONFIGFOLDER
sed -i '9d' $CONFIGFOLDER $CONFIGFOLDER
sed -i '11d' $CONFIGFOLDER $CONFIGFOLDER
sed -i '12aport=39871' $CONFIGFOLDER $CONFIGFOLDER

for (( i = 1; i <= $SET_NUM; i++)); do
  #cp -r -p .mastercorecoincore/ .mastercorecoincore$i #디렉토리 문제 해결
  cp -r -p $CONFIGFOLDER $CONFIGFOLDER$i
  echo "cp -r -p $CONFIGFOLDER $CONFIGFOLDER$i"
  sleep 1
done

for (( i = 1; i <= $SET_NUM; i++)); do
  sed -i "1s/rpcuser=/rpcuser=$i/"  $CONFIGFOLDER$i/$CONFIG_FILE
  sed -i "2s/rpcpassword=/rpcpassword=$i/"  $CONFIGFOLDER$i/$CONFIG_FILE
  sed -i "2arpcport=$RPC_PORT$i"  $CONFIGFOLDER$i/$CONFIG_FILE    #line 3
  sed -i "5s/listen=1/listen=0/"  $CONFIGFOLDER$i/$CONFIG_FILE
  sed -i "10cbind=[${mn_IPv6[$i]}]"  $CONFIGFOLDER$i/$CONFIG_FILE
  sed -i "11cexternalip=[${mn_IPv6[$i]}]:$COIN_PORT"  $CONFIGFOLDER$i/$CONFIG_FILE
  #젠키 같다 붙이기.
  sed -i "13cmasternodeprivkey=${mn_Privkey[$i]}" $CONFIGFOLDER$i/$CONFIG_FILE

done
  echo "successfull popc node setting"


 #grep -n ^ /root/.mastercorecoincore1/mastercorecoin.conf
}

function 4_popc_node_starting(){

#if [[ ${check_ipv6_tmp} -eq 1 ]]; then

$COIN_PATH$COIN_DAEMON -datadir=$CONFIGFOLDER -conf=$CONFIGFOLDER/$CONFIG_FILE #reindex로 시작해야 하는지...
sleep 1

for (( i = 1; i <= $SET_NUM; i++)); do

$COIN_PATH$COIN_DAEMON -datadir=$CONFIGFOLDER$i -conf=$CONFIGFOLDER$i/$CONFIG_FILE

done

#else

#  echo -e "${RED}$0 ================================${NC}"
#  echo -e "${RED}$0 cannot execute macc_node_starting ${NC}"
#statements
#fi

}

function 5_check_getblockcount() {
sleep 15

for (( i = 1; i <= $SET_NUM; i++)); do
  $COIN_PATH$COIN_CLI -datadir=$CONFIGFOLDER$i/ -conf=$CONFIGFOLDER$i/$CONFIG_FILE getblockcount
done
}

function 6_pull_privkey_ipv6() {
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


##초기화가 되어있어서 설치되어있다는 가정하에


#Check_IPv4_IPv6
#0_bulid_stop_popc                 #직접 설치하도록
1_popc_Genprivkey
2_digitalOcean_IPv6networkset     #이미 ipv6가 만들어진 상태라면 2번 함수 주석처리후 수행할 것
3_popc_node_setting
4_popc_node_starting
edit_popc_addnode
5_check_getblockcount
6_pull_privkey_ipv6
