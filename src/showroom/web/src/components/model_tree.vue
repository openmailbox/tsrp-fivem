<script>
export default {
    methods: {
        toggleCategory(event) {
            event.target.setAttribute("open", !!event.target.getAttribute("open"))
        }
    },
    props: ["categories"]
}
</script>

<template>
    <div id="panel-tree" class="panel tsrp-bg text-secondary">
        <div class="panel-header">
            <div class="panel-title h4">Showroom</div>
        </div>
        <div class="panel-body">
            <details v-for="category in categories" @click="toggleCategory($event)" class="accordion">
                <input type="checkbox" hidden />
                <summary class="accordion-header">
                    <i class="icon icon-arrow-right"></i>
                    <div class="title h5">{{ category.name }}</div>
                    <div class="title h5 in-stock-count">({{ category.models.length }})</div>
                </summary>
                <div class="accordion-body">
                    <table>
                        <tbody>
                            <tr v-for="vehicle in category.models" @click="$emit('selectModel', vehicle, category.name)">
                                <td>{{ vehicle.name }}</td>
                                <td>{{ vehicle.price }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </details>
        </div>
    </div>
</template>

<style>
#panel-tree.panel {
    float: right;
    height: 100vh;
    user-select: none;
    width: 33vw;
}

#panel-tree .accordion-header .title {
    display: inline-block;
    margin-left: 1em;
}

#panel-tree .accordion-body {
    margin-left: 3em;
}

#panel-tree td {
    padding-right: 1em;
}

#panel-tree .panel-header {
    background: #36358f;
    margin-bottom: 0.5em;
}

#panel-tree .in-stock-count {
    float: right;
}
</style>