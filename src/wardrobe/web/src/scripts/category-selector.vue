<script>
export default {
    emits: ['cancel']
}
</script>

<template>
    <div class="panel">
        <div class="panel-header">
            <div class="panel-title h5 title text-center">Character Customization</div>
        </div>
        <div class="panel-body columns"></div>
        <div class="panel-footer text-center">
            <button @click="$emit('cancel')" class="btn btn-lg btn-error">Cancel</button>
            <button class="btn btn-lg btn-success">Confirm</button>
        </div>
    </div>
</template>
