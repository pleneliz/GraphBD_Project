USE master;
GO
DROP DATABASE IF EXISTS HouseholdService;
GO
CREATE DATABASE HouseholdService;
GO
USE HouseholdService;
GO

-- Create schema for history tables
CREATE SCHEMA History;
GO

-- Create Enterprise table with temporal properties
CREATE TABLE Enterprise
(
    EnterpriseID int IDENTITY NOT NULL PRIMARY KEY CLUSTERED,
    EnterpriseName nvarchar(255) NOT NULL,
    Address nvarchar(255) NOT NULL,
    Phone nvarchar(15) NOT NULL
    CONSTRAINT CHK_Enterprise_Phone CHECK (LEN(Phone) = 13 AND Phone LIKE '8044 [0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'),
    
    StartDate datetime2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    EndDate datetime2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
    PERIOD FOR SYSTEM_TIME (StartDate, EndDate)
    )
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = History.EnterpriseHistory));
GO

-- Create Service table with temporal properties
CREATE TABLE Service
(
    ServiceID int IDENTITY NOT NULL PRIMARY KEY CLUSTERED,
    ServiceName nvarchar(100) NOT NULL,
    Price decimal(10, 2) NOT NULL,
    EnterpriseID int NOT NULL
    CONSTRAINT FK_Service_Enterprise FOREIGN KEY (EnterpriseID) REFERENCES Enterprise(EnterpriseID),
    
    StartDate datetime2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    EndDate datetime2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
    PERIOD FOR SYSTEM_TIME (StartDate, EndDate)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = History.ServiceHistory));
GO

-- Create Client table with temporal properties
CREATE TABLE Client
(
    ClientID int IDENTITY NOT NULL PRIMARY KEY CLUSTERED,
    FirstName nvarchar(100) NOT NULL,
    LastName nvarchar(100) NOT NULL,
    Email nvarchar(100) NOT NULL,
    Phone nvarchar(15) NOT NULL,
    CONSTRAINT UQ_Client_Email UNIQUE (Email),
    CONSTRAINT CHK_Client_Phone CHECK (LEN(Phone) = 13 AND Phone LIKE '8044 [0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'),
    
    StartDate datetime2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    EndDate datetime2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
    PERIOD FOR SYSTEM_TIME (StartDate, EndDate)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = History.ClientHistory));
GO

-- Create Order table with temporal properties
CREATE TABLE [Order]
(
    OrderID int IDENTITY NOT NULL PRIMARY KEY CLUSTERED,
    ClientID int NOT NULL
    CONSTRAINT FK_Order_Client FOREIGN KEY (ClientID) REFERENCES Client(ClientID),
    ServiceID int NOT NULL
    CONSTRAINT FK_Order_Service FOREIGN KEY (ServiceID) REFERENCES Service(ServiceID),
    OrderDate datetime NOT NULL,
    OrderStatus nvarchar(50) NOT NULL,
   
   StartDate datetime2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    EndDate datetime2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
    PERIOD FOR SYSTEM_TIME (StartDate, EndDate)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = History.OrderHistory));
GO

-- Create WorkingHours table with temporal properties
CREATE TABLE WorkingHours
(
    WorkingHoursID int IDENTITY NOT NULL PRIMARY KEY CLUSTERED,
    EnterpriseID int NOT NULL
    CONSTRAINT FK_WorkingHours_Enterprise FOREIGN KEY (EnterpriseID) REFERENCES Enterprise(EnterpriseID),
    DayOfWeek nvarchar(3) NOT NULL,
    StartTime time NOT NULL,
    EndTime time NOT NULL,
    
    StartDate datetime2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    EndDate datetime2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
    PERIOD FOR SYSTEM_TIME (StartDate, EndDate)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = History.WorkingHoursHistory));
GO

-- Data insertion date: 2022-01-10
INSERT INTO Enterprise (EnterpriseName, Address, Phone)
VALUES
('CleanMaster', 'г. Минск, пр-т Независимости, 10', '8044 123-45-67'),
('FixItPro', 'г. Гомель, ул. Советская, 5', '8044 234-56-78'),
('DomService', 'г. Брест, ул. Московская, 7', '8044 345-67-89'),
('Santehnik+','г. Витебск, пр-т Фрунзе, 4','8044 456-78-90'),
('Remont24', 'г. Гродно, ул. Кирова, 18','8044 567-89-01'),
('MoyDom', 'г. Могилев, ул. Первомайская, 25','8044 678-90-12'),
('Pomoshchnik', 'г. Минск, ул. Октябрьская, 31','8044 789-01-23'),
('MasterNaChas', 'г. Гомель, ул. Гоголя, 9','8044 890-12-34'),
('Domovenok', 'г. Брест, ул. Советская, 11','8044 901-23-45'),
('UyutService', 'г. Витебск, ул. Толстого, 16','8044 012-34-56');

-- Data insertion date: 2022-01-10
INSERT INTO Service (ServiceName, Price, EnterpriseID)
VALUES
('Uborka kvartiry', 50.00, 1),
('Remont santehniki', 75.00, 2),
('Melkiy remont', 60.00, 3),
('Ustanovka tehniki', 90.00, 4),
('Generalnaya uborka', 120.00, 1),
('Pokraska sten', 100.00, 5),
('Elektromontazh', 85.00, 6),
('Moyka okon', 40.00, 7),
('Chistka kovrov', 55.00, 8),
('Sborka mebeli', 70.00, 9);

-- Data insertion date: 2022-01-10
INSERT INTO Client (FirstName, LastName, Email, Phone)
VALUES
('Ivan', 'Ivanov', 'ivanov1@mail.com', '8044 111-11-11'),
('Petr', 'Petrov', 'petrov2@mail.com', '8044 222-22-22'),
('Sergey', 'Sergeev', 'sergeev3@mail.com', '8044 333-33-33'),
('Anna', 'Ivanova', 'anna4@mail.com', '8044 444-44-44'),
('Maria', 'Petrova', 'maria5@mail.com', '8044 555-55-55'),
('Elena', 'Smirnova', 'elena6@mail.com', '8044 666-66-66'),
('Oleg', 'Orlov', 'oleg7@mail.com', '8044 777-77-77'),
('Aleksey', 'Alekseev', 'aleksey8@mail.com', '8044 888-88-88'),
('Yuliya', 'Yureva', 'yulia9@mail.com', '8044 999-99-99'),
('Natalya', 'Nikolaeva', 'natasha10@mail.com', '8044 000-00-00');

-- Data insertion date: 2022-01-10
INSERT INTO [Order] (ClientID, ServiceID, OrderDate, OrderStatus)
VALUES
(1, 1, '2022-01-05', 'Completed'),
(1, 2, '2022-01-06', 'Completed'),
(2, 3, '2022-01-07', 'InProgress'),
(2, 4, '2022-01-08', 'Completed'),
(3, 5, '2022-01-09', 'Cancelled'),
(4, 6, '2022-01-10', 'Completed'),
(5, 7, '2022-01-10', 'Accepted'),
(6, 8, '2022-01-10', 'Accepted'),
(7, 9, '2022-01-10', 'Completed'),
(8, 10, '2022-01-10', 'Completed'),
(9, 1, '2022-01-11', 'InProgress'),
(10, 2, '2022-01-11', 'Cancelled'),
(1, 3, '2022-01-11', 'Completed'),
(2, 4, '2022-01-11', 'Completed'),
(3, 5, '2022-01-11', 'Completed'),
(4, 6, '2022-01-11', 'Completed'),
(5, 7, '2022-01-11', 'Completed'),
(6, 8, '2022-01-11', 'Completed'),
(7, 9, '2022-01-11', 'Accepted'),
(8, 10, '2022-01-11', 'InProgress'),
(9, 1, '2022-01-12', 'Completed'),
(10, 2, '2022-01-12', 'Completed'),
(1, 3, '2022-01-12', 'Completed'),
(2, 4, '2022-01-12', 'Completed'),
(3, 5, '2022-01-12', 'Cancelled'),
(4, 6, '2022-01-12', 'Accepted'),
(5, 7, '2022-01-12', 'Accepted'),
(6, 8, '2022-01-12', 'Completed'),
(7, 9, '2022-01-12', 'Completed'),
(8, 10, '2022-01-12', 'Completed');

-- Data insertion date: 2022-01-10
INSERT INTO WorkingHours (EnterpriseID, DayOfWeek, StartTime, EndTime)
VALUES
(1, 'Mon', '09:00', '18:00'),
(1, 'Tue', '09:00', '18:00'),
(1, 'Wed', '09:00', '18:00'),
(1, 'Thu', '09:00', '18:00'),
(1, 'Fri', '09:00', '17:00'),
(2, 'Mon', '10:00', '19:00'),
(2, 'Tue', '10:00', '19:00'),
(3, 'Mon', '08:00', '16:00'),
(4, 'Wed', '09:00', '17:00'),
(5, 'Fri', '09:00', '17:00');

-- Date: 2022-02-10
INSERT INTO Client (FirstName, LastName, Email, Phone) VALUES
('Maria', 'Ivanova', 'maria@mail.com', '8044 101-10-10'),
('Pavel', 'Grigorev', 'pavel@mail.com', '8044 102-20-20'),
('Alina', 'Petrova', 'alina@mail.com', '8044 103-30-30'),
('Sergey', 'Fomin', 'sergey@mail.com', '8044 104-40-40'),
('Ekaterina', 'Orlova', 'katerina@mail.com', '8044 105-50-50');

UPDATE Service SET Price = Price + 10 WHERE ServiceID IN (1, 2, 3);
UPDATE Client SET Phone = '8044 999-99-99' WHERE ClientID = 1;
UPDATE Enterprise SET Address = 'г. Минск, ул. Новая, 1' WHERE EnterpriseID = 1;

DELETE FROM [Order] WHERE OrderID IN (1, 2, 3);

-- Date: 2022-03-10
INSERT INTO Service (ServiceName, Price, EnterpriseID) VALUES
('Chistka kovrov', 75.00, 1),
('Remont tehniki', 120.00, 2),
('Nastroika Wi-Fi', 60.00, 3),
('Ustanovka dverej', 90.00, 1),
('Vyvoz musora', 50.00, 4);

UPDATE Service SET Price = Price * 1.05 WHERE ServiceID IN (4, 5, 6);
UPDATE Client SET Email = 'update1@mail.com' WHERE ClientID = 2;
UPDATE Enterprise SET Phone = '8044 000-00-00' WHERE EnterpriseID = 2;

DELETE FROM [Order] WHERE ClientID = 6;
DELETE FROM Client WHERE ClientID = 6;
DELETE FROM [Order] WHERE ClientID = 7;
DELETE FROM Client WHERE ClientID = 7;

-- Date: 2022-04-10
INSERT INTO [Order] (ClientID, ServiceID, OrderDate, OrderStatus) VALUES
(3, 1, '2022-04-01', 'Created'),
(4, 2, '2022-04-02', 'Confirmed'),
(5, 3, '2022-04-03', 'Completed'),
(3, 4, '2022-04-04', 'Created'),
(4, 5, '2022-04-05', 'Cancelled');

UPDATE [Order] SET OrderStatus = 'Completed' WHERE OrderID IN (4, 5);
UPDATE Client SET FirstName = 'Updated' WHERE ClientID = 3;
UPDATE Enterprise SET EnterpriseName = 'Company XX' WHERE EnterpriseID = 3;

DELETE FROM [Order] WHERE ServiceID IN (6,7);
DELETE FROM Service WHERE ServiceID IN (6, 7);

-- Date: 2022-05-10
INSERT INTO Enterprise (EnterpriseName, Address, Phone) VALUES
('Uyut Service', 'г. Минск, ул. Ветеранов, 15', '8044 333-22-11'),
('TehMaster', 'г. Гомель, ул. Победы, 9', '8044 334-22-11'),
('Domashniy komfort', 'г. Брест, ул. Ленина, 22', '8044 335-22-11'),
('Profi Chistota', 'г. Витебск, ул. Чехова, 10', '8044 336-22-11'),
('Vsyo dlya doma', 'г. Гродно, ул. Гоголя, 5', '8044 337-22-11');

UPDATE Enterprise SET Phone = '8044 777-77-77' WHERE EnterpriseID IN (2, 3);
UPDATE Service SET Price = Price + 20 WHERE ServiceID IN (9, 10);

DELETE FROM [Order] WHERE ClientID IN (9, 10);
DELETE FROM Client WHERE ClientID IN (9, 10);

-- Date: 2022-06-10
INSERT INTO WorkingHours (EnterpriseID, DayOfWeek, StartTime, EndTime) VALUES
(1, 'MON', '08:00', '17:00'),
(2, 'TUE', '09:00', '18:00'),
(3, 'WED', '10:00', '19:00'),
(4, 'THU', '08:00', '17:00'),
(5, 'FRI', '09:00', '18:00');

UPDATE Client SET LastName = 'CHANGED' WHERE ClientID IN (12, 13);
UPDATE [Order] SET OrderStatus = 'Archived' WHERE OrderID IN (6, 7);

DELETE FROM [Order] WHERE OrderID IN (8, 9, 10);

-- Date: 2022-07-10
INSERT INTO Client (FirstName, LastName, Email, Phone) VALUES
('Artur', 'Kovalyov', 'artur@mail.com', '8044 301-01-01'),
('Yuliya', 'Zaharova', 'yulia@mail.com', '8044 302-02-02'),
('Vasiliy', 'Zhukov', 'vasiliy@mail.com', '8044 303-03-03'),
('Galina', 'Kirillova', 'galina@mail.com', '8044 304-04-04'),
('Maksim', 'Martynov', 'maxim@mail.com', '8044 305-05-05');

UPDATE Enterprise SET Address = 'г. Минск, ул. Первая, 10' WHERE EnterpriseID IN (4,5);
UPDATE Client SET Email = 'client_updated@mail.com' WHERE ClientID = 14;
UPDATE Service SET ServiceName = 'Updated service' WHERE ServiceID = 11;

DELETE FROM [Order] WHERE ServiceID IN (9, 10);
DELETE FROM Service WHERE ServiceID IN (9,10);

-- Date: 2022-08-10
INSERT INTO Service (ServiceName, Price, EnterpriseID) VALUES
('Remont santehniki', 85.00, 2),
('Mytie okon', 55.00, 3),
('Sborka mebeli', 100.00, 1),
('Remont kryshi', 200.00, 4),
('Uborka kvartir', 75.00, 5);

UPDATE Client SET Phone = '8044 888-88-88' WHERE ClientID IN (15,16,17);
UPDATE Enterprise SET EnterpriseName = 'Updated Service' WHERE EnterpriseID = 3;

DELETE FROM Client WHERE ClientID IN (12,13,14);

-- Date: 2022-09-10
INSERT INTO [Order] (ClientID, ServiceID, OrderDate, OrderStatus) VALUES
(15, 12, '2022-09-01', 'Created'),
(16, 13, '2022-09-02', 'Completed'),
(17, 14, '2022-09-03', 'Cancelled'),
(18, 15, '2022-09-04', 'Created'),
(19, 16, '2022-09-05', 'Confirmed');

UPDATE [Order] SET OrderStatus = 'Archived' WHERE OrderID IN (11,12,13);
UPDATE Enterprise SET Address = 'г. Минск, ул. Центральная, 5' WHERE EnterpriseID = 2;

DELETE FROM [Order] WHERE OrderID IN (14,15,16);

-- Date: 2022-10-10
INSERT INTO WorkingHours (EnterpriseID, DayOfWeek, StartTime, EndTime) VALUES
(1, 'SAT', '10:00', '15:00'),
(2, 'SUN', '11:00', '16:00'),
(3, 'MON', '09:00', '18:00'),
(4, 'TUE', '08:30', '17:30'),
(5, 'WED', '10:00', '19:00');

UPDATE WorkingHours SET StartTime = '09:00' WHERE WorkingHoursID IN (1,2,3);
UPDATE Service SET Price = Price * 0.95 WHERE ServiceID IN (12,13);

DELETE FROM [Service] WHERE EnterpriseID IN (6,7);
DELETE FROM Enterprise WHERE EnterpriseID IN (6,7);

-- Date: 2022-11-10
INSERT INTO Enterprise (EnterpriseName, Address, Phone) VALUES
('Sluzhba Byta', 'г. Минск, ул. Ломоносова, 7', '8044 601-01-01'),
('Hozyain doma', 'г. Гомель, ул. Суворова, 11', '8044 602-02-02'),
('RemBytService', 'г. Брест, ул. Карбышева, 3', '8044 603-03-03'),
('ElektroSila', 'г. Витебск, ул. Пушкина, 14', '8044 604-04-04'),
('DomService', 'г. Гродно, ул. Школьная, 6', '8044 605-05-05');

UPDATE Client SET LastName = 'NEW' WHERE ClientID IN (18,19);
UPDATE Service SET ServiceName = 'Updated position' WHERE ServiceID = 14;

DELETE FROM [Order] WHERE ClientID IN (15,16);
DELETE FROM Client WHERE ClientID IN (15,16);

-- Date: 2022-12-10
INSERT INTO Client (FirstName, LastName, Email, Phone) VALUES
('Irina', 'Malysheva', 'irina@mail.com', '8044 901-11-11'),
('Anton', 'Loginov', 'anton@mail.com', '8044 902-22-22'),
('Svetlana', 'Bykova', 'svetlana@mail.com', '8044 903-33-33'),
('Grigory', 'Romanov', 'grigory@mail.com', '8044 904-44-44'),
('Artem', 'Yurev', 'artem@mail.com', '8044 905-55-55');

UPDATE Enterprise SET Address = 'г. Минск, ул. Финальная, 1' WHERE EnterpriseID IN (9,10);
UPDATE Service SET Price = Price + 15 WHERE ServiceID IN (15,16);

DELETE FROM [Order] WHERE OrderID IN (17,18,19);

