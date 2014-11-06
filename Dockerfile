FROM centos:centos6

RUN yum localinstall -y http://ftp.riken.jp/Linux/fedora/epel/6/i386/epel-release-6-8.noarch.rpm
ADD config/pdns.el6.repo /etc/yum.repos.d/pdns.el6.repo

RUN yum install -y pdns pdns-backend-mysql mysql-server supervisor

RUN yum clean all

ADD config/pdns_schema.sql     /root/
ADD config/pdns_priviledge.sql /root/

RUN /etc/init.d/mysqld restart && mysqladmin -u root create pdns && cat /root/pdns_schema.sql /root/pdns_priviledge.sql | mysql -u root pdns

RUN mkdir -p /etc/pdns/conf.d/ /var/log/supervisor/jobs/
ADD config/supervisord.conf /etc/supervisord.conf
ADD config/pdns.conf /etc/pdns/
ADD config/pdns.gmysql.conf /etc/pdns/conf.d/

EXPOSE 8081
EXPOSE 53/udp

CMD ["/usr/bin/supervisord"]
