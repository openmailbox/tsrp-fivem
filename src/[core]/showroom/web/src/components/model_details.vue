<script>
export default {
    computed: {
        formatMoney() {
            return this.price && new Intl.NumberFormat('en-US', {
                style:               'currency',
                currency:            'USD',
                trailingZeroDisplay: 'stripIfInteger'
            }).format(this.price);
        }
    },
    methods: {
        doAction() {
            fetch("https://showroom/showroom:CreateVehicleAction", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=UTF-8" },
                body: JSON.stringify({
                    name:   this.name,
                    price:  this.price,
                    action: this.action
                })
            });
        }
    },
    props: ["name", "price", "category", "action"]
}
</script>

<template>
    <div id="panel-details" class="panel tsrp-bg text-secondary">
        <div class="panel-header h5">
            <div class="panel-title">{{ name }}</div>
        </div>
        <div class="panel-body">
            <table class="table">
                <tbody>
                    <tr v-show="price">
                        <td>MSRP</td>
                        <td>{{ formatMoney }}</td>
                    </tr>
                    <tr>
                        <td>Category</td>
                        <td>{{ category }}</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div @click="doAction" class="panel-footer text-center" v-show="action">
            <div class="btn btn-primary">{{ action }}</div>
        </div>
    </div>
</template>

<style>
#panel-details tr, td {
    border: none !important;
}

#panel-details .panel-body {
    margin-bottom: 0.5em;
    margin-top: 0.5em;
}

#panel-details .table td {
    padding: 0 0 0.5em 0.4em;
}

#panel-details.panel {
    float: right;
    margin-top: 2vh;
    width: 18vw;
}

#panel-details .panel-header {
    background: #36358f;
    padding: 0.2em 0 0.5em 0.8em;
}
</style>