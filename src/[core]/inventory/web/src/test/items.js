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
            quantity: 1,
            details: [
                { label: "+100 Armor" }
            ]
        },
        {
            name: "Coffee",
            description: "Drink for a boost",
            actions: [ "Use", "Discard" ],
            quantity: 3
        }
    ],

    equipment: {
        Pistol: {
            name:        "heavypistol",
            description: "A heavyweight champion of magazine fed, semi-automatic handguns that delivers accuracy along with a serious forearm workout.",
            label:       "Heavy Pistol",
            details: [
                { label: "Magazine",   text: "12 / 12"  },
                { label: "Ammunition", text: "50 / 100" }
            ],
        },
        Melee: {
            name:        "dagger",
            label:       "Antique Dagger",
            description: "An antique-style cavalry dagger with a hand guard."
        },
        Throwable: {
            name: "grenade",
            label: "Grenade"
        },
        Heavy: {
            name: "machinegun",
            label: "Machine Gun"
        }
    }
}