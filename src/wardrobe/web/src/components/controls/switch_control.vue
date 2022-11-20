<script>
import { store } from "../../store.js";

export default {
  data() {
    return {
      store,
    };
  },
  props: ["label", "options", "enabled"],
  methods: {
  },
};
</script>

<template>
  <div class="card">
    <div class="card-header">
      <div class="card-title h5">{{ label }}</div>
    </div>
    <div class="card-body">
      <div class="form-group">
        <label class="form-switch">
          <input
            type="checkbox"
            :checked="enabled"
            @change="store.setValue(label, $event.target.checked)"
          />
          <i class="form-icon"></i> Hide/Show
        </label>
      </div>
    </div>
  </div>
</template>
