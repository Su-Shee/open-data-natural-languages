#!/usr/bin/env perl

use strict;
use warnings;

use feature 'say';

use IO::All;

my $file = $ARGV[0];
my $text < io $file;     

# keep punctuation on the sentences
my @sentences = split(/(?<=[.?!])/, $text);

my %scores;
my @scores;

foreach my $sentence (@sentences) {

  my @words = split(/ /, $sentence);
  
  # count how many times a word occurs in sentence
  my %term_frequency;
  $_++ for @term_frequency{ @words };

  # go over all words
  my $salience;
  for my $term (keys %term_frequency) {
    
    # word count per sentence = "term frequency" - sentence is "the document"
    my $tf = $term_frequency{$term};

    # in how many sentences does the word/term occur? "document frequency"
    my $df = grep { /\Q$term\E/ } @sentences;

    # "inverse document frequency = log(number of docs / document frequency) -
    # results in low weight of stop words etc, emphasizes central terms indicating
    # the real, main topic of a text
    my $idf = log(scalar @sentences/$df) unless $df == 0;

    # "term frequency - inverse document frequency" = term frequency * inverse
    # document frequency
    my $tfidf = $tf * $idf;
    
    # weight/salience of sentence: add tfidfs
    $salience += $tfidf;
  }
  
  # save per sentence scores
  push @scores, sprintf("%.3f", $salience);
  $scores{$sentence} = sprintf("%.3f", $salience);
}

# sort by weight and output e.g. the 7 "most important" sentences
my @by_score = sort { $b <=> $a } @scores;
my @top7     = @by_score[0..6];

for my $sentence (@sentences) {
  for my $score (@top7) {
    say $sentence if $scores{$sentence} == $score;
  }
}

