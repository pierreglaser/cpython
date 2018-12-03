#!/bin/bash

OLD_VIRTUALENV=${VIRTUAL_ENV}
CPYTHON_COV_HOME=$HOME/repos/cpython_coverage
COVERAGE_PROCESS_START=$HOME/repos/cpython/.coveragerc
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
PYTHON=python3.8
HTML_DIR="$CPYTHON_COV_HOME"/"$CURRENT_BRANCH"

if [ "$CURRENT_BRANCH" = "dynamic-func-pickling-pure-python" ]; then
    workon pythonic_pickle_python
elif [ "$CURRENT_BRANCH" = "implement-save-function-cpickle" ]; then
    workon c_pickle_python
else
    echo "unknown branch: $CURRENT_BRANCH. Please indicate which virtualenv to "
         " use for"
    exit 1
fi

# enable subprocess coverage requires:
# - creating a .pth file that quickly imports coverage and
#   coverage.process_startup()
# - adding COVERAGE_PROCESS_START as an environment variable before running the
#   tests

$PYTHON install_coverage_subprocess_pth.py

COVERAGE_PROCESS_START=${COVERAGE_PROCESS_START} $PYTHON -mcoverage run Lib/test/regrtest.py test_pickle -v -m test_method_in_main


$PYTHON remove_coverage_pth_code.py

$PYTHON -m coverage combine
$PYTHON -m coverage report


# make a coverage directory for each branch
if [ ! -d "$HTML_DIR" ]; then
    mkdir "$HTML_DIR"
fi

$PYTHON -m coverage html --directory="$HTML_DIR"

# restore the previous workon environment
if [ -n "${OLD_VIRTUALENV}" ]; then
    workon "$(basename "$VIRTUAL_ENV")"
else
    deactivate
fi

# open the coverage summary
xdg-open "$HTML_DIR/index.html"
