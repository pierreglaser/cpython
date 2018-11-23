set breakpoint pending on
dir ~/repos/cpython
break _pickle_save_function_tuple_impl
break _pickle_Pickler_extract_func_data
break fill_globals
break process_closure
break _pickle_make_skel_func_impl
break _pickle__fill_function
break Modules/_pickle.c:7534
break Modules/_pickle.c:7763
break Modules/_pickle.c:7773
break Modules/_pickle.c:3627
break Modules/_pickle.c:3403

disable breakpoint 2 3 4 5 6 7
run -m pdb simple_test.py
