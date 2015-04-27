library("tm")
library("wordcloud")

# read files from a directory as the corpus to work on
corpus <- Corpus(DirSource('./textfiles/'), 
            readerControl = list (reader = readPlain, language = "de"))

# apply a couple of cleanup functions ("dass" doesn't seem to be a stopword!)
corpus <- tm_map(corpus, removeWords, stopwords("german"))
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removePunctuation)

# generate the term matrix (it's a simple table of word count-per-document)
termmatrix <-TermDocumentMatrix(corpus, control = list(stopwords = TRUE))

# if we'd need to collect the most frequently used words... (wordcloud does that for us)
mostfreq   <- findFreqTerms(termmatrix, lowfreq = 5)

# remap it as one wordcount matrix
tmatrix <- as.matrix(termmatrix)

# sort the wordcount
wordcount <- sort(rowSums(tmatrix), decreasing = TRUE)

# extract the words itself
words     <- names(wordcount)

# create the usal data frame visualizations in R require
df <- data.frame(word = words, freq = wordcount)

# display word cloud
wordcloud(df$word, df$freq, min.freq = 7)
