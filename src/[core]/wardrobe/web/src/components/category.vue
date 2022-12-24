<script>
import { store } from "../store.js";

export default {
  data() {
    return {
      store,
    };
  },
  props: ["index", "label", "selected"],
};
</script>

<template>
  <div
    @click="store.selectCategory(index)"
    class="category column col-6"
    :class="{ highlighted: selected }"
  >
    <img
      class="wardrobe-icon d-block"
      src="https://img.icons8.com/nolan/64/fill-color.png"
    />
    <span class="title h5">{{ label }}</span>
  </div>
</template>

<style>
.category {
  border: 1px solid #2d375b;
  border-right: 5px solid #2d375b;
  height: 7em;
  padding: 10px 0;
  text-align: center;
}

.category .title {
  font-size: 1em;
}

@media only screen and (min-width: 2560px) {
  category .title {
    font-size: 2.2vh;
  }
}

.wardrobe-icon {
  height: 64px;
  width: 64px;
  margin: auto;
}

.category.highlighted {
  border-color: #24fae1;
  color: #24fae1;
}
</style>
