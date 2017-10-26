folder_i <-paste("/home/harish/PycharmProjects/Topic-Modeling/Data Extraction/dataset/", "2002", sep="")
folder_i##test 1 year only
corpus_Year_2015 <- Corpus(DirSource(folder_i, recursive=TRUE),readerControl = list(reader=readPlain))

##stem
corpus_Year_2015<-tm_map(corpus_Year_2015,content_transformer(removePunctuation));
corpus_Year_2015<-tm_map(corpus_Year_2015,content_transformer(removeNumbers));
words_to_remove_in_article<-c("Federal Reserve System", "Federal Open Market Committee","project", "meeting","committ","committee","particip","federal", "FOMC", "\r","\t","Present", "\n") #irrevalant words
corpus_Year_2015<-tm_map(corpus_Year_2015, removeWords,words_to_remove_in_article); #removing irrevalant words in the article
corpus_Year_2015<-tm_map(corpus_Year_2015,removeWords,stopwords("english"));
corpus_Year_2015<-tm_map(corpus_Year_2015, content_transformer(tolower));
corpus_Year_2015<-tm_map(corpus_Year_2015, stemDocument, language="english");
corpus_Year_2015<-tm_map(corpus_Year_2015,stripWhitespace);

##build tdm/dtm matrix
tdm <- TermDocumentMatrix(corpus_Year_2015,control=list(wordLengths=c(4,Inf),bounds = list(global = c(2,400))))
tdm_matrix <- as.matrix(tdm)
dim(tdm_matrix)
##build a document/term matrix... words must have length 4
dtm <- DocumentTermMatrix(corpus_Year_2015,control=list(wordLengths=c(4,Inf),bounds = list(global = c(2,400))))
dtm_matrix <- as.matrix(dtm)
dim(dtm_matrix)

##LDA - top 5 words per topic
k= 5
ldaout <- LDA(dtms,k)

##docs by topics k
ldaout.topics <- as.matrix(topics(ldaout))

##top n terms
n = 5
ldaout.terms <- as.matrix(terms(ldaout,n))
ldaout.terms

##SVD for LSA
sing_v <- svd(dtm_matrix)

##find how many concepts to get 90%?
threshold <- sum(sing_v$d)*.9

loopcount = 0
counter <- threshold
while (counter > 0) {
  loopcount <- loopcount + 1
  counter = counter - sing_v$d[loopcount]
}

D <- D[1:loopcount,1:loopcount]

concept90 <- sing_v$v[,1:loopcount] %*% D %*% t(sing_v$u[,1:loopcount])
dim(concept90)

##cluster
nb_orig <- NbClust(data = dtm_matrix,method="kmeans",min.nc = 2,max.nc = 7, index = "duda")
concept90_duda <- NbClust(data = concept90,method="kmeans",min.nc = 2,max.nc = 8, index = "duda")
kmeansconcept50 <- kmeans(concept90, centers = 2, iter.max = 50)

 
##concept50_matrix
fviz_nbclust(concept90, kmeans, method = "wss") +
  geom_vline(xintercept = 2, linetype = 2)+
  labs(subtitle = "Elbow method 6 concepts")
# Silhouette method
fviz_nbclust(concept90, kmeans, method = "silhouette")+
  labs(subtitle = "Silhouette method 6 concepts")

##plot 2 concepts
num_cluster <- concept90_duda$Best.nc[1]
c2 <- kmeans(concept90,num_cluster)
fviz_cluster(c2,data=concept90,geom = "point",stand = FALSE, ellipse.type = "norm",main= "kMeans k = 2")


