# Hadoop Docker for Test

This docker image is **only for test**! 

You can use it for self unit test while developing.

> Run build instrumentation at project's root path

```
docker build . -t hadoop
```

## Run hadoop cluster local

> Create a docker network for test cluster(if created, ignore it)

```
docker network create cluster --subnet 10.1.1.0/24
```

> Create 3 docker container (1 master and 2 slaves)

```
docker run -dt \
    --network cluster \
    --name docker2 \
    --ip 10.1.1.2 \
    -e hadoop_master=docker2 \
    -e hadoop_slaves=docker3,docker4 \
    hadoop

docker run -dt \
    --network cluster \
    --name docker3 \
    --ip 10.1.1.3 \
    -e hadoop_master=docker2 \
    -e hadoop_slaves=docker3,docker4 \
    hadoop

docker run -dt \
    --network cluster \
    --name docker4 \
    --ip 10.1.1.4 \
    -e hadoop_master=docker2 \
    -e hadoop_slaves=docker3,docker4 \
    hadoop
```

> Initiate and start hadoop cluster

```
docker exec -it docker2 /bin/bash /opt/bin/initiate-cluster 
```
