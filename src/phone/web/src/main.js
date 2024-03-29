import { createApp } from 'vue'
import App from './app.vue'
import './assets/index.css'

const app = createApp(App);
let vm = app.mount('#app');

// Handle messages passed from client-side scripts to NUI
const handleMessage = function(item) {
    switch (item.type) {
        case "phone:CreateSession":
            // call a method in the Vue app via the vm object
            vm.createSession(item);
            break;
    }
};

window.addEventListener("message", function(event) {
    handleMessage(event.data);
});

document.addEventListener("keydown", (event) => {
    if (event.repeat) return;

    switch (event.key) {
        case "Escape":
            vm.deleteSession();
            break;
        case "Home":
            vm.goHome();
            break;
    }
});
