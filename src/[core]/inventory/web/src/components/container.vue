<script>
import Item from './item.vue'

export default {
    data() {
        return {
        }
    },
    methods: {
    },
    components: { Item }
}
</script>

<template>
    <div class="panel">
        <div class="panel-header text-secondary">
            <div class="panel-title h3">Inventory</div>
        </div>
        <div class="panel-body tsrp-bg-semi-90">
            <Item />
        </div>
    </div>
</template>

<style>
.panel {
    width: 33vw;
    height: 100vh;
}

.panel-header {
    background: #36358f;
}
</style>
