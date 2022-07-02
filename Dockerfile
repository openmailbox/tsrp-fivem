FROM ubuntu:20.04

LABEL Name=tsrp-fivem Version=0.0.1

RUN apt-get -y update
RUN apt-get -y install xz-utils wget curl git

RUN mkdir /fivem
RUN mkdir /fivem/fxserver
RUN mkdir -p /fivem/server-data/resources

WORKDIR /fivem/fxserver

# Uncomment to prefer a local server build.
#COPY fx.tar.xz /fivem/fxserver/fx.tar.xz

COPY fivem_setup.sh /fivem/fivem_setup.sh
RUN /fivem/fivem_setup.sh

VOLUME /fivem/server-data/resources/\[local\]
VOLUME /fivem/fxserver/txData

EXPOSE 30120/tcp
EXPOSE 30120/udp
EXPOSE 40125/tcp

# Env var b/c we might want to change at runtime
ENV FIVEM_SERVER_BUILD=2545

COPY cfg/server.cfg.orig /fivem/server-data/server.cfg
COPY fivem-key.txt /fivem/fivem-key.txt

RUN /bin/bash -c 'sed -i "s/MY_LICENSE_KEY/$(cat /fivem/fivem-key.txt)/" /fivem/server-data/server.cfg'

# Install and link the default FiveM resources
RUN git clone https://github.com/citizenfx/cfx-server-data.git /fivem/cfx-server-data
RUN ln -s /fivem/cfx-server-data/resources '/fivem/server-data/resources/[base]'

# Install and link the FiveM mysql-async resource. Bump tag version as needed.
RUN git clone --depth 1 --branch 3.3.2 https://github.com/brouznouf/fivem-mysql-async.git /fivem/mysql-async
RUN ln -s /fivem/mysql-async '/fivem/server-data/resources/mysql-async'

WORKDIR /fivem/server-data

ENTRYPOINT /fivem/fxserver/run.sh \
           +set sv_enforceGameBuild $FIVEM_SERVER_BUILD \
           +set txAdminPort 40125
