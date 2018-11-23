import faulthandler
import sys
import unittest
from io import BytesIO

import _pickle as pickle

import cloudpickle

global_variable = 1
another_global_variable = 2
faulthandler.enable()


def f():
    local_variable = 2
    return global_variable + local_variable


def function_with_nested_func():
    f()
    return another_global_variable


class CloudPickleTest(unittest.TestCase):
    def setUp(self):
        fileobj = BytesIO()
        self.pickler = pickle.Pickler(fileobj)
        self.cloudpickler = cloudpickle.CloudPickler(fileobj)

    def test_walk_global_ops(self):
        cloudpickle_global_ops = self.cloudpickler.extract_func_data(f)
        pickle_global_op = self.pickler.extract_func_data(f)
        assert cloudpickle_global_ops == pickle_global_op, pickle_global_op

    def test_walk_global_ops_with_nested_func(self):
        cloudpickle_global_ops = self.cloudpickler.extract_func_data(
                    function_with_nested_func)
        pickle_global_op = self.pickler.extract_func_data(
                    function_with_nested_func)
        assert cloudpickle_global_ops == pickle_global_op

    def test_save_function_tuple(self):
        # this does not test anything for now though
        state = pickle.save_function_tuple(f)
        # __import__('ipdb').set_trace()
        # closure_values = state['closure_values']
        # base_globals = state['base_globals']
        # val = len(closure_values) if closure_values is not None else -1
        # skel_func = pickle.make_skel_func(
        #     state['code'],
        #     val,
        #     base_globals
        # )
        # # __import__('ipdb').set_trace()

        # # save the rest of the func data needed by _fill_function
        # if hasattr(f, '__annotations__') and sys.version_info >= (3, 7):
        #     state['annotations'] = f.__annotations__
        # if hasattr(f, '__qualname__'):
        #     state['qualname'] = f.__qualname__

        # repickled_function = pickle._fill_function(tuple([skel_func, state]))
        assert repickled_function() == f()


if __name__ == "__main__":
    unittest.main()
