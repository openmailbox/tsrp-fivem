# Database Utilities
This resource does two things:
1. Provide utilities and a workflow for managing a continually evolving database schema.
1. Provide a consistent API for resources that need to interact with the database.

The second one is largely provided by the [mysql-async](https://github.com/brouznouf/fivem-mysql-async) resource out of the box. An argument could be made for wrapping `mysql-async` in our own API in case we want to swap out for a different database adapter later. However, that would take a significant amount of work at this point given that we're trying to open source existing TSRP code in mass. We'd have to change every single call site to `MySQL.Async` and/or override the global definition. Doesn't seem like the juice is worth the squeeze for now, but could be a good future refactor.

## Migrations
A migration is a change applied to the database schema, usually to add a new column or table. We build things iteratively, and as a result we need a way to incrementally move the database schema forward over time. We have not yet made every decision about every table and column we might want in the future. Migrations allow us to make changes later in a uniform way that (usually) doesn't require downtime for the tables in question. Migrations are important because the _structure_ of the data needs to remain consistent even if the contents of the data do not.

Migrations are named in a particular format, starting with a timestamp. Consider the following example:

```lua
AddMigration("20220703_create_items", function()
    MySQL.Sync.execute(
        [[CREATE TABLE items (
            id bigint not null auto_increment primary key,
            name varchar(255) not null
        );]]
    )
end)
```

This migration would be saved in `dbutil/server/migrations/20220703_create_items.lua`. The naming is important because migrations have an implicit dependency on each other: They must always run in the same order. I can't add a column to a table if the table does not yet exist. This is also why we are using synchronous MySQL functions instead of asynchronous for this particular use case.

The `AddMigration()` function is globally defined in the `dbutil` resource, and is the intended API for adding a migration.

After adding this migration and starting the server, run the `dbutil migrate` command from a server console to execute any pending migrations. Periodically running migrations ensures that multiple developers can make database schema changes that remain consistent with each other.
