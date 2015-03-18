#!/bin/bash

service sshd start
chkconfig sshd on

service mysqld start
chkconfig mysqld on

echo "Starting namenode"
$HADOOP_HOME/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR start namenode

echo "Starting secondarynamenode"
$HADOOP_HOME/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR start secondarynamenode

echo "Starting datanode"
$HADOOP_HOME/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR start datanode

echo "Starting Apache Spark"
$SPARK_HOME/sbin/start-all.sh

echo "Starting hive-metastore"
service hive-metastore start

if [[ $1 == "-d" ]]; then
  while true; do sleep 5s; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi

echo "All set! HDP 2.1 with Spark-1.3.0 is now running"