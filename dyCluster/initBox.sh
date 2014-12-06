#!/bin/sh

ips=$(cat agents.txt | cut -d',' -f1)
IFS=$'\n'

for box in $ips; do
        scp block.sh stabilizer@${box}:~ > /dev/null
        ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no stabilizer@${box} "chmod +x block.sh &"
done
