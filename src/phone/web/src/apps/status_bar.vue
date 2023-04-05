<script>
export default {
    props: ["time"]
}
</script>
<template>
    <div id="phone-status" class="text-light text-small container">
        <div id="status-left">{{ time }}</div>
        <div id="status-right">iFruit</div>
    </div>
</template>

<style>
#phone-status {
    background-color: transparent;
    padding: 0.4em 0.8em;
}

#status-left, #status-right {
    display: inline-block;
    padding: 0 0.2em;
}

#phone-status #status-right {
    float: right;
}
</style>