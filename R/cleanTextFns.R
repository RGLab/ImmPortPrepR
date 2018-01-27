###########################################
###          HELPER FUNCTIONS           ###
###########################################

# turn a character vector into a list of words
vec2Words <- function(charVec){
  charVec <- charVec[ !is.na(charVec) ] # rm NAs
  charVec <- gsub("[[:punct:]]|\\d+", " ", charVec) # rm all punctuation and digits
  charVec <- gsub("\\s{2,}", " ", charVec) # rm extra spaces
  charVec <- unique(tolower(charVec)) # want unique within vector b/c comparing across sdy
  words <- unlist(strsplit(charVec, " ")) # make list of words
  words <- words[ nchar(words) > 2 ] # not trying to work with chopped up modifers e.g. IL or cd
}

###########################################
###            MAIN FUNCTIONS           ###
###########################################

#' @title check for spelling errors in a character vector
#'
#' @description takes character and returns list of problematic
#'     spellings and suggestions for replacement
#'
#' @param input character vector
#' @import hunspell
#' @export
checkSpelling <- function(input){
    res <- unique(unlist(hunspell(unique(input)))) # unique wrapper in case single long char vec
    probs <- res[ lengths(res) > 0 ]
    if (!is.null(probs)){
        suggestions <- hunspell_suggest(probs)
        names(suggestions) <- probs
        return(suggestions)
    }else{
        message("No misspellings found!")
        return(NULL)
    }
}

#' @title Check a character vector against words in ImmuneSpace
#'
#' @description checkByContext compares non-stopwords in a vector to those
#'     already in ImmuneSpace. Any words not already in ImmuneSpace are analyzed
#'     via stringdist to find closest matches.  These matches are returned in a
#'     named list.
#'
#' @param input character vector
#' @importFrom stopwords stopwords
#' @importFrom stringdist stringdist
#' @export
checkByContext <- function(input){
    # assume that user has run checkSpelling and no mis-spellings in input
    # so this looks for issues like "does" in place of "doses"
    # TODO: take closer look at stopwords!
    words <- unique(vec2Words(input))
    words <- words[ !(words %in% stopwords(source = "smart")) ] # remove stopwords / non-analytical words
    words <- words[ !(words %in% names(R2i::ISFreqsAll)) ] # rm words that are in IS dbase
    res <- sapply(words, function(x){
        dists <- stringdist(x, names(R2i::ISFreqsAll)) # get string distances using OSA method
        poss <- names(R2i::ISFreqsAll)[ dists == min(dists) ]
    })
}

#' @title find and replace characters in a vector
#'
#' @description find all instances of a word in a vector
#'     and replace it with another word
#'
#' @param input character vector
#' @param find word to find
#' @param replace replacement word
#' @export
findReplace <- function(input, find, replace){
    tmp <- sapply(input, function(x){ gsub(find, replace, x) })
    return(unname(tmp))
}

#' @title Interactively find and replace problematic words in a vector
#'
#' @description For each word in the output list from checkSpelling()
#'     find the word in the inputVector and allow the user to enter a
#'     replacement word
#'
#' @param misspelledWords named list of problematic words and suggested replacements
#' @param inputVector character vector
#' @param outFile filepath for where to append lines of code
#' @export
InteractiveFindReplace.vector <- function(misspelledWords, inputVector, outFile = NULL){
    ret <- inputVector
    message("NOTE: leaving the replacement field blank means do not replace.")

    for( nm in names(misspelledWords) ){
        message(paste0("word not found: ", nm))
        message("Possible suggestions: ")
        print(misspelledWords[[nm]])
        rep <- readline(prompt = paste0("enter replacement for ", nm, ": "))
        if(rep == ""){ rep <- misspelledWords[[nm]]}
        message("")

        ret <- gsub(pattern = nm, replacement = rep, x = ret)
        # ret <- findReplace(find = nm,
        #                    replace = rep,
        #                    input = ret)

        if(!is.null(outFile)){
            # codeLn <- paste0("\ninput <- unname(sapply(input, function(x){ gsub('",
            #                  nm, "', '", rep, "', x) }))")
            cat(codeLn, file = outFile, append = TRUE)
        }
    }

    return(ret)
}

#' @title Interactively find and replace problematic words in a data frame
#'
#' @description For each word in the output list from checkSpelling()
#'     find the word in the inputVector and allow the user to enter a
#'     replacement word
#'
#' @param misspelledWords named list of problematic words and suggested replacements
#' @param inputDF character vector
#' @param outFile filepath for where to append lines of code
#' @export
InteractiveFindReplace.df <- function(misspelledWords, inputDF, outFile = NULL){
    ret <- inputDF
    message("NOTE: leaving the replacement field blank means do not replace.")

    for( nm in names(misspelledWords) ){
        message(paste0("word not found: ", nm))
        message("Possible suggestions: ")
        print(misspelledWords[[nm]])
        rep <- readline(prompt = paste0("enter replacement for ", nm, ": "))
        if(rep == ""){ rep <- misspelledWords[[nm]]}
        message("")

        ret <- data.frame(lapply(inputDF, function(x){
                                    gsub(pattern = nm,
                                    replacement = rep,
                                    x)}))
        colnames(ret) <- colnames(inputDF)

        if(!is.null(outFile)){
            codeLn <- paste0("\ndata.frame(lapply(inputDF, function(x){ gsub(pattern = '",
                             nm, "', replacement = '", rep, "', x) }))")
            cat(codeLn, file = outFile, append = TRUE)
        }
    }

    return(ret)
}

#' @title Interactively check spelling against dictionary and ImmuneSpace-specific words
#'
#' @description Given an input vector and output directory, the user may
#'     correct words that are not found in a standard dictionary or a
#'     current list of ImmuneSpace specific terms.
#'
#' @param inputVector vector, only character type will be worked on
#' @param vectorName name of vector for use in output R doc
#' @param outFile filepath for where to append lines of code
#' @export
interactiveSpellCheck.vector <- function(inputVector, vectorName, outputDir){

    # skip if not a character vector
    if(typeof(inputVector) != "character"){
        message("skipping non-character vector")
        return(inputVector)
    }

    # Want file to be executable
    outFile <- paste0(outputDir, "/", vectorName, ".R")

    # write first lines of file
    header <- paste0("# Changes made to ", vectorName, " using interactiveSpellCheck() \n",
                     "# at ", Sys.time(), "\n")
    cat(header, file = outFile, append = TRUE)

    # run regular spell-check first
    message("---- Running Spell Check ---- \n")
    misspelledWords <- checkSpelling(inputVector)

    # do findReplace
    tmpVec <- InteractiveFindReplace(misspelledWords,
                                     inputVector,
                                     outFile)

    # run checkByContext
    message("---- Running Context Check ---- \n")
    contextWords <- checkByContext(tmpVec) # fix to not flag regular words like mosquito

    # do findReplace
    resVec <- InteractiveFindReplace(contextWords,
                                     tmpVec,
                                     outFile)

    # Add newlines in case wrapped in sapply statement
    cat("\n\n", file = outFile, append = TRUE)

    names(resVec) <- vectorName

    return(resVec)

}

#' @title Interactively check spelling against dictionary and ImmuneSpace-specific words
#'
#' @description Given an input vector and output directory, the user may
#'     correct words that are not found in a standard dictionary or a
#'     current list of ImmuneSpace specific terms.
#'
#' @param inputDF dataframe, only character type will be worked on
#' @param vectorName name of vector for use in output R doc
#' @param outFile filepath for where to append lines of code
#' @export
interactiveSpellCheck.df <- function(inputDF, vectorName, outputDir){

    # Want file to be executable
    outFile <- paste0(outputDir, "/", vectorName, ".R")

    # write first lines of file
    header <- paste0("# Changes made to ", vectorName, " using interactiveSpellCheck() \n",
                     "# at ", Sys.time(), "\n")
    cat(header, file = outFile, append = TRUE)

    # get all unique words from entire DF into one vector
    words <- unique(unlist(apply(inputDF, 2, vec2Words)))

    # Run vector through checkSpelling
    misspelledWords <- checkSpelling(words)

    # do InteractivefindReplace.DF ... creates named list of find:replace pairs and then iterates
        # through findReplace after all are chosen

    # run regular spell-check first
    message("---- Running Spell Check ---- \n")
    misspelledWords <- checkSpelling(inputVector)

    # do findReplace in apply loop
    tmpVec <- InteractiveFindReplace(misspelledWords,
                                     inputVector,
                                     outFile)

    # run checkByContext
    message("---- Running Context Check ---- \n")
    contextWords <- checkByContext(tmpVec) # fix to not flag regular words like mosquito

    # do findReplace
    resVec <- InteractiveFindReplace(contextWords,
                                     tmpVec,
                                     outFile)

    # Add newlines in case wrapped in sapply statement
    cat("\n\n", file = outFile, append = TRUE)

    names(resVec) <- vectorName

    return(resVec)
}


