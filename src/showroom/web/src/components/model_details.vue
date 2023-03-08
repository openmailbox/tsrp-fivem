<script>
export default {
    props: ["name", "price", "category", "owned"]
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
                    <tr>
                        <td>MSRP</td>
                        <td>{{ price }}</td>
                    </tr>
                    <tr>
                        <td>Category</td>
                        <td>{{ category }}</td>
                    </tr>
                    <tr>
                        <td>Owned</td>
                        <td>{{ owned }}</td>
                    </tr>
                </tbody>
            </table>
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