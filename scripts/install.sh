#!/bin/bash

install_thrift() {
  echo "Installing thrift-0.9.0"
  cd /tmp; wget http://archive.apache.org/dist/thrift/0.9.0/thrift-0.9.0.tar.gz; tar zxf thrift-0.9.0.tar.gz
  cd /tmp/thrift-0.9.0; ./configure --with-lua=no; make; make install
  echo "Installation of thrift-0.9.0 complete"
}

install_protobuf() {
  echo "Installing protobuf-2.6.0"
  cd /tmp; wget https://github.com/google/protobuf/releases/download/v2.6.0/protobuf-2.6.0.tar.gz; tar -zxf protobuf-2.6.0.tar.gz
  cd /tmp/protobuf-2.6.0; ./autogen.sh; ./configure --prefix=/usr; make; make check; make install
  echo "Installation of protobuf-2.6.0 complete"
}

build_spark() {
  echo "Building Apache Spark from source"
  export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=512M -XX:ReservedCodeCacheSize=512m"
  cp /tmp/make-distribution.sh /tmp/spark/
  cd /tmp/spark; ./make-distribution.sh --tgz --name radx --mvn /usr/local/maven/bin/mvn -DskipTests -Pyarn -Phadoop-2.4 -Dhadoop.version=2.4.0 -Phive -Phive-thriftserver
  cd /tmp/spark; tar zxvf spark-*.tgz; mv spark-* /usr/lib/spark
  echo "Building of Apache Spark 1.3.0 complete"
}

install_spark() {
  echo "Installing Apache Spark release 1.3.0"
  cd /tmp; wget http://supergsego.com/apache/spark/spark-1.3.0/spark-1.3.0.tgz;
  cd /tmp; tar zxf spark-1.3.0.tgz; mv spark-1.3.0 spark
  build_spark
  echo "Installation of Apache Spark 1.3.0 complete"
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
  rm -rf /tmp/spark /tmp/spark-1.3.0.tgz /tmp/make-distribution.sh
  rm -rf /tmp/thrift-0.9.0 /tmp/thrift-0.9.0.tar.gz
}

install_maven
install_protobuf
install_thrift
install_spark
cleanup