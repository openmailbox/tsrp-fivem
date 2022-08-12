# Resource Template
This is a template that may be used to initialize a new resource. Copy and paste this folder and edit as needed.

## Conventions
Resources are organized in a series of folders:
- `client/` - Files inteded for client-side use.
- `server/` - Files intended for server-side use.
- `shared/` - Files intended for both client and server-side use (i.e. for shared configuration).
- `web/` - HTML/CSS/JS files for client-side UI using the FiveM embedded Chrome browser.

We often use the [Model-View-Controller pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) as a framework for organizing the message passing that occurs between the server and multiple clients. The "view" is handled client-side by the contents of `web/`, but you'll commonly find subdirectories for `controllers/` and `models/` on both client and server. Examine some of the existing resources in the repository for working examples.

You'll want to check out the [common resource](https://github.com/openmailbox/tsrp-fivem/tree/webpack/src/common) for global definitions widely used across all other resources.

We typically use [Spectre CSS](https://picturepan2.github.io/spectre/) to maintain a common look and feel.






