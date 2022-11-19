<script>
import IndexControl from "./controls/index_control.vue";
import SliderControl from "./controls/slider_control.vue";
import ColorControl from "./controls/color_control.vue";

export default {
  props: ["controls"],
  components: { IndexControl, SliderControl, ColorControl },
};
</script>

<template>
  <div class="panel tsrp-bg-semi category-details">
    <div class="panel-body">
      <div v-for="control in controls">
        <IndexControl
          v-if="control.type === 'index' && control.count > 0"
          :label="control.label"
          :count="control.count"
          :value="control.value"
        />
        <SliderControl
          v-else-if="control.type === 'slider' && control.max > 1"
          :label="control.label"
          :min="control.min"
          :max="control.max"
          :value="control.value"
        />
        <ColorControl
          v-else-if="control.type === 'color'"
          :label="control.label"
          :options="control.options"
        />
      </div>
    </div>
  </div>
</template>

<style>
.category-details {
  height: 70vh;
  margin-top: 13vh;
}

.category-details .panel-body {
  padding: 0;
}
</style>
