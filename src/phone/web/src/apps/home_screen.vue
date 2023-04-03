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
    <div v-for="app in apps" class="app">
        <div class="app-icon">
            <img src="@/assets/icon-settings.png" class="img-responsive" />
        </div>
        <div class="app-name text-light text-center text-small">
            <p>Settings</p>
        </div>
    </div>
</template>

<style>
.app {
    display: inline-block;
    margin: 0.5em;
}

.app-icon {
    margin: auto;
    width: 3em;
}

.app p {
    font-size: 0.8em;
    margin: 0;
}
</style>