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
        this.categories = data.categories;
    },

    selectCategory(index) {
        this.activeCategoryIndex = index;
    },

    setValue(label, value) {
        let controls = this.getActiveControls();

        for (let i = 0; i < controls.length; i++) {
            if (controls[i].label === label) {
                if (controls[i].type === "color") {
                    let colors = controls[i].options;

                    for (let j = 0; j < colors.length; j++) {
                        colors[j].selected = (j === value);
                    }
                } else {
                    controls[i].value = value;
                }

                return
            }
        }
    }
})
