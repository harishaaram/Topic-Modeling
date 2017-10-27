#Install and load library
# update.packages(ask = FALSE)
# install.packages("NLP", dependencies=TRUE)
# install.packages("slam", dependencies=TRUE)
# install.packages("tm", dependencies=TRUE) # for text mining
# install.package("SnowballC", dependencies=TRUE) # for text stemming
# install.packages("wordcloud", dependencies=TRUE)# word-cloud generator
# install.packages("RColorBrewer", dependencies=TRUE) # color palettes
# install.packages('lda', dependencies=TRUE)
# install.packages('modeltools', dependencies=TRUE)
# install.packages('stats4', dependencies=TRUE)
# # install.packages('methods', dependencies=TRUE)
# install.packages('toppicmodels', dependencies=TRUE)
# install.packages('ggplot2', dependencies = TRUE)
# install.packages("NbClust", dependencies = TRUE)
# install.packages("factoextra", dependencies = TRUE)

cat('\014')
library(NLP)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(ggplot2)
library(factoextra)
# library(cluster)
library(NbClust)
# library(fpc)

## BUILDING CORPUS
#TODO:Change years - i am doing it for 2006
for(i in 2000:2006){
  print(i)
  folder_i <-paste("/home/harish/PycharmProjects/Topic-Modeling/Data Extraction/dataset/", i, sep="");
  # print(folder_i)
  # summary(folder_i)
  corpus_name <- paste("corpus_Year", i, sep="_");
  # print(corpus_name)
  corpus_name <- Corpus(DirSource(folder_i, recursive=TRUE),readerControl = list(reader=readPlain));#creating corpus for each year eg: corpus_year_2002
  
  #---------------Data preprocessing:
  # print("dimension before:");
  # print(DocumentTermMatrix(corpus_name));
  corpus_name<-tm_map(corpus_name,removePunctuation);
  corpus_name<-tm_map(corpus_name,removeNumbers);
  
  words_to_remove_in_article<-c("Federal Reserve System", "Federal Open Market Committee", "meeting", "FOMC", "\r","\t","Present", "\n", 'year') #irrevalant words
  corpus_name<-tm_map(corpus_name, removeWords,words_to_remove_in_article); #removing irrevalant words in the article
  
  corpus_name<-tm_map(corpus_name,removeWords,stopwords("english"));
  
  corpus_name<-tm_map(corpus_name, content_transformer(tolower));
  
  corpus_name<-tm_map(corpus_name, stemDocument, language="english");
  corpus_name<-tm_map(corpus_name,stripWhitespace);
  # print("dimension after:");
  # print(DocumentTermMatrix(corpus_name));
  
  #----------------------Text Analysis------
  
  ##build tdm/dtm matrix
  tdm <- TermDocumentMatrix(corpus_name,control=list(wordLengths=c(4,Inf),bounds = list(global = c(2,8))))
  tdm_matrix <- as.matrix(tdm)
  dim(tdm_matrix)
  ##build a document/term matrix... words must have length 4
  dtm <- DocumentTermMatrix(corpus_name,control=list(wordLengths=c(4,Inf),bounds = list(global = c(2,8))))
  dtm_matrix <- as.matrix(dtm)
  print(dim(dtm_matrix))
  
  # pruning by frequency
  m <- as.matrix(tdm)
  v <- sort(rowSums(m), decreasing=TRUE)
  d <- data.frame(word = names(v),freq=v)
  print(head(d, 10))
  print(findFreqTerms(dtm,lowfreq = 10))
  
  #-------------Frequencies--------
  #bar plot:
  saveFileAs<- paste("wordFreq_barplot", i, sep="_")
  setwd('/home/harish/PycharmProjects/Topic-Modeling/pictures')
  png(filename = saveFileAs)
  barplot(d[1:20,]$freq, las = 2, names.arg = d[1:20,]$word,
          col ="lightblue", main ="Most frequent words",
          ylab = "Word frequencies")
  dev.off()
  
  #wordcloud
  dtms <- removeSparseTerms(dtm, 0.93)
  freq=v
  #create sort order (descending)
  ord <- order(freq,decreasing=TRUE)
  #inspect most frequently occurring terms
  freq[head(ord)]
  #making wordcloud
  length(freq)
  
  saveFileAs<- paste("wordcloud", i, sep="_")
  png(filename = saveFileAs)
  wordcloud(names(v), v, max.words=100, rot.per=0.15, random.order=F,colors=brewer.pal(8, "Dark2"))
  dev.off()
  
  #Terminverse and inverse document frequency
  dtm_tfxidf2<- weightTfIdf(dtms)
  # Normalization
  norm_eucl <- function(dtm_tfxidf2) dtm_tfxidf2/apply(dtm_tfxidf2, MARGIN=1, FUN=function(dtm_tfxidf2)
  sum(dtm_tfxidf2^2)^.5)
  
}
