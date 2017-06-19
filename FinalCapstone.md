Final Project Word Prediction
========================================================
author: Johnny Alvarez Mendez
date: June 19th 2017
autosize: true

Project Background
========================================================

Nowadays time is a valuable thing for the people, always is important to create several ways of how to improve our time
spent, that is the reason why we think about develop a word prediction application, in order to help the user with some
word suggestions when is typing a text.
Application delay is good in order to predict the next word and the prediction acuracy 
Application is easy to use, just the usertypes the text on the "text input" textbox and after that just click the "Predict" button and prediction will show below "Predction" label.
Also is going to give some other related word and freq related based on trained texts.
Hope you like it

Cleaning with "tm" package
========================================================
For the data cleaning transformation the package process the raw data in the corpus into a easy format for manipulation, with this package we converted the text to lower case, stripped of whitespace, and removed common stopwords.

Data Processing: n-Grams/ Katz's Model
========================================================

N-gram is a sequence of n items in a continous way given a text or speech. This packages takes all key words or phrase and matches that key word or phrase with the most frequen term found. However not all words can be founded because we need a lot of training data in order to make it perfect, that is also the reason why we use Katz's model, it can segregate text into smaller n-grams when key is not found in the larger n-gram. Also maximum handled is triagram.
If the prediction is not found the word "No Prediction Found :(" will appear


Code and Application references
========================================================

For my code reference, please visit:

https://github.com/johanalva/Capstone

Application deployed is here: https://scotturbinamoreira93.shinyapps.io/Capstone_Final/



Thank you

