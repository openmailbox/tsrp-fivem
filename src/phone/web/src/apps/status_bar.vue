<script>
export default {
    props: ["time"]
}
</script>
<template>
    <div id="phone-status" class="text-light text-small container">
        <div class="columns">
            <div class="column col-2">
                <p>{{ time }}</p>
            </div>
            <div class="column col-8"></div>
            <div class="column col-2 text-right">
                <p>iFruit</p>
            </div>
        </div>
    </div>
</template>

<style>
#phone-status {
    background-color: transparent;
    padding: 0.4em 0.8em 0 0.8em;
}

#phone-status p {
    margin-bottom: 0;
    margin-left: 0.2em;
    margin-right: 0.2em;
}
</style>