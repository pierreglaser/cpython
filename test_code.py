import pickle

def f():
    pass


print(pickle.dumps(f.__code__))
print(pickle.loads(pickle.dumps(f.__code__)))
