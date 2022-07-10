# NPC Relationships
This resource makes NPCs engage in dynamic acts based on preset relationship groups with other NPCs (and players). In other words, this resource allows the developer to configure how NPCs should act around each other. You can make two gangs attack each other on sight, cause NPC cops to back up player cops in gun fights, and so on.

## Configuration
All configuration lives in `shared/config.lua`. Comments in that file provide details on what each section does.

# How it Works
NPC behaviors are based on the built-in FiveM concept of **Relationships**. Any ped (NPC or player) can be assigned to a single "relationship group". For example, if the Ballas and Vagos groups are configured to hate each other, then the locals in those groups will attack each other on sight. They will literally car jack, fight, and shoot each other in the middle of the street.

In order for this to work, two things need to happen:
1. The Ballas and Vagos relationship groups need to be set to "hate" each other. This is done using the [`SetRelationshipBetweenGroups()`](https://runtime.fivem.net/doc/natives/?_0xBF25EB89375A37AD) native.
2. The locals need to be assigned to those relationship groups using the [`SetPedRelationshipGroupHash()`](https://runtime.fivem.net/doc/natives/?_0xC80A74AC829DDD92) native.

The hidden complexity here is that _every_ ped must be properly assigned to the correct relationship group when it spawns, and _every_ player needs to be running the same relationship configurations at the same time. This is because there's no guarantee of which client is the network owner for each local.

This resource abstracts the maintenance of group assignments behind a single configuration file, and listens for newly spawned locals in order to make sure they're properly assigned. That's it. It's deceptively simple. There is almost 0 performance impact on either client or server.
