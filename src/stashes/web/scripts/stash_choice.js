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
    template: `
        <div class="card">
            <div class="card-image">
                <img class="img-responsive" src="https://www.vespura.com/fivem/weapons/images/WEAPON_PISTOL.png" />
            </div>
            <div class="card-footer">
                <button @click="selectItem" class="btn btn-lg btn-success p-centered">Select</button>
            </div>
        </div>
    `
}
