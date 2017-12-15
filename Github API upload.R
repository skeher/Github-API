#To run each individual line of code, move the cursor to the first line of code, 
#and click ctrl+enter.  Allow time for each line to run (wait for the red stop sign in the
#console to disappear) before running the next line. The cursor will automatically go to the
#next line when the previous line runs, so just hold ctrl and keeping pressing enter!!

#step 1: You will need to install the packages and activate the libraries below in order to
#run this code. Please ensure the packages have been checked in the packages tab in the pane
#on the right hand side of the screen.


install.packages("jsonlite")
install.packages("httpuv")
install.packages("httr")

require(devtools)
install_github('rCharts', 'ramnathv')
library(rCharts)

library(httr)
library(jsonlite)
library(httpuv)

#The above 3 lines of code give me access to a package with D3.js libraries, allowing
#me to produce visualizations which will follow.  Find the link here:
#http://ramnathv.github.io/rCharts/


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


#Step1: Interrogating the GitHub API.  

#The information about my github profile is 
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

#Step 2: Processing the data from Github

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

#Step 2:

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

#Step3: Visualize the processed data from Github

myPlot <- nPlot(numOfFollowers ~ namesOfFollowers, data = finalData, type = "multiBarChart")
myPlot #prints out the D3.JS interactive graph of how many followers my followers have

myPlot$save("myplot.html") #this saves a html file of the plot to documents.  In your file 
                          #explorer, go to This PC -> Documents -> myplot.html to view it.

#the graph shows that dowlind1 and oboyle-mikey are the most influential developers who follow me
#creavyd is the least influential developer