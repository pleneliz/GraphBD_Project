
--4. Вывести состояние всех таблиц базы данных по состоянию на последний день каждого квартала 2022 года в 23:59:59.9999999
-- Дата: 2022-03-31 23:59:59.9999999

-- 1 квартал
SELECT '2022-03-31' AS PeriodEnd, * FROM Enterprise FOR SYSTEM_TIME AS OF '2022-03-31T23:59:59.9999999';
SELECT '2022-03-31' AS PeriodEnd, * FROM Service FOR SYSTEM_TIME AS OF '2022-03-31T23:59:59.9999999';
SELECT '2022-03-31' AS PeriodEnd, * FROM Client FOR SYSTEM_TIME AS OF '2022-03-31T23:59:59.9999999';
SELECT '2022-03-31' AS PeriodEnd, * FROM [Order] FOR SYSTEM_TIME AS OF '2022-03-31T23:59:59.9999999';
SELECT '2022-03-31' AS PeriodEnd, * FROM WorkingHours FOR SYSTEM_TIME AS OF '2022-03-31T23:59:59.9999999';

-- 2 квартал
SELECT '2022-06-30' AS PeriodEnd, * FROM Enterprise FOR SYSTEM_TIME AS OF '2022-06-30T23:59:59.9999999';
SELECT '2022-06-30' AS PeriodEnd, * FROM Service FOR SYSTEM_TIME AS OF '2022-06-30T23:59:59.9999999';
SELECT '2022-06-30' AS PeriodEnd, * FROM Client FOR SYSTEM_TIME AS OF '2022-06-30T23:59:59.9999999';
SELECT '2022-06-30' AS PeriodEnd, * FROM [Order] FOR SYSTEM_TIME AS OF '2022-06-30T23:59:59.9999999';
SELECT '2022-06-30' AS PeriodEnd, * FROM WorkingHours FOR SYSTEM_TIME AS OF '2022-06-30T23:59:59.9999999';

-- 3 квартал
SELECT '2022-09-30' AS PeriodEnd, * FROM Enterprise FOR SYSTEM_TIME AS OF '2022-09-30T23:59:59.9999999';
SELECT '2022-09-30' AS PeriodEnd, * FROM Service FOR SYSTEM_TIME AS OF '2022-09-30T23:59:59.9999999';
SELECT '2022-09-30' AS PeriodEnd, * FROM Client FOR SYSTEM_TIME AS OF '2022-09-30T23:59:59.9999999';
SELECT '2022-09-30' AS PeriodEnd, * FROM [Order] FOR SYSTEM_TIME AS OF '2022-09-30T23:59:59.9999999';
SELECT '2022-09-30' AS PeriodEnd, * FROM WorkingHours FOR SYSTEM_TIME AS OF '2022-09-30T23:59:59.9999999';

-- 4 квартал
SELECT '2022-12-31' AS PeriodEnd, * FROM Enterprise FOR SYSTEM_TIME AS OF '2022-12-31T23:59:59.9999999';
SELECT '2022-12-31' AS PeriodEnd, * FROM Service FOR SYSTEM_TIME AS OF '2022-12-31T23:59:59.9999999';
SELECT '2022-12-31' AS PeriodEnd, * FROM Client FOR SYSTEM_TIME AS OF '2022-12-31T23:59:59.9999999';
SELECT '2022-12-31' AS PeriodEnd, * FROM [Order] FOR SYSTEM_TIME AS OF '2022-12-31T23:59:59.9999999';
SELECT '2022-12-31' AS PeriodEnd, * FROM WorkingHours FOR SYSTEM_TIME AS OF '2022-12-31T23:59:59.9999999';




--5. Вывести состояние всех таблиц базы данных за лето 2022 года.


-- Состояние таблицы Enterprise за лето 2022
SELECT 'Enterprise' AS TableName, * 
FROM Enterprise
FOR SYSTEM_TIME FROM '2022-06-01T00:00:00.0000000' TO '2022-08-31T23:59:59.9999999';

-- Состояние таблицы Service за лето 2022
SELECT 'Service' AS TableName, * 
FROM Service
FOR SYSTEM_TIME FROM '2022-06-01T00:00:00.0000000' TO '2022-08-31T23:59:59.9999999';

-- Состояние таблицы Client за лето 2022
SELECT 'Client' AS TableName, * 
FROM Client
FOR SYSTEM_TIME FROM '2022-06-01T00:00:00.0000000' TO '2022-08-31T23:59:59.9999999';

-- Состояние таблицы Order за лето 2022
SELECT '[Order]' AS TableName, * 
FROM [Order]
FOR SYSTEM_TIME FROM '2022-06-01T00:00:00.0000000' TO '2022-08-31T23:59:59.9999999';

-- Состояние таблицы WorkingHours за лето 2022
SELECT 'WorkingHours' AS TableName, * 
FROM WorkingHours
FOR SYSTEM_TIME FROM '2022-06-01T00:00:00.0000000' TO '2022-08-31T23:59:59.9999999';





--6. Вывести строки, которые были вставлены и удалены за третий квартал 2022 года.
-- Enterprise
SELECT 'Enterprise' AS TableName, * 
FROM History.EnterpriseHistory
WHERE EndDate BETWEEN '2022-07-01' AND '2022-09-30T23:59:59.9999999';

-- Service
SELECT 'Service' AS TableName, * 
FROM History.ServiceHistory
WHERE EndDate BETWEEN '2022-07-01' AND '2022-09-30T23:59:59.9999999';

-- Client
SELECT 'Client' AS TableName, * 
FROM History.ClientHistory
WHERE EndDate BETWEEN '2022-07-01' AND '2022-09-30T23:59:59.9999999';

-- Order
SELECT '[Order]' AS TableName, * 
FROM History.OrderHistory
WHERE EndDate BETWEEN '2022-07-01' AND '2022-09-30T23:59:59.9999999';

-- WorkingHours
SELECT 'WorkingHours' AS TableName, * 
FROM History.WorkingHoursHistory
WHERE EndDate BETWEEN '2022-07-01' AND '2022-09-30T23:59:59.9999999';




--7. Создать любой запрос с несколькими темпоральными таблицами, используя JOIN.
SELECT 
    c.ClientID,
    c.FirstName,
    c.LastName,
    o.OrderID,
    o.OrderDate
FROM 
    Client FOR SYSTEM_TIME AS OF '2022-05-15' AS c
JOIN 
    [Order] FOR SYSTEM_TIME AS OF '2022-05-15' AS o
    ON c.ClientID = o.ClientID;
    