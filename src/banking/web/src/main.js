import { createApp } from 'vue'
import App from './deposit.vue'
import './assets/main.css'

const app = createApp(App);
let vm = app.mount('#atm');

const handleMessage = function(item) {
    switch (item.type) {
        case "atm:CreateSession":
            vm.createSession(item.cash);
            break;
    }
};

window.addEventListener("message", function(event) {
    handleMessage(event.data);
});
