const InputHandler = (function () {
  const command = function (eventName, params) {
    fetch(`https://wardrobe/wardrobe:${eventName}`, {
      method: "POST",
      headers: { "Content-Type": "application/json; charset=UTF-8" },
      body: JSON.stringify(params),
    });
  };

  const _initialize = function () {
    document.addEventListener("keydown", (event) => {
      if (event.repeat) return;
      switch (event.key) {
        case "a":
          command("CreateRotation", { direction: -1 });
          break;
        case "d":
          command("CreateRotation", { direction: 1 });
          break;
        case "w":
          command("CreateCameraPan", { direction: 1 });
          break;
        case "s":
          command("CreateCameraPan", { direction: -1 });
          break;
        case "e":
          command("CreateCameraZoom", { direction: 1 });
          break;
        case "q":
          command("CreateCameraZoom", { direction: -1 });
          break;
      }
    });

    document.addEventListener("keyup", (event) => {
      switch (event.key) {
        case "a":
        case "d":
          command("DeleteRotation", {});
          break;
        case "w":
        case "s":
          command("DeleteCameraPan", {});
          break;
        case "q":
        case "e":
          command("DeleteCameraZoom", {});
          break;
      }
    });
  };

  _initialize();
})();
