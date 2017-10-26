#Install and load library
update.packages(ask = FALSE)
install.packages("NLP", dependencies=TRUE)
install.packages("slam", dependencies=TRUE)
install.packages("tm", dependencies=TRUE) # for text mining
install.package("SnowballC", dependencies=TRUE) # for text stemming
install.packages("wordcloud", dependencies=TRUE)# word-cloud generator
install.packages("RColorBrewer", dependencies=TRUE) # color palettes
install.packages('lda', dependencies=TRUE)
install.packages('modeltools', dependencies=TRUE)
install.packages('stats4', dependencies=TRUE)
# install.packages('methods', dependencies=TRUE)
install.packages('toppicmodels', dependencies=TRUE)
install.packages('ggplot2', dependencies = TRUE)

cat('\014')
library(NLP)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(ggplot2)
# library(factoextra)
# library(cluster)
# library(NbClust)
# library(fpc)

## BUILDING CORPUS
for(i in 1996:2007){
  # print(i)
  folder_i <-paste("/home/harish/PycharmProjects/Topic-Modeling/Data Extraction/dataset/", i, sep="");
  # print(folder_i)
  # summary(folder_i)
  corpus_name <- paste("corpus_Year", i, sep="_");
  # print(corpus_name)
  corpus_name <- Corpus(DirSource(folder_i, recursive=TRUE),readerControl = list(reader=readPlain));#creating corpus for each year eg: corpus_year_2002
  # data preprocessing:
  print("dimension before:");
  print(DocumentTermMatrix(corpus_name)); #https://stackoverflow.com/questions/32241806/how-to-print-text-and-variables-in-a-single-line-in-r
  corpus_name<-tm_map(corpus_name,removePunctuation);
  corpus_name<-tm_map(corpus_name,removeNumbers);
  
  words_to_remove_in_article<-c("Federal Reserve System", "Federal Open Market Committee", "meeting", "FOMC", "\r","\t","Present", "\n") #irrevalant words
  corpus_name<-tm_map(corpus_name, removeWords,words_to_remove_in_article); #removing irrevalant words in the article
  
  corpus_name<-tm_map(corpus_name,removeWords,stopwords("english"));
  
  corpus_name<-tm_map(corpus_name, content_transformer(tolower));
  
  corpus_name<-tm_map(corpus_name, stemDocument, language="english");
  corpus_name<-tm_map(corpus_name,stripWhitespace);
  print("dimension before:");
  print(DocumentTermMatrix(corpus_name));
}

# ANALYSIS:
#creating document term matrix:
# for(i in 1993:2007){
# corpus_name <- paste("corpus_Year", i, sep="_")
# dtm4<-DocumentTermMatrix(corpus_name,control=list(wordLengths=c(4,Inf)))
# matDTM<-as.matrix(dtm4)
# tfidf4<-weightTfIdf(dtm4)
# sparse4<-removeSparseTerms(tfidf4,0.995)
# s4<-as.matrix(sparse4); 
# dim(s4)
# }
