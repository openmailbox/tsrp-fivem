<script>
import Input from './input.vue'

export default {
    components: { Input },
    data() {
        return {
            currentSetting: "",
            settings: {
                wallpaper: {
                    label: "Image URL",
                    value: "https://images.pexels.com/photos/1723637/pexels-photo-1723637.jpeg"
                }
            }
        }
    },
    methods: {
        formatName(name) {
            return String(name).toUpperCase()[0] + String(name).slice(1);
        },

        updateSetting(newValue) {
            this.settings[this.currentSetting].value = newValue;
            this.currentSetting = "";
        }
    }
}
</script>

<template>
    <div class="panel bg-secondary">
        <div class="panel-header">
            <div class="panel-title text-bold">Settings</div>
        </div>
        <div class="panel-body">
            <ul class="menu bg-gray">
                <li v-for="(_, name) in settings" class="menu-item">
                    <a @click="currentSetting = name" href="#">
                        <i class="icon icon-link"></i> {{ formatName(name) }}
                    </a>
                </li>
            </ul>

            <Input v-show="currentSetting"
                :title="currentSetting"
                :label="currentSetting && settings[currentSetting].label"
                :value="currentSetting && settings[currentSetting].value"
                @update-setting="(value) => updateSetting(value)"
            />
        </div>
    </div>
</template>

<style>
#settings {
    background: gray;
}
</style>
