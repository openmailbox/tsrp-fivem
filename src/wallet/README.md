# Wallet
Provides a simple interface for interacting with a player's wallet.

```lua
exports.wallet:AdjustCash(player_id, 42)  -- add $42
exports.wallet:AdjustCash(player_id, -10) -- remove $10
```

The `AdjustCash()` export returns `false` if the wallet has insufficient funds.

Wallets are owned by the server, but will be synchronized across clients using the proper natives.
