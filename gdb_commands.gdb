set breakpoint pending on
dir ~/repos/cpython/Modules/
break _pickle_save_function_tuple_impl
break _pickle_Pickler_extract_func_data
break fill_globals
break process_closure
break _pickle.c:7642
disable breakpoint 2 3 4
run -m pdb test_save_function_tuple.py
