import unittest
from io import BytesIO

import _pickle as pickle

import cloudpickle

global_variable = 1
another_global_variable = 2


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


if __name__ == "__main__":
    unittest.main()
