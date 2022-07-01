#!/bin/bash

# Update to a new server build as needed
FIVEM_SERVER_URL="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/5562-25984c7003de26d4a222e897a782bb1f22bebedd/fx.tar.xz"

if [ ! -f /fivem/fxserver/fx.tar.xz ]
then
    echo "Fetching FiveM server files."
    wget -v $FIVEM_SERVER_URL
else
    echo "FiveM server files found. Skipping download."
fi

echo "Unpacking FiveM server files."

cd /fivem/fxserver 
tar xf fx.tar.xz
