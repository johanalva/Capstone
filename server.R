options(shiny.maxRequestSize=30*1024^2)




library(shiny)
library(data.table)
library(NLP)
library(tm)

# Reading the dataset 
Dataset <- fread("NgramTable_Datatable.txt")
setkeyv(Dataset, c('w1', 'w2', 'w3', 'w4', 'freq'))


# Cleaning the data
Input_ready <- function(Text){
  Text_Cleaned <- tolower(Text)
  Text_Cleaned <- stripWhitespace(Text_Cleaned)
  Text_Cleaned <- gsub("[^\\p{L}\\s]+", "", Text_Cleaned, ignore.case=F, perl=T)
  return(Text_Cleaned)
}

Split_Input_ready <- function(Text){
  Text_Cleaned <- tolower(Text)
  Text_Cleaned <- stripWhitespace(Text_Cleaned)
  Text_Cleaned <- gsub("[^\\p{L}\\s]+", "", Text_Cleaned, ignore.case=F, perl=T)
  Fixed_Input <- unlist(strsplit(Text_Cleaned, " "))
  return(Fixed_Input)
}

#counting Ngrams


Word_Count1 <- function(TextInputA){
  NgramsTable <<- Dataset[list("<s>", TextInputA[1])]
  NgramsTable <<- NgramsTable[NgramsTable$w3!="<s>", ]
  NgramsTable <<- NgramsTable[order(NgramsTable$freq, decreasing=TRUE), ]
  
  #Predictions words
  Alt_pred <<- as.data.frame(NgramsTable)
  Alt_pred <<- Alt_pred[1:5, c("w3", "freq")]
  Alt_pred <<- Alt_pred[!is.na(Alt_pred$freq), ]
  Alt_pred <<- Alt_pred[!duplicated(Alt_pred), ]
  if(nrow(Alt_pred)==0){
    Alt_pred <<- data.frame(Word=NA, Likelihood=NA)
  }else{
    Alt_pred$freq <- round(Alt_pred$freq/sum(Alt_pred$freq)*100, 1)
    Alt_pred <<- Alt_pred
    colnames(Alt_pred) <<- c("Word", "Likelihood")
    rownames(Alt_pred) <<- NULL
  }
  
  Guess_Output <- NgramsTable$w3[1]
  if(is.na(Guess_Output)|is.null(Guess_Output)){
    Guess_Output <- "No prediction found :("
  }
  
  return(Guess_Output)
}

# Counting n grams
Word_Count2 <- function(TextInputB){
  NgramsTable <<- Dataset[list("<s>", TextInputB[1], TextInputB[2])]
  NgramsTable <<- NgramsTable[NgramsTable$w4!="<s>", ]
  NgramsTable <<- NgramsTable[order(NgramsTable$freq, decreasing=TRUE), ]
  
  #Predicitons
  Alt_pred <<- as.data.frame(NgramsTable)
  Alt_pred <<- Alt_pred[1:5, c("w4", "freq")]
  Alt_pred <<- Alt_pred[!is.na(Alt_pred$freq), ]
  Alt_pred <<- Alt_pred[!duplicated(Alt_pred), ]
  if(nrow(Alt_pred)==0){
    Alt_pred <<- data.frame(Word=NA, Likelihood=NA)
  }else{
    Alt_pred$freq <- round(Alt_pred$freq/sum(Alt_pred$freq)*100, 1)
    Alt_pred <<- Alt_pred
    colnames(Alt_pred) <<- c("Word", "Likelihood")
    rownames(Alt_pred) <<- NULL
  }
  
  Guess_Output <- NgramsTable$w4[1]
  if(is.na(Guess_Output)|is.null(Guess_Output)){       
    Guess_Output <- Word_Count1(TextInputB[2])
  }
  
  return(Guess_Output)
}

#Count of n grams

Word_Count3 <- function(TextInputC){
  NgramsTable <<- Dataset[list("<s>", TextInputC[1], TextInputC[2], TextInputC[3])]
  NgramsTable <<- NgramsTable[NgramsTable$w5!="<s>", ]
  NgramsTable <<- NgramsTable[order(NgramsTable$freq, decreasing=TRUE), ]
  
  #Predictions
  Alt_pred <<- as.data.frame(NgramsTable)
  Alt_pred <<- Alt_pred[1:5, c("w5", "freq")]
  Alt_pred <<- Alt_pred[!is.na(Alt_pred$freq), ]
  Alt_pred <<- Alt_pred[!duplicated(Alt_pred), ]
  if(nrow(Alt_pred)==0){
    Alt_pred <<- data.frame(Word=NA, Likelihood=NA)
  }else{
    Alt_pred$freq <- round(Alt_pred$freq/sum(Alt_pred$freq)*100, 1)
    Alt_pred <<- Alt_pred
    colnames(Alt_pred) <<- c("Word", "Likelihood")
    rownames(Alt_pred) <<- NULL
  }
  
  Guess_Output <- NgramsTable$w5[1]
  if(is.na(Guess_Output)|is.null(Guess_Output)){
    Shortened_Input <- c(TextInputC[2], TextInputC[3])
    Guess_Output <- Word_Count2(Shortened_Input)
    if(is.na(Guess_Output)|is.null(Guess_Output)){
      Guess_Output <- Word_Count1(TextInputC[3])
    }
  }
  
  return(Guess_Output)
}
library(shiny)
library(data.table)
library(NLP)
library(tm)

# All server logic
shinyServer(function(input, output) {    
  # Dataset Summary
  
  output$Original <- renderText({
    Original_Input <- input$obs
    return(Original_Input)
  })
  
 
  output$Translated <- renderText({
    Original_Input <- input$obs
    Translated_Input <- Input_ready(Original_Input)
    return(Translated_Input)
  })
  
  # Generate a summary of the dataset
  output$BestGuess <- renderText({
    Original_Input <- input$obs
    Translated_Input <- Input_ready(Original_Input)
    BestGuess_Output <- "The predicted next word will be here."
    Fixed_Input <- Split_Input_ready(Original_Input)
    Word_Count <- length(Fixed_Input)
    
    if(Word_Count==1){
      BestGuess_Output <- Word_Count1(Fixed_Input)
    }
    if(Word_Count==2){
      BestGuess_Output <- Word_Count2(Fixed_Input)
    }
    if(Word_Count==3){
      BestGuess_Output <- Word_Count3(Fixed_Input)
    }
    if(Word_Count > 3){
      Words_to_Search <- c(Fixed_Input[Word_Count - 2],
                           Fixed_Input[Word_Count - 1],
                           Fixed_Input[Word_Count])
      BestGuess_Output <- Word_Count3(Words_to_Search)
    }
    return(BestGuess_Output)
  })
  
  # Show predictions
  
  output$view <- renderTable({
    Original_Input <- input$obs
    Fixed_Input <- Split_Input_ready(Original_Input)
    Word_Count <- length(Fixed_Input)
    
    if(Word_Count==1){
      BestGuess_Output <- Word_Count1(Fixed_Input)
    }
    if(Word_Count==2){
      BestGuess_Output <- Word_Count2(Fixed_Input)
    }
    if(Word_Count==3){
      BestGuess_Output <- Word_Count3(Fixed_Input)
    }
    if(Word_Count > 3){
      Words_to_Search <- c(Fixed_Input[Word_Count - 2],
                           Fixed_Input[Word_Count - 1],
                           Fixed_Input[Word_Count])
      BestGuess_Output <- Word_Count3(Words_to_Search)
    }
    
    if(exists("Alt_pred", where = -1)){
      Alt_pred
    }else{
      XNgramsTable <- data.frame(Word=NA, Likelihood=NA)
    }
    
  })
})