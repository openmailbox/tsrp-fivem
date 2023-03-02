<script>
import ItemActions from './item_actions.vue'
import ItemDetails from './item_details.vue'

export default {
    data() {
        return {
            hover: false
        }
    },
    methods: {
        select(event) {
            if (!fetch) {
                console.warn("Unable to find fetch() API for FiveM.")
                return
            }

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
        class="item"
    >
        <div class="title text-light h4 text-center">
            {{ name[0].toUpperCase() }}
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
    margin: 1em 0.5em 1em 0;
    width: 3vw;
    height: 3vw;
}

.item:hover {
    border: 1px solid white;
}

.item-extras {
    margin-top: -2vh;
    margin-left: -24vw;
    pointer-events: none;
    width: 33vw;
}

.item-modal {
    display: inline-block;
}
</style>
