<script>
import ModelTree from './components/model_tree.vue'
import ModelDetails from './components/model_details.vue'
import "../../../common/web/styles/tsrp-theme.css"
import TestData from './test/default' // data for testing the front-end

export default {
    data() {
        return {
            isActive: true,
            categories: TestData.categories,
            selectedModel: {}
        }
    },
    components: { ModelTree, ModelDetails },
    methods: {
        createSession() {
            this.isActive = false;
        },

        deleteSession(skipPost) {
            if (!skipPost) {
                fetch("https://showroom/showroom:DeleteSession", {
                    method: "POST",
                    headers: { "Content-Type": "application/json; charset=UTF-8" },
                });
            }

            this.isActive = false;
        },

        setModel(model) {
            this.selectedModel = model;
        }
    }
}
</script>

<template>
    <div v-show="isActive">
        <ModelTree
            :categories="categories"
            @select-model="(vehicle) => setModel(vehicle)"
        />

        <ModelDetails
            v-show="selectedModel.name"
            :name="selectedModel.name"
            :price="selectedModel.price"
            :category="selectedModel.category"
            :owned="selectedModel.owned"
        />
    </div>
</template>

<style>
</style>
