<script>
import Container from "./components/container.vue";
//import ItemData from "./test/items" // for testing

export default {
    data() {
        return {
            isActive: false,
            containers: {
                inventory: {
                    contents: [] // ItemData.items
                }
            }
        }
    },
    methods: {
        createSession() {
            this.isActive = true;
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
    components: { Container },
}
</script>

<template>
    <div v-show="isActive" id="inventory">
        <Container
            :contents="containers.inventory.contents"
        />
    </div>
</template>

<style>
#inventory {
    float: right;
}
</style>
