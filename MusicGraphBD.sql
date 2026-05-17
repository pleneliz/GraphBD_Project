USE master;
GO
DROP DATABASE IF EXISTS MusicLabelDB;
GO
CREATE DATABASE MusicLabelDB;
GO

USE MusicLabelDB;
GO

CREATE TABLE Labels (
    LabelId INT PRIMARY KEY,
    Name NVARCHAR(100),
    Genre NVARCHAR(50)
) AS NODE;

CREATE TABLE Contracts (
    ContractId INT PRIMARY KEY,
    Title NVARCHAR(200),
    RoyaltyRate INT
) AS NODE;

CREATE TABLE Producers (
    ProducerId INT PRIMARY KEY,
    FullName NVARCHAR(100),
    Instrument NVARCHAR(100)
) AS NODE;

CREATE TABLE OwnsRights AS EDGE;

CREATE TABLE SignedContract AS EDGE;

CREATE TABLE SubLicense AS EDGE;

INSERT INTO Labels (LabelId, Name, Genre) VALUES
(1, N'Нервы', 'Rock'),
(2, N'ЛСП', 'Rap'),
(3, N'Кис-Кис', 'Rock'),
(4, N'Пошлая Молли', 'Rock'),
(5, N'Nirvana', 'Grunge'),
(6, N'Папин Олимпос', 'Alternative Rock'),
(7, N'Полматери', 'Jazz'),
(8, N'Måneskin', 'Rock'),
(9, N'Go_A', 'Electro'),
(10, N'Валентин Стрыкало', 'Rock');

INSERT INTO Contracts (ContractId, Title, RoyaltyRate) VALUES
(1, N'Вдохновение', 2021),
(2, N'Городские ритмы', 2017),
(3, N'Ночной экспресс', 2020),
(4, N'Первая любовь', 2018),
(5, N'Nevermind', 1991),
(6, N'Танцевальная вечеринка', 2021),
(7, N'Академия звука', 2022),
(8, N'Rush!', 2023),
(9, N'Народная культура', 2016),
(10, N'Свободное плавание', 2014);

INSERT INTO Producers (ProducerId, FullName, Instrument) VALUES
(1, N'Юрий Каплан', N'vocal/guitar'),
(2, N'Арина Окунева', N'vocal/bass'),
(3, N'Артём Мельников', N'guitar'),
(4, N'Алина Олешева', N'drums'),
(5, N'Kurt Cobain', N'vocals'),
(6, N'Костя Боровский', N'guitar'),
(7, N'Krist Novoselic', N'bass'),
(8, N'Dave Grohl', N'drums'),
(9, N'Женя Мильковский', N'vocals'),
(10, N'Сергей Ковальчук', N'bass');

INSERT INTO OwnsRights ($from_id, $to_id)
VALUES
((SELECT $node_id FROM Producers WHERE ProducerId = 1), (SELECT $node_id FROM Labels WHERE LabelId = 10)),
((SELECT $node_id FROM Producers WHERE ProducerId = 2), (SELECT $node_id FROM Labels WHERE LabelId = 3)),
((SELECT $node_id FROM Producers WHERE ProducerId = 3), (SELECT $node_id FROM Labels WHERE LabelId = 6)),
((SELECT $node_id FROM Producers WHERE ProducerId = 4), (SELECT $node_id FROM Labels WHERE LabelId = 3)),
((SELECT $node_id FROM Producers WHERE ProducerId = 5), (SELECT $node_id FROM Labels WHERE LabelId = 5)),
((SELECT $node_id FROM Producers WHERE ProducerId = 6), (SELECT $node_id FROM Labels WHERE LabelId = 1)),
((SELECT $node_id FROM Producers WHERE ProducerId = 7), (SELECT $node_id FROM Labels WHERE LabelId = 5)),
((SELECT $node_id FROM Producers WHERE ProducerId = 8), (SELECT $node_id FROM Labels WHERE LabelId = 5)),
((SELECT $node_id FROM Producers WHERE ProducerId = 9), (SELECT $node_id FROM Labels WHERE LabelId = 1)),
((SELECT $node_id FROM Producers WHERE ProducerId = 10), (SELECT $node_id FROM Labels WHERE LabelId = 7));

INSERT INTO SignedContract ($from_id, $to_id)
VALUES
((SELECT $node_id FROM Labels WHERE LabelId = 1), (SELECT $node_id FROM Contracts WHERE ContractId = 1)),
((SELECT $node_id FROM Labels WHERE LabelId = 2), (SELECT $node_id FROM Contracts WHERE ContractId = 2)),
((SELECT $node_id FROM Labels WHERE LabelId = 3), (SELECT $node_id FROM Contracts WHERE ContractId = 3)),
((SELECT $node_id FROM Labels WHERE LabelId = 4), (SELECT $node_id FROM Contracts WHERE ContractId = 4)),
((SELECT $node_id FROM Labels WHERE LabelId = 5), (SELECT $node_id FROM Contracts WHERE ContractId = 5)),
((SELECT $node_id FROM Labels WHERE LabelId = 6), (SELECT $node_id FROM Contracts WHERE ContractId = 6)),
((SELECT $node_id FROM Labels WHERE LabelId = 7), (SELECT $node_id FROM Contracts WHERE ContractId = 7)),
((SELECT $node_id FROM Labels WHERE LabelId = 8), (SELECT $node_id FROM Contracts WHERE ContractId = 8)),
((SELECT $node_id FROM Labels WHERE LabelId = 9), (SELECT $node_id FROM Contracts WHERE ContractId = 9)),
((SELECT $node_id FROM Labels WHERE LabelId = 10), (SELECT $node_id FROM Contracts WHERE ContractId = 10));

INSERT INTO SubLicense ($from_id, $to_id)
VALUES
((SELECT $node_id FROM Labels WHERE LabelId = 1), (SELECT $node_id FROM Labels WHERE LabelId = 6)),
((SELECT $node_id FROM Labels WHERE LabelId = 1), (SELECT $node_id FROM Labels WHERE LabelId = 10)),
((SELECT $node_id FROM Labels WHERE LabelId = 1), (SELECT $node_id FROM Labels WHERE LabelId = 3)),
((SELECT $node_id FROM Labels WHERE LabelId = 1), (SELECT $node_id FROM Labels WHERE LabelId = 4)),

((SELECT $node_id FROM Labels WHERE LabelId = 6), (SELECT $node_id FROM Labels WHERE LabelId = 1)),
((SELECT $node_id FROM Labels WHERE LabelId = 10), (SELECT $node_id FROM Labels WHERE LabelId = 1)),
((SELECT $node_id FROM Labels WHERE LabelId = 3), (SELECT $node_id FROM Labels WHERE LabelId = 1)),
((SELECT $node_id FROM Labels WHERE LabelId = 4), (SELECT $node_id FROM Labels WHERE LabelId = 1)),

((SELECT $node_id FROM Labels WHERE LabelId = 4), (SELECT $node_id FROM Labels WHERE LabelId = 5)),
((SELECT $node_id FROM Labels WHERE LabelId = 4), (SELECT $node_id FROM Labels WHERE LabelId = 7)),

((SELECT $node_id FROM Labels WHERE LabelId = 5), (SELECT $node_id FROM Labels WHERE LabelId = 4)),
((SELECT $node_id FROM Labels WHERE LabelId = 7), (SELECT $node_id FROM Labels WHERE LabelId = 4)),

((SELECT $node_id FROM Labels WHERE LabelId = 8), (SELECT $node_id FROM Labels WHERE LabelId = 9)),
((SELECT $node_id FROM Labels WHERE LabelId = 9), (SELECT $node_id FROM Labels WHERE LabelId = 8));

SELECT p.FullName, p.Instrument
FROM Producers AS p, OwnsRights AS or_, Labels AS l
WHERE MATCH(p-(or_)->l) AND l.Name = N'Nirvana';

SELECT c.Title, c.RoyaltyRate
FROM Contracts AS c, SignedContract AS sc, Labels AS l
WHERE MATCH(l-(sc)->c) AND l.Name = N'Кис-Кис';

SELECT l2.Name
FROM Labels AS l1, SubLicense AS sl, Labels AS l2
WHERE MATCH(l1-(sl)->l2) AND l1.Name = N'Нервы';

SELECT l.Name AS LabelName, c.Title AS ContractTitle
FROM Labels AS l, SignedContract AS sc, Contracts AS c
WHERE MATCH(l-(sc)->c) AND c.RoyaltyRate = 2021;

SELECT p.FullName, p.Instrument, l.Name AS Label
FROM Producers AS p, OwnsRights AS or_, Labels AS l
WHERE MATCH(p-(or_)->l) AND l.Genre = 'Rock';

SELECT 
    l1.Name AS LabelName,
    STRING_AGG(l2.Name, '->') WITHIN GROUP (GRAPH PATH) AS SubLicensePath
FROM 
    Labels AS l1,
    SubLicense FOR PATH AS sl,
    Labels FOR PATH AS l2
WHERE 
    MATCH(SHORTEST_PATH(l1(-(sl)->l2)+))
    AND l1.Name = N'Нервы';

SELECT 
    l1.Name AS LabelName,
    STRING_AGG(l2.Name, '->') WITHIN GROUP (GRAPH PATH) AS SubLicensePath
FROM 
    Labels AS l1,
    SubLicense FOR PATH AS sl,
    Labels FOR PATH AS l2
WHERE 
    MATCH(SHORTEST_PATH(l1(-(sl)->l2){1,3}))
    AND l1.Name = N'Пошлая Молли';