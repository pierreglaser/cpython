CPYTHON_HOME=$HOME/repos/cpython
CPYTHON_COV_HOME=$HOME/repos/cpython_coverage

COVERAGE_PROCESS_START=/home/pierre/repos/cpython/.coveragerc \
    COVERAGE_FILE=$CPYTHON_COV_HOME/.coverage python \
    -mcoverage run --pylib --source pickle Lib/test/regrtest.py test_pickle

pushd $CPYTHON_COV_HOME
coverage combine
coverage report
coverage html
popd

xdg-open $CPYTHON_COV_HOME/htmlcov/_home_pierre_dev_python_lib_python3_8_pickle_py.html
