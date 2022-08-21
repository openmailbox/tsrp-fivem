import { reactive } from 'vue'

// temporary test data
import categoryData from '../test/category_data.js'

export const store = reactive({
    activeCategoryIndex: 0,
    categories: categoryData.categories,

    getActiveControls() {
        return this.categories[this.activeCategoryIndex].controls;
    },

    initialize(data) {
        this.categories = data;
    },

    selectCategory(index) {
        this.activeCategoryIndex = index;
    },

    setValue(name, value) {
        let controls = this.getActiveControls();

        for (let i = 0; i < controls.length; i++) {
            if (controls[i].name === name) {
                controls[i].value = value;
                return
            }
        }
    }
})
