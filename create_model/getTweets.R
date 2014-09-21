
library(RMongo)

## create tunnel to mongodb to get data
##system("sh mongo_tunnel.sh")
Sys.setlocale('LC_ALL','C')
mongo <- mongoDbConnect("db") # update values
username = "user"
password = "password"
authenticated <- dbAuthenticate(mongo, username, password)
dbShowCollections(mongo)
df <- dbGetQuery(mongo, "ark_collection", "{}", 0, 1000000)
df <- subset(df, X_id!="")
df$manual_class <- rep(NA, nrow(df))
# is a retweet
is.rt <- function(string){
  list.of.words <- strsplit(string, " ")[[1]]
  if("RT" %in% list.of.words) return(TRUE)
  else return(FALSE)
}
# is a reply
is.reply <- function(string){
  list.of.words <- strsplit(string, " ")[[1]]
  if("@" %in% substring(list.of.words,1,1)) return(TRUE)
  else return(FALSE)
}
df <- df[!sapply(df$text,is.rt),]
df <- df[!sapply(df$text,is.reply),]
write.csv(df, "create_model/ark_tweets.csv", row.names=F)
