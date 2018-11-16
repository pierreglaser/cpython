import unittest
from io import BytesIO

import _pickle as pickle

import cloudpickle
from cloudpickle import _walk_global_ops, Pickler

global_variable = 1


def f():
    local_variable = 2
    return global_variable + local_variable


class CloudPickleTest(unittest.TestCase):
    def setUp(self):
        fileobj = BytesIO()
        self.pickler = pickle.Pickler(fileobj)

    def test_walk_global_ops(self):
        cloudpickle_global_ops = list(cloudpickle.CloudPickler.extract_code_globals(f.__code__))
        pickle_global_op = self.pickler.extract_func_data(f)
        assert cloudpickle_global_ops == pickle_global_op, pickle_global_op


if __name__ == "__main__":
    unittest.main()
