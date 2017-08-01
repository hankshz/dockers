#!/bin/bash

set -e

apt-get update
apt-get install -y default-jdk openssh-server
java -version

# setup sshd and skip password
mkdir /var/run/sshd
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
cp /raw/ssh_config ~/.ssh/config

mkdir -p /build

tar xvf /raw/hadoop-$HADOOP_VERSION.tar.gz -C /build
mv /build/hadoop-$HADOOP_VERSION $HADOOP_BUILD
sed -i 's@export JAVA_HOME=${JAVA_HOME}@export JAVA_HOME='"$JAVA_HOME"'@g' $HADOOP_BUILD/etc/hadoop/hadoop-env.sh
cp /raw/hadoop/hdfs-site.xml $HADOOP_BUILD/etc/hadoop/hdfs-site.xml
cp /raw/hadoop/core-site.xml $HADOOP_BUILD/etc/hadoop/core-site.xml
cp /raw/hadoop/mapred-site.xml $HADOOP_BUILD/etc/hadoop/mapred-site.xml
cp /raw/hadoop/yarn-site.xml $HADOOP_BUILD/etc/hadoop/yarn-site.xml
cp /raw/hadoop/slaves $HADOOP_BUILD/etc/hadoop/slaves

hdfs namenode -format
