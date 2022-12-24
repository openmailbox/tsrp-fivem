<script>
import { store } from "../../store.js";

export default {
  data() {
    return {
      store,
    };
  },
  props: ["label", "max", "min", "value"],
  computed: {
    count() {
      return this.max - this.min + 1;
    },
  },
};
</script>

<template>
  <div class="card details-slider">
    <div class="card-header">
      <div class="card-title h5 d-inline-flex">{{ label }}</div>
      <span class="variant-count ml-2">{{ value }} of {{ count }}</span>
    </div>
    <div class="card-body">
      <input
        class="slider"
        type="range"
        :min="min"
        :max="max"
        :value="value"
        @input="store.setValue(label, $event.target.value)"
      />
    </div>
  </div>
</template>

<style>
.details-slider .slider {
  height: 3em;
}

.details-slider .slider:focus {
  box-shadow: none;
}
</style>
