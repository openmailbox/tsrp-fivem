AddMigration("20220723_create_bank_accounts", function()
    MySQL.Sync.execute(
        [[CREATE TABLE bank_accounts (
            id bigint not null auto_increment primary key,
            created_at timestamp null,
            account_id bigint not null,
            balance bigint not null
        );

        CREATE INDEX idx_bank_accounts_account_id on bank_accounts (account_id);]]
    )
end)
