#!/bin/bash

install_thrift() {
  echo "Installing thrift-0.9.0"
  cd /tmp; wget http://archive.apache.org/dist/thrift/0.9.0/thrift-0.9.0.tar.gz; tar zxf thrift-0.9.0.tar.gz
  cd /tmp/thrift-0.9.0; ./configure --with-lua=no; make; make install
  echo "Installation of thrift-0.9.0 complete"
}

install_protobuf() {
  echo "Installing protobuf-2.6.0"
  cd /tmp; wget https://github.com/google/protobuf/releases/download/v2.6.0/protobuf-2.6.0.tar.gz; tar -zxvf protobuf-2.6.0.tar.gz
  cd /tmp/protobuf-2.6.0; ./autogen.sh; ./configure --prefix=/usr; make; make check; make install
  echo "Installation of protobuf-2.6.0 complete"
}

build_spark_13() {
  echo "Building Apache Spark from source"
  export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=512M -XX:ReservedCodeCacheSize=512m"
  cp /tmp/make-distribution.sh /tmp/spark/
  cd /tmp/spark
  ./make-distribution.sh --tgz --name radx --mvn /usr/local/maven/bin/mvn -DskipTests -Pyarn -Phadoop-2.4 -Dhadoop.version=2.4.0 -Phive -Phive-thriftserver
  cd /tmp/spark && tar zxvf spark-*.tgz -C /usr/lib/spark && mv /usr/lib/spark/spark-* /usr/lib/spark/1.3.0
  echo "Building of Apache Spark 1.3.0 complete"
}

install_spark() {
  mkdir /usr/lib/spark
  echo "Installing Apache Spark release 1.3.0"

  # CHECKOUT_COMMIT_REV="9a151ce58b3e756f205c9f3ebbbf3ab0ba5b33fd"
  # PR_COMMIT_REV="8f471a66db0571a76a21c0d93312197fee16174a"
  # cd /tmp; git clone https://github.com/apache/spark.git; git checkout -b custom-spark $CHECKOUT_COMMIT_REV; git cherry-pick $PR_COMMIT_REV

  cd /tmp; wget http://supergsego.com/apache/spark/spark-1.3.0/spark-1.3.0.tgz; tar zxvf spark-1.3.0.tgz; mv spark-1.3.0 spark
  build_spark_13
  echo "Installation of Apache Spark 1.3.0 complete"
  rm -rf /tmp/spark-1.3.0 /tmp/spark

  echo "Installing Apache Spark release 1.2.1 pre-built for Hadoop-2.4"
  cd /tmp; wget http://mirror.symnds.com/software/Apache/spark/spark-1.2.1/spark-1.2.1-bin-hadoop2.4.tgz; tar zxvf spark-1.2.1-bin-hadoop2.4.tgz; mv spark-1.2.1-bin-hadoop2.4 /usr/lib/spark/1.2.1
  echo "Installation of Apache Spark 1.2.1 complete"

  echo "Installing Apache Spark release 1.1.0 pre-built for Hadoop-2.4"
  cd /tmp; wget http://d3kbcqa49mib13.cloudfront.net/spark-1.1.0-bin-hadoop2.4.tgz; tar zxvf spark-1.1.0-bin-hadoop2.4.tgz; mv spark-1.1.0-bin-hadoop2.4 /usr/lib/spark/1.1.0
  echo "Installation of Apache Spark 1.1.0 complete"
}

install_maven() {
  echo "Installing Apache Maven 3.2.5"
  wget -O /tmp/maven.tgz http://www.eng.lsu.edu/mirrors/apache/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz
  cd /tmp; tar xzf maven.tgz

  mv /tmp/apache-maven-* /usr/local/maven
  echo -e "export M2_HOME=/usr/local/maven\nexport PATH=$M2_HOME/bin:$PATH" > /etc/profile.d/maven.sh
  source /etc/profile.d/maven.sh
  if [ -f /tmp/settings.xml ]; then
    mkdir -p /root/.m2; mv /tmp/settings.xml /root/.m2/
  fi
  echo 'Installation of Apache Maven 3.2.5 complete.'
}

cleanup() {
  rm -rf /tmp/maven.tgz /tmp/apache-maven-*
  rm -rf /tmp/protobuf-2.6.0 /tmp/protobuf-2.6.0.tar.gz
  rm -rf /tmp/spark /tmp/spark-1.3.0.tgz /tmp/make-distribution.sh /tmp/spark-1.2.1-bin-hadoop2.4.tgz /tmp/spark-1.1.0-bin-hadoop2.4.tgz
  rm -rf /tmp/thrift-0.9.0 /tmp/thrift-0.9.0.tar.gz
}

install_maven
install_protobuf
install_thrift
install_spark
cleanup