CREATE VIEW categoryview AS
SELECT *
FROM category
WHERE exists (SELECT 1 FROM advert WHERE advert.category_id = category.id AND advert.enabled = true)
ORDER BY category.order desc