#!/bin/bash

# Author:   Eric DONGMO
# Date:     August 2019
# CopyRight (c) :

# This script will be used to audit this server running running on centOS 7.

#Authorized Users Only

        if
		 [ $UID -ne 0 ] && [ $USER != root ]
then

echo "   You need eleveted privileges to run this script
         Stay away from this script
         Thank You "
exit
       fi

today=`date +%Y-%m-%d_%H-%M-%S`; 

# File /etc/hosts
echo "Lookin for file \"hosts\", Please wait..."
sleep 2																				

	FILE1=/etc/hosts

    if   [ -f "$FILE1" ]
then
                echo "${FILE1} exists on this server."						2>&1 |tee -a /tmp/${today}_project11.txt
else
                echo "${FILE} does not exists on this server, check your spelling."		2>&1 |tee -a /tmp/${today}_project11.txt
    fi

#SELINUX status
echo "Checking for SELINUX status, Please wait ..."
sleep 2
        SELINUX=`grep ^\SELINUX= /etc/selinux/config | awk -F= '{print $2}'`
echo "This server has SELINUX set on \" ${SELINUX} \" "						2>&1 |tee -a /tmp/${today}_project11.txt

# User ansible
echo "Checking for ansible's UID, Please wait"
sleep 2
UID1=`cat /etc/passwd | awk -F: '/^ansible/ {print $3}'`

echo "ansible's UID is ${UID1} "									2>&1 |tee -a /tmp/${today}_project11.txt

#Package Samba
echo "Checking for Samba Package, please wait"
sleep 2
rpm -qa | grep samba	 									>> /tmp/${today}_project11.txt 2>&1
   
	 if
        [ $? -ne 0 ]
then
            echo "There's no Samba Package on this server"					2>&1 |tee -a /tmp/${today}_project11.txt
else
            echo "Samba Package is already instlled on this server"				2>&1 |tee -a /tmp/${today}_project11.txt
	fi

#Auditd Daemon
echo "Checking for \"auditd\" daemon's status, please wait"
sleep 2

STATUS=`systemctl status auditd | awk -F" " '{if(NR==3) print $2}'`				2>&1 |tee -a /tmp/${today}_project11.txt
echo "Auditd Daemon's is ${STATUS}" 								2>&1 |tee -a /tmp/${today}_project11.txt
systemctl status auditd | awk -F" " '{if(NR==3) print $2}'                                      2>&1 |tee -a /tmp/${today}_project11.txt

#Sudo logfile
echo "Checking for Secure file, please wait..."
sleep 2

test -f /var/log/secure
    if
        [ $? -eq 0 ]
then 
            echo "Sudo log messages are stored on \"secure\" file by default on this server"	2>&1 |tee -a /tmp/${today}_project11.txt
    else
            echo "There is no Sudo logfile configured on this server"				2>&1 |tee -a /tmp/${today}_project11.txt
	fi

# Group file owner
echo "Checking for the Owner, please wait"

OWNER=`ls -l /etc |grep group | awk -F" " 'NR==1 {print $3}'`
												
	ls -l /etc |grep group | awk -F" " 'NR==1 {print $3}'					>> /tmp/${today}_project11.txt 2>&1
    if
        [ ${OWNER} == root ]
then
            echo "ROOT is the owner for the \"group\" file"					2>&1 |tee -a /tmp/${today}_project11.txt

    else
            echo "ROOT is not the owner for the \"group\" file"					2>&1 |tee -a /tmp/${today}_project11.txt
	fi

#cURL
echo "Checking for cURL, please wait ..."

yum list installed '*curl*'									>> /tmp/${today}_project11.txt 2>&1
    if
        [ $? -eq 0 ]
then
            echo "We have cURL installed on this Server"					2>&1 |tee -a /tmp/${today}_project11.txt
    else
            echo "cURL is not installed on this Server"						2>&1 |tee -a /tmp/${today}_project11.txt
	fi

# Docker
echo "Checking for DOCKER, please wait ..."
sleep 2
yum list installed '*docker*'									>> /tmp/${today}_project11.txt 2>&1
    if
        [ $? -eq 0 ]
then
            echo "We have DOCKER installed on this Server"					2>&1 |tee -a /tmp/${today}_project11.txt
    else
            echo "DOCKER is not installed on this Server"					2>&1 |tee -a /tmp/${today}_project11.txt
	fi

#Total seize of memory
echo "checking memory seize, please wait ... "
sleep 2
        MEMORY=`free -m | grep Mem | awk -F" "  '{print $2}'`

echo "This server has \"${MEMORY}\" Mega Bytes"							2>&1 |tee -a /tmp/${today}_project11.txt

# Kernel Version
echo "Checking for the first digit of the Kernel Version, please wait ..."
KERNEL=`uname -r | awk -F"." '{print $1}'`		
											
echo "The first digit of the Kernel Version for this server is \"${KERNEL}\" "			2>&1 |tee -a /tmp/${today}_project11.txt

# System Achitecture
echo "Checking for System Architecture, please wait ..."
sleep 2
        ARCH=`getconf LONG_BIT`

		echo "${ARCH} Bits is the Architecture of this server"				2>&1 |tee -a /tmp/${today}_project11.txt

# Network file
echo "Checking for Network file, please wait..."
sleep 2
test -f /etc/sysconfig/network
    if
        [ $? -eq 0 ]
then 
            echo "This server has a file called \"network\" on /etc/sysconfig/network"		2>&1 |tee -a /tmp/${today}_project11.txt
    else
            echo "This server doesn't have a file called \"network\" "				2>&1 |tee -a /tmp/${today}_project11.txt
	fi

# DNS
echo "Checking for DNS..."

    if 
        grep -q 8.8.8.8  /etc/resolv.conf							>> /tmp/${today}_project11.txt 2>&1
then
            echo "We have a 8.8.8.8 DNS set on /etc/resolv.conf file on this server"		2>&1 |tee -a /tmp/${today}_project11.txt
    else
            echo "We don't have 8.8.8.8 DNS set on this server"					2>&1 |tee -a /tmp/${today}_project11.txt
    fi

# IP Address
echo "Looking for IP Address ..."
sleep 2

        IPADD=`ip -4 -o addr show enp0s3 | awk '{print $4}'`

echo "The IP Address of this server is \"${IPADD}"						2>&1 |tee -a /tmp/${today}_project11.txt

# Linux Flavor

	FLAVOR=`cat /etc/os-release | grep NAME | awk -F= 'NR==1 {print $2}'`	
        VERSION=`cat /etc/os-release | grep -oP "[0-9]+" | head -1`

echo "${FLAVOR} is the Flavor of this Server "							2>&1 |tee -a /tmp/${today}_project11.txt
echo "${VERSION} is the Version of this Server"			        			2>&1 |tee -a /tmp/${today}_project11.txt
 

#Hostname
echo "Checking for Hostname"
sleep 2
echo "\"${HOSTNAME}\" is the Hostname for this server"						2>&1 |tee -a /tmp/${today}_project11.txt
echo "Completing program, please wait... "
sleep 1
echo "Generating a report file..."

for pc in $(seq 1 100); do
    echo -ne "$pc%\033[0K\r"
    sleep 0.05
done
echo "completed"
sleep 0.5

echo "Transfering file to $HOME directory"

for pc in $(seq 1 100); do
    echo -ne "$pc%\033[0K\r"
    sleep 0.03
done

cp /tmp/${today}_project11.txt /$HOME

echo "completed"

