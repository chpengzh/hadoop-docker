FROM airdock/oracle-jdk:1.8

MAINTAINER chpengzh<chpengzh@foxmail.com>

ADD ./env/sources.list /etc/apt/sources.list
RUN rm -rf /etc/apt/sources.list.d/*.list
RUN apt-get update
RUN apt-get install -y ssh vim wget && \
    mkdir -p /tmp /opt/bin

# Download resource
ARG hdp_src=https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-2.9.0/hadoop-2.9.0.tar.gz

RUN wget $hdp_src && \
    mv hadoop*.tar.gz hadoop.tgz && \
    tar xf hadoop.tgz -C /opt && \
    mv /opt/hadoop* /opt/hadoop && \
    rm -rf hadoop.tgz

ADD ./configure /root/configure
ADD ./env/bashrc /tmp/bashrc
ADD ./template/hadoop /opt/hadoop/etc/hadoop
ADD ./bin /opt/bin

# Initiate static global enviornment variable
# Initiate ssh keys and authorization
RUN cat /tmp/bashrc >> /root/.bashrc && \
    ssh-keygen -f /root/.ssh/id_rsa -P "" && \
    cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys

# Dynamic Global enviornment variable
# Those will be configure while starting
ENV LANG="en_US.UTF-8" \
    hadoop_master=localhost \
    hadoop_slaves=localhost

# Initiate and start ssh service
ENTRYPOINT /root/configure && /bin/bash
