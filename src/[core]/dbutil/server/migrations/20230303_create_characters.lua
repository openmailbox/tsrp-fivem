AddMigration("20230303_create_characters", function()
    MySQL.Sync.execute(
        [[CREATE TABLE characters (
            id bigint not null auto_increment primary key,
            created_at timestamp null,
            last_connect_at timestamp null,
            account_id bigint not null,
            first_name varchar(50) not null,
            last_name varchar(50) not null,
            appearance json null
        );

        CREATE INDEX idx_characters_account_id on characters (account_id);
        CREATE INDEX idx_characters_last_name on characters (last_name);]]
    )
end)
