/*
 * Background + Purpose: Protein is vital to Vegetarians, Vegans, and Pescatarians because the variety of proteins they can eat is limited as their diet
 * range is smaller than an Omnivore. Because of this, Impossible Foods needs to constantly monitor the average protein content of all of their
 * products to ensure that the average does not decline with the addition of new products. Ideally, Impossible Foods would create new products
 * with protein content higher than the average.
 * 
SELECT AVG(protein) AS avg_protein
FROM nutrition;

DELIMITER $$
CREATE PROCEDURE getAvgProtein()
BEGIN
	SELECT AVG(protein) AS avg_protein
	FROM nutrition;
END

DELIMITER ;

-- Execute the stored procedure
CALL getAvgProtein(); 
 * 
 */

SELECT *
FROM nutrition;

START TRANSACTION;

SET @item := 'Burger MADE from plants';

SELECT @itemID := item_number
FROM nutrition
WHERE item_number = 6;

# Step 1: Prepare
PREPARE insertProdName FROM '
INSERT INTO nutrition
SET item = ?;
';

# Step 2: Execute
EXECUTE insertProdName USING @item;

SELECT *
FROM nutrition 
WHERE item = @item;

# Step 3
DEALLOCATE PREPARE insertProdName;

-- --------------------

DELIMITER $$

DROP PROCEDURE IF EXISTS getAvgProtein$$

CREATE PROCEDURE getAvgProtein(IN inUpdateDateStart DATE, IN inUpdateDateEnd DATE, OUT outAvgProtein INT)
BEGIN
	
	SET @updateDateStart := inUpdateDateStart;
	SET @updateDateEnd := inUpdateDateEnd;

	SELECT AVG(protein) INTO outAvgProtein
	FROM nutrition
	WHERE last_update BETWEEN @updateDateStart AND @updateDateEnd;

	START TRANSACTION;
	ALTER TABLE nutrition
	ADD AvgProteincontent VARCHAR(10)
	SET AvgProteinContent = 
	(
		SELECT AVG(protein)
		FROM nutrition 
	);
	COMMIT;

END

DELIMITER ;

-- Execute the stored procedure
CALL getAvgProtein('2021-01-01',CURDATE(), @updatedAvgProtein);

-- SELECT @updatedAvgProtein;

SELECT *
FROM nutrition;