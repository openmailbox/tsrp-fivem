<script>
import { store } from './store.js'
import CategorySelector from './category-selector.vue'
import CategoryDetails from './category-details.vue'

export default {
    data() {
        return {
            store,
            isActive: false,
        };
    },
    methods: {
        createSession(data) {
            store.initialize(data.state);
            this.isActive = true;
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
                <CategorySelector :categories="store.categories" @cancel="deleteSession" />
            </div>

            <div class="column col-4">
                <CategoryDetails :controls="store.getActiveControls()" />
            </div>
        </div>
    </div>
</template>
