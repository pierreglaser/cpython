import pickle
import itertools


def my_function():
    pass


my_function.some_builtin_attribute = itertools.chain.from_iterable

pickle_string = pickle.dumps(my_function)

del my_function

my_depickled_function = pickle.loads(pickle_string)
