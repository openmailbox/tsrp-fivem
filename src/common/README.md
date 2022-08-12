# Common Definitions
This resource provides common global definitions primarily so that other resources can refer to constants instead of strings. For example, instead of including `"onResourceStart"` as a string in every server-side event handler, resources can instead reference `Events.ON_RESOURCE_START` or something similar. Retyping the same string repeatedly is prone to user error and makes it exceedingly difficult to change the name of something later.

Use the desired definitions in other resources by including them in the manifest:

```lua
client_scripts {
    "@common/shared/events.lua",
    "@common/shared/weapons.lua",
}
```
This can be used for client or server-side scripts as needed.

## Tradeoffs
The fundamental question is about modularity. Is it better to redefine simple things like constants in every single resource that needs it? Doing so makes each resource more modular in that it can be copy/pasted into a new project without any adjustments. However, it increases the overhead of refactoring in the event that something changes. This pattern also saves on memory in the long run, assuming that referencing a script from another resource in FiveM is equivalent to pass-by-reference instead of pass-by-value. I'm not actually sure as of this writing how that works precisely, but the value of centralizing definitions still makes this worthwhile.

In short, we are making an intentional choice here to optimize for working on this codebase as a single project. We're not worried about portability.
