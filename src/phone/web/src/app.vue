<script>
import 'spectre.css'

import HomeScreen from './apps/home/main.vue'
import StatusBar from './apps/status_bar.vue'
import AppRegistry from './apps/registry.js'

let components = { HomeScreen, StatusBar };

AppRegistry.installed.forEach((app) => {
    components[app.name] = app.component;
});

export default {
    components: components,
    data() {
        return {
            clockTimer: 0,
            currentApp: "HomeScreen",
            gameTime: { hours: 0, minutes: 0 },
            isActive: true
        }
    },
    methods: {
        createSession(data) {
            if (this.isActive) return;

            this.gameTime   = data.time;
            this.clockTimer = setInterval(this.syncTime, 10000)
            this.currentApp = "HomeScreen";
            this.isActive   = true;
        },

        deleteSession() {
            this.isActive = false;

            clearInterval(this.clockTimer);

            fetch("https://phone/phone:DeleteSession", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=UTF-8" }
            });
        },

        goHome() {
            this.currentApp = "HomeScreen";
        },

        syncTime() {
            fetch("https://phone/phone:GetGameTime", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=UTF-8" }
            }).then(resp => resp.json()).then(function (resp) {
                this.gameTime = resp;
            }.bind(this))
        }
    },
    computed: {
        appRegistry() {
            return AppRegistry.installed;
        },

        displayTime() {
            return `${String(this.gameTime.hours).padStart(2, "0")}:${String(this.gameTime.minutes).padStart(2, "0")}`;
        }
    }
}
</script>

<template>
    <div v-show="isActive" id="phone-outer">
        <img class="img-responsive" src="@/assets/phone.png" />
        <div id="phone-inner">
            <main>
                <StatusBar :time="displayTime" />
                <component :is="currentApp"
                    :installed-apps="appRegistry"
                    @open-app="(name) => currentApp = name"
                ></component>
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
    pointer-events: none;
    position: absolute;
    width: 100%;
    z-index: 1;
}

#phone-inner {
    padding: 0.9em 0.7em;
    position: relative;
    transform: translateX(-0.1em);
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
