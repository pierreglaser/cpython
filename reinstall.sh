# use clinc on pickle before compiling
python3.8 ./Tools/clinic/clinic.py Modules/_pickle.c

# re-compile pickle
sudo gcc -pthread -fPIC -Wno-unused-result -Wsign-compare -g -O0  -Wall -std=c99 -Wextra -Wno-unused-result -Wno-unused-parameter -Wno-missing-field-initializers -Werror=implicit-function-declaration -I./Include -I/home/pierreglaser/dev_python/include -I. -I/usr/include/x86_64-linux-gnu -I/usr/local/include -I/home/pierreglaser/repos/cpython/Include -I/home/pierreglaser/repos/cpython -c /home/pierreglaser/repos/cpython/Modules/_pickle.c -o build/temp.linux-x86_64-3.8-pydebug/home/pierreglaser/repos/cpython/Modules/_pickle.o
sudo gcc -pthread -shared build/temp.linux-x86_64-3.8-pydebug/home/pierreglaser/repos/cpython/Modules/_pickle.o -L/home/pierreglaser/dev_python/lib -L/usr/lib/x86_64-linux-gnu -L/usr/local/lib -o build/lib.linux-x86_64-3.8-pydebug/_pickle.cpython-38dm-x86_64-linux-gnu.so

sudo cp build/lib.linux-x86_64-3.8-pydebug/_pickle.cpython-38dm-x86_64-linux-gnu.so /home/pierreglaser/dev_python/lib/python3.8/lib-dynload/

