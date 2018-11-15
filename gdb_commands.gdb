set breakpoint pending on
dir ~/repos/cpython/Modules/
break save_global
break save_global:3333
run -m pdb simple_test.py
