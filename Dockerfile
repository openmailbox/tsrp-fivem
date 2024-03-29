FROM ubuntu:20.04

LABEL Name=tsrp-fivem Version=0.0.1

RUN apt-get -y update
RUN apt-get -y install xz-utils wget curl git

RUN mkdir -p /fivem/fxserver/txData
RUN mkdir -p /fivem/server-data/resources

VOLUME /fivem/server-data/resources/\[local\]
VOLUME /fivem/server-data/resources/\[vendor\]
VOLUME /fivem/server-data/config
VOLUME /fivem/fxserver/txData

EXPOSE 30120/tcp
EXPOSE 30120/udp
EXPOSE 40125/tcp

COPY build /fivem/build

RUN chmod a+x /fivem/build/*.sh
RUN /bin/bash /fivem/build/fivem_setup.sh

# Install and link the default FiveM resources
RUN git clone https://github.com/citizenfx/cfx-server-data.git /fivem/cfx-server-data
RUN ln -s /fivem/cfx-server-data/resources '/fivem/server-data/resources/[base]'

# Install and link the FiveM mysql-async resource. Bump tag version as needed.
RUN git clone --depth 1 --branch 3.3.2 https://github.com/brouznouf/fivem-mysql-async.git /fivem/mysql-async
RUN ln -s /fivem/mysql-async '/fivem/server-data/resources/mysql-async'

# Install and link widely used resource for patching map holes
RUN git clone --depth 1 --branch 2.0.15 https://github.com/Bob74/bob74_ipl.git /fivem/bob74_ipl
RUN ln -s /fivem/bob74_ipl '/fivem/server-data/resources/bob74_ipl'

COPY src /fivem/server-data/resources/\[local\]

WORKDIR /fivem/server-data

ENTRYPOINT /fivem/fxserver/run.sh \
           +set txAdminPort 40125
