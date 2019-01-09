import sys
import xml
import xml.etree
import _pickle as pickle


def f():
    return xml.etree.__name__

# def g():
#     return xml

f()
# g()

f_pickle_string = pickle.dumps(f)
# g_pickle_string = pickle.dumps(g)

del xml.etree
del xml

sys.modules.pop('xml.etree')
sys.modules.pop('xml')

# repickled_g = pickle.loads(g_pickle_string, allow_dynamic_objects=True)
# repickled_g()

repickled_f = pickle.loads(f_pickle_string, allow_dynamic_objects=True)
repickled_f()

