-- The county must have more than 500 dairy farms,
-- The county must have a workforce of at least 25,000 people (ages 18 to 64),
-- The county must have a population density of less than 150 people per square mile.

CREATE VIEW good_counties AS
	SELECT counties.gid, counties."name", counties.geom
	FROM counties
	WHERE counties.no_farms87 > 500
		AND counties.age_18_64 > 25000
		AND counties.pop_sqmile < 150
	
SELECT * FROM good_counties

-- The city's crime rate must be less than or equal to 0.02,
-- The city must have a university.
CREATE VIEW good_citites AS
	SELECT cities.gid, cities."name", cities.geom
	FROM cities
	JOIN good_counties
		ON ST_Intersects(good_counties.geom, cities.geom)
	WHERE cities.crime_inde <= 0.02
		AND cities.university > 0

SELECT * FROM good_citites

-- There must be an interstate road within 20 miles of the city.
CREATE VIEW good_interstates AS
SELECT DISTINCT good_citites.gid, good_citites."name", good_citites.geom
FROM interstates
JOIN good_citites
	ON ST_DWithin(good_citites.geom, interstates.geom, (20 * 5280))
WHERE interstates."type" ILIKE 'Interstate'

SELECT * FROM good_interstates

-- There must be a recreational area within 10 miles of the city.
CREATE VIEW good_recareas AS
SELECT DISTINCT good_interstates.gid, good_interstates."name", good_interstates.geom
FROM recareas
JOIN good_interstates
	ON ST_DWithin(good_interstates.geom, recareas.geom, (10 * 5280))

SELECT * FROM good_recareas

