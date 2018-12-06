#!/home/pierreglaser/c_pickle_python/bin/python3.8
# -*- coding: utf-8 -*-
import pickle
import pickletools
import types

def f():
    pass


def g():
    a = 1

    def h():
        return a
    return h


print(pickle.dumps(f.__code__))
print(pickle.loads(pickle.dumps(f.__code__)))

print(pickle.dumps(types.FunctionType))
print(pickle.loads(pickle.dumps(types.FunctionType)))

closure_func = g()

print(g.__code__.co_cellvars)
print(g.__code__.co_freevars)
# print(pickletools.dis(pickle.dumps(g.__code__)))
u = pickle.loads(pickle.dumps(g.__code__))
print(u.co_cellvars)
print(u.co_freevars)
