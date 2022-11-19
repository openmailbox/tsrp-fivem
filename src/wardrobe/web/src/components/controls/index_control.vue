<script>
import { store } from "../../store.js";

export default {
  data() {
    return {
      store,
    };
  },
  props: ["label", "count", "value"],
};
</script>

<template>
  <div class="card">
    <div class="card-header">
      <div class="card-title h5">{{ label }}</div>
    </div>
    <div class="card-body">
      <div class="columns">
        <div
          v-for="n in count"
          @click="store.setValue(label, n)"
          class="column col-1 index-option"
          :class="{ highlighted: value === n }"
        >
          <div class="text-center title h3">{{ n }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<style>
.index-option {
  background-color: #0f121e;
  border: 3px solid #262d4c;
  height: 5vh;
  margin: 0.4vh;
  padding: 0;
}

.index-option .h3 {
  font-size: 2vh;
  margin-top: 0.5vh;
}

@media only screen and (min-width: 2560px) {
  .index-option .h3 {
    font-size: 2.2vh;
  }
}

.index-option.highlighted {
  border-color: #24fae1;
  color: #24fae1;
}
</style>
