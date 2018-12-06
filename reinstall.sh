CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
VENV="$(basename "${VIRTUAL_ENV}")"

FULL_REINSTALL=0

echo "verifying the Makefile options..."

if [ ! -f ./Makefile ]; then
    echo "No Makefile generated"
    FULL_REINSTALL=1
fi

INSTALL_FOLDER="$(grep -e "^prefix=" Makefile | awk '{print $NF}')"
INSTALL_PREFIX="$(basename "${INSTALL_FOLDER}")"

# if the prefix in the makefile does not match the one used for the branch in
# question, exit with an error
if [ "$CURRENT_BRANCH" = "dynamic-func-pickling-pure-python" ] && \
   [ ! "$INSTALL_PREFIX" = "pythonic_pickle_python" ]; then
        echo "Warning: invalid Makefile:
            branch: $CURRENT_BRANCH
            prefix used: ${INSTALL_PREFIX}"
        FULL_REINSTALL=1
elif [ "$CURRENT_BRANCH" = "implement-save-function-cpickle" ] && \
   [ ! "$INSTALL_PREFIX" = "c_pickle_python" ]; then
        echo "Warning: invalid Makefile:
            branch: $CURRENT_BRANCH
            prefix used: ${INSTALL_PREFIX}"
        FULL_REINSTALL=1
fi

echo "...done"


# make sure the correct virtualenv is activated
echo "checking virtualenv options..."
if [ "$CURRENT_BRANCH" = "dynamic-func-pickling-pure-python" ] && \
   [ ! "$VENV" = "pythonic_pickle_python" ]; then
        echo "Warning: invalid virtual env-branch combination:
            virtual env: ${VIRTUAL_ENV}
            branch: $CURRENT_BRANCH"
        return 1
elif [ "$CURRENT_BRANCH" = "implement-save-function-cpickle" ] && \
   [ ! "$VENV" = "c_pickle_python" ]; then
        echo "Warning invalid virtual env-branch combination:
            virtual env: ${VIRTUAL_ENV}
            branch: $CURRENT_BRANCH"
        return 1
else
    echo "...done"
fi


if [ "$FULL_REINSTALL" = 1 ]; then
    read -p "A full reinstall is necessary. Do you want to do it (y/n)?" -r
    echo # optional: start a new line
    if [ "$REPLY" = "y" ]; then
        echo "cleaning the repo, doing a full reinstall..."

        sudo git clean -xdf
        if [ "$CURRENT_BRANCH" = "implement-save-function-cpickle" ]; then
            sudo ./configure --prefix="$HOME/c_pickle_python" --with-pydebug
        elif [ "$CURRENT_BRANCH" = "dynamic-func-pickling-pure-python" ]; then
            sudo ./configure --prefix="$HOME/pythonic_pickle_python" --with-pydebug
        fi
        sudo make && sudo make altinstall

    else
        echo "exiting the script"
        return 1
    fi
else
    echo "starting a partial reinstall. This can be dangerous as not all pyc files
          are deleted"

    # remove old bytecodes (pyc files) (lighter make clean)
    echo "removing old pickle bytecode..."
    PYTHON_REPO="${HOME}"/"${VENV}"
    # from inside the cpython repo
    sudo rm "./build/lib.linux-x86_64-3.8-pydebug/_pickle.cpython-38dm-x86_64-linux-gnu.so"
    sudo rm "./build/temp.linux-x86_64-3.8-pydebug$HOME/repos/cpython/Modules/_pickle.o"
    sudo rm "./Lib/__pycache__/pickle.cpython-38.pyc"
    sudo rm "./Lib/__pycache__/pickle.cpython-38.pyc"


    # from inside the destination folder
    sudo rm "$PYTHON_REPO/lib/python3.8/__pycache__/pickle.cpython-38.pyc"
    sudo rm "$PYTHON_REPO/lib/python3.8/__pycache__/pickle.cpython-38.opt-2.pyc"
    sudo rm "$PYTHON_REPO/lib/python3.8/__pycache__/pickle.cpython-38.opt-1.pyc"

    # use clinc on pickle before compiling
    echo "calling clinic on _pickle.c"
    python3.8 ./Tools/clinic/clinic.py Modules/_pickle.c

    echo "re-compiling python"
    # re-compile pickle
    sudo make -s

    # install the tests
    echo "installing pickle tests and libraries"
    # make altinstall, but trimmed down to only modified files
    sudo /usr/bin/install -c -m 644 ./Lib/pickle.py "$HOME/$VENV/lib/python3.8"
    sudo /usr/bin/install -c -m 644 ./Lib/pickletools.py "$HOME/$VENV/lib/python3.8"
    sudo /usr/bin/install -c -m 644 ./Lib/test/pickletester.py "$HOME/$VENV/lib/python3.8/test"
    sudo /usr/bin/install -c -m 644 ./Lib/test/test_pickle.py "$HOME/$VENV/lib/python3.8/test"

fi

# re-link virtualenv python with new python
rm "$VIRTUAL_ENV/bin/python"
ln -s "$HOME/$VENV/bin/python3.8" "$VIRTUAL_ENV/bin/python"
