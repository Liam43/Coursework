# SQL Misspellings Challenge

This file is the programming challenge during my SQL Class MSBA6320. We were given a database of words and their frequently appearing misspellings. Our task was, given a word, return all misspellings of said word. The results were evaluated in terms of precision, recall, and f-score. It would measure the number of "correct" misspellings against the amount of actual misspellings in the database.

# Process
I worked with Boyang Wei on this project, and our progress could be measured in three distinct stages.
First we were given some example code from which we could base our work.


SELECT id, misspelled_word
  FROM word 
 WHERE REPLACE(misspelled_word, 'mm', 'm') = REPLACE(@word, 'mm', 'm');
 
 
The methodology for this is rather simple. Replace the letters with a common swap. In this example, the code would return the word if the "mm" to "m" correction was accepted. It would return "cummulative" if you wrote in "cumulative" as @word. Naturally, we decided to experiment with as many possible variations as we could. You can see our attempt at the bottom commented out. We never really achieved an f-score above .35 from this attempt.


However, this method felt pretty crude, and the accuracy was still rather lacking. After a bit of research, we came up with the SOUNDEX Method. This method was pretty easy to implement, and really only required adding one line of code. 


WHERE misspelled_word SOUNDS LIKE(@word)


This line of code leveraged SQL's built in SOUNDEX function to return words that had a similar sound to the word being compared. It boosted our f-score to 0.597. But still, we saw some classmates were seeing better performances than just this.


This led us to the [Levenshtein Distance Method](https://en.wikipedia.org/wiki/Levenshtein_distance). The theory is basically that it's a measurement of how many single character edits are need to match the other word. "Hah" and "High" would have a distance of three: delete the a, insert i, and insert g. We implemented this as a function and added it to the query. We through tuning, we got an f-score of 0.6 in conjunction with SOUNDEX.


This method wasn't without problems obviously. We found that there was a situation in which if a word had 2 letters swapped, like “swpaped” vs “swapped”, then neither Levenshtein Distance nor Soundex would catch it. Levenshtein would catch it with a distance of 4, but it would also catch a lot of things we didn’t want to catch. We were looking into other matching algorithms that could catch this, but in the end, we ran out of time. We never came back around to this challenge, but this would be the next step if we ever did.
