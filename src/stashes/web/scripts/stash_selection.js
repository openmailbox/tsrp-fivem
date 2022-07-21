import { createApp } from 'vue'
import StashChoice from './stash_choice.js'

Stashes.StashSelection = (function() {
    let vm = null;

    const app = createApp({
        data() {
            return {
                activeStash: {},
                isActive:    false
            }
        },
        methods: {
            open(stash) {
                this.activeStash = stash;
                this.isActive    = true;
            },

            selectItem(index) {
                fetch("https://stashes/stashes:UpdateOpening", {
                    method: "POST",
                    headers: { "Content-Type": "application/json; charset=UTF-8" },
                    body: JSON.stringify({
                        stash:    this.activeStash,
                        selected: this.activeStash.contents[index]
                    })
                });

                this.activeStash = {};
                this.isActive    = false;
            }
        }
    });

    const open = function(data) {
        vm.open(data);
    }

    app.component('stash-choice', StashChoice);
    vm = app.mount('#stash-contents');

    return {
        open: open
    }
})();
