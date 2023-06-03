CREATE TABLE person_audit
( 
  created timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  type_event char(1) DEFAULT 'I' CONSTRAINT ch_type_event CHECK(type_event IN ('I', 'U', 'D')),
  row_id bigint,
  name varchar,
  age integer,
  gender varchar,
  address varchar
  );

CREATE OR REPLACE FUNCTION fnc_trg_person_insert_audit()
  RETURNS trigger AS
$trg_person_insert_audit$
BEGIN
 INSERT INTO "person_audit" ("created", "type_event", "row_id", "name", "age","gender" ,"address")
VALUES(CURRENT_TIMESTAMP AT TIME ZONE 'Europe/Moscow', 'I', NEW."id",NEW."name",NEW."age",NEW."gender", NEW."address");
RETURN NEW;
END;
$trg_person_insert_audit$
LANGUAGE 'plpgsql';

CREATE TRIGGER trg_person_insert_audit
  AFTER INSERT
  ON "person"
  FOR EACH ROW
  EXECUTE PROCEDURE fnc_trg_person_insert_audit();

INSERT INTO person(id, name, age, gender, address)
VALUES (10, 'Damir', 22, 'male', 'Irkutsk');
