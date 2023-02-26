<script>
import Container from "./components/container.vue";

export default {
    data() {
        return {
            isActive: true
        }
    },
    methods: {
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
        <Container />
    </div>
</template>

<style>
#inventory {
    float: right;
}
</style>
