<script>
export default {
    props: ['options']
}
</script>

<template>
    <div class="card">
        <div class="card-header">
            <div class="card-title h5">Style</div>
        </div>
        <div class="card-body">
            <div class="columns">
                <div v-for="n in options" class="column col-1 index-option">
                    <div class="text-center title h3">{{ n }}</div>
                </div>
            </div>
        </div>
    </div>
</template>

<style>
.index-option {
    background-color: #0F121E;
    border: 3px solid #262D4C;
    height: 5vh;
    margin: 0.4vh;
    padding: 0;
}

.index-option .h3 {
    font-size: 2.0vh;
    margin-top: 0.5vh;
}

@media only screen and (min-width: 2560px) {
    .index-option .h3 {
        font-size: 2.2vh;
    }
}
</style>
