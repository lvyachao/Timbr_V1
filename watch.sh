./compile.sh
find ./public/js/.#src -path './public/js/.#src/node_modules/*' -prune -o -name '*.js' -o -name '*.coffee' -o -name '*.css'| entr ./compile.sh
