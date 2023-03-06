<script>
import ModelTree from './components/model_tree.vue'
import ModelDetails from './components/model_details.vue'
import "../../../common/web/styles/tsrp-theme.css"
import TestData from './test/default' // data for testing the front-end

export default {
    data() {
        return {
            categories: TestData.categories
        }
    },
    components: { ModelTree, ModelDetails }
}
</script>

<template>
    <div>
        <ModelTree :categories="categories" />

        <ModelDetails />
    </div>
</template>

<style>
</style>
