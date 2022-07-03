AddMigration("20220703_create_migrations", function()
    MySQL.Sync.execute(
        [[CREATE TABLE migrations (
            id bigint not null auto_increment primary key,
            name varchar(255) not null
        );

        CREATE UNIQUE INDEX idx_migrations_name ON migrations (name);]]
    )
end)