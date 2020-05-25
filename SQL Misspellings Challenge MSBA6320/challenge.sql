DELIMITER $$
DROP FUNCTION IF EXISTS LEVENSHTEIN $$
CREATE FUNCTION levenshtein( s1 VARCHAR(255), s2 VARCHAR(255) ) 
  RETURNS INT 
  DETERMINISTIC 
  BEGIN 
    DECLARE s1_len, s2_len, i, j, c, c_temp, cost INT; 
    DECLARE s1_char CHAR; 
    -- max strlen=255 
    DECLARE cv0, cv1 VARBINARY(256); 
    SET s1_len = CHAR_LENGTH(s1), s2_len = CHAR_LENGTH(s2), cv1 = 0x00, j = 1, i = 1, c = 0; 
    IF s1 = s2 THEN 
      RETURN 0; 
    ELSEIF s1_len = 0 THEN 
      RETURN s2_len; 
    ELSEIF s2_len = 0 THEN 
      RETURN s1_len; 
    ELSEIF ABS(LENGTH(s1) - LENGTH(s2)) <=3 THEN
      WHILE j <= s2_len DO 
        SET cv1 = CONCAT(cv1, UNHEX(HEX(j))), j = j + 1; 
      END WHILE; 
      WHILE i <= s1_len DO 
        SET s1_char = SUBSTRING(s1, i, 1), c = i, cv0 = UNHEX(HEX(i)), j = 1; 
        WHILE j <= s2_len DO 
          SET c = c + 1; 
          IF s1_char = SUBSTRING(s2, j, 1) THEN  
            SET cost = 0; ELSE SET cost = 1; 
          END IF; 
          SET c_temp = CONV(HEX(SUBSTRING(cv1, j, 1)), 16, 10) + cost; 
          IF c > c_temp THEN SET c = c_temp; END IF; 
            SET c_temp = CONV(HEX(SUBSTRING(cv1, j+1, 1)), 16, 10) + 1; 
            IF c > c_temp THEN  
              SET c = c_temp;  
            END IF; 
            SET cv0 = CONCAT(cv0, UNHEX(HEX(c))), j = j + 1; 
        END WHILE; 
        SET cv1 = cv0, i = i + 1; 
      END WHILE; 
    END IF; 
    RETURN c; 
  END$$
  
SELECT id, misspelled_word
FROM word 
WHERE misspelled_word SOUNDS LIKE(@word)
OR levenshtein(misspelled_word,@word) BETWEEN 1 AND 3;




-- REPLACE(misspelled_word, 'i', 'e') = REPLACE(@word, 'i', 'e')
-- OR REPLACE(misspelled_word, 'e', 'i') = REPLACE(@word, 'e', 'i')
-- OR REPLACE(misspelled_word, 'oo', 'o') = REPLACE(@word, 'oo', 'o')
-- OR REPLACE(misspelled_word, 'o', 'oo') = REPLACE(@word, 'o', 'oo')
-- OR REPLACE(misspelled_word, 's', 'ss') = REPLACE(@word, 's', 'ss')
-- OR REPLACE(misspelled_word, 'ss', 's') = REPLACE(@word, 'ss', 's')
-- OR REPLACE(misspelled_word, 'a', 'ou') = REPLACE(@word, 'a', 'ou')
-- OR REPLACE(misspelled_word, 'ou', 'a') = REPLACE(@word, 'ou', 'a')
-- OR REPLACE(misspelled_word, 'a', 'ou') = REPLACE(@word, 'a', 'ou')
-- OR REPLACE(misspelled_word, 'a', 'e') = REPLACE(@word, 'a', 'e')
-- OR REPLACE(misspelled_word, 'e', 'a') = REPLACE(@word, 'e', 'a')
-- OR REPLACE(misspelled_word, 's', 't') = REPLACE(@word, 's', 't')
-- OR REPLACE(misspelled_word, 't', 's') = REPLACE(@word, 't', 's')
-- OR REPLACE(misspelled_word, 'z', 's') = REPLACE(@word, 's', 'z')
-- OR REPLACE(misspelled_word, 's', 'z') = REPLACE(@word, 'z', 's')
-- OR REPLACE(misspelled_word, 'c', 's') = REPLACE(@word, 'c', 's')
-- OR REPLACE(misspelled_word, 's', 'c') = REPLACE(@word, 's', 'c')
-- OR REPLACE(misspelled_word, 'c', 'ch') = REPLACE(@word, 'c', 'ch')
-- OR REPLACE(misspelled_word, 'ch', 'c') = REPLACE(@word, 'ch', 'c')
-- OR REPLACE(misspelled_word, 'tt', 't') = REPLACE(@word, 'tt', 't')
-- OR REPLACE(misspelled_word, 't', 'tt') = REPLACE(@word, 't', 'tt')
-- OR REPLACE(misspelled_word, 'r', 'rr') = REPLACE(@word, 'r', 'rr')
-- OR REPLACE(misspelled_word, 'rr', 'r') = REPLACE(@word, 'rr', 'r')
-- OR REPLACE(misspelled_word, 'm', 'mm') = REPLACE(@word, 'm', 'mm')
-- OR REPLACE(misspelled_word, 'mm', 'm') = REPLACE(@word, 'mm', 'm')
-- REPLACE(misspelled_word, 'na', 'an') = REPLACE(@word, 'na', 'an')  
-- OR REPLACE(misspelled_word, 'an', 'na') = REPLACE(@word, 'an', 'na')
-- OR REPLACE(misspelled_word, 'ie', 'ei') = REPLACE(@word, 'na', 'an')  
-- OR REPLACE(misspelled_word, 'ei', 'ie') = REPLACE(@word, 'ei', 'ei') 
-- OR REPLACE(misspelled_word, 'gh', 'hg') = REPLACE(@word, 'gh', 'hg')  
  
