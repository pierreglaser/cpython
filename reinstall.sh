# use clinc on pickle before compiling
# python3.8 ./Tools/clinic/clinic.py Objects/codeobject.c
# python3.8 ./Tools/clinic/clinic.py Python/bltinmodule.c

# re-compile pickle
sudo  gcc -pthread -fPIC -Wno-unused-result -Wsign-compare -g -O0  -Wall -std=c99 -Wextra -Wno-unused-result -Wno-unused-parameter -Wno-missing-field-initializers -Werror=implicit-function-declaration -I./Include -I/home/pierreglaser/dev_python/include -I. -I/usr/include/x86_64-linux-gnu -I/usr/local/include -I/home/pierreglaser/repos/cpython/Include -I/home/pierreglaser/repos/cpython -c /home/pierreglaser/repos/cpython/Modules/_pickle.c -o build/temp.linux-x86_64-3.8-pydebug/home/pierreglaser/repos/cpython/Modules/_pickle.o

gcc -pthread -c -Wno-unused-result -Wsign-compare -g -Og -Wall    -std=c99 -Wextra -Wno-unused-result -Wno-unused-parameter -Wno-missing-field-initializers -Werror=implicit-function-declaration   -I. -I./Include    -DPy_BUILD_CORE -o Python/bltinmodule.o Python/bltinmodule.c

sudo gcc -pthread -shared build/temp.linux-x86_64-3.8-pydebug/home/pierreglaser/repos/cpython/Modules/_pickle.o -L/home/pierreglaser/dev_python/lib -L/usr/lib/x86_64-linux-gnu -L/usr/local/lib -o build/lib.linux-x86_64-3.8-pydebug/_pickle.cpython-38dm-x86_64-linux-gnu.so





sudo cp build/lib.linux-x86_64-3.8-pydebug/_pickle.cpython-38dm-x86_64-linux-gnu.so /home/pierreglaser/dev_python/lib/python3.8/lib-dynload/

# # compile and install the tests
# /usr/bin/install Lib/test/test_mypickle.py /home/pierreglaser/dev_python/lib/python3.8/test/test_mypickle.py
# re-do the bltin module
gcc -pthread -c -Wno-unused-result -Wsign-compare -g -Og -Wall    -std=c99 -Wextra -Wno-unused-result -Wno-unused-parameter -Wno-missing-field-initializers -Werror=implicit-function-declaration   -I. -I./Include    -DPy_BUILD_CORE -o Python/bltinmodule.o Python/bltinmodule.c
ar rcs libpython3.8dm.a Modules/getbuildinfo.o Parser/acceler.o Parser/grammar1.o Parser/listnode.o Parser/node.o Parser/parser.o Parser/bitset.o Parser/metagrammar.o Parser/firstsets.o Parser/grammar.o Parser/pgen.o Parser/myreadline.o Parser/parsetok.o Parser/tokenizer.o Objects/abstract.o Objects/accu.o Objects/boolobject.o Objects/bytes_methods.o Objects/bytearrayobject.o Objects/bytesobject.o Objects/call.o Objects/cellobject.o Objects/classobject.o Objects/codeobject.o Objects/complexobject.o Objects/descrobject.o Objects/enumobject.o Objects/exceptions.o Objects/genobject.o Objects/fileobject.o Objects/floatobject.o Objects/frameobject.o Objects/funcobject.o Objects/iterobject.o Objects/listobject.o Objects/longobject.o Objects/dictobject.o Objects/odictobject.o Objects/memoryobject.o Objects/methodobject.o Objects/moduleobject.o Objects/namespaceobject.o Objects/object.o Objects/obmalloc.o Objects/capsule.o Objects/rangeobject.o Objects/setobject.o Objects/sliceobject.o Objects/structseq.o Objects/tupleobject.o Objects/typeobject.o Objects/unicodeobject.o Objects/unicodectype.o Objects/weakrefobject.o Python/_warnings.o Python/Python-ast.o Python/asdl.o Python/ast.o Python/ast_opt.o Python/ast_unparse.o Python/bltinmodule.o Python/ceval.o Python/codecs.o Python/compile.o Python/coreconfig.o Python/dynamic_annotations.o Python/errors.o Python/frozenmain.o Python/future.o Python/getargs.o Python/getcompiler.o Python/getcopyright.o Python/getplatform.o Python/getversion.o Python/graminit.o Python/import.o Python/importdl.o Python/marshal.o Python/modsupport.o Python/mysnprintf.o Python/mystrtoul.o Python/pathconfig.o Python/peephole.o Python/pyarena.o Python/pyctype.o Python/pyfpe.o Python/pyhash.o Python/pylifecycle.o Python/pymath.o Python/pystate.o Python/context.o Python/hamt.o Python/pythonrun.o Python/pytime.o Python/bootstrap_hash.o Python/structmember.o Python/symtable.o Python/sysmodule.o Python/thread.o Python/traceback.o Python/getopt.o Python/pystrcmp.o Python/pystrtod.o Python/pystrhex.o Python/dtoa.o Python/formatter_unicode.o Python/fileutils.o Python/dynload_shlib.o    Modules/config.o Modules/getpath.o Modules/main.o Modules/gcmodule.o Modules/posixmodule.o  Modules/errnomodule.o  Modules/pwdmodule.o  Modules/_sre.o  Modules/_codecsmodule.o  Modules/_weakref.o  Modules/_functoolsmodule.o  Modules/_operator.o  Modules/_collectionsmodule.o  Modules/_abc.o  Modules/itertoolsmodule.o  Modules/atexitmodule.o  Modules/signalmodule.o  Modules/_stat.o  Modules/timemodule.o  Modules/_threadmodule.o  Modules/_localemodule.o  Modules/_iomodule.o Modules/iobase.o Modules/fileio.o Modules/bytesio.o Modules/bufferedio.o Modules/textio.o Modules/stringio.o  Modules/faulthandler.o  Modules/_tracemalloc.o Modules/hashtable.o  Modules/symtablemodule.o  Modules/xxsubtype.o Python/frozen.o

/usr/bin/install Lib/copyreg.py /home/pierreglaser/dev_python/lib/python3.8/copyreg.py
/usr/bin/install Lib/pickle.py /home/pierreglaser/dev_python/lib/python3.8/pickle.py

    # /usr/bin/install -c -m 644 ./Include/bltinmodule.h /home/pierreglaser/dev_python/include/python3.8dm upgrade) ensurepip="--altinstall --upgrade" ;; \
		# install|*) ensurepip="--altinstall" ;; \

