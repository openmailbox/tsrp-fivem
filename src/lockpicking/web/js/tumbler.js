function Tumbler(index, data) {
    this.index = index + 1;
    var randomNumber = getRandomInteger(Tumbler.pinRegion.min + data.rangeVariance, Tumbler.pinRegion.max - data.rangeVariance);
    this.greenRegion = {
        min: randomNumber - data.rangeVariance,
        max: randomNumber + data.rangeVariance
    };
    this.pinFallSpeed = data.pinFallSpeed;

    var template = document.createElement("template");
    template.innerHTML = Tumbler.template.trim();
    template.content.querySelector(".pin-wrapper").id = "pin-" + this.index;

    this.element = template.content.firstChild;

    document.getElementById("tumblers").appendChild(this.element);
    document.getElementById("pin-" + this.index).style.bottom = Tumbler.pinRegion.min + '%';

    this.isGreen = false;
    this._currentPinLocation = 25;
    this.unlocked = false;
    Object.defineProperty(this, "currentPinLocation", {
        get() { return this._currentPinLocation; },
        set(value) {
            this._currentPinLocation = value;
            if (document.getElementById("pin-" + this.index)) {
                document.getElementById("pin-" + this.index).style.bottom = value + '%';
            };
        }
    });
};

Tumbler.pinRegion = {
    min: 25,
    max: 50
};
Tumbler.audio = new Howl({
    src: ["./sound/click.wav"],
    loop: false,
    volume: 0.3
})


Tumbler.template = `
            <div class="tumbler-wrapper">
                <div class="pin-wrapper">
                    <img src="./img/pin_green.png" class="pin-green d-none" alt="">
                    <img src="./img/pin.png" class="pin" alt="">
                </div>
                <img src="./img/tumbler.png" class="tumbler" alt="">
            </div>
            `;

Tumbler.prototype.move = function (timestamp) {
    this.currentPinLocation -= this.pinFallSpeed;

    if (this.checkRegion()) {
        if (!this.isGreen)
            this.changeColor();
    }
    else {
        if (this.isGreen)
            this.changeColor();
    }
    if (this.currentPinLocation > Tumbler.pinRegion.min && this.unlocked == false && rendering == true) {
        window.requestAnimationFrame(this.move.bind(this));
    }
};

Tumbler.prototype.unlock = function () {
    document.getElementById("pin-" + this.index).querySelector(".pin-green").classList.add("d-none");
    this.unlocked = true;
    Tumbler.audio.play();
    this.checkForCompletion();
};

Tumbler.prototype.changeColor = function () {
    this.isGreen = !this.isGreen;

    if (this.isGreen)
        document.getElementById("pin-" + this.index).querySelector(".pin-green").classList.remove("d-none");
    else
        document.getElementById("pin-" + this.index).querySelector(".pin-green").classList.add("d-none");
};

Tumbler.prototype.use = function () {
    if (this.unlocked == true) return;

    this.currentPinLocation = Tumbler.pinRegion.max;
    this.move();
};

Tumbler.prototype.attemptUnlock = function () {
    if (this.checkRegion()) {
        if (this.unlocked == false)
            this.unlock();
    }
    else {
        this.relock();
    }
};

Tumbler.prototype.checkRegion = function () {
    return this.currentPinLocation <= this.greenRegion.max && this.currentPinLocation >= this.greenRegion.min;
};

Tumbler.prototype.relock = function () {
    if (pickBreakChance != null && getRandomInteger(1, 100) <= pickBreakChance) {
        closeWindow("broke");
        return;
    }
    activeTumblers.forEach(tumbler => {
        tumbler.unlocked = false;
        if (this.currentPinLocation > Tumbler.pinRegion.min)
            tumbler.move();
    });
};

Tumbler.prototype.checkForCompletion = function () {
    var finished = true;

    activeTumblers.forEach(tumbler => {
        if (tumbler.unlocked == false)
            finished = false;
    });

    if (finished) {
        closeWindow("success")
    }
};

function getRandomInteger(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}