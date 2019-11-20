# Hbase-Pseudo-Docker
伪分布式 Hbase Docker 容器，容器搭建过程参考 -> [使用Docker搭建伪分布式Hbase(外置Zookeeper)](<https://xinze.fun/2019/11/20/%E4%BD%BF%E7%94%A8Docker%E6%90%AD%E5%BB%BA%E4%BC%AA%E5%88%86%E5%B8%83%E5%BC%8FHbase-%E5%A4%96%E7%BD%AEZookeeper/>)

Docker-compose.yml

```yml
version: '2.1'
services:
  zookeeper:
    container_name: zk
    image: wurstmeister/zookeeper:3.4.6
    ports:
      - "2181:2181"

  hbase:
    container_name: hbase
    hostname: docker-linux
    image: pierrezemb/hbase-docker:standalone-1.3.1
    links:
      - zookeeper
    depends_on:
      - zookeeper
    logging:
      driver: "none"
    ports:
      - "16010:16010"
      - "8080:8080"
      - "9090:9090"
      - "16000:16000"
      - "16020:16020"
      - "16030:16030"
    command: ["/wait-for-it.sh", "zookeeper:2181", "-t", "10", "--", "/usr/bin/supervisord"]
```

