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

# install.packages("lda", dependencies = TRUE)
# install.packages("MASS", dependencies = TRUE)
# install.packages("topicmodels", dependencies = TRUE)
# install.packages("lsa", dependencies = TRUE)

#------------------------For Installing R in Jupyter NOTEBOOK----------------------
install.packages('devtools')
devtools::install_github('IRkernel/IRkernel')
# or devtools::install_local('IRkernel-master.tar.gz')
IRkernel::installspec()  # to register the kernel in the current R installation
#-------------------------------------------------------------------------------------------


cat('\014')
rm(list = ls())


library(NLP)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(ggplot2)
library(factoextra)
# library(cluster)
library(NbClust)
library(lsa)
# library(fpc)

#LDA

library(lda)
library(MASS)
library(topicmodels)

setwd("/home/harish/PycharmProjects/Topic-Modeling/")

## BUILDING CORPUS

folder <-"/home/harish/PycharmProjects/Topic-Modeling/Data Extraction/dataset/manual_93_2005"
print(folder)
# summary(folder_i)
corpus_name <- paste("corpus_Year", i, sep="_");
# print(corpus_name)
corpus_name <- Corpus(DirSource(folder_i, recursive=TRUE),readerControl = list(reader=readPlain));#creating corpus for each year eg: corpus_year_2002

#---------------Data preprocessing:
print("dimension before:");
print(DocumentTermMatrix(corpus_name));
corpus_name<-tm_map(corpus_name,PlainTextDocument);
corpus_name<-tm_map(corpus_name, content_transformer(tolower));
corpus_name<-tm_map(corpus_name,removeWords,stopwords("english"));
corpus_name<-tm_map(corpus_name,removePunctuation);
corpus_name<-tm_map(corpus_name,removeNumbers);
corpus_name<-tm_map(corpus_name,stripWhitespace);
words_to_remove_in_article<-c("system","reserve","rate", "continue", "open","committee", "federal", "also", "meeting", "FOMC", "\r","\t","Present", "\n", 'year') #irrevalant words
corpus_name<-tm_map(corpus_name, removeWords,words_to_remove_in_article); #removing irrevalant words in the article
corpus_name<-tm_map(corpus_name, stemDocument, language="english");

print("dimension after:");
print(DocumentTermMatrix(corpus_name));

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

##-----------------------------------------LDA---------------------------------- top 5 words per 2 topics
k= 2
ldaout <- LDA(dtms,k)

##docs by topics k
ldaout.topics <- as.matrix(topics(ldaout))

##top n terms
n = 9
ldaout.terms <- as.matrix(terms(ldaout,n))
ldaout.terms

##------------------------------------SVD for LSA------------------------------------





sing_v <- svd(dtm_matrix)
D<-diag(sing_v$d)
D
##find how many concepts to get 90%?
threshold <- sum(sing_v$d)*.9
threshold

#HOW DO YOU COME UP WITH THIS?
loopcount = 0
counter <- threshold
while (counter > 0) {
  loopcount <- loopcount + 1
  print(sing_v$d[loopcount])
  counter = counter - sing_v$d[loopcount]
}

D <- D[1:loopcount,1:loopcount] #NOW 6 scaling vectors are choosen

#REconstructing the matrix with only 90% of the relavant information for geting 90% concepts
concept90 <- sing_v$v[,1:loopcount] %*% D %*% t(sing_v$u[,1:loopcount])
dim(concept90)

##cluster
nb_orig <- NbClust(data = dtm_matrix,method="kmeans",min.nc = 2, max.nc = 6,index = "duda")
concept90_duda <- NbClust(data = concept90,method="kmeans",min.nc = 2,max.nc = 8, index = "duda")
kmeansconcept50 <- kmeans(concept90, centers = 2, iter.max = 50)


##concept90_matrix
fviz_nbclust(concept90, kmeans, method = "wss") +
  geom_vline(xintercept = 2, linetype = 2)+
  labs(subtitle = "Elbow method 6 concepts")
# Silhouette method
saveFileAs<- paste("Optimal Number of clusters", i, sep="_")
png(filename = saveFileAs)
fviz_nbclust(concept90, kmeans, method = "silhouette")+
  labs(subtitle = "Silhouette method 6 concepts")
dev.off()

##plot 2 concepts
num_cluster <- concept90_duda$Best.nc[1]
c2 <- kmeans(concept90,num_cluster)
png('optimalCluster_2000yr.png')
fviz_cluster(c2,data=concept90,geom = "point",stand = FALSE, ellipse.type = "norm",main= "kMeans k = 2")
dev.off()

# sing<-svd(dtm4)
# D<-diag(sing$d)
# diagD<-D[1:100,1:100]
# sing$u[,1:100] %*% diagD
# documentVector2<-sing$u[,1:100] %*% diagD
# wordVector2<-diagD %*% sing$v[1:100,]

sing<-svd(dtm_matrix)
documentVector<-sing$u[,1:6] %*% diag(sing$d)[1:6,1:6]#choosen 6 concepts ie 6 dimensions
wordVector<-diag(sing$d)[1:6,1:6] %*% sing$v[1:6,]

D <- diag(sing$d)[1:6, 1:6]
D

#tfidf:
tdm_tfidf <- weightTfIdf(dtm)
m <- as.matrix(tdmWithStemming_tfxidf2)
v <- sort(rowSums(m), decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
print(d)
#DVM
m <- as.matrix(documentVector)
rownames(m) <- 1:nrow(m)
norm_eucl<- function(m)m/apply(m,MARGIN=1, FUN=function(x)sum(x^2)^.5)
m_norm<-norm_eucl(m)
cl<-kmeans(m_norm,2)
table(cl$cluster)
png('DVM_CLUSTER6.png')
plot(prcomp(m_norm)$x, col=cl$cl)
dev.off()
print(cl$tot.withinss)
# #for sse
# cl$tot.withinss

#WVM
m <- as.matrix(wordVector)
rownames(m) <- 1:nrow(m)
norm_eucl<- function(m)m/apply(m,MARGIN=1, FUN=function(x)sum(x^2)^.5)
m_norm<-norm_eucl(m)
cl<-kmeans(m_norm,2)
table(cl$cluster)
png('WVM_6.png')
plot(prcomp(m_norm)$x, col=cl$cl)
dev.off()
print(cl$tot.withinss)


k=4
ldaGibbs5 <-LDA(dtms, k, method = "Gibbs") 
#docs to topics
#ldaGibbs5.topics <- as.matrix(topics(ldaGibbs5))
#ldaGibbs5@gamma

##return top words by concept

##first create function to return top words; require dtms
concept<-function(num){ 
  sv<-sort.list((svd(dtms))$v[,num],decreasing = FALSE)
  # print(sv)
  # print(dtms$dimnames)
  dm<-dtms$dimnames$Terms[head(sv,10)] 
  dm
}

##how many words?
num <- 5
i <- 1:num
sapply(i, concept)
# https://stackoverflow.com/questions/14875493/lda-with-topicmodels-how-can-i-see-which-topics-different-documents-belong-to
k=5
ldaGibbs5 <-LDA(dtms, k, method = "Gibbs") 
#docs to topics 
ldaGibbs5.topics <- as.matrix(topics(ldaGibbs5))
#get probability of each topic in each doc
topicProbabilities <- as.data.frame(ldaGibbs5@gamma)
topicProbabilities

vector <- NULL
for(i in 1:nrow(ldaGibbs5@gamma)) {
  vector <- c(vector, ldaGibbs5@gamma[i,])
}


Concepts <- rep(c("Concept 1","Concept 2","Concept 3", "Concept 4","Concept 5"),times=8)#why 80?
TimeByDocs <- as.numeric(rep(1:8,each=5))
chartdata <- data.frame(Concepts,TimeByDocs,vector)
ggplot(chartdata, aes(x=TimeByDocs,y=vector,fill=Concepts)) + geom_area()


#top words by topic
lda.terms <- as.matrix(terms(ldaGibbs5,5))
lda.terms

#----------------------------
lsatextmatrix <- textmatrix(mydir = folder_i, stemming = TRUE, language = "english", minWordLength = 4,
                            minDocFreq = 2, stopwords = words_to_remove_in_article, removeNumbers = TRUE)

folder_i <-"/home/harish/PycharmProjects/Topic-Modeling/Data Extraction/dataset/2007/out"

#build other dtm
lsatextmatrix2007 <- textmatrix(mydir = folder_i, vocabulary = rownames(lsatextmatrix))

#perform lsa
lsa2006 <- lsa(lsatextmatrix)


##fold in
lsa2007folded <- fold_in(lsatextmatrix2007 ,lsa2006)
lsa
