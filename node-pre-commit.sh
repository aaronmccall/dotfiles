#!/bin/bash
ROOT_DIR=$(git rev-parse --show-toplevel)

for file in $(git diff-index --name-only HEAD -- | grep -P '\.((js)|(json))$'); do
    jshint $file
    if [ $? -eq 1 ]; then
        echo 'Pre-commit hook failed linting! exiting'
        exit 1
    else
        echo 'Pre-commit hook passed linting...'
        if [ -d test ]; then
            if [ -f test/tests.js ]; then 
	            nodeunit test/tests.js
                if [ $? -eq 1 ]; then
                    echo 'Pre-commit hook failed unit tests! exiting'
                    exit 1
                else
                    echo 'Pre-commit hook passed unit tests...'
                    exit 0
                fi
            fi
        else
            exit 0
        fi
    fi
done
