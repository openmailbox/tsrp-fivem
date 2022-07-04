AddMigration("20220704_create_accounts_and_idents", function()
    MySQL.Sync.execute(
        [[CREATE TABLE accounts (
            id bigint not null auto_increment primary key,
            created_at timestamp null,
            last_connect_at timestamp null,
            name varchar(255) not null
        );

        CREATE TABLE identifiers (
            id bigint not null auto_increment primary key,
            account_id bigint not null,
            `value` varchar(255) not null,
            created_at timestamp null
        );

        CREATE INDEX idx_identifiers_account_id on identifiers (account_id);
        CREATE INDEX idx_identifiers_value on identifiers (`value`);]]
    )
end)
