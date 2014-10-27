#!/bin/bash

#Script Info
echo -e "\e[34m#########################################\e[0m"
echo -e "\e[34m# DNS Bruteforcer                       #\e[0m"
echo -e "\e[34m# Script by\e[0m \e[40;38;5;82m K@r \e[30;48;5;82m 7h1ck \e[0m \e[34m, Version 1.0  #\e[0m"
echo -e "\e[34m#########################################\e[0m"
echo " "

#Script
kali_exec(){
        for dn in $(cat /usr/share/dnsrecon/namelist.txt); do
        host $dn.$target | grep "has address" | sort -u & 
        done
	
}
backtrack_exec(){
        for dn in $(cat /pentest/enumeration/dns/dnsrecon/namelist.txt); do 
        host $dn.$target | grep "has address" | cut -d" " -f 4 | sort -u &
        done
	
}
forward_lookup_brute_force(){
	echo -n -e "Type \e[91m1 for kali\e[0m or \e[91m2 for backtrack\e[0m hit [Enter] : "
	read os
	echo " "
	echo -n -e "Enter your Target Address as \e[92mexample.com\e[0m and not as \e[91mwww.example.com\e[0m and hit [Enter] : "
	read target
	echo " "
	case "$os" in
        	1) kali_exec;;
        	2) backtrack_exec;;
        	*) echo "input invalid"
	esac
}
ip_list(){
        echo -n "Path of text file with ips to perform Reverse Lookup Brute Force : "
        read path
        echo " "
        echo -n "Target domain you are looking for in your result : "
        read target
        echo " "
        for ip in $(cat $path);do
        host $ip | grep "name pointer" | grep "$target" | cut -d" " -f 5 | sort -u &
        done
	
}
single_ip_seq(){
        echo -n "Enter a class C ip address of target, only the network id (192.168.1) : "
        read ip
        echo " "
	echo -n "Target domain name to filter the result(www.example.com as example) : "
	read target
        for range in $(seq 1 254);do
        host $ip.$range | grep "name pointer" | grep "$target" | cut -d" " -f 5 | sort -u &
        done
	
}
single_ip(){
	echo -n "Enter the ip address of the target : "
	read ip
	host $ip | grep "name pointer" | cut -d" " -f 5 | sort -u 
	choice
}
reverse_lookup_brute_force(){
	echo -e "\033[91mScript Options : \e[0m"
	echo "  1.List of ips"
	echo "  2.subnetwork lookup"
	echo "  3.single ip"
	echo " "
	echo -n " Enter your option no : "
	read no
	echo " "
	case $no in
        	1)ip_list;;
        	2)single_ip_seq;;
		3)single_ip;;
        	*)echo "Invalid input"
	esac
}
zone_transfer(){
	echo -e "\e[93m Warning\e[0m : \033[91mZone transfer is dangerous, know before using it !\e[0m"
	echo " "
	echo -n "Enter target web address to perform zone transfer : "
	read target
	for nameserver in $(host -t ns $target | cut -d" " -f 4);do
	host -l $target $nameserver
	done
	choice
}
choice(){
echo " "
echo " "
echo -e " Choose your Brute Vector "
echo -e "   1.\e[96m Forward lookup brute force\e[0m (Works in kali and backtrack only)"
echo -e "   2.\e[96m Reverse lookup brute force\e[0m (Works in all linux)"
echo -e "   3.\e[96m Zone Transfer\e[0m (Works in all linux)"
echo -e "   4.\e[96m Exit\e[0m"
echo " "
echo -n "Option : "
read no
case $no in 
        1)forward_lookup_brute_force;;
        2)reverse_lookup_brute_force;;
        3)zone_transfer;;
	4)echo "$(exit 0)" && echo "Ya not the Right time";;
        *)echo "invalid choice, cya !"
esac

}
echo -e "\033[93m Warning\e[0m : \033[91moptions like Zone transfer will take you a peak into the Internal network if the target is vulnerable\e[0m"
echo -e "\033[93m Warning\e[0m : \033[91mIf Zone transfer was successfull, it may lead to Security Violation. use it only if authorised to do !\e[0m"
echo " "
choice
