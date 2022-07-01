# Time Served FiveM Code
This repository contains open-source scripts for the [Time Served](https://www.timeservedrp.com) community FiveM server.

## Contributing
Contributions are welcome. Here are instructions for setting up a local development environment:
1. Install [Docker](https://www.docker.com/).
1. `git clone` this repository into a local directory of your choice.
1. Obtain your own license key from the [Fivem Keymaster](https://keymaster.fivem.net/).
1. Paste your key into a file named `fivem-key.txt` in the top level of your repo copy.
1. Use [Docker Compose](https://docs.docker.com/compose/) to execute `compose up` on the `compose.yaml` file.
1. In the resulting `tsrp-fivem` container, find the port that was mapped from your local host to container port `40125`.
1. In your browser, navigate to `http://localhost:<port>` using the mapped port. You will see the txAdmin setup screen.
1. Inspect the logs of the resulting `tsrp-fivem` container to find the pin number to setup txAdmin.
1. Complete txAdmin setup and start the FiveM server.
1. Open your FiveM client and connect to whatever local host port was mapped to container port `30120`.