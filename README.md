## Docker Container with HDP-2.1 & Apache Spark-1.3.0

### Installed software;

* hdp-2.1
   * hive-0.13.0
   * hadoop-2.4.0
* spark-1.3.0 & (spark-1.2.1 & spark-1.1.0)
* thrift-0.9.0
* protobuf-2.6.0
* maven-3.2.5

By default, `SPARK_HOME=/usr/lib/spark/1.3.0` and Apache Spark 1.3.0 is built with support for `hive` (Spark SQL).

### How to use?

```bash
docker pull ypandit/hdp-spark
docker run -td ypandit/hdp-spark
```
