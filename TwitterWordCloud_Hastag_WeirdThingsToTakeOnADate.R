install.packages("tm") ; install.packages("httpuv")
install.packages('base64enc') ; install.packages("twitteR")
install.packages("wordcloud")
install.packages("RColorBrewer") ; install.packages("tm")
install.packages("stringr")

consumer_key <- "j4PL61FDK3iDaOTtNHbsM2Oqm"
consumer_secret <- "ftTkXBi5OmN2SH36jsgQ0zBwS1ZO6E0r5SKlW5SsozXLIp3Kw9"
access_token <- "1004636173-PrTNoX33kZLU74kACn02XNxlefyqcDlRBkTG9hg"
access_secret <- "HZ4ym0BTbGyNCtcRE4KGdVXEk8uVUzYNCKBPYoYuBpF0u"

setup_twitter_oauth(consumer_key = consumer_key, consumer_secret = consumer_secret, access_token = access_token, access_secret = access_secret)
dtsc <- searchTwitter("#WeirdThingsToTakeOnDates",n=2000, lang = "en")

dtsc_text <- sapply(dtsc, function(x) x$getText())
dtsc_text <- gsub("(f|h)tp(s?)://(.*)[.][a-z+]+", "", dtsc_text)
dtsc_text <- gsub("(f|h)tps(s?)://(.*)[.][a-z+]+", "", dtsc_text)
dtsc_text <- gsub("https","", dtsc_text)
dtsc_text <- str_replace_all(dtsc_text,"[^a-zA-Z\\s]", " ")

#Using tm package we transform it to corpus, continue cleaning and then break down the words using the stopword "PresidentialDebate"
dtsc_corpus <- Corpus(VectorSource(dtsc_text))
dtsc_corpus <- tm_map(dtsc_corpus,PlainTextDocument)
tdm <- TermDocumentMatrix(
  dtsc_corpus,
  control = list(
    stopwords = c("WeirdThingsToTakeOnDates", stopwords("english")))
  )
#Count the frequencies of the words, sort it and create a data frame with them
m <- as.matrix(tdm)
word_freqs <- sort(rowSums(m), decreasing = TRUE)
word_freqs<-word_freqs
dm <- data.frame(word = names(word_freqs), freq = word_freqs)

#Using the wordcloud package, we visualize our results
wordcloud(dm$word, dm$freq, random.order = FALSE, scale = c(4, .5), colors = brewer.pal(8, "Dark2"))
