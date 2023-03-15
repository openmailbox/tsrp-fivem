<script>
export default {
    data() {
        return {
            clickModifiers: [null, "Shift", "Ctrl", "Alt"]
        }
    },
    methods: {
        formatName(name) {
            return name[0].toUpperCase() + name.slice(1);
        },

        getClickModifier(index) {
            if (index < 1) {
                return '';
            } else {
                return `${this.clickModifiers[index]} + `;
            }
        }
    },
    props: ["actions"]
}
</script>

<template>
    <div class="item-actions tile tsrp-bg container-border text-light">
        <div class="tile-content">
            <p class="bg-dark tile-title">Actions</p>
            <table class="table text-small">
                <tbody>
                    <tr v-for="(action, i) in actions">
                        <td>{{ formatName(action) }}</td>
                        <td class="action-icon">{{ getClickModifier(i) }}<span class="material-symbols-outlined">left_click</span></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>

<style>
.item-actions {
    width: 8vw;
}

.item-actions .tile-title {
    padding: 0.1em 0.3em;
    margin-bottom: 0;
}

.item-actions .action-icon {
    text-align: right;
}

.item-actions tr, .item-actions td {
    padding: 0.3em;
}
</style>