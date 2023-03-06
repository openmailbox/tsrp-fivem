<script>
export default {

}
</script>

<template>
    <div id="panel-details" class="panel tsrp-bg text-secondary">
        <div class="panel-header h5">
            <div class="panel-title">Asea</div>
        </div>
        <div class="panel-body">
            <table class="table">
                <tbody>
                    <tr>
                        <td>MSRP</td>
                        <td>$20,000</td>
                    </tr>
                    <tr>
                        <td>Category</td>
                        <td>Sedan</td>
                    </tr>
                    <tr>
                        <td>Owned</td>
                        <td>0</td>
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
    width: 20vw;
}

#panel-details .panel-header {
    background: #36358f;
    padding: 0.2em 0 0.5em 0.8em;
}
</style>