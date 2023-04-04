<script>
import 'spectre.css'
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
    <div v-show="isActive" id="phone-outer">
        <img class="img-responsive" src="@/assets/phone.png" />
        <div id="phone-inner">
            <main>
                <HomeScreen />
            </main>
        </div>
    </div>
</template>

<style>
#phone-outer {
    bottom: 0;
    margin: 0 1em 1em 0;
    position: fixed;
    right: 0;
    width: 18vw;
}

#phone-outer img {
    height: 100%;
    position: absolute;
    width: 100%;
    z-index: 1;
}

#phone-inner {
    padding: 0.65em;
    position: relative;
    transform: translateX(-0.15em);
}

#phone-inner main {
    aspect-ratio: 9 / 19.5;
    background: url("https://images.pexels.com/photos/1723637/pexels-photo-1723637.jpeg");
    background-size: cover;
    background-repeat: no-repeat;
    height: 100%;
    width: 100%;
}
</style>
