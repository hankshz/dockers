#!/bin/bash

set -e

rm -rf output
stop-yarn.sh
stop-dfs.sh
start-dfs.sh
start-yarn.sh
# wait until ready
sleep 20
hdfs dfs -mkdir -p /user
hdfs dfs -mkdir -p /user/root
hdfs dfs -rm -r -f input
hdfs dfs -rm -r -f output
hdfs dfs -mkdir input
hdfs dfs -put $HADOOP_BUILD/etc/hadoop/*.xml input
hadoop jar $HADOOP_BUILD/share/hadoop/mapreduce/hadoop-mapreduce-examples-$HADOOP_VERSION.jar grep input output 'dfs[a-z.]+'
hdfs dfs -cat output/*
hdfs dfs -get output .
cat output/*
stop-yarn.sh
stop-dfs.sh
