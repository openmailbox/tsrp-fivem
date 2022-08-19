export default {
    categories: [
        {
            label: "Face",
            controls: [
                {
                    type: "index",
                    count: 10
                }
            ]
        },
        {
            label: "Hair",
            controls: [
                {
                    type: "index",
                    count: 7
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
                    count: 50
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
