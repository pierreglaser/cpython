set breakpoint pending on
dir ~/repos/cpython
break save_function
break Modules/_pickle.c:4180
run -m pdb test_cell.py
