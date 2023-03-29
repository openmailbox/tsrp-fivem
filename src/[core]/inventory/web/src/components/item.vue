<script>
import ItemActions from './item_actions.vue'
import ItemDetails from './item_details.vue'
import QuantitySelect from './quantity_select.vue'

export default {
    props: ["name", "description", "uuid", "actions", "quantity", "details"],
    components: { ItemActions, ItemDetails, QuantitySelect },
    emits: ["itemRemoved"],
    data() {
        return {
            hover: false,
            isDisabled: false,
            pendingAction: null,
            waitingForQuantity: false
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
        getActionFromEvent(event) {
            let actionIndex = 0;

            if (event.shiftKey) actionIndex += 1;
            if (event.ctrlKey) actionIndex += 1;
            if (event.altKey) actionIndex += 1;

            return this.actions[actionIndex];
        },

        performAction(action, quantity) {
            fetch("https://inventory/inventory:CreateItemAction", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=UTF-8" },
                body: JSON.stringify({
                    item: { uuid: this.uuid, name: this.name },
                    action: action,
                    quantity: quantity || 1
                })
            }).then(resp => resp.json()).then(function(resp) {
                this.isDisabled = false;

                if (resp.success) {
                    this.$emit('itemRemoved', this.uuid, quantity);
                }
            }.bind(this));
        },

        selectItem(event) {
            if (!this.actions || this.actions.length === 0) return;

            if (this.isDisabled) return;
            this.isDisabled = true;

            const action        = this.getActionFromEvent(event);
            const isFirstAction = action === this.actions[0];

            if (!isFirstAction && this.quantity > 1) {
                this.pendingAction = event;
                this.waitingForQuantity = true;
            } else {
                this.performAction(action)
            }
        },

        selectQuantity(amount) {
            this.performAction(this.getActionFromEvent(this.pendingAction), parseInt(amount));
            this.waitingForQuantity = false;
            this.pendingAction = null;
        }
    }
}
</script>

<template>
    <div
        @mouseover="hover = true"
        @mouseleave="hover = false"
        @click="selectItem($event)"
        class="item"
        :class="{ disabled: isDisabled }"
    >
        <div class="item-icon-outer text-secondary">
            <div class="item-icon-inner h2">{{ iconFromName }}</div>
            <div v-show="quantity > 1" class="item-icon-quantity">{{ quantity }}</div>
        </div>
        <div class="p-absolute item-extras" v-show="hover">
            <div class="container">
                <div class="columns col-gapless">
                    <div v-show="!hasActions" class="column col-3"></div>

                    <ItemDetails
                        class="column col-9 item-modal"
                        :name="name"
                        :description="description"
                        :details="details"
                    />

                    <div v-show="hasActions" class="column col-3">
                        <ItemActions class="item-modal"
                            :actions="actions"
                        />
                    </div>
                </div>
            </div>
        </div>

        <QuantitySelect
            v-show="waitingForQuantity"
            :maximum="quantity"
            @quantity-selected="(n) => selectQuantity(n)"
        />
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
