<script>
import Item from './item.vue'
import ItemData from "../test/items";

export default {
    data() {
        return {
            items: ItemData.items
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
            <Item
                v-for="item in items"
                :name="item.name"
                :description="item.description"
            />
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
