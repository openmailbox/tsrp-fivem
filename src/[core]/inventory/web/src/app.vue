<script>
import Container from "./components/container.vue";
import Equipment from "./components/equipment.vue";

export default {
    data() {
        return {
            isActive: false
        }
    },
    methods: {
        changeMessage(data) {
            console.log(`changing message to ${data.message}`);
            this.message = data.message;
        }
    },
    components: { Container, Equipment },
}
</script>

<template>
    <div v-show="isActive" id="inventory">
        <Equipment />
        <Container />
    </div>
</template>

<style>
#inventory {
    float: right;
}
</style>
