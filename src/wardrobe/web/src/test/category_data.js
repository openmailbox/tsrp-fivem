// Static data to populate the interface for easy testing
export default {
    categories: [
        {
            label: "Face",
            name: "face",
            controls: [
                {
                    type: "index",
                    label: "Style",
                    count: 10,
                    value: 1
                }
            ]
        },
        {
            label: "Hair",
            name: "hair",
            controls: [
                {
                    type: "index",
                    label: "Style",
                    count: 7,
                    value: 2
                },
                {
                    type: "color",
                    label: "Primary",
                    options: [
                        { r: 255, g: 0, b: 0 },
                        { r: 0, g: 255, b: 0, selected: true },
                        { r: 0, g: 0, b: 255 }
                    ]
                }
            ]
        },
        {
            label: "Shoes",
            name: "shoes",
            controls: [
                {
                    type: "index",
                    label: "Style",
                    value: 25,
                    count: 50,
                },
                {
                    type: "slider",
                    label: "Variant",
                    value: 2,
                    min: 1,
                    max: 10
                }
            ]
        }
    ]
}
