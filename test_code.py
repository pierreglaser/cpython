#!/home/pierreglaser/dev_python/bin/python3.8
# -*- coding: utf-8 -*-
import pickle
import types

def f():
    pass


print(pickle.dumps(f.__code__))
print(pickle.loads(pickle.dumps(f.__code__)))
