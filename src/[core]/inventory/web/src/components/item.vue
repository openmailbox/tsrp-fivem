<script>
import ItemActions from './item_actions.vue'
import ItemDetails from './item_details.vue'

export default {
    data() {
        return {
            hover: false,
            isDisabled: false
        }
    },
    computed: {
        hasActions() {
            return this.actions && this.actions.length > 0;
        },

        iconFromName() {
            return (this.name && this.name[0].toUpperCase()) || '';
        }
    },
    methods: {
        select(event) {
            if (!this.actions || this.actions.length === 0) return;

            if (this.isDisabled) return;
            this.isDisabled = true;

            let actionIndex = 0;

            if (event.shiftKey) actionIndex += 1;
            if (event.ctrlKey) actionIndex += 1;
            if (event.altKey) actionIndex += 1;

            fetch("https://inventory/inventory:CreateItemAction", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=UTF-8" },
                body: JSON.stringify({
                    item: { uuid: this.uuid, name: this.name },
                    action: this.actions[actionIndex]
                })
            }).then(resp => resp.json()).then(function(resp) {
                this.isDisabled = false;

                if (resp.success) {
                    this.$emit('itemRemoved', this.uuid);
                }
            }.bind(this));
        }
    },
    props: ["name", "description", "uuid", "actions", "quantity"],
    components: { ItemActions, ItemDetails }
}
</script>

<template>
    <div
        @mouseover="hover = true"
        @mouseleave="hover = false"
        @click="select($event)"
        class="item"
        :class="{ disabled: isDisabled }"
    >
        <div class="item-icon-outer text-secondary">
            <div class="item-icon-inner h2">{{ iconFromName }}</div>
            <div v-show="quantity > 1" class="item-icon-quantity">{{ quantity || '' }}</div>
        </div>
        <div class="p-absolute item-extras" v-show="hover">
            <div class="container">
                <div class="columns col-gapless">
                    <div v-show="!hasActions" class="column col-3"></div>

                    <ItemDetails
                        class="column col-9 item-modal"
                        :name="name"
                        :description="description"
                    />

                    <div v-show="hasActions" class="column col-3">
                        <ItemActions class="item-modal"
                            :actions="actions"
                        />
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<style>
.item {
    background: black;
    border: 1px solid green;
    display: inline-block;
    height: 100%;
    width: 100%
}

.item:hover {
    border: 1px solid white;
}

.item.disabled {
    border: 1px solid rgb(0, 0, 0);
    background: rgb(42, 42, 42);
}

.item-icon-outer {
    height: 100%;
    position: relative;
    width: 100%;
}

.item-icon-inner {
    left: 50%;
    position: absolute;
    top: 50%;
    transform: translate(-50%, -50%);
    user-select: none;
}

.item-icon-quantity {
    bottom: 0;
    font-size: 1.5em;
    padding-right: 0.15em;
    position: absolute;
    right: 0;
    z-index: 1;
}

.item-extras {
    margin-top: -2vh;
    margin-left: -26vw;
    pointer-events: none;
    width: 25vw;
}

.item-modal {
    display: inline-block;
}
</style>
