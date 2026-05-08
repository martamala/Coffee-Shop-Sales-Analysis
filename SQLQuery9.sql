USE CoffeeShopDB;
GO

SELECT TOP 10 * FROM Transactions_Clean;

USE CoffeeShopDB;
GO


USE CoffeeShopDB;
GO

SELECT 
    product_type, 
    SUM(TRY_CAST(REPLACE(unit_price, ',', '.') AS FLOAT) * TRY_CAST(transaction_qty AS INT)) AS Realny_Zysk
FROM Transactions_Final
GROUP BY product_type
HAVING SUM(TRY_CAST(REPLACE(unit_price, ',', '.') AS FLOAT)) IS NOT NULL
ORDER BY Realny_Zysk DESC;

SELECT 
    DATEPART(HOUR, TRY_CAST(transaction_time AS TIME)) AS Godzina,
    SUM(TRY_CAST(REPLACE(unit_price, ',', '.') AS FLOAT) * TRY_CAST(transaction_qty AS INT)) AS Utarg
FROM Transactions_Final
GROUP BY DATEPART(HOUR, TRY_CAST(transaction_time AS TIME))
ORDER BY Utarg DESC;

SELECT 
    AVG(TRY_CAST(REPLACE(unit_price, ',', '.') AS FLOAT) * TRY_CAST(transaction_qty AS INT)) AS Srednie_Zamowienie
FROM Transactions_Final;

SELECT 
    DATENAME(WEEKDAY, TRY_CAST(transaction_date AS DATE)) AS Dzien_Tygodnia,
    SUM(TRY_CAST(REPLACE(unit_price, ',', '.') AS FLOAT) * TRY_CAST(transaction_qty AS INT)) AS Utarg
FROM Transactions_Final
GROUP BY DATENAME(WEEKDAY, TRY_CAST(transaction_date AS DATE))
ORDER BY Utarg DESC;

SELECT TOP 20 transaction_date
FROM Transactions_Final
WHERE TRY_CAST(transaction_date AS DATE) IS NULL;

SELECT 
    DATENAME(WEEKDAY, TRY_CAST(REPLACE(transaction_date, '.', '-') AS DATE)) AS Dzien_Tygodnia,
    SUM(TRY_CAST(REPLACE(unit_price, ',', '.') AS FLOAT) * TRY_CAST(transaction_qty AS INT)) AS Utarg
FROM Transactions_Final
WHERE TRY_CAST(REPLACE(transaction_date, '.', '-') AS DATE) IS NOT NULL
GROUP BY DATENAME(WEEKDAY, TRY_CAST(REPLACE(transaction_date, '.', '-') AS DATE))
ORDER BY Utarg DESC;

SELECT 
    store_location, 
    SUM(TRY_CAST(REPLACE(unit_price, ',', '.') AS FLOAT) * TRY_CAST(transaction_qty AS INT)) AS Calkowity_Utarg,
    COUNT(transaction_id) AS Liczba_Klientow
FROM Transactions_Final
GROUP BY store_location
ORDER BY Calkowity_Utarg DESC;

SELECT 
    store_location, 
    COUNT(*) AS Liczba_Sprzedazy 
FROM Transactions_Clean 
GROUP BY store_location
ORDER BY Liczba_Sprzedazy DESC; -- dodajemy sortowanie, żeby lider był na górze

SELECT DISTINCT product_type 
FROM Transactions_Clean 
WHERE product_type LIKE '%Coffee%';

SELECT DISTINCT product_type, unit_price
FROM Transactions_Clean
WHERE product_type LIKE '%Coffee%' AND unit_price > 3.00

SELECT DISTINCT
    product_type,
    unit_price,
    CASE 
        WHEN unit_price < 3.00 THEN 'Tania Kawa'
        WHEN unit_price BETWEEN 3.00 AND 4.00 THEN 'Standard'
        ELSE 'Produkt Premium'
    END AS Segment_Cenowy
FROM Transactions_Clean
WHERE product_category = 'Coffee';

SELECT 
    CASE 
        WHEN unit_price < 3.00 THEN 'Tania Kawa'
        WHEN unit_price BETWEEN 3.00 AND 4.00 THEN 'Standard'
        ELSE 'Produkt Premium'
    END AS Segment_Cenowy,
    SUM(Revenue) AS Razem_Przychód
FROM Transactions_Clean
WHERE product_category = 'Coffee'
GROUP BY 
    CASE 
        WHEN unit_price < 3.00 THEN 'Tania Kawa'
        WHEN unit_price BETWEEN 3.00 AND 4.00 THEN 'Standard'
        ELSE 'Produkt Premium'
    END;

    SELECT 
    CASE 
        WHEN unit_price < 3.00 THEN 'Tania Kawa'
        WHEN unit_price BETWEEN 3.00 AND 4.00 THEN 'Standard'
        ELSE 'Produkt Premium'
    END AS Segment_Cenowy,
    -- Liczymy przychód sami: cena * ilość
    SUM(unit_price * transaction_qty) AS Razem_Przychód
FROM Transactions_Clean
WHERE product_category = 'Coffee'
GROUP BY 
    CASE 
        WHEN unit_price < 3.00 THEN 'Tania Kawa'
        WHEN unit_price BETWEEN 3.00 AND 4.00 THEN 'Standard'
        ELSE 'Produkt Premium'
    END;

    SELECT 
    product_type, 
    SUM(unit_price * transaction_qty) AS Zysk_Premium
FROM Transactions_Clean 
WHERE unit_price > 4 
GROUP BY product_type 
ORDER BY Zysk_Premium DESC;