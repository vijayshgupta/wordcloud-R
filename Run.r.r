#PnS Assignment 1 - Lohitaksh - 2014059

#Loading the requires libraries
library(tm)
library(wordcloud)
library(NLP)
library(RColorBrewer)
library(SnowballC)

#Choose the directory the text is in
require(tcltk)
ReturnVal <- tkmessageBox(title = "Choose Directory",
                          message = "Choose the directory the text file to be processed is in", icon = "info", type = "ok")

words <- Corpus (DirSource(choose.dir()))                          #load documents in the specified folder

#Getting the currect working directory of package
pth <- dirname(sys.frame(1)$ofile)
path = paste(pth, "/names/names.txt", sep = "")
outpath = paste(pth, "/OUTPUT/", sep = "")

conn <- file(path,open="r")
names <- readLines(conn)                                             #getting the list of names to filter off
close(conn)

words <- tm_map(words, stripWhitespace)                              #remove the whitespaces between words

words <- tm_map(words, removePunctuation)                            #remove the punctution makrs

words <- tm_map(words, removeNumbers)                                #remove the numbers from the list

words <- tm_map(words, content_transformer(tolower))                 #lowercase all words

words <- tm_map(words, removeWords, stopwords("english"))            #remove stopwords contained in these stopwords dictionaries
words <- tm_map(words, removeWords, stopwords("french"))
words <- tm_map(words, removeWords, stopwords("SMART"))
words <- tm_map(words, removeWords, stopwords("german"))

for(i in 1:length(names)){                                           #removes names from a given namelist
 words <- tm_map(words, removeWords, names[i])
}

words <- tm_map(words, stemDocument)                                 #stems the words to the base word

#Creating png of the wordcloud
outpath1 = paste(outpath, "wordcloud.png", sep = "")
png(outpath1,1080,1080)
wordcloud(words, scale=c(8,.2),max.words=50, random.order=TRUE,colors=brewer.pal(8, "Set1"))
dev.off()


freq <- DocumentTermMatrix(words)                                    #Make a DTM of the wordlist of the format word:frequency
freq2 <- as.matrix(freq)                                             #Convert it into a matrix
sorted = sort(colSums(freq2),decreasing=TRUE)                        #Sort the matrix in decreading order of frequency
sorted=sorted[1:20]                                                  #Slice the matrix to the first 20 words

#Create png of Histogram of top 20 words
outpath2 = paste(outpath, "histogram.png", sep = "")
png(outpath2,1080,1080)            
barplot(sorted,las=2,legend.text="Histogram of top 20 occuring words")
dev.off()

sorted2 = sorted[1:15]                                               #Shorten the list to first 15

total=sum(unlist(freq2))                                             #Calculate total number of words (after the filtering)

for(i in 1:length(sorted2)){                                         #Calculate relative frequency of the top 15 words
  sorted2[i]=sorted2[i]/total
}

#Create png of the Relative Frequency Histogram of the top 15 words
outpath3 = paste(outpath, "relativehist.png", sep = "")
png(outpath3,1080,1080)
barplot(sorted2,las=2,legend.text="Relative Frequency Histogram of top 15 occuring words")
dev.off()

