<script>
import { store } from '../store.js'

export default {
    data() {
        return {
            store
        }
    },
    props: ['name', 'label', 'options'],
    methods: {
        componentToHex(c) {
            let hex = c.toString(16);
            return hex.length === 1 ? "0" + hex : hex;
        },
        rgbToHex(r, g, b) {
            return "#" + this.componentToHex(r) + this.componentToHex(g) + this.componentToHex(b);
        }
    }
}
</script>

<template>
    <div class="card">
        <div class="card-header">
            <div class="card-title h5">{{ label }}</div>
        </div>
        <div class="card-body">
            <div class="columns">
                <div v-for="(color, index) in options"
                    class="column col-1 color-option"
                    :class="{ highlighted: color.selected }"
                    :style="{ 'background-color': rgbToHex(color.r, color.g, color.b) }"
                    @click="store.setValue(name, index)">
                </div>
            </div>
        </div>
    </div>
</template>

<style>
.color-option {
    border: 3px solid #262D4C;
    height: 5vh;
    margin: 0.4vh;
    padding: 0;
}

.color-option.highlighted {
    border-color: #24FAE1;
    color: #24FAE1;
}
</style>
