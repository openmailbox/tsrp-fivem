<script>
import ModelTree from './components/model_tree.vue'
import ModelDetails from './components/model_details.vue'
import "../../../common/web/styles/tsrp-theme.css";

export default {
    data() {
        return {
            message: 'Hello World!'
        }
    },
    methods: {
        changeMessage(data) {
            console.log(`changing message to ${data.message}`);
            this.message = data.message;
        }
    },
    components: { ModelTree, ModelDetails }
}
</script>

<template>
    <div>
        <ModelTree />

        <ModelDetails />
    </div>
</template>

<style>
</style>
