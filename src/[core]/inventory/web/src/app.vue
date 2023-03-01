<script>
import Container from "./components/container.vue";

export default {
    data() {
        return {
            isActive: false,
            containers: { inventory: [] }
        }
    },
    methods: {
        createSession(data) {
            this.isActive   = true;
            this.containers = data;
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

        changeMessage(data) {
            console.log(`changing message to ${data.message}`);
            this.message = data.message;
        }
    },
    components: { Container },
}
</script>

<template>
    <div v-show="isActive" id="inventory">
        <Container
            :contents="containers.inventory"
        />
    </div>
</template>

<style>
#inventory {
    float: right;
}
</style>
