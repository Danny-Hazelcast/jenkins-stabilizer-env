#!/bin/sh

dedicatedMemberBox=$1
members=$2
clients=$3
duration=$4

heapSZ=1000m
partitions=271
monitorSec=10


jvmArgs="-Dhazelcast.partition.count=$partitions"
jvmArgs="$jvmArgs -Dhazelcast.health.monitoring.level=NOISY -Dhazelcast.health.monitoring.delay.seconds=$monitorSec"
jvmArgs="$jvmArgs -Xmx$heapSZ -XX:+HeapDumpOnOutOfMemoryError"
jvmArgs="$jvmArgs -verbose:gc -XX:+PrintGCTimeStamps -XX:+PrintGCDetails -XX:+PrintTenuringDistribution -XX:+PrintGCApplicationStoppedTime -XX:+PrintGCApplicationConcurrentTime -Xloggc:verbosegc.log"

coordinator --dedicatedMemberMachines $dedicatedMemberBox \
	--memberWorkerCount $members \
	--clientWorkerCount $clients \
      	--duration $duration \
      	--workerVmOptions "$jvmArgs" \
      	--parallel \
	--hzFile hazelcast.xml \
	sandBoxTest.properties

echo "The-End"

