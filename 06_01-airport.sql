--CREATE DATABASE airport;
--GO
--USE airport;

CREATE TABLE Person (
	PersonId int IDENTITY(1,1),
	FirstName nvarchar(500),
	MiddleName nvarchar(500),
	LastName nvarchar(500) NOT NULL,
	BirthDate date NOT NULL,
	PRIMARY KEY (PersonId),
);

CREATE TABLE Passenger (
	PassengerId int IDENTITY(1,1),
	PersonId int,
	PRIMARY KEY (PassengerId),
	FOREIGN KEY (PersonId) REFERENCES Person(PersonId)
);

CREATE TABLE Plane (
	PlaneId int IDENTITY(1,1),
	Title nvarchar(500),
	Seats int NOT NULL,
	PRIMARY KEY (PlaneId)
);

CREATE TABLE TravelClass (
	TravelClassId int IDENTITY(1,1),
	Title nvarchar(500),
	PRIMARY KEY (TravelClassId)
);

CREATE TABLE PlaneTravelClass (
	PlaneId int,
	TravelClassId int,
	Quantity int,
	PRIMARY KEY (PlaneId, TravelClassId), --?
	FOREIGN KEY (PlaneId) REFERENCES Plane(PlaneId),
	FOREIGN KEY	(TravelClassId) REFERENCES TravelClass(TravelClassId)
);

CREATE TABLE City (
	CityId int IDENTITY(1,1),
	CityName nvarchar(500),
	PRIMARY KEY (CityId)
);

CREATE TABLE Airport (
	AirportId int IDENTITY(1,1),
	CityId int,
	AirportName nvarchar(500),
	PRIMARY KEY (AirportId),
	FOREIGN KEY (CityId) REFERENCES City(CityId)
);

CREATE TABLE Flight (
	FlightId int IDENTITY(1,1),
	PlaneId int,
	DeparturePlace int,
	ArrivalPlace int,
	DepartureTime datetime2 NOT NULL,
	ArrivalTime datetime2 NOT NULL,
	PRIMARY KEY (FlightId),
	FOREIGN KEY (PlaneId) REFERENCES Plane(PlaneId),
	FOREIGN KEY (DeparturePlace) REFERENCES Airport(AirportId),
	FOREIGN KEY (ArrivalPlace) REFERENCES Airport(AirportId)
);

--DROP TABLE Ticket;
CREATE TABLE Ticket (
	FlightId int,
	PassengerId int,
	TravelClassId int NOT NULL,
	Price smallmoney DEFAULT 0,
	PRIMARY KEY (FlightId, PassengerId),
	FOREIGN KEY (FlightId) REFERENCES Flight(FlightId),
	FOREIGN KEY (PassengerId) REFERENCES Passenger(PassengerId),
	FOREIGN KEY (TravelClassId) REFERENCES TravelClass(TravelClassId)
);
/*
ALTER TABLE Ticket
ALTER COLUMN Price smallmoney NOT NULL;
*/
--TRUNCATE TABLE Person

DECLARE @i AS int
SET @i = 0
WHILE @i < 500
BEGIN
	SET @i += 1;
	INSERT INTO Person (FirstName, MiddleName, LastName, BirthDate)
	VALUES ('FirstName' + CAST(@i AS nvarchar(500)), 
			'MiddleName' + CAST(@i AS nvarchar(500)),
			'LastName' + CAST(@i AS nvarchar(500)), 
			DATEADD(yyyy, -(CAST(RAND()*1000 AS int)%20 + 10), GETDATE()) )
END

TRUNCATE TABLE Passenger;
--Populate Passenger
DECLARE @i AS int
SET @i = 10
WHILE @i < 500
BEGIN
	SET @i += 1;
	INSERT INTO Passenger (PersonId)
	VALUES (@i)
END

--Populate Plane
DECLARE @i AS int
SET @i = 0
WHILE @i < 10
BEGIN
	SET @i += 1;
	INSERT INTO Plane (Title)
	VALUES ('Plane' + CAST(@i AS nvarchar(500)))
END
-- ALTER TABLE Plane
-- DROP COLUMN Seats;

--Populate PlaneTravelClass
--TRUNCATE TABLE PlaneTravelClass;
DECLARE @i AS int
SET @i = 0
WHILE @i < 10
BEGIN
	SET @i += 1;
	INSERT INTO PlaneTravelClass (PlaneId, TravelClassId, Quantity)
	VALUES (@i, 1, 10), (@i, 2, 20), (@i, 3, 30)
END

--Populate City
DECLARE @i AS int
SET @i = 0
WHILE @i < 10
BEGIN
	SET @i += 1;
	INSERT INTO City (CityName)
	VALUES ('City' + CAST(@i AS nvarchar(500)))
END

--Populate Airport
DECLARE @i AS int
SET @i = 0
WHILE @i < 10
BEGIN
	SET @i += 1;
	INSERT INTO Airport (CityId, AirportName)
	VALUES (@i, 'Airport' + CAST(@i AS nvarchar(500)))
END

--Populate Flight
--TRUNCATE TABLE Flight;
DECLARE @i AS int
DECLARE @DepTime AS datetime2
DECLARE @ArrTime AS datetime2
SET @i = 0
WHILE @i < 10
BEGIN
	SET @i += 1
	SET @DepTime = DATEADD(dd, CAST(RAND()*100 AS int), GETDATE())
	SET @DepTime = DATEADD(hh, CAST(RAND()*24 AS int), @DepTime)
	SET @ArrTime = DATEADD(hh, CAST(RAND()*9+1 AS int), @DepTime)
	INSERT INTO Flight (PlaneId, DeparturePlace, ArrivalPlace, DepartureTime, ArrivalTime)
	VALUES (@i%10+1, 1, CAST(RAND()*8+2 AS int), @DepTime, @ArrTime)
END

--Populate TravelClass
INSERT INTO TravelClass (Title)
VALUES ('First class'), ('Business class'), ('Economy class');

--Populate Ticket
DECLARE @i AS INT
DECLARE @rnd AS FLOAT
SET @i = 0
WHILE @i < 500
BEGIN
	SET @i += 1
	SET @rnd = CAST((RAND()*10) AS INT)%3+1
	INSERT INTO Ticket (FlightId, PassengerId, TravelClassId, Price)
	VALUES (@i%10+1, @i, @rnd, @rnd*100)
END

DROP VIEW FlightsView;
CREATE VIEW FlightsView AS
SELECT f.FlightId, f.PlaneId, f.DepartureTime, f.ArrivalTime, 
	cd.CityName AS Departure_City, ad.AirportName AS Departure_Place, 
	ca.CityName AS Arrival_City, aa.AirportName AS Arrival_Place
FROM Flight AS f INNER JOIN Airport AS ad ON f.DeparturePlace = ad.AirportId
	INNER JOIN Airport AS aa ON f.ArrivalPlace = aa.AirportId
	INNER JOIN City AS ca ON aa.CityId = ca.CityId
	INNER JOIN City AS cd ON ad.CityId = cd.CityId;

--1. Flights to the specified city on date
SELECT FlightId, PlaneId, DepartureTime, ArrivalTime, Departure_City, Departure_Place, Arrival_City, Arrival_Place
FROM FlightsView
WHERE Arrival_City = 'City6' AND ArrivalTime BETWEEN '2020-02-01' AND '2020-03-01'
ORDER BY DepartureTime;

--2. Max flight duration
SELECT FlightId, PlaneId, FORMAT(DepartureTime, 'yyyy-MM-dd hh:mm') AS DepartureTime, FORMAT(ArrivalTime, 'yyyy-MM-dd hh:mm') AS ArrivalTime, 
	Departure_City, Departure_Place, Arrival_City, Arrival_Place, DATEDIFF(hour, DepartureTime, ArrivalTime) AS [Duration]
FROM FlightsView
WHERE DATEDIFF(hour, DepartureTime, ArrivalTime) = (SELECT MAX(DATEDIFF(hour, DepartureTime, ArrivalTime)) FROM FlightsView);

--3. Flight duration > 2 hours
SELECT FlightId, PlaneId, FORMAT(DepartureTime, 'yyyy-MM-dd hh:mm') AS DepartureTime, FORMAT(ArrivalTime, 'yyyy-MM-dd hh:mm') AS ArrivalTime, 
	Departure_City, Departure_Place, Arrival_City, Arrival_Place, DATEDIFF(hour, DepartureTime, ArrivalTime) AS [Duration]
FROM FlightsView
WHERE DATEDIFF(HOUR, DepartureTime, ArrivalTime) > 2; 

--4. Flights count by city
SELECT Arrival_City, COUNT(FlightId) AS [FlightsCount]
FROM FlightsView
GROUP BY Arrival_City
ORDER BY Arrival_City;

--5. City with max flights
SELECT Arrival_City, COUNT(FlightId) AS [FlightsCount]
FROM FlightsView
GROUP BY Arrival_City
HAVING COUNT(FlightId) = (SELECT MAX(FlightsCount)
							FROM (SELECT Arrival_City, COUNT(FlightId) AS [FlightsCount]
									FROM FlightsView
									GROUP BY Arrival_City) AS FlightsCount)
;

--6. Total flights for month
SELECT COUNT(FlightId) AS [Total flights]
FROM FlightsView
WHERE DATEPART(MONTH, DepartureTime) = 4;

--7. Flights with business class 
SELECT fv.FlightId, ptc.Quantity, t.Sold
FROM FlightsView AS fv
INNER JOIN PlaneTravelClass AS ptc ON fv.PlaneId = ptc.PlaneId
LEFT JOIN (SELECT FlightId, COUNT(FlightId) AS 'Sold'
			FROM Ticket
			WHERE TravelClassId = 2
			GROUP BY FlightId) AS t ON fv.FlightId = t.FlightId
WHERE ptc.TravelClassId = 2 AND ptc.Quantity > t.Sold AND CAST(fv.DepartureTime AS DATE) = '2020-04-08';

--Flights with total and free places ?????????
SELECT fv.FlightId, ptc.Quantity, tc.Title AS TravelClass
FROM FlightsView AS fv
INNER JOIN PlaneTravelClass AS ptc ON fv.PlaneId = ptc.PlaneId
INNER JOIN TravelClass AS tc ON ptc.TravelClassId = tc.TravelClassId;

SELECT FlightId, TravelClassId, COUNT(TravelClassId) AS Sold
FROM Ticket
GROUP BY FlightId, TravelClassId
ORDER BY FlightId;

SELECT fv.FlightId, ptc.Quantity, t.Sold, tc.Title AS TravelClass
FROM FlightsView AS fv
INNER JOIN PlaneTravelClass AS ptc ON fv.PlaneId = ptc.PlaneId
INNER JOIN TravelClass AS tc ON ptc.TravelClassId = tc.TravelClassId
INNER JOIN (SELECT FlightId, TravelClassId, COUNT(TravelClassId) AS Sold
			FROM Ticket
			GROUP BY FlightId, TravelClassId) AS t ON fv.FlightId=t.FlightId
;

--8. Sold tickets and sum
SELECT COUNT(t.FlightId) AS 'Sold tickets', SUM(t.Price) AS Total
FROM Ticket AS t
INNER JOIN FlightsView AS fv ON t.FlightId = fv.FlightId
WHERE CAST(fv.DepartureTime AS date) = '2020-04-08';

--9. Flights and cities
SELECT FlightId, Arrival_City
FROM FlightsView
WHERE Departure_Place = 'Airport1';
