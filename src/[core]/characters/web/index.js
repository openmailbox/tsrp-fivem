import '../styles/index.css'

const app = createApp(App);
let vm = app.mount('#app');

// Handle messages passed from client-side scripts to NUI
const handleMessage = function(item) {
    switch (item.type) {
        case "someResourceEvent":
            // call a method in the Vue app via the vm object
            vm.changeMessage(item);
            break;
    }
};

window.addEventListener("message", function(event) {
    handleMessage(event.data);
});
