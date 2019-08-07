# Base image.
FROM centos:7.4.1708

# Volumes.
VOLUME ["/data"]
VOLUME ["/data/work"]

# Copy.
COPY work/* /data/work/
COPY repo/* /etc/yum.repo.d/

# Ports.
#EXPOSE 80
#EXPOSE 21

# Command

# Run
RUN rm -rf /var/cache/yum/* \
  && yum clean all
RUN yum clean metadata
RUN yum -y install epel-release
RUN yum -y install git
#RUN yum -y install ansible

RUN curl -kL https://bootstrap.pypa.io/get-pip.py | python
RUN pip install -r /data/work/requirements.txt -I
RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
RUN rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
RUN yum -y install python-devel-2.7.5
RUN yum -y install gcc-4.8.5
RUN yum -y install java-1.8.0-openjdk
RUN yum -y install unzip
RUN yum -y install wget-1.14
RUN yum -y install httpd-tools
RUN yum -y install nginx
RUN yum -y install elasticsearch
RUN yum -y install kibana

RUN echo "export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk" >> /root/.bashrc
RUN source /root/.bashrc
COPY work/sites/* /etc/nginx/conf.d/sites/*.conf
RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bk
RUN \cp -fr /data/work/nginx.default.conf /etc/nginx/conf.d/default.conf

# EntryPoint
ENTRYPOINT /sbin/init
