import { createApp } from 'vue'
import App from './app.vue'
import './assets/index.css'

const app = createApp(App);
let vm = app.mount('#app');

// Handle messages passed from client-side scripts to NUI
const handleMessage = function(item) {
    switch (item.type) {
        case "showroom:CreateSession":
            vm.createSession();
            break;
        case "showroom:DeleteSession":
            vm.deleteSession(true);
            break;
    }
};

window.addEventListener("message", function(event) {
    handleMessage(event.data);
});
