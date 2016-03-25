const path  = require("path");

module.exports = {
    entry: "./src/index.js",
    output: {
        path: path.resolve(__dirname, "dist"),
        filename: "bundle.js"
    },
    module: {
        loaders: [
            {
                test: /\.(js|jsx)$/,
                exclude: /(node_modules|dist)/,
                loader: "babel",
                query: {
                    presets: ["es2015", "stage-2"]
                }
            }
        ]
    }
};
