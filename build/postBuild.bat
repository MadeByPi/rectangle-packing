neko ./build/UMDWrap.n -in ./bin/rectanglepacking-debug.js -out ./bin/rectanglepacking-debug.js
neko ./build/UMDWrap.n -in ./bin/rectanglepacking.js -out ./bin/rectanglepacking.js

:turning 'uselessCode' warnings off on the closure build - gives a false positive (unreachable code) and Haxe already runs dead-code-elimination on the output...
java -jar ./build/closure-compiler.jar  --jscomp_off  uselessCode --js ./bin/rectanglepacking.js --js_output_file ./bin/rectanglepacking.min.js