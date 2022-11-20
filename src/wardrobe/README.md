# Wardrobe

This resource provides a user interface for various (eventually all) aspects of character customization. Players enter a wardrobe "session" with the `/wardrobe` command (for now; likely permissioned later). You can also programmatically start a wardrobe session by generating a client-side event: `TriggerEvent(Events.CREATE_WARDROBE_SESSION)`. The wardrobe session event is one of the many [globally defined events](https://github.com/openmailbox/tsrp-fivem/blob/main/src/common/shared/events.lua).

## Contributing

For the moment, you'll need to manage your own NodeJS installation if you want to work on the front-end. This will likely change later.

1. Install the latest [NodeJS LTS](https://nodejs.org/en/).
1. From the top-level directory of the repo (where you can see `src/`)...
    1. Run `npm ci --workspaces` to install dependencies.
    1. Run `npm run dev -w wardrobe` to start a local dev server and also recompile changed assets on the fly.
