DROP FUNCTION fnc_person_visits_and_eats_on_date(varchar, numeric, date);

CREATE FUNCTION fnc_person_visits_and_eats_on_date(IN pperson varchar DEFAULT 'Dmitriy',
                                                   IN pprice numeric DEFAULT 500,
                                                   IN pdate date DEFAULT '2022-01-08')
RETURNS TABLE (name varchar)
AS 
$$
BEGIN
    RETURN QUERY (
        SELECT DISTINCT pi.name
        FROM person_visits pv
            JOIN pizzeria pi ON pv.pizzeria_id = pi.id
        WHERE pv.visit_date = pdate 
              AND person_id IN (SELECT p.id 
                                FROM person p
                                WHERE p.name = pperson)
        INTERSECT 
        SELECT DISTINCT pi2.name
        FROM menu m
            JOIN pizzeria pi2 ON m.pizzeria_id = pi2.id
        WHERE m.price < pprice
    );
END;
$$
LANGUAGE plpgsql;

SELECT *
FROM fnc_person_visits_and_eats_on_date(pprice := 800);

SELECT *
FROM fnc_person_visits_and_eats_on_date(pperson := 'Anna',pprice := 1300,pdate := '2022-01-01');