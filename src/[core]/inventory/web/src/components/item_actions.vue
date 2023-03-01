<script>
export default {
}
</script>

<template>
    <div class="tile tsrp-bg container-border text-light">
        <div class="tile-content">
            <p class="bg-dark tile-title">Actions</p>
            <table class="table text-small">
                <tbody>
                    <tr>
                        <td>Use</td>
                        <td class="action-icon"><span class="material-symbols-outlined">left_click</span></td>
                    </tr>
                    <tr>
                        <td>Discard</td>
                        <td class="action-icon">Shift + <span class="material-symbols-outlined">left_click</span></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>

<style>
.tile-title {
    padding: 0.1em 0.3em;
    margin-bottom: 0;
}

.action-icon {
    text-align: right;
}

tr, td {
    padding: 0;
}
</style>