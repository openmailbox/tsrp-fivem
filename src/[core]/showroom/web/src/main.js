import { createApp } from 'vue'
import App from './app.vue'
import './assets/index.css'

const app = createApp(App);
let vm = app.mount('#app');

// Handle messages passed from client-side scripts to NUI
const handleMessage = function(item) {
    switch (item.type) {
        case "showroom:CreateSession":
            vm.createSession(item.action);
            vm.setCategories(item.categories);
            break;
        case "showroom:DeleteSession":
            vm.deleteSession(true);
            break;
    }
};

const sendUpdate = function(eventName, params) {
    fetch(`https://showroom/showroom:${eventName}`, {
      method: "POST",
      headers: { "Content-Type": "application/json; charset=UTF-8" },
      body: JSON.stringify(params),
    });
}

window.addEventListener("message", function(event) {
    handleMessage(event.data);
});

document.addEventListener("keydown", (event) => {
    if (event.repeat) return;
    switch (event.key) {
        case "Escape":
            vm.deleteSession();
            break;
        case "a":
            sendUpdate("CreateVehicleRotation", { direction: -1 })
            break;
        case "d":
            sendUpdate("CreateVehicleRotation", { direction: 1 })
            break;
    }
});

document.addEventListener("keyup", (event) => {
    if (event.repeat) return;
    switch (event.key) {
        case "a":
        case "d":
            sendUpdate("DeleteVehicleRotation", {});
            break;
    }
});
