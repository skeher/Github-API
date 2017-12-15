# Github-API
Interrogating the Github API using R

The hypothesis: The data I chose to analyse is the number of followers I have, thus finding out who are the most influential developers that follow me.  I believe the amount of GitHub followers a user has is indicitive of the quality of their work.  This is the aspect of the software engineering process which I have elucidated.  

How to run:  Ensure packages are installed and libraries are activated or 'checked' (they will have a tick beside them in the packages pane on the right hand side of the screen).  Run each line of code using CTRL + enter, starting from the top.  Allow time for each line of code to run, especially installing packages and producing plots and graphs. 

Interrogating the GitHub API: This is identified in the comments of the R code.  I made an application to be given permission to access the GitHub database, allowing me to extract data using the fromJson function.  The extracted information is stored as a data frame and specific elements of the data frame can be accessed using the $ operator.

Processing the data: I used a for loop to access the names of my followers, and how many people they were following.  I stored these as two seperate vectors initially but amalgamated these into one dataframe for ease of storage and access.

Visualization: I used a package in R called rCharts which supports D3.JS graphs and plots.  I produced a bar chart with follower names on the x axis and number of followers on the y axis.  The final line of code saves the plot as an html file called "myplot.html" in the user's documents folder.  The file should be in your file explorer if this line has been run properly.  However, the myplot.html file which I have uploaded to GitHub may work.  In any case, I have also uploaded two screenshots which demonstrate the interactive graph.  

Conclusion: The chart shows that oboyle-mikey and dowlind1 are the most influential developers that follow me, which 15 followers each.  creavyd is the least influential, with just 2 followers.
