#!/bin/bash

# Update to a new server build as needed
FIVEM_SERVER_URL="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/5848-4f71128ee48b07026d6d7229a60ebc5f40f2b9db/fx.tar.xz"

cd /fivem/fxserver

if [ ! -f /fivem/fxserver/fx.tar.xz ]
then
    echo "Fetching FiveM server files."
    wget -v $FIVEM_SERVER_URL
else
    echo "FiveM server files found. Skipping download."
fi

echo "Unpacking FiveM server files."
tar xf fx.tar.xz
