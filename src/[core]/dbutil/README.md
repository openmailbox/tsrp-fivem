# Database Utilities
This resource does two things:
1. Provide utilities and a workflow for managing a continually evolving database schema.
1. Provide a consistent API for resources that need to interact with the database.

The second one is largely provided by the [mysql-async](https://github.com/brouznouf/fivem-mysql-async) resource out of the box. An argument could be made for wrapping `mysql-async` in our own API in case we want to swap out for a different database adapter later. However, that would take a significant amount of work at this point given that we're trying to open source existing TSRP code in mass. We'd have to change every single call site to `MySQL.Async` and/or override the global definition. Doesn't seem like the juice is worth the squeeze for now, but could be a good future refactor.

## Migrations
