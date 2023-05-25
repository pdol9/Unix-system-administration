#!/bin/bash

arch=$(uname -a)
cpu=$(cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l)
vcpu=$(cat /proc/cpuinfo | grep "^processor" | wc -l)
ramU=$(free -h | grep Mem | awk '{print $3}')
ramT=$(free -h | grep Mem | awk '{print $2}')
ramP=$(free -k | grep Mem | awk '{printf("%.2f%%"), $3 / $2 * 100}')
hddUs=$(df -h --total | grep total | awk '{print $3}')
hddT=$(df -h --total | grep total | awk '{print $2}')
hddP=$(df -h --total | grep total | awk '{print $5}')
load=$(top -bn1 | grep '^%Cpu' | xargs | awk '{printf("%.1f%%"), $2 + $4}')
boot=$(who -b | awk '{print $3,$4}')
lvm=$(if [ $(lsblk | grep lvm | wc -l) -eq 0 ]; then echo no; else echo yes; fi)
con=$(cat /proc/net/tcp | wc -l | awk '{print $1-1}' | tr '\n' ' ' && echo "ESTABLISHED")
log=$(who | wc -l)
ip=$(hostname -I | awk '{print $1}')
mac=$(ip link show | grep link/ether | awk '{print $2}')
sudo=$(grep COMMAND /var/log/sudo/sudo.log | wc -l)

wall "
	***********************************************************

	#Architecture: $arch
	#CPU physical: $cpu
	#vCPU : $vcpu
	#Memory Usage: $ramU/$ramT ($ramP)
	#Disk Usage: $hddUs/$hddT ($hddP)
	#CPU load: $load
	#Last boot: $boot
	#LVM use: $lvm
	#Connections TCP : $con
	#User log: $log
	#Network: IP $ip ($mac)
	#Sudo : $sudo cmd

	***********************************************************
	"
