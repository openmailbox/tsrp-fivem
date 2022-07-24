# Time Served FiveM Code
This repository contains open-source scripts for the [Time Served](https://www.timeservedrp.com) community FiveM server.

Related repositories:
- [TSRP Documentation](https://github.com/openmailbox/tsrp-docs)
- [TSRP Website](https://github.com/openmailbox/tsrp-web)

## Contributing
Contributions are welcome. Here are instructions for setting up a local development environment:
1. Install [Docker](https://www.docker.com/).
1. `git clone` this repository into a local directory of your choice.
1. Obtain your own license key from the [Fivem Keymaster](https://keymaster.fivem.net/).
1. Create your local config by copying `cfg/server.orig.cfg` to `cfg/server.cfg`.
1. Modify `cfg/server.cfg` and add your FiveM license key at the bottom where it says `MY_LICENSE_KEY`.
1. Use [Docker Compose](https://docs.docker.com/compose/) to execute `compose up` on the `compose.yaml` file.
1. In your browser, navigate to `http://localhost:40125` using the mapped port. You will see the txAdmin setup screen.
1. Inspect the logs of the resulting `tsrp-fivem` container to find the pin number to setup txAdmin.
1. Complete txAdmin setup and start the FiveM server.
    1. Select "Local Server Data" for Deployment Type.
    1. Input `/fivem/server-data` for Local Server Data.
    1. Input `config/server.cfg` for Server CFG File.
1. Open your FiveM client and connect to localhost on port `30120`.

Resources in `src` are linked into the running container as a volume, meaning changes will be reflected immediately.

The base [FiveM-provided](https://github.com/citizenfx/cfx-server-data/tree/master/resources) and [mysql-async](https://github.com/brouznouf/fivem-mysql-async) resources are linked at build time, meaning pulling in any new changes is as easy as rebuilding the image. In the future, we will probably need to change this to support a scenario where we want to fork or modify the base resources (i.e. chat). For now, it's a 1 or 0 choice to use or not use any of them which we can control from `server.cfg`.
