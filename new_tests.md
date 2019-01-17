# List of tests related to dynamic objects pickling

Serializing dyamic objects was the purpose of the ``cloudpickle`` module,
therefore most of its test suite was migrated. Some tests were refactored or
simply discarded. This files summarizes the migration from the cloudpickle test
suite to the ``cpython`` test suite.


## tests dealing with closures

### ``test_recursive_closure``

* present: yes
* cpython equivalent: ``test_recursive_closure``
* importance: capital

### ``test_empty_cell_preserved``

* present no - cells are now created in a traditional way, not by tricking the
* compiler

### ``test_unhashable_closure``

* goal: added to cloudpickle in ba23a20bf42aca0eeaae99f67b0a2e7f85cfdf7a.
``set(closure)`` was called at some point in the code, which raised an error if
the closure was unhashable.
* present: no - at no point is the hashability of a function's closure important
in the current codebase.

### ``test_locally_defined_function_and_class``
* goal: test pickling-depickling of classes with references to variables in
    the closure of their methods.
* present: currently no. Will add it if it has a clear purpose.

### ``test_submodule_closure``

* goal: make sure that submodules refered by attribute in a function are
correctly serialized
* present: yes


### ``test_cell_manipulation``

* goal: test cell creation/value setting
* present no: cell_contents is now writeable

### ``test_builtin_function_without_module``

* goal: in cloudpickle, ``builtin_function_or_method`` are dispatched
  ``save_global``. We must make sure those method are pickled using
  ``save_global`` and not ``save_function``, as builtin methods do not have a
  ``__code__`` attributes.
* present: no. In pickle, i do not modify the dispatch table for builtin types,
  so this should go well.

### ``test_module_locals_behavior``

* goal: Makes sure that a local function defined in another module is correctly
  serialized. This notably checks that the globals are accessible and that
  there is no issue with the builtins (see #211)
* present: no, failure only on 3.4


### ``test_closure_none_is_preserved``:
* goal: make sure a function with a None closure has a None closure at
  depickling
* keep: no - in python3.8, a closure is either None, or a tuple of scrictly positive
  length. In addition, it is not possible to create a function with the wrong
  number of cells. So this test is probably unnecessary.

### ``test_closure_interacting_with_a_global_variable``
* goal: current default behavior in cloudpickle regaring global variable
  collusion is to not ovveride the existing globals of a processs when a
  function is unpickled. This test used to check this behavior for non
  ``__main__`` modules. 
* present: yes, but switch behavior to override globals 

## tests pickling classes

### ``test_interactively_defined_function``

* goal: pickle some basic objects defined in a __main__ module: functions,
  classes...
* present: yes, but with no dynamic classes for now. A bunch of attribute
  preserving/result checking tests are done. Could be refactored?

### ``test_abc``

* goal: TBD
* present: TBD

### ``test_cycle_in_classdict_globals``

* yet another circular reference test
* present: TBD

### ``test_faulty_module``

* goal: TBD
* present: TBD

### ``test_weakset_identity_preservation``

* goal: Test that weaksets don't lose all their inhabitants if they're pickled
  in a larger data structure that includes other references to their
  inhabitants.  fails because: uses classes in its implementation
* present: no (for now, weaksets are not picklable)


### ``test_classmethod``

* goal: pickle methods decorated with static/classmethod fails because:
  temporarily dropping dynamic class pickling, because it occasionally involves
  non-empty closures
* present: TBD


## TEST WITH DYNAMIC MODULES

### ``test_dynamic_module``
* goal: pickle a dynamic module
* present: TBD (no dynamic module pickling yet)


### ``test_dynamic_modules_globals``

* goal: test the behavior of ``dynamic_modules_globals``, which acts like
  sys.modules for dynamic modules.
* present: TBD (no dynamic module pickling yet)

### ``test_load_dynamic_module_in_grandchild_process``

* goal: Make sure that when loaded, a dynamic module preserves its dynamic property.
* present: TBD (no dynamic module pickling yet)

### ``test_function_from_dynamic_module_with_globals_modifications``

* goal: make sure variables from the global namespace of the process in which a
  function from a dynamic module gets unpickled are not overriden if the
  function carries some global variables with it fails because: removed dynamic
  module support
* present: TBD (no dynamic module pickling yet)

### ``test_is_dynamic_module``
* goal: make sure cloudpickle spots dynamic module correctly
* present: most probably yes (to differentiate between dynamic and static
  modules, even if we do not serialize dynamic modules)


## TEST WITH SPECIFIC, ISOLATED FUNCTIONALITIES

### ``test_builtin_type__new__``
* goal: test pickling of builtin type constructors
* present: no because for now we do not ``builtin_function_or_method`` types
  to ``save_global``

### ``test_dynamic_pytest_module``
* goal: TBD
* present: TBD

### ``test_namedtuple``
* goal: test pickling of namedtuples
* present: no namedtuple support

### ``test_tornado_coroutine``

* goal: test ``pickle_depickling`` a locally defined coroutine function
* present: TBD

### ``test_EllipsisType``

* goal: pickle-depickle type(Ellipsis)
* present: TBD

### ``test_ufunc``

* goal: self explaining
* present: probably not in this form at least

### ``test_NotImplemente``

* goal: pickle NotImplemented
* present: not in this PR

### ``test_NotImplementedType``

* goal: pickle NotImplementedType
* present: not in this PR

### ``test_itemgetter``

* goal: pickle operator.itemgetter
* present: not in this PR

### ``test_attrgette``

* goal: pickle operator.attrgetter
* present: not in this PR


### ``test_buffer``
* goal: pickle a buffer
* present: no (skipped under python3 on cloudpickle)

### ``test_logger``
* goal: pickle a logger instance
* present: not in this PR

## RETRO-COMPATIBILITY TESTS

### ``test_function_pickle_compat_0_4_1``

* goal: make sure cloudpickle can depickle pickle strings from 0.4.1 (Python
  2.7)
* present: no

### ``test_function_pickle_compat_0_4_0``
* goal: make sure cloudpickle can depickle pickle strings from 0.4.0 (Python
  2.7)
* present: no


## OTHER TESTS

### ``test_correct_globals_import``
* goal: checks that non-used globals are not part of the pickle string of a function
* present: soon


### ``test_import``

* goal: according to the doc, like ``test_multiprocess`` except subpackage
  modules referenced directly
* present: yes

### ``test_nested_lambda``

* goal: checks ``pickle_depickle`` on a lambda calling another lambda, both
  defined in a local scope
* present: yes

### ``test_wraps_preserves_function_[annotations, doc, name]``

* goal: test that decorating a function using functools.wraps and the
  ``pickle_depickling`` it preserves function [annotation, doc, name]
* present: yes


### ``test_multiprocess``
* goal: define a function (in this case, in a local scope) pickle it and run
it in another process
* present: yes

## file saving tests

### ``test_closed_file``
* goal: TBD
* present: not in this PR
[re
test_empty_file:
    goal:
    fails because: removed file saving functionality
    keep: not for now
    status: REMOVED
    commit last touched:
test_pickling_special_file_handles:
    goal:
    fails because: removed file saving functionality
    keep: not for now
    status: REMOVED
    commit last touched:
test_plus_mode:
    goal:
    fails because: removed file saving functionality
    keep: not for now
    status: REMOVED
    commit last touched:
test_r_mode:
    goal:
    fails because: removed file saving functionality
    keep: not for now
    status: REMOVED
    commit last touched:
test_seek:
    goal:
    fails because: removed file saving functionality
    keep: not for now
    status: REMOVED
    commit last touched:
test_w_mode:
    goal:
    fails because: removed file saving functionality
    keep: not for now
    status: REMOVED
    commit last touched:

test_pickling_file_handles
    goal:
    fails because: removed file saving functionality
    keep: not for now
    status: REMOVED
    commit last touched:

########################################################################################
#                                   BROKEN TESTS                                       #
########################################################################################

test_dynamically_generated_class_that_uses_super:
    goal: test pickling_depickling of a subclass that uses super in some of its methods
    fails because: pickles a nested function with non-none closure
    keep: yes. execute this test in the main and not in a local scope.
    status: BROKEN
    commit last touched:

test_memoryview
    goal: pickling a memoryview
    fails because: dropped memoryview pickling functionality
    keep: not for now (additional feature)
    status: REMOVED
    commit last touched:

test_sliced_and_non_contiguous_memoryview
    goal: test pickling_depickling of a subclass that uses super in some of its methods
    fails because: pickles a nested function with non-none closure
    keep: yes. execute this test in the main and not in a local scope.
    status: REMOVED
    commit last touched:

test_large_memoryview
    goal: test pickling_depickling of a subclass that uses super in some of its methods
    fails because: pickles a nested function with non-none closure
    keep: yes. execute this test in the main and not in a local scope.
    status: REMOVED
    commit last touched:

########################################################################################
#                      TEST MODIFIED TO BE RUN IN __MAIN__ MODULE                      #
########################################################################################
test_generator
test_partial
test_method_descriptors
test_itertools_count
test_unhashable function

