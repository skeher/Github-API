#step 1: Have gained access to GitHub information.

install.packages("jsonlite")
library(jsonlite)
install.packages("httpuv")
library(httpuv)
install.packages("httr")
library(httr)

# Can be github, linkedin etc depending on application
oauth_endpoints("github")

# Change based on what your application is 
myapp <- oauth_app(appname = "Sweng_API",
                   key = "80571090559281f968f8",
                   secret = "b2b23b65cac352644d678927406d6971bbe07941")

# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "jtleek/datasharing", "created_at"]

# The code above was sourced from Michael Galarnyk's blog, found at:
# https://towardsdatascience.com/accessing-data-from-github-api-using-r-3633fb62cb08


#Interrogating the GitHub API.  The information about my github profile is 
#stored in a data frame called 'myData'.  I can access different parts of the data 
#frame using the $ operator, shown below.

myData <- fromJSON("https://api.github.com/users/skeher")
myData$followers #number of followers i have
myData$public_repos #number of public repositories i have

#I want specific details about my followers, so i use the link below

myFollowers <- fromJSON("https://api.github.com/users/skeher/followers")
myFollowers$login #the usernames of all users who follow me
length <- length(myFollowers$login) #the amount of people who follow me
length

#I can get specific information on repositories too

repositories <- fromJSON("https://api.github.com/users/skeher/repos")
repositories$name #the names of my public repositories
repositories$created_at #when these repositories were created
lca <- fromJSON("https://api.github.com/repos/skeher/LCA/commits")
lca$commit$message #the message i included in each commit to my lca repository


#I can look at other user's information too, by just changing the user name in
#the link above, and specifiying what i want to look at.

ecclesg <- fromJSON("https://api.github.com/users/ecclesg/following")
ecclesg$login

#Instead of viewing this information in a dataframe, i can convert it back to a
#JSon and study it this way, as it is viewed in a browser.

myDataJSon <- toJSON(myData, pretty = TRUE)
myDataJSon

#Reading this gives me an inclination into what kind of data is available to me
#and what URLs i can use 

#################################################################################

#I have interrogated the GitHub API and displayed data regarding the logged in
#developer.This answers part 1 of the assignment. I will now move onto part 2

#################################################################################

#The aspect of the software engineering process i wish to elucidate is the 
#number of followers that my followers have.  In this way, i will be able to
#determine which are the most influential developers out of my followers.

followersNames <- fromJSON("https://api.github.com/users/skeher/followers")
followersNames$login #shown previously, gets the user names of my followers

a <- "https://api.github.com/users/"
b <- followersNames$login[5]
b
c <- "/followers"

test <- sprintf("%s%s%s", a,b,c) #this method amalgamates a, b and c into one string 
test                              #called test 


#I now have the link to yitpin96's followers, contained in a string called test. If I
#wanted access to fionawolfe's followers link, i woiuld simply change b to
# b <- followersNames$login[2] as she is second in the list.

numOfFollowers <- c() #this creates an empty vector
namesOfFollowers <- c()
for (i in 1:length(followersNames$login)) {
  followers <- followersNames$login[i] #loops through each of my followers, indexed by i
  jsonLink <- sprintf("%s%s%s", a, followers, c) #creates link for my ith follower
  followData <- fromJSON(jsonLink) #stores the followers of my ith follower
  numOfFollowers[i] = length(followData$login) #amount of followers the ith follower has
  namesOfFollowers[i] = followers #names of all users following the ith follower
  
}
numOfFollowers
namesOfFollowers
finalData <- data.frame(numOfFollowers, namesOfFollowers) #stores two vectors as one
                                                          #data frame
finalData$namesOfFollowers
finalData$numOfFollowers

