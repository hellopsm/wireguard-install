#!/bin/bash
content=$(sed -n '8p' /etc/wireguard/wg0.conf) #get line 8 content
#echo $content
tmpPort=${content:13} #get oldPort
oldPort=$tmpPort
newPort=$((oldPort+1)) #get newPort
#newPort=15643 #init port
systemctl stop wg-quick@wg0.service
systemctl stop wg-iptables.service
sleep 3
sed -i "8s/${oldPort}/${newPort}/g" /etc/wireguard/wg0.conf #在第8行用新端口替换旧端口
sed -i "6s/${oldPort}/${newPort}/g" /etc/systemd/system/wg-iptables.service
sed -i "10s/${oldPort}/${newPort}/g" /etc/systemd/system/wg-iptables.service
systemctl daemon-reload
systemctl restart wg-iptables.service
sleep 3
systemctl restart wg-quick@wg0.service
echo "newPort is ${newPort}" #打印显示新端口号
