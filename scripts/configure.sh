#!/bin/bash

configure_hadoop() {
  echo "Configuring Hadoop. Creating required directories"
  mkdir -p /dfs/nn;
  chown -R hdfs:hadoop /dfs/nn;
  chmod -R 755 /dfs/nn;

  mkdir -p /dfs/snn;
  chown -R hdfs:hadoop /dfs/snn;
  chmod -R 755 /dfs/snn;

  mkdir -p /dfs/dn;
  chown -R hdfs:hadoop /dfs/dn;
  chmod -R 755 /dfs/dn;

  mkdir -p /var/log/hadoop-hdfs;
  chown -R hdfs:hadoop /var/log/hadoop-hdfs;
  chmod -R 755 /var/log/hadoop-hdfs;

  mkdir -p /var/run/hadoop/hdfs;
  chown -R hdfs:hadoop /var/run/hadoop/hdfs;
  chmod -R 755 /var/run/hadoop/hdfs

  mkdir -p $HADOOP_HOME/logs;
  chown -R hdfs:hadoop $HADOOP_HOME/logs;
  chmod -R 755 $HADOOP_HOME/logs

  mkdir -p $HADOOP_LOG_DIR;
  chown -R hdfs:hadoop $HADOOP_LOG_DIR;
  chmod -R 755 $HADOOP_LOG_DIR

  mkdir -p /usr/lib/hadoop-hdfs/libexec
  cp /usr/lib/hadoop/libexec/hdfs-config.sh /usr/lib/hadoop-hdfs/libexec/
  echo "Hadoop configuration complete"
}

configure_hive_metastore() {
  echo "Configuring hive-metastore for hive-0.13.0"
  service mysqld restart

  mysql -uroot -e "USE mysql; CREATE DATABASE IF NOT EXISTS hive; GRANT ALL ON `hive`.* TO 'hive'@'localhost' IDENTIFIED BY 'hive'; FLUSH PRIVILEGES;"

  hive_metastore_sql="/usr/lib/hive/scripts/metastore/upgrade/mysql/hive-schema-0.13.0.mysql.sql"
  if [ -f $hive_metastore_sql ]; then
    mysql -uhive -D hive -phive < $hive_metastore_sql
  else
    echo "hive may not have been installed"
    exit 1
  fi
  echo "hive-metastore has been configured with hive-0.13.0 schema"
}

configure_hadoop
configure_hive_metastore