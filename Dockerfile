#
# Ubuntu 14.04 with Tomcat Dockerfile
#
# Pull base image.
FROM java:8

MAINTAINER HaibinZhao "zhaohaibin@6starhome.com"

ENV REFRESHED_AT 2016-12-13 12:00

ENV NEO4J_SHA256 47317a5a60f72de3d1b4fae4693b5f15514838ff3650bf8f2a965d3ba117dfc2
ENV NEO4J_TARBALL neo4j-community-3.1.0-unix.tar.gz
ARG NEO4J_URI=http://dist.neo4j.org/neo4j-community-3.1.0-unix.tar.gz

USER root

# 安装必要软件
RUN \
    apt-get update && \
    apt-get install git curl  openssh-server onts-arphic-ukai supervisor -y && \
    sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf

RUN \                                                                                                                                                                       
    apt-get clean && \                                                                                                                                                      
    rm -rf /var/lib/apt/lists/*

RUN echo "export LC_ALL=C" >> /root/.bashrc

# 设置环境变量，所有操作都是非交互式的
ENV DEBIAN_FRONTEND noninteractive

# 注意这里要更改系统的时区设置，因为在 web 应用中经常会用到时区这个系统变量，默认的 ubuntu 会让你的应用程序发生不可思议的效果哦
RUN echo "Asia/Chongqing" > /etc/timezone && \
        dpkg-reconfigure -f noninteractive tzdata

RUN curl --fail --silent --show-error --location --remote-name ${NEO4J_URI} \
    && echo "${NEO4J_SHA256}  ${NEO4J_TARBALL}" | sha256sum -csw - \
    && tar --extract --file ${NEO4J_TARBALL} --directory /var/lib \
    && mv /var/lib/neo4j-* /var/lib/neo4j \
    && rm ${NEO4J_TARBALL}

ADD adds/authorized_keys /authorized_keys

ADD config/config.sh /config.sh

RUN chmod u+x /config.sh

RUN sh /config.sh && rm /config.sh

ADD config/sshd.conf /etc/supervisor/conf.d/sshd.conf
ADD config/neo4j.conf /etc/supervisor/conf.d/neo4j.conf

ADD assets /assets
RUN chmod u+x /assets/startup.sh

WORKDIR /var/lib/neo4j

RUN mv data /data \
    && ln -s /data

VOLUME /data

EXPOSE 7474 7473 7687 22

CMD ["/assets/startup.sh"]

