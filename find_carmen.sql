-- TEST COMMAND AND SAMPLE OUTPUT
-- Record your query (or queries, some clues require more than one) below the clue, then comment out the output below it
-- use two `-` to comment at the start of a line, or highlight the text and press `⌘/` to toggle comments
-- EXAMPLE: SELECT ALL FROM THE TABLE COUNTRY AND LIMIT IT TO ONE ENTRY

SELECT * FROM COUNTRY LIMIT 1;

--  -[ RECORD 1 ]--+--------------------------
-- code           | AFG
-- name           | Afghanistan
-- continent      | Asia
-- region         | Southern and Central Asia
-- surfacearea    | 652090
-- indepyear      | 1919
-- population     | 22720000
-- lifeexpectancy | 45.9
-- gnp            | 5976.00
-- gnpold         |
-- localname      | Afganistan/Afqanestan
-- governmentform | Islamic Emirate
-- headofstate    | Mohammad Omar
-- capital        | 1
-- code2          | AF


-- Clue #1: We recently got word that someone fitting Carmen Sandiego's description has been traveling through Southern Europe. She's most likely traveling someplace where she won't be noticed, so find the least populated country in Southern Europe, and we'll start looking for her there.
SELECT region FROM country WHERE region = 'Southern Europe';
SELECT population from country WHERE region = 'Southern Europe';
--    3401200
--       78000
--     3972000
--    39441700
--       25000
--    57680000
--    10640000
--    10545700
--     4473000
--     2024000
--      380200
--     9997600
--       27000
--     1987800
--        1000
SELECT name from country WHERE region = 'Southern Europe' and population = 1000;
-- Holy See (Vatican City State)
Carmen is in Vatican City State

-- Clue #2: Now that we're here, we have insight that Carmen was seen attending language classes in this country's officially recognized language. Check our databases and find out what language is spoken in this country, so we can call in a translator to work with you.
SELECT code from country WHERE name = 'Holy See (Vatican City State)'
-- VAT
SELECT language from countrylanguage WHERE countrycode = 'VAT';
-- Italian
SELECT isofficial from countrylanguage WHERE countrycode = 'VAT';
-- true
Better call an Italian translator

-- Clue #3: We have new news on the classes Carmen attended – our gumshoes tell us she's moved on to a different country, a country where people speak only the language she was learning. Find out which nearby country speaks nothing but that language.
SELECT *  FROM country LEFT JOIN countrylanguage ON country.code = countrylanguage.countrycode WHERE countrylanguage.language = 'Italian' and country.region = 'Southern Europe';
-- ITA  | Italy                         | Europe    | Southern Europe |      301316 |      1861 |   57680000 |             79 | 1161755.00 | 1145372.00 | Italia                          | Republic                 | Carlo Azeglio Ciampi |    1464 | IT    | ITA         | Italian  | t          |       94.1
--  SMR  | San Marino                    | Europe    | Southern Europe |          61 |       885 |      27000 |           81.1 |     510.00 |            | San Marino                      | Republic                 |                      |    3171 | SM    | SMR         | Italian  | t          |        100
--  VAT  | Holy See (Vatican City State) | Europe    | Southern Europe |         0.4 |      1929 |       1000 |                |       9.00 |            | Santa Sede/Cittï¿½ del Vaticano | Independent Church State | Johannes Paava
SELECT language FROM countrylanguage WHERE countrycode = 'ITA';
--  Italian
--  Sardinian
--  Friuli
--  French
--  German
--  Albaniana
--  Slovene
--  Romani 
-- several languages spoken
SELECT language FROM countrylanguage WHERE countrycode = 'SMR';
--  Italian
Carmen is currently in San Marino

-- Clue #4: We're booking the first flight out – maybe we've actually got a chance to catch her this time. There are only two cities she could be flying to in the country. One is named the same as the country – that would be too obvious. We're following our gut on this one; find out what other city in that country she might be flying to.
SELECT * FROM city WHERE city.countrycode = 'SMR';
--  3170 | Serravalle | SMR         | Serravalle/Dogano |       4802
--  3171 | San Marino | SMR         | San Marino        |       2294

Carmen is flying to: Serravalle


-- Clue #5: Oh no, she pulled a switch – there are two cities with very similar names, but in totally different parts of the globe! She's headed to South America as we speak; go find a city whose name is like the one we were headed to, but doesn't end the same. Find out the city, and do another search for what country it's in. Hurry!
SELECT * FROM city WHERE city.name LIKE 'Serra%';
--   265 | Serra      | BRA         | Espï¿½rito Santo  |     302666
--  3170 | Serravalle | SMR         | Serravalle/Dogano |       4802
SELECT * FROM country JOIN city on country.code = city.countrycode WHERE city.countrycode = 'BRA' AND city.name = 'Serra';
--  BRA  | Brazil | South America | South America | 8.547403e+06 |      1822 |  170115000 |           62.9 | 776739.00 | 804108.00 | Brasil    | Federal Republic | Fernando Henrique Cardoso |     211 | BR    | 265 | Serra | BRA         | Espï¿½rito Santo |     302666

Carmen is in Brazil

-- Clue #6: We're close! Our South American agent says she just got a taxi at the airport, and is headed towards the capital! Look up the country's capital, and get there pronto! Send us the name of where you're headed and we'll follow right behind you!
SELECT capital FROM country WHERE country.name = 'Brazil';
-- 211
SELECT id FROM city JOIN country on city.id = country.capital WHERE country.capital = 211;
-- 211 
SELECT name FROM city WHERE id = 211;
--Brasï¿½lia

-- Clue #7: She knows we're on to her – her taxi dropped her off at the international airport, and she beat us to the boarding gates. We have one chance to catch her, we just have to know where she's heading and beat her to the landing dock.

-- Lucky for us, she's getting cocky. She left us a note, and I'm sure she thinks she's very clever, but if we can crack it, we can finally put her where she belongs – behind bars.

-- Our playdate of late has been unusually fun –
-- As an agent, I'll say, you've been a joy to outrun.
-- And while the food here is great, and the people – so nice!
-- I need a little more sunshine with my slice of life.
-- So I'm off to add one to the population I find
-- In a city of ninety-one thousand and now, eighty five.

91084
-- We're counting on you, gumshoe. Find out where she's headed, send us the info, and we'll be sure to meet her at the gates with bells on.
SELECT name FROM city WHERE city.population = 91084;

--Santa Monica

-- She's in 
Santa Monica
____________________________!
--FIX Brazil Capital

carmen=# UPDATE city
carmen-# SET name = 'Brasília'
carmen-# WHERE city.id = 211;
UPDATE 1
carmen=# SELECT name FROM city WHERE id = 211; 
--  Brasília

--FIX Algeria's localname

SELECT localname  FROM country WHERE country.name = 'Algeria';
--Al-Jazaï¿½ir/Algï¿½rie
--Should be: الجزائر al-Dschazā’ir
carmen=# UPDATE country
carmen-# SET localname = 'الجزائر al-Dschazā’ir'
carmen-# WHERE country.name = 'Algeria';
UPDATE 1
SELECT localname FROM country WHERE country.name = 'Algeria';
--  الجزائر al-Dschazā’ir

carmen=# SELECT *  FROM country WHERE name = 'Albania';
--  code |  name   | continent |     region      | surfacearea | indepyear | population | lifeexpectancy |   gnp   | gnpold  |  localname  | governmentform |  headofstate   | capital | code2 

--  ALB  | Albania | Europe    | Southern Europe |       28748 |      1912 |    3401200 |           71.6 | 3205.00 | 2500.00 | Shqip�ria | Republic       | Rexhep Mejdani |      34 | AL
-- (1 row)

carmen=# UPDATE country
carmen-# SET localname = 'Shqipëria'
carmen-# WHERE country.name = 'Albania';
UPDATE 1
carmen=# SELECT localname FROM country WHERE name = 'Albania';
--Shqipëria                       