-- Crea e popola le tabelle utilizzando dati a tua discrezione (sono sufficienti pochi record per tabella; riporta le query utilizzate).
CREATE TABLE Product (
    id_product INT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(100),
    price DECIMAL(10, 2)
);

CREATE TABLE Region (
    id_region INT PRIMARY KEY,
    name VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE Sales (
    id_sales INT PRIMARY KEY,
    id_product INT,
    id_region INT,
    sale_date DATE,
    quantity INT,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (id_product) REFERENCES Product(id_product),
    FOREIGN KEY (id_region) REFERENCES Region(id_region)
);

-- Inserimento dei dati nella tabella Product
INSERT INTO Product (Id_Product, Name, Category) VALUES
(1, 'barbie', 'bambole'),
(2, 'lego', 'costruzioni'),
(3, 'macchinine', 'veicoli'),
(4, 'cucinina', 'casa'),
(5, 'palla', 'giochi sportivi');

-- Inserimento dei dati nella tabella Region
INSERT INTO Region (ID_Region, Name) VALUES
(1, 'europa'),
(2, 'oriente'),
(3, 'occidente');

-- Inserimento dei dati nella tabella Sales
INSERT INTO Sales (Id_Sales, sale_Date, Quantity, Total_amount, ID_Product, ID_Region) VALUES
(1, '2024-06-17', 5, 23.00, 1, 1),
(2, '2024-05-16', 3, 60.00, 2, 1),
(3, '2024-08-11', 2, 20.00, 3, 2),
(4, '2024-07-04', 1, 200.00, 4, 2),
(5, '2024-01-22', 7, 35.00, 5, 3);

-- es 1  Verificare che i campi definiti come PK siano univoci
SELECT Id_Product, COUNT(*)
FROM Product
GROUP BY Id_Product
HAVING COUNT(*) > 1;

-- 
SELECT Id_region, COUNT(*)
FROM region
GROUP BY Id_region
HAVING COUNT(*) > 1;

-- 
SELECT Id_sales, COUNT(*)
FROM sales
GROUP BY Id_sales
HAVING COUNT(*) > 1;

-- es 2 Esporre l’elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno
SELECT 
    p.Id_Product,
    p.Name,
    YEAR(s.sale_Date) AS Year,
    SUM(s.Quantity * s.total_amount) AS fatturato  
FROM 
    Sales s
JOIN 
    Product p ON s.ID_Product = p.Id_Product
GROUP BY 
    p.Id_Product, p.Name, YEAR(s.sale_Date)
ORDER BY 
    p.Id_Product, Year;
    
-- es 3 Esporre il fatturato totale per stato per anno. Ordina il risultato per data e per fatturato decrescente.     
    SELECT
    r.Name,
    YEAR(s.sale_Date) AS Year,
    SUM(s.Quantity * s.total_amount) AS fatturato
FROM
    Sales s
JOIN
    Region r ON s.ID_Region = r.ID_Region
GROUP BY
    r.Name, YEAR(s.sale_Date)
ORDER BY
    Year ASC, fatturato DESC;


-- es 4 Rispondere alla seguente domanda: qual è la categoria di articoli maggiormente richiesta dal mercato?
SELECT
    p.Category,
    SUM(s.Quantity *s.total_amount) AS fatturato
FROM
    Sales s
JOIN
    Product p ON s.ID_Product = p.Id_Product
GROUP BY
    p.Category
ORDER BY
    fatturato DESC
LIMIT 1;

-- es 5 Rispondere alla seguente domanda: quali sono, se ci sono, i prodotti invenduti? Proponi due approcci risolutivi differenti
SELECT
    p.Id_Product,
    p.Name,
    p.Category
FROM
    Product p
LEFT JOIN
    Sales s ON p.Id_Product = s.ID_Product
WHERE
    s.ID_Product IS NULL;
    
    SELECT
    p.Id_Product,
    p.Name,
    p.Category
FROM
    Product p
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Sales s
        WHERE s.ID_Product = p.Id_Product
    );
    
    -- es 6 Esporre l’elenco dei prodotti con la rispettiva ultima data di vendita (la data di vendita più recente
    SELECT
    p.Id_Product,
    p.Name,
    p.Category,
    MAX(s.sale_date) AS ultima_vendita
FROM
    Product p
LEFT JOIN
    Sales s ON p.Id_Product = s.ID_Product
GROUP BY
    p.Id_Product, p.Name, p.Category
ORDER BY
    p.Id_Product;




