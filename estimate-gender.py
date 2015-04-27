#!/usr/bin/env python
# -*- coding: utf-8 -*- 

from __future__ import division
import sys
import re
import nltk

fh = open(sys.argv[1], 'r')
rawtext = fh.read()

# based on several papers analysing the differences of male and female writers
# in English, we try to apply those rules to German - the quick and dirty way. :)

# supposedly, women use a certain range of pronouns more often than men
f_pronouns  = ['ich', 'du', 'sie', 'ihr']

# on the other hand, men refer more often to he/him/his
m_pronouns  = ['er', 'sein', 'wir', 'denen']

# men use more negatives
negatives   = ['nicht', 'kein', 'non']

# men use more "determiners"
determiners = ['ein', 'manch', 'jed', 'jen', 'dies', 'kein', 'einig']

# let's also check who uses more (weak) adjectives in German
adjectives  = ['bar', 'haft', 'ig', 'isch', 'lich', 'los', 'sam']

# the use of numerals is supposedly also a male identifier
numerals    = ['zwei', 'drei', 'vier', 'fünf', 'sechs', 'sieben', 'acht', 'neun', 'zehn']

# other indicators for male writers are the use of quanitifers
# other indicators for a female writer is the use of present tense

# we simply go over every word list and count the matches
def count_words (wordlist, expr):
  count = {}
  for word in wordlist:
    regex = re.compile(expr % word, re.I)
    occurences = len(re.findall(regex, rawtext))
    count[word] = occurences
  return count

# calculating the percentage of occurences
def calc_percent (values):
  word_count = len(nltk.word_tokenize(rawtext))
  return "%.3f" % (100 * (sum(values) / word_count))

stats = {}

# yes, it seems in German, female writers use more of these pronouns
f_count = count_words(f_pronouns, '%s')
stats['female pronouns'] = calc_percent(f_count.values())

# yes, it seems in German, male writers use a little more of the male-indicating pronouns
m_count = count_words(m_pronouns, ' ?%s[e]?[rmsn]?')
stats['male pronouns'] = calc_percent(m_count.values())

# no, in my German example texts, men don't use more determiners - women do
d_count = count_words(determiners, '%s[e]?[srmn]?')
stats['determiners'] = calc_percent(d_count.values())

# no, in my German example texts, men don't use more negatives - women do
n_count = count_words(negatives, '%s[e]?[srmn-]?')
stats['negatives'] = calc_percent(n_count.values())

# a quick check on a certain range of adjectives shows women use more of them
a_count = count_words(adjectives, '[a-züöä]+?%s')
stats['adjectives'] = calc_percent(a_count.values())

# in German, it seems men are using a little more numerals than women
num_count = count_words(numerals, '%s')
stats['numerals'] = calc_percent(num_count.values())

print stats
