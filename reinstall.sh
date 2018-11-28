# use clinc on pickle before compiling
python3.8 ./Tools/clinic/clinic.py Modules/_pickle.c

# re-compile pickle
gcc -pthread -fPIC -Wno-unused-result -Wsign-compare -g -O0  -Wall -std=c99 -Wextra -Wno-unused-result -Wno-unused-parameter -Wno-missing-field-initializers -Werror=implicit-function-declaration -I./Include -I$HOME/dev_python/include -I. -I/usr/include/x86_64-linux-gnu -I/usr/local/include -I$HOME/epos/cpython/Include -I$HOME/repos/cpython -c $HOME/repos/cpython/Modules/_pickle.c -o build/temp.linux-x86_64-3.8-pydebug$HOME/repos/cpython/Modules/_pickle.o
gcc -pthread -shared build/temp.linux-x86_64-3.8-pydebug$HOME/repos/cpython/Modules/_pickle.o -L$HOME/dev_python/lib -L/usr/lib/x86_64-linux-gnu -L/usr/local/lib -o build/lib.linux-x86_64-3.8-pydebug/_pickle.cpython-38dm-x86_64-linux-gnu.so

sudo cp build/lib.linux-x86_64-3.8-pydebug/_pickle.cpython-38dm-x86_64-linux-gnu.so $HOME/dev_python/lib/python3.8/lib-dynload/

# compile and install the tests
# /usr/bin/install Lib/test/test_pickle.py /home/pierreglaser/dev_python/lib/python3.8/test/test_pickle.py
# /usr/bin/install Lib/test/test_pickle.py /home/pierreglaser/dev_python/lib/python3.8/test/pickletester.py
# /usr/bin/install -c -m 644 ./Lib/pickle.py /home/pierreglaser/dev_python/lib/python3.8

# PYTHONPATH=/home/pierreglaser/dev_python/lib/python3.8    python3.8 -E -Wi /home/pierreglaser/dev_python/lib/python3.8/compileall.py -d /home/pierreglaser/dev_python/lib/python3.8 -f -x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data' /home/pierreglaser/dev_python/lib/python3.8/test/test_pickle.py
# PYTHONPATH=/home/pierreglaser/dev_python/lib/python3.8    python3.8 -E -Wi /home/pierreglaser/dev_python/lib/python3.8/compileall.py -d /home/pierreglaser/dev_python/lib/python3.8 -f -x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data' /home/pierreglaser/dev_python/lib/python3.8/test/pickletester.py




sudo /usr/bin/install -c -m 644 ./Lib/_compat_pickle.py $HOME/dev_python/lib/python3.8
sudo /usr/bin/install -c -m 644 ./Lib/pickle.py $HOME/dev_python/lib/python3.8
sudo /usr/bin/install -c -m 644 ./Lib/pickletools.py $HOME/dev_python/lib/python3.8
sudo /usr/bin/install -c -m 644 ./Lib/test/pickletester.py $HOME/dev_python/lib/python3.8/test
sudo /usr/bin/install -c -m 644 ./Lib/test/test_pickle.py $HOME/dev_python/lib/python3.8/test
sudo /usr/bin/install -c -m 644 ./Lib/test/test_pickletools.py $HOME/dev_python/lib/python3.8/test


PYTHONPATH=$HOME/dev_python/lib/python3.8  python3.8 -E -Wi $HOME/dev_python/lib/python3.8/compileall.py -d $HOME/dev_python/lib/python3.8 -f -x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data' $HOME/dev_python/lib/python3.8/_compat_pickle.py
PYTHONPATH=$HOME/dev_python/lib/python3.8  python3.8 -E -Wi $HOME/dev_python/lib/python3.8/compileall.py -d $HOME/dev_python/lib/python3.8 -f -x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data' $HOME/dev_python/lib/python3.8/pickle.py
PYTHONPATH=$HOME/dev_python/lib/python3.8  python3.8 -E -Wi $HOME/dev_python/lib/python3.8/compileall.py -d $HOME/dev_python/lib/python3.8 -f -x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data' $HOME/dev_python/lib/python3.8/pickletools.py
PYTHONPATH=$HOME/dev_python/lib/python3.8  python3.8 -E -Wi $HOME/dev_python/lib/python3.8/compileall.py -d $HOME/dev_python/lib/python3.8 -f -x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data' $HOME/dev_python/lib/python3.8/test/pickletester.py
PYTHONPATH=$HOME/dev_python/lib/python3.8  python3.8 -E -Wi $HOME/dev_python/lib/python3.8/compileall.py -d $HOME/dev_python/lib/python3.8 -f -x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data' $HOME/dev_python/lib/python3.8/test/test_pickle.py
PYTHONPATH=$HOME/dev_python/lib/python3.8  python3.8 -E -Wi $HOME/dev_python/lib/python3.8/compileall.py -d $HOME/dev_python/lib/python3.8 -f -x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data' $HOME/dev_python/lib/python3.8/test/test_pickletools.py
