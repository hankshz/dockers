#!/bin/bash

set -e

rm -rf ~/input
rm -rf ~/grep_example
mkdir ~/input
cp $HADOOP_BUILD/etc/hadoop/*.xml ~/input
$HADOOP_BUILD/bin/hadoop jar $HADOOP_BUILD/share/hadoop/mapreduce/hadoop-mapreduce-examples-$HADOOP_VERSION.jar grep ~/input ~/grep_example 'principal[.]*'
cat ~/grep_example/*
