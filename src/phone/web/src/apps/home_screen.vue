<script>
export default {
    data() {
        return {
            apps: [ {} ]
        }
    }
}
</script>

<template>
    <div class="container">
        <div v-for="app in apps" class="app">
            <div class="app-icon">
                <img src="@/assets/icon-settings.png" class="img-responsive" />
            </div>
            <div class="app-name text-light text-center">
                <p>Settings</p>
            </div>
        </div>
    </div>
</template>

<style>
.app {
    display: inline-block;
    margin: 0.5em 0;
    width: 20%;
}

.app-icon {
    height: 3.5em;
    margin: auto;
    position: relative;
    width: 3.5em;
}

.app p {
    margin: 0;
}
</style>