/*

The purpose of a trigger (overall) is to maintain data integrity, enforce business rules, for data validation, update denormalized (duplicated) data,
and audit logs. The trigger runs when a table is modified through an INSERT, UPDATE, or DELETE, which will trigger the trigger. 

This trigger will store previous ("old") nutritional data and updated ("new") nutritional data that is being changed in the nutrion table, 
so we constantly have the ability to compare our modified product nutrition information to our unmodified product nutrition data. 
This will allow us to maintain the nutritional benefits of our current product offerings.   

CREATE TABLE nutrition_facts_updates (
  item_number SMALLINT,
  item VARCHAR(50),
  brand VARCHAR(20),
  old_calories SMALLINT,
  new_calories SMALLINT,
  old_total_fat SMALLINT,
  new_total_fat SMALLINT,
  old_total_carbohydrates SMALLINT,
  new_total_carbohydrates SMALLINT,
  old_total_sugars SMALLINT,
  new_total_sugars SMALLINT,
  old_protein SMALLINT,
  new_protein SMALLINT,
  updated_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
  -- PRIMARY KEY  (item_number)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

DROP TABLE nutrition_facts_updates;
*/


DELIMITER $$
CREATE TRIGGER nutrition_facts_updates
	AFTER UPDATE ON nutrition
	FOR EACH ROW
BEGIN
	INSERT INTO nutrition_facts_updates 
	(item_number, item, brand, old_calories, new_calories, old_total_fat, new_total_fat, old_total_carbohydrates, new_total_carbohydrates, old_total_sugars, new_total_sugars, old_protein, new_protein, serving_size, serving_size_unit)
	VALUES 
	(item_number(), OLD.item, OLD.brand, OLD.calories, NEW.calories, OLD.total_fat, NEW.total_fat, OLD.total_carbohydrates, NEW.total_carbohydrates, OLD.total_sugars, NEW.total_sugars, OLD.protein, NEW.protein, OLD.serving_size, OLD.serving_size_unit)
END$$
DELIMITER ;

SHOW TRIGGERS;

UPDATE nutrition  
SET item = 'Burger made from plants'
WHERE item_number = 3;
