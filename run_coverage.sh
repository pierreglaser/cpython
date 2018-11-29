CPYTHON_COV_HOME=$HOME/repos/cpython_coverage
COVERAGE_PROCESS_START=$HOME/repos/cpython/.coveragerc

# enable subprocess coverage requires:
# - creating a .pth file that quickly imports coverage and
#   coverage.process_startup()
# - adding COVERAGE_PROCESS_START as an environment variable before running the
#   tests


python install_coverage_subprocess_pth.py

COVERAGE_PROCESS_START=${COVERAGE_PROCESS_START} python -mcoverage run Lib/test/regrtest.py test_pickle -v


python remove_coverage_pth_code.py

python -m coverage combine
python -m coverage report
python -m coverage html

# xdg-open $CPYTHON_COV_HOME/htmlcov/index.html
