#!/bin/bash
hugo serve -D
##docker run -it --rm -v $(pwd):/wd -p 1313:1313 --entrypoint "" klakegg/hugo:0.92.2 sh -c "cd /wd; hugo serve -D"

