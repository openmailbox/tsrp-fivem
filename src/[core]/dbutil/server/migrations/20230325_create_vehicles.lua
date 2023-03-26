AddMigration("20230303_create_vehicles", function()
    MySQL.Sync.execute(
        [[CREATE TABLE vehicles (
            id bigint not null auto_increment primary key,
            created_at timestamp null,
            last_seen_at timestamp null,
            character_id bigint null,
            model varchar(50) not null
        );

        CREATE INDEX idx_vehicles_character_id on vehicles (character_id);]]
    )
end)
