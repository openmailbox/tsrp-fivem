<script>
import { store } from './store.js'
import CategorySelector from './category-selector.vue'
import CategoryDetails from './category-details.vue'

// temporary test data
import categoryData from '../test/category_data.js'

export default {
    data() {
        return {
            store,
            isActive: true,
            categories: categoryData.categories
        };
    },
    methods: {
        createSession(data) {
            this.categories = data.categories;
            this.isActive   = true;

            store.selectCategory(0);
        },

        deleteSession(skipPost) {
            if (!skipPost) {
                fetch("https://wardrobe/wardrobe:DeleteSession", {
                    method: "POST",
                    headers: { "Content-Type": "application/json; charset=UTF-8" }
                });
            }

            this.isActive = false;
        }
    },
    components: { CategorySelector, CategoryDetails }
}
</script>

<template>
    <div v-show="isActive" class="container text-secondary">
        <div class="columns">
            <div class="column col-6"></div>

            <div class="column col-2">
                <CategorySelector :categories="categories" @cancel="deleteSession" />
            </div>

            <div class="column col-4">
                <CategoryDetails />
            </div>
        </div>
    </div>
</template>
