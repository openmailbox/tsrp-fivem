// test data for populating the front-end
export default {
    items: [
        {
            name: "Energy Drink",
            description: "Use to regain a small amount of health over time.",
            actions: [ "Use", "Discard" ],
            quantity: 1
        },
        {
            name: "Body Armor",
            description: "Use to refill your body armor.",
            actions: [ "Use", "Discard" ],
            quantity: 1
        },
        {
            name: "Coffee",
            description: "Drink for a boost",
            actions: [ "Use", "Discard" ],
            quantity: 3
        }
    ],

    equipment: {
        Pistol: { name: "heavypistol", label: "Heavy Pistol" },
        Melee: { name: "dagger", label: "Antique Dagger" },
        Throwable: { name: "grenade", label: "Grenade" },
        Heavy: { name: "machinegun", label: "Machine Gun" }
    }
}