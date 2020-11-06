LUA="lua5.3"

export LUA_PATH="$PWD/tde/?/?.lua;$PWD/tde/?.lua;$PWD/tde/?/init.lua;"
export LUA_PATH="$LUA_PATH;$PWD/plugins/?/init.lua;"
export LUA_PATH="$LUA_PATH;$PWD/plugins/?.lua;"
export LUA_PATH="$LUA_PATH;./?.lua;./?/init.lua;"
export LUA_PATH="$LUA_PATH;"

if [[ "$1" == "" ]]; then
    echo "Please specify how long to profile for"
    echo "Alternativly you can supply a file as the first argument"
    echo "Then we profile that file"
    exit 1
fi

if [[ -f "$1" ]]; then
    "$LUA" profiler/init.lua "$1"
    exit 0
fi

if [[ "$2" == "" ]]; then
    echo "Please specify the amount of functions to print"
    exit 1
fi

"$LUA" profiler/init.lua "0" "$1" "$2"
 

