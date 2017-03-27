cd ./public/js/.#src
webpack injectSearch/main.coffee ../inject/injectSearch/build.js
webpack injectResult/main.coffee ../inject/injectResult/build.js
cp injectSearch/build.css ../inject/injectSearch/build.css
cp injectResult/build.css ../inject/injectResult/build.css
