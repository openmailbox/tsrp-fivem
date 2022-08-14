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
    <div v-show="isActive" class="container">
        <CategorySelector @cancel="deleteSession" />
        <CategoryDetails />
    </div>
</template>
