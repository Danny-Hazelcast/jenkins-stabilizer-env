#!/bin/bash

g1MemberBox=$1
g1Members=$g1MemberBox
g1Clients=0
g1Duration=3m

g2MemberBox=$2
g2Members=$g2MemberBox
g2Clients=0
g2Duration=2m

baseDir=$3
mins5=300
maxClusterSize=$(($g1MemberBox + $g2MemberBox))

startGroup2="Running 00d 00h 00m 30s"
blockGroup2="Running 00d 00h 01m 00s"

./setup.sh $g1MemberBox $g2MemberBox

for i in {1..4}; do
	
	provisioner --restart > /dev/null	

	echo "cluster time line $g1Members-$maxClusterSize-$g1Members Run $i"
	
	cd group1
	./run.sh $g1MemberBox $g1Members $g1Clients $g1Duration > out.txt 2>&1 &
	cd ..

	./listener.sh group1/out.txt "${startGroup2}" "${mins5}"
	
	cd group2
        ./run.sh $g2MemberBox $g2Members $g2Clients $g2Duration > out.txt 2>&1 &
        cd ..

	./listener.sh group2/out.txt "${blockGroup2}" "${mins5}"
	cd group2
	provisioner --kill
	cd ..

	./listener.sh group1/out.txt "The-End" "${mins5}"

	version=$(grep -o maven=.* stabilizer.properties | cut -d '=' -f2)	
	resPath="$baseDir/$version/$g1Members-$maxClusterSize-$g1Members/run$i"
	
	cd group1
		provisioner --download $resPath/group1 > /dev/null
	cd ..
	cd group2
               	provisioner --download $resPath/group2 > /dev/null
        cd ..
	provisioner --clean > /dev/null

	mv group1/failures-* $resPath/group1 2>/dev/null
	mv group2/failures-* $resPath/group2 2>/dev/null
	
	mv group1/out.txt $resPath/group1 2>/dev/null
        mv group2/out.txt $resPath/group2 2>/dev/null

	if [ -f $resPath/group1/failures* ] || [ -f $resPath/group2/failures* ]; then
		echo "FAIL! $resPath"
     	fi
done
