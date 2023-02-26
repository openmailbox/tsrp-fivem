<script>
import ItemDetails from './item_details.vue'

export default {
    data() {
        return {
            hover: false
        }
    },
    props: ["name"],
    components: { ItemDetails }
}
</script>

<template>
    <div class="item">
        <div
            @mouseover="hover = true"
            @mouseleave="hover = false"
            class="title text-light h4 text-center"
        >
            {{ name[0].toUpperCase() }}
        </div>
        <ItemDetails
            class="item-tooltip"
            v-show="hover"
            :name="name"
        />
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
</style>