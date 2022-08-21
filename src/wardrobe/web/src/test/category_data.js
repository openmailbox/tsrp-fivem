export default {
    categories: [
        {
            label: "Face",
            controls: [
                {
                    type: "index",
                    name: "drawable",
                    count: 10,
                    value: 1
                }
            ]
        },
        {
            label: "Hair",
            controls: [
                {
                    type: "index",
                    name: "drawable",
                    count: 7,
                    value: 2
                },
                {
                    type: "color",
                    options: [
                        { r: 255, g: 0, b: 0 },
                        { r: 0, g: 255, b: 0 },
                        { r: 0, g: 0, b: 255 }
                    ]
                }
            ]
        },
        {
            label: "Shoes",
            controls: [
                {
                    type: "index",
                    name: "drawable",
                    count: 50,
                    value: 25
                },
                {
                    type: "slider",
                    min: 0,
                    max: 10
                }
            ]
        }
    ]
}
