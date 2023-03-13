<script>
import Container from "./components/container.vue";
import Equipment from "./components/equipment.vue";
//import ItemData from "./test/items" // for testing

export default {
    data() {
        return {
            isActive: false,
            equipment: {}, // ItemData.equipment,
            containers: {
                inventory: {
                    contents: [], // ItemData.items,
                }
            }
        }
    },
    methods: {
        createSession(equipData) {
            this.equipment = equipData;
            this.isActive  = true;
        },

        deleteSession(skipPost) {
            if (!skipPost) {
                fetch("https://inventory/inventory:DeleteSession", {
                    method: "POST",
                    headers: { "Content-Type": "application/json; charset=UTF-8" },
                });
            }

            this.isActive = false;
        },

        updateContainers(data) {
            this.containers = data;
        }
    },
    components: { Equipment, Container },
}
</script>

<template>
    <div v-show="isActive" id="inventory">
        <div class="container">
            <div class="columns">
                <div class="column col-3"></div>
                <div class="column col-3">
                    <Equipment
                        :equipment="equipment"
                    />
                </div>

                <div class="column col-2">
                </div>

                <div class="column col-4">
                    <Container
                        :contents="containers.inventory.contents"
                    />
                </div>

            </div>
        </div>
    </div>
</template>

<style>
</style>
