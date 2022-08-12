const path = require('path');

module.exports = {
  entry: './web/src/index.js',
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, 'web', 'dist'),
  },
};
