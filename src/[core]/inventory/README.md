# Inventory
This resource provides the front-end and various bindings for player inventory, containers, and item manipulation.

## Item Actions
Items have four potential actions:
- Use
- Discard
- Equip
- Unequip

The actions available on an item depend on that item's tags (see below). However, by default all items are stackable and can be discarded.

## Item Tags
Registered items can have an arbitrary number of tags that each indicate some system behavior:

| Tag        | Behavior
| ---------- | -------
| ammunition | Resupplies player ammo when used.
| equipment  | Not stackable; can be equipped and used from the in-game weapon wheel.
| singleuse  | Only useable one at a time; can still be discarded in stacks.
