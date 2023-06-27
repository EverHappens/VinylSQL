--Top 5 most expensive products
SELECT
    rank() OVER (ORDER BY pr.price DESC),
    al.author_name,
    al.album_name,
    la.label_name,
    pr.price,
    la.country,
    pr.release_date,
    al.genre
FROM sd.product pr
JOIN sd.album al ON pr.album_id = al.album_id
JOIN sd.label la ON pr.label_id = la.label_id
LIMIT 5
