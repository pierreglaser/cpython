import pickle
import _pickle


def f(x):
    return x**2


pickle_string = _pickle.dumps(f)
print(pickle_string)
g = pickle._loads(pickle_string)
print(f'f(2): {f(2)}')
print(f'g(2): {g(2)}')
