# pubmedXML.R
This function allows you to use R to parse a PubMed XML file into a data frame that you can either work with in R or export to a .csv file.
It requires the XML package to be installed in your version of R, so if it isn't, run the following command before using it:

    install.packages("XML")

To use the function, open R and set the working directory to the folder on your computer that contains both the XML file you want to parse and the pubmedXML.R file

    setwd("C:/Users/Documents")

Then load the function

    source("pubmedXML.R")

and run it on the XML file you want to parse, in this example named myfile.xml

    theData <- extractPubmedXML("myfile.xml")

Once R is done extracting the data, you can work with the data frame in R or save it to a .csv file with the command:

    write.csv(theData, file = "myfile.csv")
