set breakpoint pending on
dir ~/repos/cpython
break object___reduce_ex___impl
break _PyObject_GetState
run -m pdb simple_test.py
