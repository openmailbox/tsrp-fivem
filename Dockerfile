FROM ubuntu:20.04

LABEL Name=tsrp-fivem Version=0.0.1

RUN apt-get -y update 
RUN apt-get -y install xz-utils wget curl

RUN mkdir /fivem
RUN mkdir /fivem/fxserver
RUN mkdir /fivem/server-data

WORKDIR /fivem/fxserver

# Uncomment to prefer a local server build.
COPY fx.tar.xz /fivem/fxserver/fx.tar.xz

COPY fivem_setup.sh /fivem/fivem_setup.sh
RUN /fivem/fivem_setup.sh

VOLUME /fivem/server-data/resources

EXPOSE 30120/tcp
EXPOSE 30120/udp
EXPOSE 40125/tcp

# Env var b/c we might want to change at runtime
ENV FIVEM_SERVER_BUILD=2545

COPY server-data/server.cfg.orig /fivem/server-data/server.cfg
COPY fivem-key.txt /fivem/fivem-key.txt

RUN /bin/bash -c 'sed -i "s/MY_LICENSE_KEY/$(cat /fivem/fivem-key.txt)/" /fivem/server-data/server.cfg'

WORKDIR /fivem/server-data

ENTRYPOINT /fivem/fxserver/run.sh +exec server.cfg \ 
           +set sv_enforceGameBuild $FIVEM_SERVER_BUILD \
           +set serverProfile default \
           +set txAdminPort 40125
