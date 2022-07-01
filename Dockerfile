FROM ubuntu:20.04

LABEL Name=tsrp-fivem Version=0.0.1

RUN apt-get -y update 
RUN apt-get -y install xz-utils wget
RUN mkdir /fivem

RUN mkdir /fivem/fxserver
RUN mkdir /fivem/server-data

VOLUME /fivem/server-data/resources

EXPOSE 30120/tcp
EXPOSE 30120/udp
EXPOSE 40125/tcp

WORKDIR /fivem/fxserver

# Update this as needed for new fxserver build
ARG FIVEM_SERVER_URL='https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/5562-25984c7003de26d4a222e897a782bb1f22bebedd/fx.tar.xz'

# Env var b/c we might want to change at runtime
ENV FIVEM_SERVER_BUILD=2545

RUN /bin/bash -c 'wget -v $FIVEM_SERVER_URL'
RUN /bin/bash -c 'tar xf fx.tar.xz'

COPY server-data/server.cfg.orig /fivem/server-data/server.cfg
COPY fivem-key.txt /fivem/fivem-key.txt

RUN /bin/bash -c 'sed -i "s/MY_LICENSE_KEY/$(cat /fivem/fivem-key.txt)/" /fivem/server-data/server.cfg'

WORKDIR /fivem/server-data
ENTRYPOINT ["/fivem/fxserver/run.sh", \
            "+exec server.cfg", \ 
            "+set sv_enforceGameBuild ${FIVEM_SERVER_BUILD}", \
            "+set serverProfile default", \
            "+set txAdminPort 40125"]
