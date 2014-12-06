#!/bin/sh

agents=$1
f=$2

ips=$(cat $agents | cut -d',' -f2)
IFS=$'\n'

for ip in $ips ; do
	./${f} ${ip}	
done
