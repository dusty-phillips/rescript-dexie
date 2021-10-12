# pretty.sh just pipes pta to tap-diff
# I orginally had the
# test:watch script set to 
#    "test:watch": "onchange --initial '{tests,src}/*.mjs' -- yarn test",
# however it was laggy due to the yarn startup time
# so I moved it here instead

parent_path=$(dirname $(dirname $(realpath $0)))
pta=$parent_path/node_modules/.bin/pta
tapdiff=$parent_path/node_modules/.bin/tap-diff2

$pta tests/*.test.mjs | $tapdiff
