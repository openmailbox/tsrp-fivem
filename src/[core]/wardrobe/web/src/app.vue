<script>
import { store } from "./store.js";
import CategorySelector from "./components/category-selector.vue";
import CategoryDetails from "./components/category-details.vue";

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

    deleteSession(skipPost, rollback) {
      if (!skipPost) {
        fetch("https://wardrobe/wardrobe:DeleteSession", {
          method: "POST",
          headers: { "Content-Type": "application/json; charset=UTF-8" },
          body: JSON.stringify({ rollback: rollback })
        });
      }

      this.isActive = false;
    },

    rollbackAndExit() {
      this.deleteSession(false, true);
    },

    saveAndExit() {
      this.deleteSession();
    }
  },
  components: { CategorySelector, CategoryDetails },
};
</script>

<template>
  <div v-show="isActive" class="container text-secondary">
    <div class="columns">
      <div class="column col-6"></div>

      <div class="column col-2">
        <CategorySelector
          :categories="store.categories"
          @cancel="rollbackAndExit"
          @save="saveAndExit"
        />
      </div>

      <div class="column col-4">
        <CategoryDetails :controls="store.getActiveControls()" />
      </div>
    </div>
  </div>
</template>
