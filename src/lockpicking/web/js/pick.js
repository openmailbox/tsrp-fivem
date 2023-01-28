Pick.startLocation;
Pick.moveSpeed = 0.1;
Pick.audio = new Howl({
    src: ["./sound/push.wav"],
    loop: false,
    volume: 0.1
})

function Pick() {
    this.moving = false;
};

Pick.prototype.TEMPLATE = `
    <div class="lockpick-wrapper" id="pick">
        <img src="./img/lockpick.png" alt="">
    </div>
`;

Pick.prototype.move = function (direction) {
    if (direction == "left") {
        if (currentTumbler < 1) return;

        Pick.audio.pause();
        Pick.audio = new Howl({
            src: ["./sound/next.wav"],
            loop: false,
            volume: 1.0
        })
        Pick.audio.play();

        currentTumbler -= 1;
        this.render();
    }
    else {
        if (currentTumbler >= activeTumblers.length - 1) return;

        Pick.audio.pause();
        Pick.audio = new Howl({
            src: ["./sound/next.wav"],
            loop: false,
            volume: 1.0
        })
        Pick.audio.play();

        currentTumbler += 1;
        this.render();
    }
};

Pick.prototype.render = function() {
    if (this.element) this.element.remove();
    this.element = this._initElement();
    activeTumblers[currentTumbler].element.appendChild(this.element);
}

Pick.prototype.use = async function () {
    if (this.moving) return;

    Pick.audio.pause();
    Pick.audio = new Howl({
        src: ["./sound/push.wav"],
        loop: false,
        volume: 0.3
    })
    Pick.audio.play();

    this.moving = true;
    this.element.querySelector("img").classList.add("lockpick-rotate");
    await sleep(600);
    this.moving = false;
    this.element.querySelector("img").classList.remove("lockpick-rotate");
};

Pick.prototype._initElement = function() {
    let template = document.createElement("template");

    template.innerHTML = Pick.prototype.TEMPLATE.trim();

    return template.content.firstChild;
};

function sleep(ms) {
    return new Promise(
        resolve => setTimeout(resolve, ms)
    );
}
