FROM ubuntu:20.04

LABEL Name=tsrp-fivem Version=0.0.1

RUN apt-get -y update
RUN apt-get -y install xz-utils wget curl git

RUN mkdir -p /fivem/fxserver/txData/default
RUN mkdir -p /fivem/server-data/resources

WORKDIR /fivem/fxserver

COPY fivem_setup.sh /fivem/fivem_setup.sh
RUN /fivem/fivem_setup.sh

VOLUME /fivem/server-data/resources/\[local\]
VOLUME /fivem/server-data/config
VOLUME /fivem/fxserver/txData

EXPOSE 30120/tcp
EXPOSE 30120/udp
EXPOSE 40125/tcp

# Install and link the default FiveM resources
RUN git clone https://github.com/citizenfx/cfx-server-data.git /fivem/cfx-server-data
RUN ln -s /fivem/cfx-server-data/resources '/fivem/server-data/resources/[base]'

# Install and link the FiveM mysql-async resource. Bump tag version as needed.
RUN git clone --depth 1 --branch 3.3.2 https://github.com/brouznouf/fivem-mysql-async.git /fivem/mysql-async
RUN ln -s /fivem/mysql-async '/fivem/server-data/resources/mysql-async'

# Install and link widely used resource for patching map holes
RUN git clone --depth 1 --branch 2.0.15 https://github.com/Bob74/bob74_ipl.git /fivem/bob74_ipl
RUN ln -s /fivem/bob74_ipl '/fivem/server-data/resources/bob74_ipl'

WORKDIR /fivem/server-data

ENTRYPOINT /fivem/fxserver/run.sh \
           +set txAdminPort 40125
