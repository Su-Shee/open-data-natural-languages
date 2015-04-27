#!/bin/sh -

echo "Checking for Perl stuff...";

if ! perl -MIO::All -e '' >/dev/null 2>&1; then
    echo "You are missing the Perl module IO::All.";
fi

if perl -c automated-summary.pl; then
  echo "The script automated-summary.pl looks good!";
else
  echo "The script automated-summary.pl failed syntax check!";
fi

echo "Checking for R...";

# R library sqldf
if ! echo 'library("wordcloud")' | R --slave >/dev/null 2>&1; then
  echo "You are missing the R module wordcloud.";
fi

# R library tm
if ! echo 'library("tm")' | R --slave >/dev/null 2>&1; then
  echo "You are missing the R module tm.";
fi

echo "Testing some R plots...";

# run R visualizations...
for script in *.R; do
  R --slave < $script >/dev/null
  rm -f *.pdf
  rm -f *.png
done;

echo "Checking for Python...";

# Python module csv - should come with Python!
if ! python -c 'import nltk' >/dev/null 2>&1; then
    echo "You are missing the Python NLTK framework.";
fi

if python -m py_compile estimate-gender.py; then
  echo "The script estimate-gender.py looks good!";
else
  echo "The script automated-summary.pl failed syntax check!";
fi

rm -f *.pyc

echo "We're done!";
