# Time Served FiveM Code
This repository contains open-source scripts for the [Time Served](https://www.timeservedrp.com) community FiveM server.

## Contributing
Contributions are welcome. Here are instructions for setting up a local development environment:
1. Install [Docker](https://www.docker.com/).
1. `git clone` this repository into a local directory of your choice.
1. Obtain your own license key from the [Fivem Keymaster](https://keymaster.fivem.net/).
1. Paste your key into a file named `fivem-key.txt` in the top level of your repo copy.
1. Use [Docker Compose](https://docs.docker.com/compose/) to execute `compose up` on the `compose.yaml` file.
1. In your browser, navigate to `http://localhost:40125` using the mapped port. You will see the txAdmin setup screen.
1. Inspect the logs of the resulting `tsrp-fivem` container to find the pin number to setup txAdmin.
1. Complete txAdmin setup and start the FiveM server.
1. Open your FiveM client and connect to localhost on port `30120`.

Resources in `src` are linked into the running container as a volume, meaning changes will be reflected immediately.

The base [FiveM-provided resources](https://github.com/citizenfx/cfx-server-data/tree/master/resources) are linked at build time, meaning pulling in any new changes is as easy as rebuilding the image. In the future, we will probably need to change this to support a scenario where we want to fork or modify the base resources (i.e. chat). For now, it's a 1 or 0 choice to use or not use any of them which we can control from `server.cfg`.
