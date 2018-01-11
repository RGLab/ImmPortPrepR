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
