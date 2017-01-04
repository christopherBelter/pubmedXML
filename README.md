# pubmedXML.R

This file contains two functions to work with PubMed XML files in R. The first, clean_api_xml(), prepares XML files obtained by two PubMed API packages, reutils and rentrez, for parsing with the second. The second, extract_xml(), extracts values from a PubMed XML into a data frame in R. 

## clean_api_xml()

This function cleans XML obtained via the PubMed API using either reutils or rentrez. The reutils package forces the user to download large record sets in batches of 500, while the rentrez package recommends this approach. In either case, the XML obtained by this method actually consists of multiple XML files pasted together into a single file. The XML package cannot parse the data in this format. The XML also contains a number of unescaped Unicode characters like \<U+2009> that cause errors in parsing. The clean_api_xml() function fixes both issues, prepares the file for parsing with the extract_xml() function, and saves the cleaned version of the file.

The function has two arguments: infile and outfile. The infile is the raw XML file obtained by the API and the outfile is the file name of the new, cleaned file. 

To use the function, set the working directory to the folder that contains the XML file you want to parse:

    setwd("C:/Users/Documents")

and then load the function

    source(C:/Users/Documents/pubmedXML.R")

Then run the function on the raw XML file obtained from the API, in this example named raw_results.xml

    cleanXML <- clean_api_xml(infile = "raw_results.xml", outfile = "clean_results.xml")

You can then pass the cleanXML object directly into the extract_xml() function below. 

## extract_xml()

This function allows you to use R to parse a PubMed XML file into a data frame that you can either work with in R or export to a .csv file. Note that you can use this function on either XML downloaded via API or XML downloaded through the web interface of PubMed. If the latter, skip the clean_api_xml() function entirely and pass the name of the XML file you donwloaded from the web directly to the extract_xml() function. 

It requires the XML package to be installed in your version of R, so if it isn't, run the following command before using it:

    install.packages("XML")

To use the function, open R and set the working directory to the folder on your computer that contains both the XML file you want to parse and the pubmedXML.R file

    setwd("C:/Users/Documents")

Then load the function

    source("pubmedXML.R")

and run it on the XML file you want to parse, in this example named myfile.xml

    theData <- extract_xml("myfile.xml")

Once R is done extracting the data, you can work with the data frame in R or save it to a .csv file with the command:

    write.csv(theData, file = "myfile.csv")

## Sample workflow

This sample workflow shows you how to use the reutils package to obtain records from the PubMed API and then parse the resulting XML into a data frame in R.

First, set the working directory, load the reutils package and the pubmedXML.R file

    setwd("C:/Users/Documents")
    source("C:/Users/Documents/pubmedXML.R")
    library(reutils)

Next, save the search string you want to use. In this example, I'm searching for all papers funded by the Fogarty International Center that were published in 2015. 

    myQuery <- "fic[gr] AND 2015[dp]"

Then run the search in PubMed via the API and save the search results as a list of pmids to the NCBI history server.

    pmids <- esearch(myQuery, db = "pubmed", usehistory = TRUE)

Then download the full records of the search results in XML format in batches of 500 and save them to a file called raw_results.xml

    rawXML <- efetch(pmids, retmode = "xml", outfile = "raw_results.xml")

Once the download is complete, use the clean_api_xml() function to clean it up into a correctly formatted XML file

    cleanXML <- clean_api_xml(infile = "raw_results.xml", outfile = "clean_results.xml")

Finally, extract the values from the clean XML file using the extract_xml() function

    theData <- extract_xml(cleanXML)

And now you have a data frame that you can work with in R or save, as above. 
