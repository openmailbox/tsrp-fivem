<script>
export default {
    emits: ["quantitySelected"],
    props: ["maximum"],
    data() {
        return {
            currentValue: 1
        }
    },
    methods: {
        updateValue(event) {
            this.currentValue = event.target.value;
        }
    }
}
</script>

<template>
    <div id="quantity-select" class="modal active">
        <a href="#close" class="modal-overlay"></a>
        <div class="modal-container bg-dark">
            <div class="modal-header">
                <div class="modal-title h5 text-light">How Many?</div>
            </div>
            <div class="modal-body text-light text-center container">
                <div class="title h3">{{ currentValue }}</div>
                <div class="columns text-small">
                    <div class="column col-1">1</div>
                    <div class="column col-10">
                        <input
                            class="slider"
                            type="range"
                            min="1"
                            :max="maximum"
                            :value="currentValue"
                            @input="updateValue"
                        />
                    </div>
                    <div class="column col-1">{{ maximum }}</div>
                </div>
            </div>
            <div class="modal-footer">
                <button @click="$emit('quantitySelected', currentValue)" class="btn btn-primary">Done</button>
            </div>
        </div>
    </div>
</template>

<style>
#quantity-select .modal-overlay {
    background-color: rgba(8, 12, 17, 0.9) !important;
}
</style>
