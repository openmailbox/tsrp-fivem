export default {
    props: {
        index: Number,
        item:  Object
    },
    emits: ['selectItem'],
    methods: {
        selectItem() {
            this.$emit("selectItem", this.index);
        }
    },
    computed: {
        imageUrl() {
            return `https://www.vespura.com/fivem/weapons/images/WEAPON_${this.item.label.toUpperCase()}.png`
        }
    },
    template: `
        <div class="card">
            <div v-if="this.item.weapon" class="card-image">
                <img class="img-responsive" :src="imageUrl" />
            </div>
            <div v-else class="card-body">
                <div v-if="this.item.cash">
                    <div class="title h2 text-center">\${{ this.item.cash }}</div>
                </div>
                <div v-else-if="this.item.armor" class="text-center">
                    <i class="fa-solid fa-shield-halved fa-2xl"></i>
                    <div class="title h2">+{{ this.item.armor }}</div>
                </div>
            </div>
            <div class="card-footer">
                <button @click="selectItem" class="btn btn-lg btn-success p-centered">Select</button>
            </div>
        </div>
    `
}
