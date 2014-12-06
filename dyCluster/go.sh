#!/bin/sh

boxCount=8

provisioner --scale $boxCount
./initBox.sh

dir="$(pwd)/archive/$(date '+%Y_%m_%d-%H_%M_%S')"

for (( smallGroup=1; smallGroup <= $boxCount/2; smallGroup++ )); do
	bigGroup=$(( $boxCount - $smallGroup ))

	./run.sh $bigGroup $smallGroup $dir
done

failCount=$(find $dir -name failures* | wc -l)
if (($failCount > 0 )); then
	find $dir -name failures*
fi
exit $failCount

