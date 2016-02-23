-- What languages are spoken in the 20 poorest (GNP/ capita) countries in the world?

SELECT
	c.name AS country,
	cl.language AS language,
	c.gnp AS gnp

FROM
	country c JOIN
	countrylanguage cl ON c.code = cl.countrycode

WHERE
	gnp > 0

ORDER BY
	gnp ASC

LIMIT
	20

-- What are the cities in the countries with no official language?

WITH officialLanguage AS
	(SELECT
		cy.countrycode AS country,
		cy.name AS cityname,
		cl.isofficial AS official
	FROM
		city cy JOIN
		countrylanguage cl ON cy.countrycode = cl.countrycode
	WHERE
		cl.isofficial = FALSE)

	SELECT	cntry.name AS country,
		cityname

	FROM 	officialLanguage ol JOIN
		country cntry ON ol.country = cntry.code


-- Which languages are spoken in the ten largest (area) countries?

SELECT
	cy.name AS country,
	cl.language AS language
FROM
	country cy JOIN
	countrylanguage cl ON cy.code = cl.countrycode
WHERE
	cy.surfacearea > 0
ORDER BY
	cy.surfacearea DESC
LIMIT
	10


-- What is the total city population
--in countries where English is an official language?

WITH officialLanguagesByCountry AS
	(SELECT
		cl.countrycode AS country,
		cl.language AS language,
		cl.isofficial AS official
	FROM
		countrylanguage cl JOIN
		country cy ON cl.countrycode = cy.code
	WHERE
		cl.language = 'English'
	),

officialEnglish AS
	(SELECT
		olc.country AS country,
		cty.name AS city,
		cty.population AS population
	FROM
		officialLanguagesByCountry olc JOIN
		city cty ON olc.country = cty.countrycode
	WHERE
		olc.official = TRUE
	)

SELECT

	SUM (population
	)
FROM
	officialEnglish

--Spanish?

WITH officialLanguagesByCountry AS
	(SELECT
		cl.countrycode AS country,
		cl.language AS language,
		cl.isofficial AS official
	FROM
		countrylanguage cl JOIN
		country cy ON cl.countrycode = cy.code
	WHERE
		cl.language = 'Spanish'
	),

officialSpanish AS
	(SELECT
		olc.country AS country,
		cty.name AS city,
		cty.population AS population
	FROM
		officialLanguagesByCountry olc JOIN
		city cty ON olc.country = cty.countrycode
	WHERE
		olc.official = TRUE
	)

SELECT

	SUM (population
	)
FROM
	officialSpanish

-- Are there any countries without an official language?
SELECT
	cy.code AS countrycode,
	cty.name AS city
FROM
	country cy LEFT JOIN
	city cty ON cy.code = cty.countrycode

WHERE
	cty.name is NULL

-- Which countries have the 100 biggest cities in the world?

SELECT
	cry.name,
	cy.name,
	cy.population
FROM
	city cy JOIN
	country cry ON cy.countrycode = cry.code
ORDER BY
	cy.population DESC
LIMIT
	100

-- What languages are spoken in the countries with the 100 biggest cities in the world?

WITH countriesWithLargestCities AS
	(SELECT
		cry.code AS code,
		cry.name AS country,
		cy.name AS city,
		cy.population AS population
	FROM
		city cy JOIN
		country cry ON cy.countrycode = cry.code
	ORDER BY
		cy.population DESC
	LIMIT
		100)

SELECT
	clc.country AS country,
	clc.city AS city,
	cl.language AS language
FROM
	countriesWithLargestCities clc JOIN
	countrylanguage cl ON clc.code = cl.countrycode
ORDER BY
	language

-- Which countries have the highest proportion of official language speakers? The lowest?
