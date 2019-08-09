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
SET_NUM=5

BLUE="\033[0;34m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
PURPLE="\033[0;35m"
RED='\033[0;31m'
GREEN="\033[0;32m"
NC='\033[0m'
MAG='\e[1;35m'

#network ipv6 변수값 설정
tmpIPv6=$(hostname -I)
setIPv6=`${tmpIPv6} | cut -d" " -f3`
for (( i = 1; i <= $SET_NUM; i++)); do  #NODEIPv6에 포트셋팅  /etc/network/interfaces에서 쓰일 변수 생성
  mn_IPv6[$i]=${setIPv6}$i            #mn_IPv6[1~6]에   IPv6:1 ~ 6 값 생성
  echo "mn_IPv6[$i] : ${mn_IPv6[$i]}"
done



##IPv4와 IPv6를 인수로 넣어주기.
##IPv6는 read로 전달하도록 해야할듯.
#inputIPv4=$1
#inputIPv6=$2

function 0_bulid_stop_MACC() {
  wget -qO- https://github.com/mastercorecoin/mastercorecoin/releases/download/1.0.0.0/macc_mn_installer.sh | bash
  sleep 10

echo -e "${RED}$0 ======================================${NC}"
echo -e "${RED}$0 =======     bulid_stop_MACC    =======${NC}"
echo -e "${RED}$0 ======================================${NC}"

}


#프라이빗키 생성 / 배열값 mn_Privkey[1 ~ 6]
function 1_macc_Genprivkey() {

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

function edit_macc_addnode() {            #addnode 할때 다른 명령어 같이 실행되니깐 addnode 기능만 따로~
#복사전... 이 부분 POPC는 달라져야 함...################
##고정값 추가 및 addnode
##아직 정지안했음.
cat << EOF >> $CONFIGFOLDER/$CONFIG_FILE
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
addnode=128.199.171.192
addnode=45.77.21.70
addnode=198.13.38.119
addnode=45.32.39.247
addnode=95.179.154.9
addnode=157.230.123.11
addnode=104.248.141.211
addnode=178.128.54.41
addnode=204.48.26.40
addnode=207.154.201.240
addnode=159.89.151.147
addnode=167.99.206.80
addnode=138.68.103.119
addnode=134.209.225.16
addnode=159.65.139.78
addnode=68.183.64.70
addnode=104.248.157.119:34652
addnode=104.248.39.113:29871
addnode=112.162.233.135:50514
addnode=113.10.36.11:60418
addnode=128.199.155.59:55256
addnode=128.199.167.13:29871
addnode=128.199.171.192:37988
addnode=128.199.175.9:42000
addnode=128.199.251.99:47266
addnode=134.209.108.46:60394
addnode=134.209.108.51:49510
addnode=134.209.225.16:58492
addnode=134.209.233.131:52286
addnode=134.209.240.245:51216
addnode=134.209.246.108:42116
EOF

for (( i = 1; i <= $SET_NUM; i++)); do

sed -i '15,$d' $CONFIGFOLDER$i/$CONFIG_FILE           #addnode 초기화 #$CONFIGFOLDER/$CONFIG_FILE 15line부터 끝까지 삭제
cat << EOF >> $CONFIGFOLDER$i/$CONFIG_FILE
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
addnode=128.199.171.192
addnode=45.77.21.70
addnode=198.13.38.119
addnode=45.32.39.247
addnode=95.179.154.9
addnode=157.230.123.11
addnode=104.248.141.211
addnode=178.128.54.41
addnode=204.48.26.40
addnode=207.154.201.240
addnode=159.89.151.147
addnode=167.99.206.80
addnode=138.68.103.119
addnode=134.209.225.16
addnode=159.65.139.78
addnode=68.183.64.70
addnode=104.248.157.119:34652
addnode=104.248.39.113:29871
addnode=112.162.233.135:50514
addnode=113.10.36.11:60418
addnode=128.199.155.59:55256
addnode=128.199.167.13:29871
addnode=128.199.171.192:37988
addnode=128.199.175.9:42000
addnode=128.199.251.99:47266
addnode=134.209.108.46:60394
addnode=134.209.108.51:49510
addnode=134.209.225.16:58492
addnode=134.209.233.131:52286
addnode=134.209.240.245:51216
addnode=134.209.246.108:42116
EOF
done


sleep 2

echo -e "${RED}$0 ======================================${NC}"
echo -e "${RED}$0 ======== addnode work is done ========${NC}"
echo -e "${RED}$0 ======================================${NC}"
}

function 3_macc_node_setting(){

#if [[ ${check_ipv6_tmp} -eq 1 ]]; then

$COIN_PATH$COIN_CLI stop   #cli stop
sleep 5

sed -i '3d'  $CONFIGFOLDER/$CONFIG_FILE
sed -i '11alogtimestamps=1\nmaxconnections=256\nport=29871' $CONFIGFOLDER/$CONFIG_FILE

for (( i = 1; i <= $SET_NUM; i++)); do
  #cp -r -p .mastercorecoincore/ .mastercorecoincore$i #디렉토리 문제 해결
  cp -r -p $CONFIGFOLDER $CONFIGFOLDER$i
  echo "cp -r -p $CONFIGFOLDER $CONFIGFOLDER$i"
  sleep 1
done

for (( i = 1; i <= $SET_NUM; i++)); do
  sed -i "1s/rpcuser=/rpcuser=$i/"  $CONFIGFOLDER$i/$CONFIG_FILE
  sed -i "2s/rpcpassword=/rpcpassword=$i/"  $CONFIGFOLDER$i/$CONFIG_FILE
  sed -i "2arpcport=$RPC_PORT$i"  $CONFIGFOLDER$i/$CONFIG_FILE
  sed -i "5s/listen=1/listen=0/"  $CONFIGFOLDER$i/$CONFIG_FILE
  sed -i "8cbind=[${mn_IPv6[$i]}]"  $CONFIGFOLDER$i/$CONFIG_FILE
  sed -i "9cexternalip=[${mn_IPv6[$i]}]:$COIN_PORT"  $CONFIGFOLDER$i/$CONFIG_FILE
  #젠키 같다 붙이기.
  sed -i "12cmasternodeprivkey=${mn_Privkey[$i]}" $CONFIGFOLDER$i/$CONFIG_FILE
  sed -i '10d' $CONFIGFOLDER$i/$CONFIG_FILE
done
  echo "successfull macc node setting"

#else

#  echo -e "${RED}$0 ================================${NC}"
#  echo -e "${RED}$0 cannot execute macc_node_setting ${NC}"
#statements
#fi
 #grep -n ^ /root/.mastercorecoincore1/mastercorecoin.conf
}

function 4_macc_node_starting(){

#if [[ ${check_ipv6_tmp} -eq 1 ]]; then

$COIN_PATH$COIN_DAEMON -datadir=$CONFIGFOLDER -conf=$CONFIGFOLDER/$CONFIG_FILE -reindex #reindex로 시작해야 하는지...
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
0_bulid_stop_MACC
1_macc_Genprivkey
2_digitalOcean_IPv6networkset
3_macc_node_setting
edit_macc_addnode
4_macc_node_starting
5_check_getblockcount
6_pull_privkey_ipv6
