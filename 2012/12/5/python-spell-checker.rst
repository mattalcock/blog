public: yes
tags: [python, probability, statistics, bayes]
pub_date: 2012-12-05
summary: |
  How to use Python and some powerful statistics to create a very lightweight but effective Google style spell checker.

Did you mean 'python spell checker'?
====================================

Have you ever been really impressed with Googles 'Did you mean....' spell checker? 
Have you ever just typed something into google to help you with your spelling? 

My answer to the above questions above would be Yes, all the time!

In a fantastic post I read some years ago Peter Norvig outlined how Google’s ‘did you mean’ spelling corrector uses probability theory, large training sets and some elegant statistical language processing to be so effective.  Type in a search like 'speling' and Google comes back in 0.1 seconds or so with Did you mean: 'spelling'. Below is a toy spelling corrector in python that achieves 80 to 90% accuracy and is very fast. It's written in a fanstically impressive 21 lines of code. It uses list comprehensions, and some of my favorite data structures (sets and default dictionaries).

The code and supporting data files can be found in my hacks public repo under the spellcheck folder. 

The data seed comes from a big.txt file that consists of about a million words. The file is a concatenation of several public domain books from Project Gutenberg and lists of most frequent words from Wiktionary and the British National Corpus. It uses a simple training method of just counting the occurrences of each word in the big text file. Obviously Google has a lot more data to seed this spelling checker with but I was suprised at how effective this relatively small seed was.

.. sourcecode:: python

    import re, collections

    def words(text):
        return re.findall('[a-z]+', text.lower())

    def train(features):
        model = collections.defaultdict(lambda: 1)
        for f in features:
            model[f] += 1
        return model

    NWORDS = train(words(file('big.txt').read()))
    alphabet = 'abcdefghijklmnopqrstuvwxyz'

    def edits1(word):
        s = [(word[:i], word[i:]) for i in range(len(word) + 1)]
        deletes    = [a + b[1:] for a, b in s if b]
        transposes = [a + b[1] + b[0] + b[2:] for a, b in s if len(b)>1]
        replaces   = [a + c + b[1:] for a, b in s for c in alphabet if b]
        inserts    = [a + c + b     for a, b in s for c in alphabet]
        return set(deletes + transposes + replaces + inserts)

    def known_edits2(word):
        return set(e2 for e1 in edits1(word) for e2 in edits1(e1) if e2 in NWORDS)

    def known(words): 
        return set(w for w in words if w in NWORDS)

    def correct(word):
        candidates = known([word]) or known(edits1(word)) or    known_edits2(word) or [word]
        return max(candidates, key=NWORDS.get)


If your new to python some of the above code my look complicated and hard to follow. Although dense I love Peter's use of list comprehensions and generators. The use of nested function composits is also very efficient and I've noticed a massive speed up in using such approaches when injesting or processing large data files. 

An exmaple of nested function composition is:

.. sourcecode:: python

    NWORDS = train(words(file('big.txt').read()))

An example of complex list comprehension is:

.. sourcecode:: python

    [a + c + b[1:] for a, b in s for c in alphabet if b]

The final thing I really like in this code snippet is the overriding of the key function when max is called in the 'correct' function. This is a great way to find the word with the highest value in a dictionaty of word->count mappings.

.. sourcecode:: python

    return max(candidates, key=NWORDS.get)

The code is simple and elegant and basically generates a set of candidates words based on the partial or badly spelt word (aka the original word). The most often used word from the candiates is chosen. Peter expalins how Bayes Theorem is used to select the best correction given the original word.

See more details, test results and further work at Peter Novig’s `site <http://norvig.com/spell-correct.html>`_ .


