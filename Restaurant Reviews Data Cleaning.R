getwd()


Deception = read.delim('deception_data_converted_final.txt', stringsAsFactors = FALSE  )
View(Deception)

Deception$reviews = paste(Deception$review, Deception$X.1, Deception$X.2, Deception$X.3, Deception$X.4, 
                          Deception$X.5, Deception$X.6, Deception$X.7, Deception$X.8, Deception$X.9, Deception$X.10,
                          Deception$X.11, Deception$X.12, Deception$X.13, Deception$X.14, Deception$X.15, Deception$X.16,
                          Deception$X.17, Deception$X.18, Deception$X.19, Deception$X.20)



Deception = Deception[-c(3:24)]


install.packages("dplyr")
library(dplyr)


#recoding false = 0 and true = 1,  negative = 0 and positive = 1

Deception$lie = dplyr::recode(Deception$lie, f=0, t=1)
Deception$sentiment = dplyr::recode(Deception$sentiment, n=0, p=1)


#Cleaning the Text
install.packages("tm")
install.packages("SnowballC")
library(SnowballC)

library(tm)

corpus = VCorpus(VectorSource(Deception$reviews))
View(corpus)
#updating the corpus to lower cases reviews
corpus = tm_map(corpus, content_transformer(tolower))
corpus = tm_map(corpus, removeNumbers)
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, stopwords())
corpus = tm_map(corpus, stemDocument)
corpus = tm_map(corpus, stripWhitespace)


#Creating the bag of words model


dtm = DocumentTermMatrix(corpus)
dtm = removeSparseTerms(dtm, 0.999)


#converting document term matrix to normal dataframe for classification model

dataset = as.data.frame(as.matrix(dtm))
View(dataset)


#adding dependent variable in our new dataset 
dataset$lie = Deception$lie
dataset$sentiment =   Deception$sentiment



dataset = as.data.frame(dataset)


write.csv(dataset, file = "dataset.csv")






