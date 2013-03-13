public: yes
tags: [python, introduction]
pub_date: 2013-01-05
summary: |
  An introduction into decorators and annotations in python and their simple power.

Decorators & Annotations
========================

I wanted to highlight the power of decorators and annotations in python and give the novice Python programmer some insight into how they can be used. If you've only been using Python for a short while then both of these will probably be new.

Decorators are a way of implementing the famous computer science decorator pattern. This pattern put in simple terms is a mechanism that allow you to inject or modify code in a function. In python you can have two different styles of decorator. The function defined style or the class defined style. I prefer the function style but I'll show you using a class structure as well.

The best way to explain their use is through a well known example. The below code shows how to functionally compute the Fibonacci numbers.

The Fibonacci sequence is : [0,1,1,2,3,5,8,13.....] where the nth number equalling the sum of n-1 and n-2.

An elegant way of computing this is using the below code:

.. sourcecode:: python

    def fib(n):
        if n<=0:
            return 0
        elif n==1:
            return 1
        else:
            return fib(n-2) + fib(n-1)

So fib(7) would return 13. As you can see from the code this uses recursion. The challenge with this approach for calculating the fib sequence is that the low 'tail' function calls will get called multiple times. Remvoing this overhead is called 'tail recursion elimination' or TRE. Python doesn't support this and `probably wont <http://neopythonic.blogspot.co.uk/2009/04/tail-recursion-elimination.html>`_ . Below shows how running the fib function for just a small n can result in a massive numbers of calls of the tail values.

.. sourcecode:: python 

    fib(7) = fib(6) + fib(5)
    fib(7) = fib(4) + fib(3) + fib(4) + fib(3)
    fib(7) = fib(3) + fib(2) + fib(2) + fib(1) + fib(3) + fib(2) + fib(2) + fib(1)
    .....
    fib(7) = fib(1) + fib(0) + fib(1) + fib(0) + .......... [All fib zeros and fib ones]

A way to make this faster is to use a technique called Memoize. This remembers the result of a function for a given argument, stores it and if called again uses the stored version rather than re calculating. This can speed up the above by many orders of magnitude.

The best way to implement this function calling memory is by decorating the function with some code that can modify the execution path to check a pre saved store first. Below is the memoize decorator as a function.

.. sourcecode:: python

    def memoize(f):
        cache= {}
        def memf(*args, **kw):
            key = (args, tuple(sorted(kw.items())))
            if key not in cache:
                cache[key] = f(*args, **kw)
            return cache[key]
        return memf

The memoize decorator above takes a function as an argument. It then creates a new function that stores the results of the function into a cash. The decorator then returns the new function that contains the original function call.
We can then use some cleaver dynamic language tricks to re alias the fib function to the decorated version.

.. sourcecode:: python

    fib = memoize(fib)

Calling fib after this aliased decoration we can ensure that the decorated function will run instead of the basic fib function
.
I hope that explains how decorators work in python and gives you an example of use. So what are annotations?

Annotations allow us to use decorators all over our code and are actually syntactic sugar (the same thing) as the above aliased line. Rather than re-aliasing fib to the decorated fib we can use annotations at the point of writing the fib function definition.

An annotated fib function would look like this. Note the simple use of @ and the decorator name above the definition.

.. sourcecode:: python

    @memoize
    def fib(n):
        if n<=0:
            return 0
        elif n==1:
            return 1
        else:
            return fib(n-2) + fib(n-1)

Simple hey! So annotations are just stylish and helpful ways to decorate functions at the place of definition. This really helps when your sharing code and working as a small team because you don't have to look all over the code to see if the function has been re-aliased and decorated it's right above the definition.

Once of the best uses of this type of decoration using annotations is to log the performance of a function or to perform some detailed profiling. You only need write a single decorator to modify and wrap any function and then you just sprinkle the decorator around your code as annotations depending on what functions you want to time/profile or investigate in detail.

As I mentioned before there is also a class style to writing decorators, lets use our memoize decorator as an example.

Written as a class the decorator is:

.. sourcecode:: python

    class Memoize:

        def __init__(self, f):
            self.f = f
            self.cache = {}

        def __call__(self, *args, **kw):
            key = key = (args, tuple(sorted(kw.items())))
            if not key in self.cache:
                self.cache[key] = self.f(*args, **kw)
            return self.cache[key]

The class has to have to functions to operate as a decorator. __init__ and __call__. Some people find this easier to read and construct others prefer the function style. I think it really depends on how advanced the decorator is going to be.

The class style can then be applied in the exact same way as the above function style decorator.

.. sourcecode:: python

    fib = Memoize(fib)

    @Memoize
    def fib(n):
        if n<=0:
            return 0
       ...

I hope this has helped understand the basics of decorators and annotations. All of the decorator code listed above can be found in the hacks repo on my github account `here <https://github.com/mattalcock/hacks/tree/master/decorators>`_ 