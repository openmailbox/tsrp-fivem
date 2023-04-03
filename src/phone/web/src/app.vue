<script>
import HomeScreen from './apps/home_screen.vue'

export default {
    components: { HomeScreen },
    data() {
        return {
            isActive: true
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
        <HomeScreen />
    </main>
</template>

<style>
main {
    aspect-ratio: 9 / 16;
    background: url("https://images.pexels.com/photos/1723637/pexels-photo-1723637.jpeg");
    background-size: cover;
    background-repeat: no-repeat;
    bottom: 0;
    border: 0.8vw solid gray;
    margin: 0 1em 1em 0;
    position: absolute;
    right: 0;
    width: 20vw;
}
</style>
