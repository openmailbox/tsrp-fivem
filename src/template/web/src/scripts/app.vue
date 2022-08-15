<script>
export default {
    data() {
        return {
            message: 'Hello World!'
        }
    },
    methods: {
        changeMessage(data) {
            console.log(`changing message to ${data.message}`);
            this.message = data.message;
        }
    }
}
</script>

<template>
    <div class="my-component">
        {{ message }}
    </div>
</template>

<style>
.my-component {
    display: inherit;
}
</style>
