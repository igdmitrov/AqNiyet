CREATE VIEW cityview AS
SELECT *
FROM city
WHERE exists (SELECT 1 FROM advert WHERE advert.city_id = city.id AND advert.enabled = true)
ORDER BY city.order desc