<script>
export default {
    props: ["title", "label", "value"],
    computed: {
        formatTitle() {
            return String(this.title).toUpperCase()[0] + String(this.title).slice(1);
        }
    },
    methods: {
        update() {
            const newValue = document.querySelector("#settings-input input").value;
            this.$emit("updateSetting", newValue);
        }
    }
}
</script>

<template>
    <div id="settings-input" class="modal active">
        <a href="#close" class="modal-overlay"></a>
        <div class="modal-container">
            <div class="modal-header">
                <div class="modal-title h5">{{ formatTitle }}</div>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">{{ label }}</label>
                    <input :value="value" class="form-input text-small" type="text" />
                </div>
            </div>
            <div class="modal-footer">
                <button @click="update()" class="btn btn-primary">Done</button>
            </div>
        </div>
    </div>
</template>