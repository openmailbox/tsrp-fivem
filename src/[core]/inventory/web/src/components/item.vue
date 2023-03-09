<script>
import ItemActions from './item_actions.vue'
import ItemDetails from './item_details.vue'

export default {
    data() {
        return {
            hover: false,
            isDisabled: false,
            isRemoved: false
        }
    },
    methods: {
        select(event) {
            if (this.isDisabled) return;
            this.isDisabled = true;

            let route = "https://inventory/inventory:CreateItemUse"

            if (event.shiftKey) {
                route = "https://inventory/inventory:CreateItemDiscard"
            }

            fetch(route, {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=UTF-8" },
                body: JSON.stringify({
                    item: { uuid: this.uuid, name: this.name, description: this.description },
                    modifiers: { shift: event.shiftKey, control: event.ctrlKey }
                })
            }).then(resp => resp.json()).then((resp) => {
                if (resp.success) {
                    this.isRemoved = true;
                } else {
                    this.isDisabled = false;
                }
            });
        }
    },
    props: ["name", "description", "uuid"],
    components: { ItemActions, ItemDetails }
}
</script>

<template>
    <div
        @mouseover="hover = true"
        @mouseleave="hover = false"
        @click="select($event)"
        v-show="!isRemoved"
        class="item"
        :class="{ disabled: isDisabled }"
    >
        <div class="item-icon-outer text-secondary">
            <div class="item-icon-inner h2">
                {{ name[0].toUpperCase() }}
            </div>
        </div>
        <div class="p-absolute item-extras" v-show="hover">
            <div class="container">
                <div class="columns col-gapless">
                    <ItemDetails
                        class="column col-9 item-modal"
                        :name="name"
                        :description="description"
                    />

                    <div class="column col-3">
                        <ItemActions class="item-modal" />
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

.item-extras {
    margin-top: -2vh;
    margin-left: -29vw;
    pointer-events: none;
    width: 33vw;
}

.item-modal {
    display: inline-block;
}
</style>
