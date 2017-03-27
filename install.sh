rm -rf public/js/inject/node_modules
hash meteor 2>/dev/null || curl https://install.meteor.com/ | sh
cd ./public/js/.#src
npm install -g webpack
npm install coffee-loader style-loader css-loader stylus-loader
