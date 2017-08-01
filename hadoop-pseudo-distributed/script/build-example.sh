#!/bin/bash

set -e

rm -rf output
# format twice will cause name node lost
$HADOOP_BUILD/bin/hdfs namenode -format | true
$HADOOP_BUILD/sbin/stop-dfs.sh
$HADOOP_BUILD/sbin/start-dfs.sh
# wait until ready
sleep 20
$HADOOP_BUILD/bin/hdfs dfs -mkdir -p /user
$HADOOP_BUILD/bin/hdfs dfs -mkdir -p /user/root
$HADOOP_BUILD/bin/hdfs dfs -rm -r -f input
$HADOOP_BUILD/bin/hdfs dfs -rm -r -f output
$HADOOP_BUILD/bin/hdfs dfs -mkdir input
$HADOOP_BUILD/bin/hdfs dfs -put $HADOOP_BUILD/etc/hadoop/*.xml input
$HADOOP_BUILD/bin/hadoop jar $HADOOP_BUILD/share/hadoop/mapreduce/hadoop-mapreduce-examples-$HADOOP_VERSION.jar grep input output 'dfs[a-z.]+'
$HADOOP_BUILD/bin/hdfs dfs -cat output/*
$HADOOP_BUILD/bin/hdfs dfs -get output .
cat output/*
$HADOOP_BUILD/sbin/stop-dfs.sh
