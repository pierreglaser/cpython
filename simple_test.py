import pickle


def f():
    return 1


print(pickle.dumps(f.__code__))
