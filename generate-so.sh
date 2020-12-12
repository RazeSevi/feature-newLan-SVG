#!/usr/bin/env bash

# MIT License
# 
# Copyright (c) 2019 manilarome
# Copyright (c) 2020 Tom Meyers
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
if [[ "$1" == "" ]]; then
    echo "Supply lua version eg luajit(5.1) or lua5.3(5.3)"
    read -p "Version: (5.3) " version
fi
if [[ -z "$version" ]]; then
    version="5.1"
fi

[[ -d lua-install ]] && rm -rf lua-install

luarocks --lua-version "$version" install --tree lua-install lua-cjson 2.1.0-1
luarocks --lua-version "$version" install --tree lua-install luasocket
luarocks --lua-version "$version" install --tree lua-install luaposix

# update lib-lua
cp -r lua-install/share/lua/"$version"/* tde/lib-tde/lib-lua/

# update lib-so
cp -r lua-install/lib/lua/"$version"/* tde/lib-tde/lib-so/

# cleanup
[[ -d lua-install ]] && rm -rf lua-install
