<script>
import ItemActions from './item_actions.vue'
import ItemDetails from './item_details.vue'

export default {
    data() {
        return {
            hover: false
        }
    },
    props: ["name", "description"],
    components: { ItemActions, ItemDetails }
}
</script>

<template>
    <div
        @mouseover="hover = true"
        @mouseleave="hover = false"
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
    width: 25vw;
}

.item-modal {
    display: inline-block;
}
</style>