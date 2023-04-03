<script>
export default {
    data() {
        return {
            isActive: false
        }
    },
    methods: {
        createSession() {
            this.isActive = true;
        },

        deleteSession() {
            this.isActive = false;

            fetch("https://phone/phone:DeleteSession", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=UTF-8" }
            });
        }
    }
}
</script>

<template>
    <main v-show="isActive">
    </main>
</template>

<style>
main {
    background: gray;
    bottom: 0;
    height: 60vh;
    margin: 0 1em 1em 0;
    position: absolute;
    right: 0;
    width: 18vw;
}
</style>
