import { reactive } from 'vue'

export const store = reactive({
    activeCategoryIndex: 0,

    selectCategory(index) {
        this.activeCategoryIndex = index;
    }
})
