set breakpoint pending on
dir ~/repos/cpython
break Modules/_pickle.c:6668
break Modules/_pickle.c:7157
run -m pdb ../../test_closure.py
