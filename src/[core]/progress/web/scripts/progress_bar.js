Progress.Bar = function(handle, duration, text) {
    this.duration = parseInt(duration);
    this.text     = text;
    this.handle   = handle;
    this.value    = 0;
    this.maxValue = this.duration * 0.06;
    this.element  = this._initElement();
};

Progress.Bar.TEMPLATE = `
<div class="progress-bar p-relative">
    <progress class="progress" value="0" max="100"></progress>
    <h5 class="title"></h5>
</div>
`

Progress.Bar.prototype.start = function() {
    this.timer = window.setInterval(function() {
        this.update();
    }.bind(this), 16.666); // 60 fps
};

Progress.Bar.prototype.stop = function() {
    window.clearInterval(this.timer);
    this.element.remove();
    this.timer = null;
}

Progress.Bar.prototype.update = function() {
    // TODO: Refactor to use requestAnimationFrame
    this.value += 1;
    this.progress.setAttribute("value", this.value)
    this.progress.setAttribute("max", this.maxValue)

    if (this.value >= this.maxValue) {
        this.stop();
    }
};

Progress.Bar.prototype._initElement = function() {
    let template = document.createElement("template");

    template.innerHTML = Progress.Bar.TEMPLATE.trim();

    template.content.querySelector(".title").innerText = this.text;

    this.progress = template.content.querySelector(".progress");
    this.progress.setAttribute("value", this.value)
    this.progress.setAttribute("max", this.maxValue)

    return template.content.firstChild;
};
