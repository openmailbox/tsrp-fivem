<script>
import ModelTree from './components/model_tree.vue'
import ModelDetails from './components/model_details.vue'
import "../../../common/web/styles/tsrp-theme.css"
import TestData from './test/default' // data for testing the front-end

export default {
    data() {
        return {
            isActive: false,
            categories: TestData.categories,
            selectedModel: {}
        }
    },
    components: { ModelTree, ModelDetails },
    methods: {
        createSession() {
            this.isActive = true;
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

        setModel(model, category) {
            model.owned    = 0;
            model.category = category;

            this.selectedModel = model;
        }
    }
}
</script>

<template>
    <div v-show="isActive">
        <ModelTree
            :categories="categories"
            @select-model="(model, category) => setModel(model, category)"
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
