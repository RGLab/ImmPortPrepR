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
    res <- hunspell(unique(input))
    probs <- unlist(res[ lengths(res) > 0 ])
    if (!is.null(probs)){
        suggestions <- hunspell_suggest(probs)
        names(suggestions) <- probs
        return(suggestions)
    }else{
        message("No misspellings found!")
        return(NULL)
    }

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
#' @param checkSpellingOutput named list of problematic words and suggested replacements
#' @param inputVector character vector
#' @export
interactiveReplace <- function(checkSpellingOutput, inputVector){
    for( nm in names(checkSpellingOutput) ){
        message(paste0("Misspelled word: ", nm))
        message("Possible suggestions: ")
        print(checkSpellingOutput[[nm]])
        rep <- readline(prompt = paste0("enter replacement for ", nm, ": "))
        message("")
        inputVector <- findReplace(find = nm,
                                   replace = rep,
                                   input = inputVector)
    }

    return(unname(inputVector))
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
    words <- vec2Words(input)
    words <- words[ !(words %in% stopwords(source = "smart")) ] # remove stopwords / non-analytical words
    words <- words[ !(words %in% names(R2i::ISFreqsAll)) ] # rm words that are in IS dbase
    res <- sapply(words, function(x){
        dists <- stringdist(x, names(R2i::ISFreqsAll)) # get string distances using OSA method
        poss <- names(R2i::ISFreqsAll)[ dists == min(dists) ]
    })
}
