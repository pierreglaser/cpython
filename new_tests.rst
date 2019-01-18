Serializing dyamic objects was the purpose of the ``cloudpickle`` module,
therefore most of its test suite was migrated. Some tests were refactored or
simply discarded. This files summarizes the migration from the cloudpickle test
suite to the ``cpython`` test suite.


SUMMARY TABLE:

================================================================     ========
                        test name                                     commit
================================================================     ========
``test_recursive_closure``                                           da4dd39_
``test_empty_cell_preserved``                                        2f4c07d_
``test_unhashable_closure``                                          ba23a20_
``test_locally_defined_function_and_class``                          d86028b_
``test_submodule_closure``                                           938fc0d_
``test_cell_manipulation``                                           cf882c6_
``test_builtin_function_without_module``                             3ca9d71_
``test_module_locals_behavior``                                      51be0f9_
``test_closure_none_is_preserved``                                   6d8ec33_
``test_closure_interacting_with_a_global_variable``                  8eaf637_
``test_interactively_defined_function``                              28a15b8_
``test_abc``                                                         10491eb_
``test_cycle_in_classdict_globals``                                  aec80d2_
``test_faulty_module``                                               fb3a80f_
``test_weakset_identity_preservation``                               10491eb_
``test_classmethod``                                                 36a53c0_
``test_dynamic_module``                                              e7341b6_
``test_dynamic_modules_globals``                                     1d73b39_
``test_load_dynamic_module_in_grandchild_process``                   8eaf637_
``test_function_from_dynamic_module_with_globals_modifications``     1d73b39_
``test_is_dynamic_module``                                           abea4e6_
``test_builtin_type__new__``                                         f0d2011_
``test_dynamic_pytest_module``                                       c5e6ca0_
``test_namedtuple``                                                  28070bb_
``test_tornado_coroutine``                                           b11d4db_
``test_EllipsisType``                                                4df0378_
``test_ufunc``                                                       1e91fa7_
``test_NotImplemented``                                              e7341b6_
``test_NotImplementedType``                                          4df0378_
``test_itemgetter``                                                  c8d3bb1_
``test_attrgetter``                                                  c8d3bb1_
``test_buffer``                                                      a3e41c6_
``test_logger``                                                      1b1e6ea_
``test_function_pickle_compat_0_4_1``                                7d8c670_
``test_function_pickle_compat_0_4_0``                                7d8c670_
``test_correct_globals_import``                                      5c781be_
``test_import``                                                      938fc0d_
``test_nested_lambdas``                                              d86028b_
``test_wraps_preserves_function_annotations``                        6d03ffe_
``test_wraps_preserves_function_doc``                                aa61338_
``test_wraps_preserves_function_name``                               33c9381_
``test_multiprocess``                                                aec80d2_
``test_memoryview``                                                  f8187e9_
``test_sliced_and_non_contiguous_memoryview``                        ac9484e_
``test_large_memoryview``                                            ac9484e_
``test_generator``                                                   16ea169_
``test_unhashable_function``                                         8a41060_
``test_partial``                                                     9ad2568_
``test_method_descriptors``                                          ce99eee_
``test_itertools_count``                                             67c977b_
================================================================     ========


---------------------------
tests dealing with closures
---------------------------


``test_recursive_closure``
--------------------------


* goal: canonical recursive object test
* commit added: support recursive closure cells da4dd39_ (ref:)
* present: yes

``test_empty_cell_preserved``
-----------------------------

* commit added: fix functions with empty cells 2f4c07d_ (ref:)
* goal: make sure that roundtripping function with empty cells preserves those
  empty cells
* present: no - cells are now created in a traditional way, not by tricking the
  compiler

``test_unhashable_closure``
---------------------------

* commit added: support unhashable closure values ba23a20_ (ref:)
* goal: ``set(closure)`` was called at some point in the code, which raised an
  error if the closure was unhashable.
* present: no - at no point is the hashability of a function's closure
  important in the current codebase.

``test_locally_defined_function_and_class``
-------------------------------------------

* commit added: TST add tests for nested constructs d86028b_ (ref: pull_25_)
* goal: test pickling-depickling of classes with references to variables in the
  closure of their methods.
* present: currently no. Will add it if it has a clear purpose.

``test_submodule_closure``
--------------------------

* commit added: Import submodules accessed by pickled functions (#80) 938fc0d_ (ref: pull_80_)
* goal: make sure that submodules refered by attribute in a function are
  correctly serialized
* present: yes


``test_cell_manipulation``
--------------------------

* commit added: add cell manipulation helper unit tests cf882c6_ (ref: pull_90_)
* goal: test cell creation/value setting
* present no: cell_contents is now writeable

``test_builtin_function_without_module``
----------------------------------------

* commit added: fix #56 3ca9d71_ (ref: pull_56_)
* goal: in cloudpickle, ``builtin_function_or_method`` are dispatched
  ``save_global``. We must make sure those method are pickled using
  ``save_global`` and not ``save_function``, as builtin methods do not have a
  ``__code__`` attributes.
* present: no. In pickle, i do not modify the dispatch table for builtin types,
  so this should go well.

``test_module_locals_behavior``
-------------------------------

* commit added: Fix module locals has no builtins (#212) 51be0f9_ (ref: pull_212_)
* goal: Makes sure that a local function defined in another module is correctly
  serialized. This notably checks that the globals are accessible and that
  there is no issue with the builtins (see #211)
* present: no, failure only on 3.4


``test_closure_none_is_preserved``:
-----------------------------------

* commit added: add test for f.__closure__ preservation 6d8ec33_ (ref:)
* goal: make sure a function with a None closure has a None closure at
  depickling
* keep: no - in python3.8, a closure is either None, or a tuple of scrictly
  positive length. In addition, it is not possible to create a function with
  the wrong number of cells. So this test is probably unnecessary.

``test_closure_interacting_with_a_global_variable``
---------------------------------------------------

* commit added: FIX Handling of global variables by locally defined functions (#198) 8eaf637_ (ref: pull_198_)
* goal: current default behavior in cloudpickle regaring global variable
  collusion is to not ovveride the existing globals of a processs when a
  function is unpickled. This test used to check this behavior for non
  ``__main__`` modules.
* present: yes, but switch behavior to override globals

----------------------
tests pickling classes
----------------------

``test_interactively_defined_function``
---------------------------------------

* commit added: New tests for interactively defined functions 28a15b8_ (ref:)
* goal: pickle some basic objects defined in a __main__ module: functions,
  classes...
* present: yes, but with no dynamic classes for now. A bunch of attribute
  preserving/result checking tests are done. Could be refactored?

``test_abc``
------------

* commit added: BUG: Support WeakSets and ABCMeta instances. 10491eb_ (ref:)
* goal: TBD
* present: TBD

``test_cycle_in_classdict_globals``
-----------------------------------

* commit added: BUG: Fix crash when pickling dynamic class cycles. aec80d2_ (ref:)
* yet another circular reference test
* present: TBD

``test_faulty_module``
----------------------

* commit added: Fix pickling classes and functions defined in a faulty module (#136) fb3a80f_ (ref: pull_136_)
* goal: TBD
* present: TBD

``test_weakset_identity_preservation``
--------------------------------------

* commit added: BUG: Support WeakSets and ABCMeta instances. 10491eb_ (ref:)
* goal: Test that weaksets don't lose all their inhabitants if they're pickled
  in a larger data structure that includes other references to their
  inhabitants.  fails because: uses classes in its implementation
* present: no (for now, weaksets are not picklable)


``test_classmethod``
--------------------

* commit added: Add test for classmethod pickling 36a53c0_ (ref: pull_41_)
* goal: pickle methods decorated with static/classmethod fails because:
  temporarily dropping dynamic class pickling, because it occasionally involves
  non-empty closures
* present: TBD


-------------------------
test with dynamic modules
-------------------------

``test_dynamic_module``
-----------------------

* commit added: Add custom logic for pickling dynamic imports. Add test cases, special case Ellipsis and NotImplemented. Use custom logic in lieu of imp.find_module to properly follow subimports. For example sklearn.tree was spuriously treated as a dynamic module. e7341b6_ (ref: pull_52_)
* goal: pickle a dynamic module
* present: TBD (no dynamic module pickling yet)


``test_dynamic_modules_globals``
--------------------------------

* commit added: Global variables handling in dynamically defined functions.  (#205) 1d73b39_ (ref: pull_205_)
* goal: test the behavior of ``dynamic_modules_globals``, which acts like
  sys.modules for dynamic modules.
* present: TBD (no dynamic module pickling yet)

``test_load_dynamic_module_in_grandchild_process``
--------------------------------------------------

* commit added: FIX Handling of global variables by locally defined functions (#198) 8eaf637_ (ref: pull_198_)
* goal: Make sure that when loaded, a dynamic module preserves its dynamic
  property.
* present: TBD (no dynamic module pickling yet)

``test_function_from_dynamic_module_with_globals_modifications``
----------------------------------------------------------------

* commit added: Global variables handling in dynamically defined functions.  (#205) 1d73b39_ (ref: pull_205_)
* goal: make sure variables from the global namespace of the process in which a
  function from a dynamic module gets unpickled are not overriden if the
  function carries some global variables with it fails because: removed dynamic
  module support
* present: TBD (no dynamic module pickling yet)

``test_is_dynamic_module``
--------------------------

* commit added: Stop using the deprecated imp module when possible (#208) abea4e6_ (ref: pull_208_)
* goal: make sure cloudpickle spots dynamic module correctly
* present: most probably yes (to differentiate between dynamic and static
  modules, even if we do not serialize dynamic modules)


--------------------------------------------
test with specific, isolated functionalities
--------------------------------------------

``test_builtin_type__new__``
----------------------------

* commit added: MAINT: Handle builtin type __new__ attrs. f0d2011_ (ref:)
* goal: test pickling of builtin type constructors
* present: no because for now we do not ``builtin_function_or_method`` types to
  ``save_global``

``test_dynamic_pytest_module``
------------------------------

* commit added: Added simple test case for the issue c5e6ca0_ (ref:)
* goal: TBD
* present: TBD

``test_namedtuple``
-------------------

* commit added: BUG: Fix bug pickling namedtuple. 28070bb_ (ref:)
* goal: test pickling of namedtuples
* present: no namedtuple support

``test_tornado_coroutine``
--------------------------

* commit added: Add support for Tornado coroutines b11d4db_ (ref:)
* goal: test ``pickle_depickling`` a locally defined coroutine function
* present: TBD

``test_EllipsisType``
---------------------

* commit added: NoneType fix (#210) 4df0378_ (ref: pull_210_)
* goal: pickle-depickle type(Ellipsis)
* present: TBD

``test_ufunc``
--------------

* commit added: adds tests for pickling of ufuncs and removes custom ufunc code in cloudpickle 1e91fa7_ (ref: pull_34_)
* goal: self explaining
* present: probably not in this form at least

``test_NotImplemented``
-----------------------

* commit added: Add custom logic for pickling dynamic imports. Add test cases, special case Ellipsis and NotImplemented. Use custom logic in lieu of imp.find_module to properly follow subimports. For example sklearn.tree was spuriously treated as a dynamic module. e7341b6_ (ref: pull_52_)
* goal: pickle NotImplemented
* present: not in this PR

``test_NotImplementedType``
---------------------------

* commit added: NoneType fix (#210) 4df0378_ (ref: pull_210_)
* goal: pickle NotImplementedType
* present: not in this PR

``test_itemgetter``
-------------------

* commit added: Adapted some spark unit tests c8d3bb1_ (ref:)
* goal: pickle operator.itemgetter
* present: not in this PR

``test_attrgetter``
-------------------

* commit added: Adapted some spark unit tests c8d3bb1_ (ref:)
* goal: pickle operator.attrgetter
* present: not in this PR


``test_buffer``
---------------

* commit added: adds a test for pickling a buffer protocol a3e41c6_ (ref:)
* goal: pickle a buffer
* present: no (skipped under python3 on cloudpickle)

``test_logger``
---------------

* commit added: FIX pickle RootLogger 1b1e6ea_ (ref:)
* goal: pickle a logger instance
* present: not in this PR

-------------------------
retro-compatibility tests
-------------------------

``test_function_pickle_compat_0_4_1``
-------------------------------------

* commit added: Restore compatibility with functions pickled with 0.4.0 (#128) 7d8c670_ (ref: pull_218_)
* goal: make sure cloudpickle can depickle pickle strings from 0.4.1 (Python
  2.7)
* present: no

``test_function_pickle_compat_0_4_0``
-------------------------------------

* commit added: Restore compatibility with functions pickled with 0.4.0 (#128) 7d8c670_ (ref: pull_128_)
* goal: make sure cloudpickle can depickle pickle strings from 0.4.0 (Python
  2.7)
* present: no


-----------
other tests
-----------

``test_correct_globals_import``
-------------------------------

* commit added: MNT Add a non regression test for function globals (#204) 5c781be_ (ref: pull_204_)
* goal: checks that non-used globals are not part of the pickle string of a
  function
* present: soon


``test_import``
---------------

* commit added: Import submodules accessed by pickled functions (#80) 938fc0d_ (ref: pull_80_)
* goal: according to the doc, like ``test_multiprocess`` except subpackage
  modules referenced directly
* present: yes

``test_nested_lambdas``
-----------------------

* commit added: TST add tests for nested constructs d86028b_ (ref: pull_25_)
* goal: checks ``pickle_depickle`` on a lambda calling another lambda, both
  defined in a local scope
* present: yes

``test_wraps_preserves_function_annotations``
---------------------------------------------

* commit added: Preserve original function's annotations with @functools.wraps #177 6d03ffe_ (ref: pull_177_)
* goal: test that decorating a function using functools.wraps and the
  ``pickle_depickling`` preserves annotations
* present: yes

``test_wraps_preserves_function_doc``
-------------------------------------

* commit added: Preserve original function's doc with @functools.wraps #177 aa61338_ (ref: pull_177_)
* goal: test that decorating a function using functools.wraps and the
  ``pickle_depickling`` preserves doc
* present: yes

``test_wraps_preserves_function_name``
--------------------------------------

* commit added: Preserve original function's name with @functools.wraps #177 33c9381_ (ref: pull_183_)
* goal: test that decorating a function using functools.wraps and the
  ``pickle_depickling`` preserves name
* present: yes

``test_multiprocess``
---------------------

* goal: define a function (in this case, in a local scope) pickle it and run it
  in another process
* present: yes

## file saving tests

``test_closed_file``
--------------------

* goal: TBD
* present: not in this PR

``test_empty_file``
-------------------

* goal: TBD
* present: not in this PR

``test_pickling_special_file_handles``
--------------------------------------

* goal: TBD
* present: not in this PR

``test_plus_mode``
------------------

* goal: TBD
* present: not in this PR

``test_r_mode``
---------------

* goal: TBD
* present: not in this PR

``test_seek``
-------------

* goal: TBD
* present: not in this PR

``test_w_mode``
---------------

* goal: TBD
* present: not in this PR

``test_pickling_file_handle``
-----------------------------

* goal: TBD
* present: not in this PR

# Broken tests

``test_dynamically_generated_class_that_uses_super``
----------------------------------------------------

* commit added: BUG: Fix crash when pickling dynamic class cycles. aec80d2_ (ref:)
* goal: test pickling-depickling of a subclass that uses super in some of its
  methods
* present: not in this PR

``test_memoryview``
-------------------

* commit added: Some cleanups, fix memoryview support f8187e9_ (ref:)
* goal: TBD
* present: not in this PR

``test_sliced_and_non_contiguous_memoryview``
---------------------------------------------

* commit added: TST non contiguous and large memory views ac9484e_ (ref:)
* goal: TBD
* present: not in this PR

``test_large_memoryview``
-------------------------

* commit added: TST non contiguous and large memory views ac9484e_ (ref:)
* goal: TBD
* present: not in this PR

``test_generator``
------------------

* commit added: Add a test for picking/unpickling generators 16ea169_ (ref: pull_39_)
* goal: TBD
* present: yes

``test_unhashable_function``
----------------------------

* commit added: BUG: Handle instancemethods of builtin types. 8a41060_ (ref: pull_145_)
* goal: TBD
* present: yes

``test_partial``
----------------

* commit added: adds test for pickling simple partial function 9ad2568_ (ref:)
* goal: TBD
* present: yes

``test_method_descriptors``
---------------------------

* commit added: Support method_descriptor ce99eee_ (ref:)
* goal: TBD
* present: yes

``test_itertools_count``
------------------------

* commit added: BUG: itertools objects are actually picklable 67c977b_ (ref)
* goal: TBD
* present: yes

.. _da4dd39: https://github.com/cloudpipe/cloudpickle/commit/da4dd398f83d935d4eb8722a505a70362b165476
.. _2f4c07d: https://github.com/cloudpipe/cloudpickle/commit/2f4c07d9684d1a7f988ac18696ce9d1daa77b071
.. _ba23a20: https://github.com/cloudpipe/cloudpickle/commit/ba23a20bf42aca0eeaae99f67b0a2e7f85cfdf7a
.. _d86028b: https://github.com/cloudpipe/cloudpickle/commit/d86028b840889a9a8bd844f00e9ff4f2ae65ab6d
.. _938fc0d: https://github.com/cloudpipe/cloudpickle/commit/938fc0d850923f0e623d202ff9e89214143b902f
.. _cf882c6: https://github.com/cloudpipe/cloudpickle/commit/cf882c6192c3ba5759691fdfe3bf9b9267548cee
.. _3ca9d71: https://github.com/cloudpipe/cloudpickle/commit/3ca9d71b188556fded2e112c7e01a34b398a0fba
.. _51be0f9: https://github.com/cloudpipe/cloudpickle/commit/51be0f98e76a3bfcca2333d6519f336e508d50a3
.. _6d8ec33: https://github.com/cloudpipe/cloudpickle/commit/6d8ec33dc24e249657eea93320beef3b9fcb421b
.. _8eaf637: https://github.com/cloudpipe/cloudpickle/commit/8eaf637e78733fe5b4c295d9204dc6dcc76fb342
.. _28a15b8: https://github.com/cloudpipe/cloudpickle/commit/28a15b8d27b712b4ec504818818744a428d66ced
.. _10491eb: https://github.com/cloudpipe/cloudpickle/commit/10491eb4eabda5c160bc25beb7deb7f7aa84a07e
.. _aec80d2: https://github.com/cloudpipe/cloudpickle/commit/aec80d21ddff84cf2a83dce3cb5921a9f58ffd05
.. _fb3a80f: https://github.com/cloudpipe/cloudpickle/commit/fb3a80f4aa8e76098b4cebd0dc8ff2331424e53d
.. _10491eb: https://github.com/cloudpipe/cloudpickle/commit/10491eb4eabda5c160bc25beb7deb7f7aa84a07e
.. _36a53c0: https://github.com/cloudpipe/cloudpickle/commit/36a53c0a659f54b93e2a8621ae483609a422a520
.. _e7341b6: https://github.com/cloudpipe/cloudpickle/commit/e7341b6718e72f5489ab3d65ab08c85963b5e240
.. _1d73b39: https://github.com/cloudpipe/cloudpickle/commit/1d73b39b5bc0ddc3555cbfc09a024b41fc7f4b17
.. _8eaf637: https://github.com/cloudpipe/cloudpickle/commit/8eaf637e78733fe5b4c295d9204dc6dcc76fb342
.. _1d73b39: https://github.com/cloudpipe/cloudpickle/commit/1d73b39b5bc0ddc3555cbfc09a024b41fc7f4b17
.. _abea4e6: https://github.com/cloudpipe/cloudpickle/commit/abea4e63f438c1f06154dcb6e4eba421e1ba2c14
.. _f0d2011: https://github.com/cloudpipe/cloudpickle/commit/f0d2011f9fc88105c174b7c861f2c2f56e870350
.. _c5e6ca0: https://github.com/cloudpipe/cloudpickle/commit/c5e6ca0a8e16cf6568b6c959525c30580828b249
.. _28070bb: https://github.com/cloudpipe/cloudpickle/commit/28070bba79cf71e5719ab8d7c1d6cbc72cd95a0c
.. _b11d4db: https://github.com/cloudpipe/cloudpickle/commit/b11d4dbaae71a726ee47e227287515d5a803390b
.. _4df0378: https://github.com/cloudpipe/cloudpickle/commit/4df0378588d3803b4176b90bfe3b13a633cf78af
.. _1e91fa7: https://github.com/cloudpipe/cloudpickle/commit/1e91fa7c0f9b1e77604d83b3ba9aecde8603ece1
.. _e7341b6: https://github.com/cloudpipe/cloudpickle/commit/e7341b6718e72f5489ab3d65ab08c85963b5e240
.. _4df0378: https://github.com/cloudpipe/cloudpickle/commit/4df0378588d3803b4176b90bfe3b13a633cf78af
.. _c8d3bb1: https://github.com/cloudpipe/cloudpickle/commit/c8d3bb11a11d0a4967d369464295154703232907
.. _c8d3bb1: https://github.com/cloudpipe/cloudpickle/commit/c8d3bb11a11d0a4967d369464295154703232907
.. _a3e41c6: https://github.com/cloudpipe/cloudpickle/commit/a3e41c696af47beff0f32976b5d4a55aa02cc8ec
.. _1b1e6ea: https://github.com/cloudpipe/cloudpickle/commit/1b1e6eac9dbb5063503192fc53229e01d12583ba
.. _7d8c670: https://github.com/cloudpipe/cloudpickle/commit/7d8c670b703a683d6fd7e642c6bec8a487594d20
.. _7d8c670: https://github.com/cloudpipe/cloudpickle/commit/7d8c670b703a683d6fd7e642c6bec8a487594d20
.. _5c781be: https://github.com/cloudpipe/cloudpickle/commit/5c781bedf3e0bc8f65d2b3e6ab0fc702fe046539
.. _938fc0d: https://github.com/cloudpipe/cloudpickle/commit/938fc0d850923f0e623d202ff9e89214143b902f
.. _d86028b: https://github.com/cloudpipe/cloudpickle/commit/d86028b840889a9a8bd844f00e9ff4f2ae65ab6d
.. _6d03ffe: https://github.com/cloudpipe/cloudpickle/commit/6d03ffe1b06d5abc8f8615ac57d475946aca4b38
.. _aa61338: https://github.com/cloudpipe/cloudpickle/commit/aa613383a5e075d9079838f8c99edc2476f9bf0e
.. _33c9381: https://github.com/cloudpipe/cloudpickle/commit/33c9381ebeb57d28512b7f94e1f047974bc5612c
.. _aec80d2: https://github.com/cloudpipe/cloudpickle/commit/aec80d21ddff84cf2a83dce3cb5921a9f58ffd05
.. _f8187e9: https://github.com/cloudpipe/cloudpickle/commit/f8187e90aed7e1b96ffaae85cdf4b37108c75d3f
.. _ac9484e: https://github.com/cloudpipe/cloudpickle/commit/ac9484e2b2e16d42e31f78cc9bf10401a75cf280
.. _ac9484e: https://github.com/cloudpipe/cloudpickle/commit/ac9484e2b2e16d42e31f78cc9bf10401a75cf280
.. _16ea169: https://github.com/cloudpipe/cloudpickle/commit/16ea1694bf411d16dcba35507caeadd3116073c1
.. _8a41060: https://github.com/cloudpipe/cloudpickle/commit/8a41060c0529d71538b21caccddcaf90dac2f470
.. _9ad2568: https://github.com/cloudpipe/cloudpickle/commit/9ad2568ef172275981c8ed0c0df65b9ea2e995c1
.. _ce99eee: https://github.com/cloudpipe/cloudpickle/commit/ce99eee4bf159985018bdf50ab363408e74ac07c
.. _67c977b: https://github.com/cloudpipe/cloudpickle/commit/67c977b89c75766be563554d1a2abd80df0b37b

.. _pull_25: https://github.com/cloudpipe/cloudpickle/pull/25
.. _pull_80: https://github.com/cloudpipe/cloudpickle/pull/80
.. _pull_90: https://github.com/cloudpipe/cloudpickle/pull/90
.. _pull_56: https://github.com/cloudpipe/cloudpickle/pull/56
.. _pull_212: https://github.com/cloudpipe/cloudpickle/pull/212
.. _pull_198: https://github.com/cloudpipe/cloudpickle/pull/198
.. _pull_136: https://github.com/cloudpipe/cloudpickle/pull/136
.. _pull_41: https://github.com/cloudpipe/cloudpickle/pull/41
.. _pull_52: https://github.com/cloudpipe/cloudpickle/pull/52
.. _pull_205: https://github.com/cloudpipe/cloudpickle/pull/205
.. _pull_198: https://github.com/cloudpipe/cloudpickle/pull/198
.. _pull_205: https://github.com/cloudpipe/cloudpickle/pull/205
.. _pull_208: https://github.com/cloudpipe/cloudpickle/pull/208
.. _pull_210: https://github.com/cloudpipe/cloudpickle/pull/210
.. _pull_34: https://github.com/cloudpipe/cloudpickle/pull/34
.. _pull_52: https://github.com/cloudpipe/cloudpickle/pull/52
.. _pull_210: https://github.com/cloudpipe/cloudpickle/pull/210
.. _pull_218: https://github.com/cloudpipe/cloudpickle/pull/218
.. _pull_128: https://github.com/cloudpipe/cloudpickle/pull/128
.. _pull_204: https://github.com/cloudpipe/cloudpickle/pull/204
.. _pull_80: https://github.com/cloudpipe/cloudpickle/pull/80
.. _pull_25: https://github.com/cloudpipe/cloudpickle/pull/25
.. _pull_177: https://github.com/cloudpipe/cloudpickle/pull/177
.. _pull_177: https://github.com/cloudpipe/cloudpickle/pull/177
.. _pull_183: https://github.com/cloudpipe/cloudpickle/pull/183
.. _pull_39: https://github.com/cloudpipe/cloudpickle/pull/39
.. _pull_145: https://github.com/cloudpipe/cloudpickle/pull/145
