FROM phusion/baseimage

RUN echo "deb https://repo.gluu.org/ubuntu/ trusty-devel main" > /etc/apt/sources.list.d/gluu-repo.list
RUN curl https://repo.gluu.org/ubuntu/gluu-apt.key | apt-key add -

RUN echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker-repo.list
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

RUN apt-get update

RUN apt-get install -y docker-engine
VOLUME [ "/etc/docker" ]
RUN echo "DOCKER_OPTS='--tlsverify --tlscacert=/etc/docker/ca.pem --tlscert=/etc/docker/server-cert.pem --tlskey=/etc/docker/server-key.pem -H unix:///var/run/docker.sock'" >> /etc/default/docker

RUN apt-get install -y weave
EXPOSE 6783 6784

RUN apt-get install -y salt-common salt-master salt-minion
ADD /conf/etc/salt/minion /etc/salt/minion
EXPOSE 4505 4506

RUN mkdir /var/cache/salt/master

RUN apt-get install -y gluu-agent gluu-master
RUN apt-get install -y git python-pip python-virtualenv python-dev build-essential
RUN git clone https://github.com/GluuFederation/gluu-flask.git
WORKDIR /gluu-flask
RUN apt-get install -y libsasl2-dev libldap2-dev libssl-dev libzmq-dev swig
RUN pip install -r requirements.txt
RUN python setup.py install
EXPOSE 8080

ADD /run.sh /run.sh
RUN chmod 777 /run.sh

ENTRYPOINT ["/run.sh"]