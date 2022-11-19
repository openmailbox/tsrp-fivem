import { reactive } from "vue";

// temporary test data
//import categoryData from '../test/category_data.js'

const findMemberByKey = (collection, name, value) => {
  for (let member of collection) {
    if (member[name] === value) {
      return member;
    }
  }

  return null;
};

export const store = reactive({
  activeCategoryIndex: 0,
  //categories: categoryData.categories,
  categories: [],

  getActiveControls() {
    const category = this.categories[this.activeCategoryIndex];
    return category ? category.controls : [];
  },

  initialize(data) {
    this.categories = data.categories;
  },

  selectCategory(index) {
    this.activeCategoryIndex = index;
  },

  setValue(label, value) {
    let activeControls = this.getActiveControls();
    let updatedControl = findMemberByKey(activeControls, "label", label);

    // update value in global state
    if (updatedControl.type === "color") {
      for (let color of updatedControl.options) {
        color.selected = j === value;
      }
    } else {
      updatedControl.value = value;
    }

    fetch("https://wardrobe/wardrobe:CreatePedUpdate", {
      method: "POST",
      headers: { "Content-Type": "application/json; charset=UTF-8" },
      body: JSON.stringify({
        attribute: this.categories[this.activeCategoryIndex].name,
        control: label,
        value: value,
      }),
    })
      .then((resp) => resp.json())
      .then((resp) => {
        if (!resp.controls) return;

        for (let update of resp.controls) {
          let changedControl = findMemberByKey(
            activeControls,
            "label",
            update.label
          );

          for (let key in update) {
            changedControl[key] = update[key];
          }
        }
      });
  },
});
