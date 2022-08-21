<script>
import IndexControl from './controls/index_control.vue'

export default {
    props: ["controls"],
    components: { IndexControl }
}
</script>

<template>
    <div class="panel tsrp-bg-semi category-details">
        <div class="panel-body">
            <div v-for="control in controls">
                <IndexControl v-if="control.type === 'index'"
                    :name="control.name"
                    :count="control.count"
                    :value="control.value" />
            </div>
        </div>
    </div>
</template>

<style>
.category-details {
    height: 70vh;
    margin-top: 13vh;
}

.category-details .panel-body {
    padding: 0;
}
</style>