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
    top: 50%;
    transform: translateY(-50%);
    padding: 0 0.2em;
    position: absolute;
}

#phone-status #status-right {
    right: 2%;
}
</style>