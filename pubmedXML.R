extractPubmedXML <- function(theFile) {
	library(XML)
	newData <- xmlParse(theFile)
	records <- getNodeSet(newData, "//PubmedArticle")
	pmid <- xpathSApply(newData,"//MedlineCitation/PMID", xmlValue)
	doi <- lapply(records, xpathSApply, ".//ELocationID[@EIdType = \"doi\"]", xmlValue)
	doi[sapply(doi, is.list)] <- NA
	doi <- unlist(doi)
	authLast <- lapply(records, xpathSApply, ".//Author/LastName", xmlValue)
	authLast[sapply(authLast, is.list)] <- NA
	authInit <- lapply(records, xpathSApply, ".//Author/Initials", xmlValue)
	authInit[sapply(authInit, is.list)] <- NA
	authors <- mapply(paste, authLast, authInit, collapse = "|")
	## affiliations <- lapply(records, xpathSApply, ".//Author/AffiliationInfo/Affiliation", xmlValue)
	## affiliations[sapply(affiliations, is.list)] <- NA
	## affiliations <- sapply(affiliations, paste, collapse = "|")
	year <- lapply(records, xpathSApply, ".//PubDate/Year", xmlValue) 
	year[sapply(year, is.list)] <- NA
	year <- unlist(year)
	articletitle <- xpathSApply(newData,"//ArticleTitle", xmlValue)
	journal <- lapply(records, xpathSApply, ".//ISOAbbreviation", xmlValue) 
	journal[sapply(journal, is.list)] <- NA
	journal <- unlist(journal)
	volume <- lapply(records, xpathSApply, ".//JournalIssue/Volume", xmlValue)
	volume[sapply(volume, is.list)] <- NA
	volume <- unlist(volume)
	issue <- lapply(records, xpathSApply, ".//JournalIssue/Issue", xmlValue)
	issue[sapply(issue, is.list)] <- NA
	issue <- unlist(issue)
	pages <- xpathSApply(newData,"//MedlinePgn", xmlValue)
	abstract <- lapply(records, xpathSApply, ".//AbstractText", xmlValue)
	abstract[sapply(abstract, is.list)] <- NA
	abstract <- sapply(abstract, paste, collapse = "|")
	meshHeadings <- lapply(records, xpathSApply, ".//DescriptorName", xmlValue)
	meshHeadings[sapply(meshHeadings, is.list)] <- NA
	meshHeadings <- sapply(meshHeadings, paste, collapse = "|")
	grantAgency <- lapply(records, xpathSApply, ".//Grant/Agency", xmlValue)
	grantAgency[sapply(grantAgency, is.list)] <- NA
	grantAgency <- sapply(grantAgency, paste, collapse = "|")
	grantNumber <- lapply(records, xpathSApply, ".//Grant/GrantID", xmlValue)
	grantNumber[sapply(grantNumber, is.list)] <- NA
	grantNumber <- sapply(grantNumber, paste, collapse = "|")
	grantCountry <- lapply(records, xpathSApply, ".//Grant/Country", xmlValue)
	grantCountry[sapply(grantCountry, is.list)] <- NA
	grantCountry <- sapply(grantCountry, paste, collapse = "|")
	ptype <- lapply(records, xpathSApply, ".//PublicationType", xmlValue)
	ptype[sapply(ptype, is.list)] <- NA
	ptype <- sapply(ptype, paste, collapse = "|")
	theDF <- data.frame(pmid, doi, authors, year, articletitle, journal, volume, issue, pages, abstract, meshHeadings, grantAgency, grantNumber, grantCountry, ptype, stringsAsFactors = FALSE)
	return(theDF)
}