// webpack.config.js
module.exports = {
  module: {
    loaders: [
      { test: /\.coffee$/, loader: 'coffee-loader' },
      { test: /\.styl$/, loader: 'style-loader!css-loader!stylus-loader' }
    ]
  },
  resolve: {
    extensions: ['', '.js', '.json', '.coffee', '.styl']
  }
};
