############################################################
# Dockerfile to build FeSa Installed Containers
# Based on CentOS
############################################################
# Set the base image to CentOS
FROM index.tenxcloud.com/tenxcloud/centos
# File Author / Maintainer
MAINTAINER LVYAFEI
# Makedir mysoft
RUN mkdir -p /opt/mysoft
# Change Workdir
WORKDIR /opt/mysoft
# Install wget
RUN yum clean all
RUN yum -y install wget
#Download Files
RUN wget http://oarixzew4.bkt.clouddn.com/zookeeper-3.4.6.tar.gz
RUN wget http://oarixzew4.bkt.clouddn.com/apache-tomcat-7.0.70.tar.gz
RUN wget http://oarixzew4.bkt.clouddn.com/jdk-7u79-linux-x64.gz
RUN wget http://oarixzew4.bkt.clouddn.com/portal0807-1.war
RUN wget http://oarixzew4.bkt.clouddn.com/crawler0807.war
# Setup Files
RUN tar -zxvf jdk-7u79-linux-x64.gz -C /opt/
RUN tar -zxvf apache-tomcat-7.0.70.tar.gz -C /opt/
RUN tar -zxvf zookeeper-3.4.6.tar.gz -C /opt
# Config zookeeper
RUN cp /opt/zookeeper-3.4.6/conf/zoo_sample.cfg /opt/zookeeper-3.4.6/conf/zoo.cfg
# Unzip Apps
RUN cp portal0807-1.war /opt/apache-tomcat-7.0.70/webapps/portal.war
RUN cp crawler0807.war /opt/apache-tomcat-7.0.70/webapps/crawler.war
# Setting ENV
ENV JAVA_HOME=/opt/jdk1.7.0_79
ENV CLASSPATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar 
ENV PATH=$PATH:$JAVA_HOME/bin
RUN echo "export JAVA_HOME=/opt/jdk1.7.0_79">> /etc/profile
RUN echo "export PATH=$JAVA_HOME/bin:$PATH">> /etc/profile
RUN echo "export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar">> /etc/profile
RUN source /etc/profile
# Init workdir
WORKDIR /opt/
# EXPOSE port
EXPOSE 8080
EXPOSE 2181
EXPOSE 22
# ENTRYPOINT commend
ENTRYPOINT /opt/apache-tomcat-7.0.70/bin/startup.sh && /opt/zookeeper-3.4.6/bin/zkServer.sh start && tail -f /opt/apache-tomcat-7.0.70/logs/catalina.out 
