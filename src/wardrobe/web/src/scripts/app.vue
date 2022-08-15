<script>
import CategorySelector from './category-selector.vue'
import CategoryDetails from './category-details.vue'

export default {
    data() {
        return {
            isActive: false
        };
    },
    methods: {
        createSession() {
            this.isActive = true;
        },

        deleteSession() {
            fetch("https://wardrobe/wardrobe:DeleteSession", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=UTF-8" }
            });

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
                <CategorySelector @cancel="deleteSession" />
            </div>

            <div class="column col-4">
                <CategoryDetails />
            </div>
        </div>
    </div>
</template>
