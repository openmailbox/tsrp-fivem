import { createApp } from 'vue'
import StashChoice from './stash_choice.js'

const app = createApp({
    data() {
        return {
            message: 'Hello Vue!'
        }
    }
});

app.component('stash-choice', StashChoice);
app.mount('#stash-contents');
