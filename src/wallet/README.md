# Wallet
Provides a simple interface for interacting with a player's wallet.

```lua
-- assume starting balance is $0
local balance = exports.wallet:AdjustCash(player_id, 42)  -- add $42
print(balance) -- $42

balance = exports.wallet:AdjustCash(player_id, -10) -- remove $10
print(balance) -- $32
```

The `AdjustCash()` export prevents a wallet from having a negative balance, and will always floor at 0.

Wallets are owned by the server, but will be synchronized across clients using the proper natives.
