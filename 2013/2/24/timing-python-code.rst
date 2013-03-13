public: yes
tags: [python, performance]
pub_date: 2013-02-24
summary: |
  Using decorators to time and optimise the performance of python code.

Timing Python Code
==================

This post outlines why timing code in Python is important and provides some simple decorators that can help you time your code without the concerns and worries of peppering your lovely clean code with temporary timing and print statements.

Scroll down if your just after the decortor code to time functions....

Python vs Speed
---------------

One of things Python was orignally critisied for was speed. Like lots of Dynamic Lanaguages there is an overhead in keeping tracking of types and because code is interpreted at runtime instead of being compiled to native code at compile time dynmaic langauges like Python will always be a little slower.

Where Python shines is in it's power and ability to allow progrmaers to opmtimise and focus on the algorthim. Focusing on the complextity of the problem and the algorithms order of magnitidue rather than the low level detials of memory management, pointers etc can often have massive benefits. Ask any computer science student and they can list of nermerous teachings that show alogrithm and data strucute design will beat brute force compuatation power.

If your looking to build something where microsecounds count then I'd turn to C or Java. `PyPy <http://pypy.org/>`_ and other sophiticated JIT (Just in Time) compliers can help and they seam to be the future for Pytohn solutions in this space. Another aterntative is to find the slow code and either optimise that function or write a C plugin for Python for your very specific task. This last approach seams very popular in the finaince industry where milliseconds mean dollars but they still need the felxiablity and speed of devlelopment benefits that come with a dynamic lanaguage.

More often than not slow code just needs some refactoring work, a new support data strucutre or a change in the complexity of processing. So the challenge is really not how can I speed up my code but what code needs my attention.

Finding Slow Code
-----------------

In order to find slow Python code we're going to have to time stuff. We don't want to cover our lovely clean code with temporary timing code and print statements, so how can we:

    - Time code without alteringing the code of a function
    - Get detailed timing information if the function is run with different arguments
    - Switch off the timing at deploy time to reduce the overhead and improve the performance of monitoring

The timing decoriatros below can help with all of these. If your new to decorators and annotations see my previous blog `post on the subject <http://blog.mattalcock.com/2013/1/5/decorates-and-annotations/>`_


The Timeit Decorator
--------------------

.. sourcecode:: python
    
    import time                                                

    def timeit(f):

        def timed(*args, **kw):
            ts = time.time()
            result = f(*args, **kw)
            te = time.time()

            print 'func:%r args:[%r, %r] took: %2.4f sec' % \
              (f.__name__, args, kw, te-ts)
            return result

        return timed


Using the decorator is easy either use annotations.

.. sourcecode:: python

    @timeit
    def compute_magic(n):
        #function definition
        ....


Or realias the function you want to time.

.. sourcecode:: python

    compute_magic = timeit(compute_magic)


Sometimes you'll want to remove the code timing. You can either do this by remvoing the timeit annotations before deployment or you can you a configuration switch to enable the decorator to wrap the function in timing code.

.. sourcecode:: python

    import time    

    #from config import TIME_FUCNTIONS
    TIME_FUCNTIONS = False                                            

    def timeit(f):
        if not TIME_FUCNTIONS: 
            return f
        else:
            def timed(*args, **kw):
                ts = time.time()
                result = f(*args, **kw)
                te = time.time()

                print 'func:%r args:[%r, %r] took: %2.4f sec' % \
                    (f.__name__, args, kw, te-ts)
                return result

            return timed

By simpley changing the TIME_FUNCTIONS configuration swtich the functions will not decorated. I find having these swtiches in a common config file/folder often helps.

All this code and the majorty of code from my posts can be found in the hack repo of my github account. Please take a look `here <https://github.com/mattalcock/hacks>`_ . I hope it's helped if there are any questions about the above or you'd like to understand more about timing code in Python drop me a mail.

Matt


