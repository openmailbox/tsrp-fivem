<script>
import Category from './category.vue';

export default {
    props: ['categories'],
    emits: ['cancel'],
    components: { Category }
}
</script>

<template>
    <div class="panel tsrp-bg-semi">
        <div class="panel-header">
            <div class="panel-title h5 title text-center">Character Customization</div>
        </div>
        <div class="panel-body columns">
            <Category v-for="cat in categories" :label="cat.label" />
        </div>
        <div class="panel-footer text-center">
            <button @click="$emit('cancel')" class="btn btn-lg btn-error">Cancel</button>
            <button class="btn btn-lg btn-success">Confirm</button>
        </div>
    </div>
</template>

<style>
.panel {
    height: 50vh;
    margin-top: 20vh;
}

.panel-body {
    margin: 0 0 0 2px;
    padding: 0;
    overflow-x: hidden;
}
</style>
