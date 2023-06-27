--Average amount of bonuses on loyalty cards
WITH current_cards AS (
    SELECT
        balance,
        to_td
    FROM sd.card_hist
    WHERE to_td IS NULL)
SELECT
    avg(balance)
FROM current_cards