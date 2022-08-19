import { createApp } from 'vue'
import App from './app.vue'
import '../styles/index.css'
import '../../../../common/web/styles/tsrp-theme.css'

const app = createApp(App);
let vm = app.mount('#app');

// Handle messages passed from client-side scripts to NUI
const handleMessage = function(item) {
    switch (item.type) {
        case "wardrobe:CreateSession":
            vm.createSession();
            break;
        case "wardrobe:DeleteSession": // only called if the game abandoned the session for some reason
            vm.deleteSession(true);
            break;
    }
};

window.addEventListener("message", function(event) {
    handleMessage(event.data);
});
