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

CREATE TABLE TravelClass (
	TravelClassId int IDENTITY(1,1),
	Title nvarchar(500),
	PRIMARY KEY (TravelClassId)
);

CREATE TABLE Ticket (
	FlightId int,
	PassengerId int,
	TravelClassId int,
	Price smallmoney,
	PRIMARY KEY (FlightId, PassengerId),
	FOREIGN KEY (FlightId) REFERENCES Flight(FlightId),
	FOREIGN KEY (PassengerId) REFERENCES Passenger(PassengerId),
	FOREIGN KEY (TravelClassId) REFERENCES TravelClass(TravelClassId)
);

--TRUNCATE TABLE Person

DECLARE @i AS int
SET @i = 0
WHILE @i < 10
BEGIN
	SET @i += 1;
	INSERT INTO Person (FirstName, MiddleName, LastName, BirthDate)
	VALUES ('FirstName' + CAST(@i AS nvarchar(500)), 
			'MiddleName' + CAST(@i AS nvarchar(500)),
			'LastName' + CAST(@i AS nvarchar(500)), 
			DATEADD(yyyy, -(CAST(RAND()*1000 AS int)%20 + 10), GETDATE()) )
END

TRUNCATE TABLE Passenger;

DECLARE @i AS int
SET @i = 0
WHILE @i < 10
BEGIN
	SET @i += 1;
	INSERT INTO Passenger (PersonId)
	VALUES (@i)
END

DECLARE @i AS int
SET @i = 0
WHILE @i < 10
BEGIN
	SET @i += 1;
	INSERT INTO Plane (Title, Seats)
	VALUES ('Plane' + CAST(@i AS nvarchar(500)), 100)
END

DECLARE @i AS int
SET @i = 0
WHILE @i < 10
BEGIN
	SET @i += 1;
	INSERT INTO City (CityName)
	VALUES ('City' + CAST(@i AS nvarchar(500)))
END

DECLARE @i AS int
SET @i = 0
WHILE @i < 10
BEGIN
	SET @i += 1;
	INSERT INTO Airport (CityId, AirportName)
	VALUES (@i, 'Airport' + CAST(@i AS nvarchar(500)))
END

TRUNCATE TABLE Flight;

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
