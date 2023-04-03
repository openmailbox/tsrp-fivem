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
        <div class="app-name text-light text-center">
            <p>Settings</p>
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
    margin: auto;
    width: 85%;
}

.app p {
    margin: 0;
}
</style>