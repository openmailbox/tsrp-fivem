<script>
import Input from './input.vue'
import { PhoneSettings } from './settings.js'

export default {
    components: { Input },
    data() {
        return {
            PhoneSettings,
            currentSettingKey: ""
        }
    },
    methods: {
        formatName(name) {
            return name.toUpperCase()[0] + name.slice(1);
        },

        updateSetting(newValue) {
            PhoneSettings.set(this.currentSettingKey, newValue);
            this.currentSettingKey = "";
        }
    },
    computed: {
        currentSetting() {
            if (this.currentSettingKey.length > 0) {
                return PhoneSettings.current[this.currentSettingKey];
            } else {
                return {};
            }
        },

        currentSettingTitle() {
            return this.formatName(this.currentSettingKey);
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
                <li v-for="(_, key) in PhoneSettings.current" class="menu-item">
                    <a @click="currentSettingKey = key" href="#">
                        <i class="icon icon-link"></i> {{ formatName(key) }}
                    </a>
                </li>
            </ul>

            <Input v-show="currentSettingKey.length > 0"
                :title="currentSettingTitle"
                :label="currentSetting.label"
                :value="currentSetting.value"
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
