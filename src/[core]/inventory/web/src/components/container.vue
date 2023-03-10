<script>
import Item from './item.vue'

export default {
    components: { Item },
    props: [ "contents" ]
}
</script>

<template>
    <div class="inv-container panel">
        <div class="panel-header text-secondary">
            <div class="panel-title h3">Inventory</div>
        </div>
        <div class="panel-body tsrp-bg-semi-90">
            <div class="spacer" v-for="item in contents">
                <Item
                    :uuid="item.uuid"
                    :name="item.name"
                    :description="item.description"
                    :actions="item.actions"
                />
            </div>
        </div>
    </div>
</template>

<style>
.panel {
    margin-top: 2vh;
    height: 90vh;
}

.panel-header {
    background: #36358f;
}

.inv-container .spacer {
    display: inline-block;
    height: 3vw;
    margin-top: 1vh;
    margin-right: 1vw;
    width: 3vw;
}
</style>
