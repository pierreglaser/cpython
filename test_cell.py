import pickle

def  f():
    """returns a function with  a non-None closure"""
    a = 1
    def g():
        return a
    return g

g = f()
g.g = g
pickle_string = pickle.dumps(f())

del f
del g

repickled_g = pickle.loads(pickle_string)
print(f'repickled func:{repickled_g}')
print(f'calling the repickled function gives:{repickled_g()}')
