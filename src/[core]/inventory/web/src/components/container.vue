<script>
import Item from './item.vue'

export default {
    components: { Item },
    methods: {
        removeItem(uuid, amountRemoved) {
            amountRemoved ||= 1;

            this.contents.forEach((item, i) => {
                if (item.uuid === uuid) {
                    if (item.quantity > amountRemoved) {
                        item.quantity -= amountRemoved;
                    } else {
                        this.contents.splice(i, 1)
                    }

                    return;
                }
            })
        }
    },
    props: [ "contents" ]
}
</script>

<template>
    <div class="inv-container panel">
        <div class="panel-header text-secondary">
            <div class="panel-title h3">Inventory</div>
        </div>
        <div class="panel-body tsrp-bg-semi-90">
            <div class="spacer" v-for="item in contents" :key="item.uuid">
                <Item
                    @item-removed="removeItem"
                    :data-uuid="item.uuid"
                    :uuid="item.uuid"
                    :name="item.name"
                    :description="item.description"
                    :actions="item.actions"
                    :quantity="item.quantity"
                    :details="item.details"
                />
            </div>
        </div>
    </div>
</template>

<style>
.inv-container.panel {
    margin-top: 2vh;
    height: 90vh;
}

.inv-container .panel-header {
    background: #36358f;
}

.inv-container .panel-body {
    padding: 0.4rem;
}

.inv-container .spacer {
    display: inline-block;
    height: 3vw;
    margin: 0.4rem;
    width: 3vw;
}
</style>
