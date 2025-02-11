SELECT
    *
FROM
    Customer;

SELECT
    c.Address,
    c.City
FROM
    Customer c;

SELECT
    e.EmployeeId,
    e.FirstName,
    e.LastName
FROM
    Employee e;

SELECT
    i.InvoiceId,
    i.Total
FROM
    Invoice i;

-- List all customers. Show only the CustomerId, FirstName and LastName columns
SELECT
    c.CustomerId,
    c.FirstName,
    c.LastName
FROM
    Customer c;
-- List customers in the United Kingdom  
SELECT
    *
FROM
    Customer c
WHERE 
    c.Country = 'United Kingdom';
-- List customers whose first names begins with an A.
-- Hint: use LIKE and the % wildcard
SELECT
    *
FROM
    Customer c
WHERE
    FirstName LIKE 'a%';
-- List Customers with an apple email address
SELECT
    *
FROM
    Customer c
WHERE
    c.Email LIKE '%@apple%';
-- Which customers have the initials LK?
SELECT
    *
FROM
    Customer c
WHERE
    c.FirstName LIKE 'L%'
    AND
    c.LastName LIKE 'K%';

-- Which are the corporate customers i.e. those with a value, not NULL, in the Company column?
SELECT
    *
FROM
    Customer c
WHERE
    c.Company IS NOT NULL;
-- How many customers are in each country.  Order by the most popular country first.
SELECT
    c.Country,
    COUNT(*) AS [No. of Customers]
FROM
    Customer c
GROUP BY 
    c.Country
ORDER BY 
    [No. of Customers] DESC;
-- When was the oldest employee born?  Who is that?

SELECT
    MIN(e.BirthDate)
FROM
    Employee e

-- List the 10 latest invoices. Include the InvoiceId, InvoiceDate and Total
-- Then  also include the customer full name (first and last name together)



-- List the customers who have spent more than £45

SELECT
    c.FirstName,
    c.LastName
FROM
    Customer c
    INNER JOIN
    Invoice i
    ON 
        c.CustomerId = i.CustomerId
GROUP BY 
    c.FirstName,
    c.LastName
HAVING
        SUM(i.Total) > 45;

SELECT
    *
FROM
    (SELECT
        i.CustomerId
    FROM
        Invoice i
    GROUP BY 
    i.CustomerId
    HAVING
    SUM(i.Total) > 45) AS TopCost
    JOIN
    Customer c ON c.CustomerId = TopCost.CustomerId

-- implement as a table subquery

SELECT
    c.FirstName,
    c.LastName,
    topCust.InvoiceTotal
FROM
    Customer c JOIN
    (SELECT
        i.CustomerId,
        SUM(i.Total) AS InvoiceTotal
    FROM
        Invoice i
    GROUP BY 
        i.CustomerId
    HAVING  
        SUM(i.Total) > 45) topCust
    ON 
        c.CustomerId = topCust.CustomerId
;

-- implement as a CTE

WITH
    cte
    AS
    (
        SELECT
            i.CustomerId,
            SUM(i.Total) AS InvoiceTotal
        FROM
            Invoice i
        GROUP BY 
            i.CustomerId
        HAVING  
            SUM(i.Total) > 45
    )
SELECT
    c.FirstName,
    c.LastName,
    cte.InvoiceTotal
FROM
    Customer c
    JOIN cte ON c.CustomerId = cte.CustomerId
;

--implement as temporary tables

SELECT
    i.CustomerId
    ,
    SUM(i.Total) AS InvoiceTotal
INTO #TopCust
-- temporary table, kept as a variable to use later in code
FROM
    Invoice i
GROUP BY 
    i.CustomerId
HAVING  
    SUM(i.Total) > 45

SELECT
    c.FirstName,
    c.LastName,
    #TopCust.InvoiceTotal
FROM
    #TopCust -- from temporary table
JOIN 
    Customer c ON #TopCust.CustomerId = c.CustomerId
;

-- List the City, CustomerId and LastName of all customers in Paris and London,
-- and the Total of their invoices

SELECT
    c.City,
    c.CustomerId,
    c.LastName,
    SUM(i.Total) AS TotalOfInvoices
FROM
    Customer c
    INNER JOIN
    Invoice i
    ON 
        c.CustomerId = i.CustomerId
WHERE
    c.City = 'London' OR c.City = 'Paris'
GROUP BY
    c.City,
    c.CustomerId,
    c.LastName;

SELECT
    *
FROM
    (SELECT
        c.City,
        c.CustomerId,
        c.LastName
    FROM
        Customer c) AS CityCustomers
    JOIN
    Invoice i
    ON 
    CityCustomers.CustomerId = i.CustomerId
WHERE
    CityCustomers.City = 'Paris' OR CityCustomers.City = 'London'