use nexacommerce;

-- Commandes Orphelines sans client
select
o.order_id,
o.customer_id,
o.total_amount_xaf,
c.name as nom_client -- sera NULL si orphelin
from orders as o
left join customers as c
on o.customer_id = c.customer_id
where c.customer_id is null 
order by o.order_id;

-- les montants négatifs ou nuls
select * 
from orders 
where total_amount_xaf < 0 or total_amount_xaf = 0
order by total_amount_xaf asc;

-- les doublons 
select
c1.customer_id as num_1,
c2.customer_id as num_2,
c1.name,
c1.city,
c1.phone as tel_1,
c2.phone as tel_2
from customers as c1
inner join customers as c2
on LOWER(TRIM(c1.name)) = LOWER(TRIM(c2.name))
and LOWER(TRIM(c1.city)) = LOWER(TRIM(c2.city))
and c1.customer_id < c2.customer_id 
order by c1.name;

-- CTE ca mensuel par ville
WITH ca_mensuel AS (
    SELECT
        YEAR(
            CASE
                WHEN order_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
                    THEN STR_TO_DATE(order_date, '%Y-%m-%d')
                WHEN order_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}'
                    THEN STR_TO_DATE(order_date, '%d/%m/%Y')
                ELSE NULL
            END
        ) AS annee,
        MONTH(
            CASE
                WHEN order_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
                    THEN STR_TO_DATE(order_date, '%Y-%m-%d')
                WHEN order_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}'
                    THEN STR_TO_DATE(order_date, '%d/%m/%Y')
                ELSE NULL
            END
        ) AS mois,
        SUM(total_amount_xaf) AS ca_mois
    FROM orders
    WHERE total_amount_xaf > 0
    GROUP BY annee, mois
    HAVING annee IS NOT NULL  -- exclut les dates non parsées
)
SELECT *
FROM ca_mensuel
ORDER BY annee DESC, mois DESC
LIMIT 12;



-- les KPIs
create view  v_order_kpis as
select
    city,
    DATE_FORMAT(order_date, '%Y-%m') as mois,
    COUNT(*) as total_commandes,
    ROUND(SUM(status = 'livré') / COUNT(*) * 100, 2) as taux_livraison_pct,
    ROUND(AVG(total_amount_xaf), 2) as panier_moyen,
    ROUND(SUM(status = 'annulé') / COUNT(*) * 100, 2) as taux_annulation_pct
from orders
group by city, DATE_FORMAT(order_date, '%Y-%m');




-- Livreur dont le temps s'est dégradé
with monthly_avg as (
    select
        courier_id,
        DATE_FORMAT(order_date, '%Y-%m') AS mois,
        AVG(delivery_time_min) AS temps_moyen
    from orders
    group by  courier_id, DATE_FORMAT(order_date, '%Y-%m')
),
avec_lag as (
    select
        courier_id,
        mois,
        temps_moyen,
        LAG(temps_moyen) over (PARTITION BY courier_id ORDER BY mois) AS mois_precedent
    from monthly_avg
)
SELECT *,
    ROUND(temps_moyen - mois_precedent, 2) AS degradation
FROM avec_lag
WHERE temps_moyen > mois_precedent
ORDER BY degradation DESC;



-- EXPLAIN sur la requête CA mensuel
EXPLAIN SELECT
    YEAR(
        CASE
            WHEN order_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
                THEN STR_TO_DATE(order_date, '%Y-%m-%d')
            WHEN order_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}'
                THEN STR_TO_DATE(order_date, '%d/%m/%Y')
            ELSE NULL
        END
    ) AS annee,
    MONTH(
        CASE
            WHEN order_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
                THEN STR_TO_DATE(order_date, '%Y-%m-%d')
            WHEN order_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}'
                THEN STR_TO_DATE(order_date, '%d/%m/%Y')
            ELSE NULL
        END
    ) AS mois,
    SUM(total_amount_xaf) AS ca_mois
FROM orders
WHERE total_amount_xaf > 0
GROUP BY annee, mois;


explain select
c1.customer_id as num_1,
c2.customer_id as num_2,
c1.name,
c1.city,
c1.phone as tel_1,
c2.phone as tel_2
from customers as c1
inner join customers as c2
on LOWER(TRIM(c1.name)) = LOWER(TRIM(c2.name))
and LOWER(TRIM(c1.city)) = LOWER(TRIM(c2.city))
and c1.customer_id < c2.customer_id 
order by c1.name;


