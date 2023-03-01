import { createApp } from 'vue'
import App from './app.vue'
import './assets/index.css'
import "../../../../common/web/styles/tsrp-theme.css";

const app = createApp(App);
let vm = app.mount('#app');

// Handle messages passed from client-side scripts to NUI
const handleMessage = function(message) {
    switch (message.type) {
        case "inventory:CreateSession":
            vm.createSession(message);
            break;
        case "inventory:DeleteSession":
            vm.deleteSession(true);
            break;
    }
};

window.addEventListener("message", function(event) {
    handleMessage(event.data);
});

document.addEventListener("keydown", (event) => {
    if (event.repeat) return;
    switch (event.key) {
        case "i":
            vm.deleteSession();
            break;
    }
});