set breakpoint pending on
dir ~/repos/cpython/Modules/
break _pickle_Pickler_extract_func_data
break fill_globals
break _pickle_Pickler_extract_func_data
break process_closure
run -m pdb test_save_function_tuple.py
