import os
import os.path as op
from distutils.sysconfig import get_python_lib

filename = op.join(get_python_lib(), 'coverage_subprocess.pth')
os.unlink(filename)
