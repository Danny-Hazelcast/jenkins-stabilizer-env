#!/bin/sh

group1size=$1
group2size=$2
boxCount=$(($group1size + $group2size))

cat agents.txt | head -n +$group1size > group1/agents.txt
cat agents.txt | tail -n -$group2size > group2/agents.txt

ips=$(cat agents.txt | cut -d',' -f2)
IFS=$'\n'

members=""
for box in $ips ; do
	members+="<member>$box<\/member>"
done

sed s/'<!--MEMBERS-->'/$members/g hazelcast.xml | tee group1/hazelcast.xml > group2/hazelcast.xml

