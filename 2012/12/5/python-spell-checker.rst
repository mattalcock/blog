public: yes
tags: [Thoughts]
pub_date: 2012-12-05
summary: |
  How to use Python and some powerful statistics to create a very lightweight but effective Google style spell checker.

Did you mean 'python spell checker'?
====================================

How to use Python and some powerful statistics to create a very lightweight but effective Google style spell checker.


Peter Norvig outlines how Google’s ‘did you mean’ spelling corrector uses probability theory, large training sets and some elegant statistical language processing to be so effective.  Type in a search like [speling] and Google comes back in 0.1 seconds or so with Did you mean: spelling. Here is a toy spelling corrector in python that achieves 80 to 90% accuracy and is very fast. (see  code below)

The big.txt file that is referenced here consists of about a million words. The file is a concatenation of several public domain books from Project Gutenberg and lists of most frequent words from Wiktionary and the British National Corpus. It uses a simple training method of just counting the occurrences of each word in the big text file. Obviously Google has a lot more data to seed this spelling checker with but I was suprised at how effective this relatively small seed was.

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

See more details, test results and further work at Peter Novig’s site. http://norvig.com/spell-correct.html


