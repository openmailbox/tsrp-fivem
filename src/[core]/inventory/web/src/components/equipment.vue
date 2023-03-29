<script>
import Item from './item.vue'
export default {
    data() {
        return {
            equipmentGrid: [
                [-1, "Throwable", "Heavy", "Shotgun", -1],
                ["Pistol", -1, -1, -1, "Melee"],
                [-1, "SMG/MG", "Rifle", "Sniper", -1]
            ]
        }
    },
    components: { Item },
    methods: {
        getEquippedItem(slotName) {
            return this.equipment[slotName]
        },

        removeItem(uuid) {
            for (const [slot, item] of Object.entries(this.equipment)) {
                if (item.uuid === uuid) {
                    this.equipment[slot] = null;
                    return;
                }
            }
        }
    },
    props: ["equipment"]
}
</script>

<template>
    <div id="equipment" class="container">
        <div class="columns">
            <div class="column col-4" v-for="column in equipmentGrid">
                <div v-for="gearSlot in column">
                    <div v-if="gearSlot !== -1" class="slot">
                        <Item
                            v-if="getEquippedItem(gearSlot)"
                            @item-removed="removeItem"
                            :data-uuid="getEquippedItem(gearSlot).uuid"
                            :uuid="getEquippedItem(gearSlot).uuid"
                            :name="getEquippedItem(gearSlot).label"
                            :description="getEquippedItem(gearSlot).description"
                            :details="getEquippedItem(gearSlot).details"
                            :actions="getEquippedItem(gearSlot).actions"
                        />
                    </div>
                    <div v-else class="spacer"></div>
                </div>
            </div>
        </div>
    </div>
</template>

<style>
#equipment {
    margin-top: 45vh;
    transform: translateY(-50%);
}

#equipment .slot, #equipment .spacer {
    height: 4vw;
    margin: 2vh auto;
    width: 4vw;
}

#equipment .slot {
    border: 2px solid black;
    background: rgb(69, 69, 69);
}
</style>
