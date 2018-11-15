import unittest
from test import support
import textwrap

from test.mypickle_test_utils import subprocess_pickle_echo
from test.mypickle_test_utils import assert_run_python_script


class DynamicFunctionTest(unittest.TestCase):
    protocol = 4

    def test_dummy(self):
        assert True

    def test_subprocess_pickle_echo(self):
        a = subprocess_pickle_echo(1)
        assert a == 1, a

    # def test_lambda(self):
    #     self.assertEqual(pickle_depickle(lambda: 1)(), 1)

    def test_interactively_defined_function(self):
        # Check that callables defined in the __main__ module of a Python
        # script (or jupyter kernel) can be pickled / unpickled / executed.
        code = """\
        from test.test_mypickle import subprocess_pickle_echo

        CONSTANT = 42

        class Foo(object):

            def method(self, x):
                return x

        foo = Foo()

        def f0(x):
            return x ** 2

        def f1():
            return Foo

        def f2(x):
            return Foo().method(x)

        def f3():
            return Foo().method(CONSTANT)

        def f4(x):
            return foo.method(x)

        # cloned = subprocess_pickle_echo(lambda x: x**2, protocol={protocol})
        # assert cloned(3) == 9

        cloned = subprocess_pickle_echo(f0, protocol={protocol})
        assert cloned(3) == 9

        # cloned = subprocess_pickle_echo(Foo, protocol={protocol})
        # assert cloned().method(2) == Foo().method(2)

        # cloned = subprocess_pickle_echo(Foo(), protocol={protocol})
        # assert cloned.method(2) == Foo().method(2)

        # cloned = subprocess_pickle_echo(f1, protocol={protocol})
        # assert cloned()().method('a') == f1()().method('a')

        # cloned = subprocess_pickle_echo(f2, protocol={protocol})
        # assert cloned(2) == f2(2)

        # cloned = subprocess_pickle_echo(f3, protocol={protocol})
        # assert cloned() == f3()

        # cloned = subprocess_pickle_echo(f4, protocol={protocol})
        # assert cloned(2) == f4(2)
        """.format(protocol=self.protocol)
        assert_run_python_script(textwrap.dedent(code))


def test_main():
    support.run_unittest(__name__)


if __name__ == "__main__":
    test_main()
