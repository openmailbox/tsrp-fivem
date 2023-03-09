<script>
import Item from './item.vue'
export default {
    components: { Item }
}
</script>

<template>
    <div id="equipment" class="container">
        <div class="columns">
            <div class="column col-4">
                <div class="spacer"></div>
                <div class="slot"></div>
                <div class="slot"></div>
                <div class="slot"></div>
            </div>
            <div class="column col-4">
                <div class="slot p-relative">
                    <!--<Item :name="'Pistol'" :description="'Blah blah blah'" />-->
                </div>
                <div class="spacer"></div>
                <div class="spacer"></div>
                <div class="spacer"></div>
                <div class="slot"></div>
            </div>
            <div class="column col-4">
                <div class="spacer"></div>
                <div class="slot"></div>
                <div class="slot"></div>
                <div class="slot"></div>
            </div>
        </div>
    </div>
</template>

<style>
#equipment {
    margin-top: 50vh;
    transform: translateY(-50%);
}

#equipment .slot, #equipment .spacer {
    height: 4vw;
    margin: 1vh auto;
    width: 4vw;
}

.slot {
    border: 1px solid black;
}
</style>
