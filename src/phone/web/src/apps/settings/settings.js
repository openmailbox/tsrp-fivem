import { reactive } from 'vue'

const DEFAULTS = {
    wallpaper: {
        label: "Image URL",
        value: "https://images.pexels.com/photos/1723637/pexels-photo-1723637.jpeg"
    }
}

export const PhoneSettings = reactive({
    current: JSON.parse(JSON.stringify(DEFAULTS)),

    set(key, value) {
        this.current[key].value = value;
    }
});
