# use clinc on pickle before compiling
python3.8 ./Tools/clinic/clinic.py Modules/_pickle.c

# re-compile pickle
gcc -pthread -fPIC -Wno-unused-result -Wsign-compare -g -O0  -Wall -std=c99 -Wextra -Wno-unused-result -Wno-unused-parameter -Wno-missing-field-initializers -Werror=implicit-function-declaration -I./Include -I/home/pierreglaser/dev_python/include -I. -I/usr/include/x86_64-linux-gnu -I/usr/local/include -I/home/pierreglaser/repos/cpython/Include -I/home/pierreglaser/repos/cpython -c /home/pierreglaser/repos/cpython/Modules/_pickle.c -o build/temp.linux-x86_64-3.8-pydebug/home/pierreglaser/repos/cpython/Modules/_pickle.o
gcc -pthread -shared build/temp.linux-x86_64-3.8-pydebug/home/pierreglaser/repos/cpython/Modules/_pickle.o -L/home/pierreglaser/dev_python/lib -L/usr/lib/x86_64-linux-gnu -L/usr/local/lib -o build/lib.linux-x86_64-3.8-pydebug/_pickle.cpython-38dm-x86_64-linux-gnu.so

cp build/lib.linux-x86_64-3.8-pydebug/_pickle.cpython-38dm-x86_64-linux-gnu.so /home/pierreglaser/dev_python/lib/python3.8/lib-dynload/

# compile and install the tests
# /usr/bin/install Lib/test/test_pickle.py /home/pierreglaser/dev_python/lib/python3.8/test/test_pickle.py
# /usr/bin/install Lib/test/test_pickle.py /home/pierreglaser/dev_python/lib/python3.8/test/pickletester.py
# /usr/bin/install -c -m 644 ./Lib/pickle.py /home/pierreglaser/dev_python/lib/python3.8

# PYTHONPATH=/home/pierreglaser/dev_python/lib/python3.8    python3.8 -E -Wi /home/pierreglaser/dev_python/lib/python3.8/compileall.py -d /home/pierreglaser/dev_python/lib/python3.8 -f -x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data' /home/pierreglaser/dev_python/lib/python3.8/test/test_pickle.py
# PYTHONPATH=/home/pierreglaser/dev_python/lib/python3.8    python3.8 -E -Wi /home/pierreglaser/dev_python/lib/python3.8/compileall.py -d /home/pierreglaser/dev_python/lib/python3.8 -f -x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data' /home/pierreglaser/dev_python/lib/python3.8/test/pickletester.py




/usr/bin/install -c -m 644 ./Lib/_compat_pickle.py /home/pierreglaser/dev_python/lib/python3.8
/usr/bin/install -c -m 644 ./Lib/pickle.py /home/pierreglaser/dev_python/lib/python3.8
/usr/bin/install -c -m 644 ./Lib/pickletools.py /home/pierreglaser/dev_python/lib/python3.8
/usr/bin/install -c -m 644 ./Lib/test/pickletester.py /home/pierreglaser/dev_python/lib/python3.8/test
/usr/bin/install -c -m 644 ./Lib/test/test_pickle.py /home/pierreglaser/dev_python/lib/python3.8/test
/usr/bin/install -c -m 644 ./Lib/test/test_pickletools.py /home/pierreglaser/dev_python/lib/python3.8/test


PYTHONPATH=/home/pierreglaser/dev_python/lib/python3.8    python3.8 -E -Wi /home/pierreglaser/dev_python/lib/python3.8/compileall.py -d /home/pierreglaser/dev_python/lib/python3.8 -f -x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data' /home/pierreglaser/dev_python/lib/python3.8/_compat_pickle.py

PYTHONPATH=/home/pierreglaser/dev_python/lib/python3.8    python3.8 -E -Wi /home/pierreglaser/dev_python/lib/python3.8/compileall.py -d /home/pierreglaser/dev_python/lib/python3.8 -f -x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data' /home/pierreglaser/dev_python/lib/python3.8/pickle.py

PYTHONPATH=/home/pierreglaser/dev_python/lib/python3.8    python3.8 -E -Wi /home/pierreglaser/dev_python/lib/python3.8/compileall.py -d /home/pierreglaser/dev_python/lib/python3.8 -f -x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data' /home/pierreglaser/dev_python/lib/python3.8/pickletools.py

PYTHONPATH=/home/pierreglaser/dev_python/lib/python3.8    python3.8 -E -Wi /home/pierreglaser/dev_python/lib/python3.8/compileall.py -d /home/pierreglaser/dev_python/lib/python3.8 -f -x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data' /home/pierreglaser/dev_python/lib/python3.8/test/pickletester.py

PYTHONPATH=/home/pierreglaser/dev_python/lib/python3.8    python3.8 -E -Wi /home/pierreglaser/dev_python/lib/python3.8/compileall.py -d /home/pierreglaser/dev_python/lib/python3.8 -f -x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data' /home/pierreglaser/dev_python/lib/python3.8/test/test_pickle.py

PYTHONPATH=/home/pierreglaser/dev_python/lib/python3.8    python3.8 -E -Wi /home/pierreglaser/dev_python/lib/python3.8/compileall.py -d /home/pierreglaser/dev_python/lib/python3.8 -f -x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data' /home/pierreglaser/dev_python/lib/python3.8/test/test_pickletools.py
