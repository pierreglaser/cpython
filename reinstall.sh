CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
VENV="$(basename "${VIRTUAL_ENV}")"

# make sure the correct virtualenv is activated
if [ "$CURRENT_BRANCH" = "dynamic-func-pickling-pure-python" ] && \
   [ ! "$VENV" = "pythonic_pickle_python" ]; then
        echo "invalid virtual env-branch combination:
            virtual env: ${VIRTUAL_ENV}
            branch: $CURRENT_BRANCH"
        return 1
elif [ "$CURRENT_BRANCH" = "implement-save-function-cpickle" ] && \
   [ ! "$VENV" = "c_pickle_python" ]; then
        echo "invalid virtual env-branch combination:
            virtual env: ${VIRTUAL_ENV}
            branch: $CURRENT_BRANCH"
        return 1
fi



# remove old bytecodes (pyc files)
echo "removing old pickle bytecode..."
PYTHON_REPO="${HOME}"/"${VENV}"
sudo rm "$PYTHON_REPO/lib/python3.8/__pycache__/pickle.cpython-38.pyc"
sudo rm "$PYTHON_REPO/lib/python3.8/__pycache__/pickle.cpython-38.opt-2.pyc"
sudo rm "$PYTHON_REPO/lib/python3.8/__pycache__/pickle.cpython-38.opt-1.pyc"

# use clinc on pickle before compiling
echo "calling clinic on _pickle.c"
python3.8 ./Tools/clinic/clinic.py Modules/_pickle.c

echo "re-compiling python"
# re-compile pickle
sudo make

# install the tests
echo "installing pickle tests and libraries"
# make altinstall, but trimmed down to only modified files
sudo /usr/bin/install -c -m 644 ./Lib/pickle.py "$HOME/dev_python/lib/python3.8"
sudo /usr/bin/install -c -m 644 ./Lib/pickletools.py "$HOME/dev_python/lib/python3.8"
sudo /usr/bin/install -c -m 644 ./Lib/test/pickletester.py "$HOME/dev_python/lib/python3.8/test"
sudo /usr/bin/install -c -m 644 ./Lib/test/test_pickle.py "$HOME/dev_python/lib/python3.8/test"

