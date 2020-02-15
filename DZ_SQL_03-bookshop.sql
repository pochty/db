/*
CREATE DATABASE bookshop;
GO
USE bookshop;
GO
*/

CREATE TABLE Person (
	PersonId INT IDENTITY,
	FirstName NVARCHAR(500),
	MiddleName NVARCHAR(500),
	LastName NVARCHAR(500) NOT NULL,
	BirthDate DATE,
	PRIMARY KEY (PersonId),
);

CREATE TABLE Author (
    AuthorId INT IDENTITY,
    PersonId INT,
    PRIMARY KEY (AuthorId),
    FOREIGN KEY (PersonId) REFERENCES Person(PersonId)
);

CREATE TABLE Publisher (
    PublisherId INT IDENTITY,
    Title NVARCHAR(1000) NOT NULL,
    Details NVARCHAR(4000),
    PRIMARY KEY (PublisherId)
);

CREATE TABLE Genre (
    GenreId INT IDENTITY,
    Title NVARCHAR(1000) NOT NULL UNIQUE,
    Details NVARCHAR(4000),
    PRIMARY KEY (GenreId)
);

CREATE TABLE Book (
    BookId INT IDENTITY,
    GenreId INT,
    Title NVARCHAR(1000) NOT NULL,
    Details NVARCHAR(4000),
    PRIMARY KEY (BookId),
    FOREIGN KEY (GenreId) REFERENCES Genre(GenreId)
);

CREATE TABLE BookAuthor (
    BookId INT,
    AuthorId INT,
    PRIMARY KEY (BookId, AuthorId),
    FOREIGN KEY (BookId) REFERENCES Book(BookId),
    FOREIGN KEY (AuthorId) REFERENCES Author(AuthorId)
);

CREATE TABLE [Edition] (
    EditionId INT IDENTITY,
    BookId INT,
    PublicationDate DATE,
    Pages INT,
    PRIMARY KEY (EditionId),
    FOREIGN KEY (BookId) REFERENCES Book(BookId)
);

CREATE TABLE Country (
    CountryId INT IDENTITY,
    Title NVARCHAR(1000) NOT NULL,
    PRIMARY KEY (CountryId)
);

CREATE TABLE Shop (
    ShopId INT IDENTITY,
    CountryId INT,
    Title NVARCHAR(1000) NOT NULL,
    PRIMARY KEY (ShopId),
    FOREIGN KEY (CountryId) REFERENCES Country(CountryId)
);

CREATE TABLE Employee (
    EmployeeId INT IDENTITY,
    PersonId INT,
    ShopId INT,
    PRIMARY KEY (EmployeeId),
    FOREIGN KEY (ShopId) REFERENCES Shop(ShopId),
    FOREIGN KEY (PersonId) REFERENCES Person(PersonId)
);

CREATE TABLE Sku (
    SkuId BIGINT IDENTITY,
    ShopId INT,
    EditionId INT,
    Price SMALLMONEY,
    Quantity INT,
    PRIMARY KEY (SkuId),
    FOREIGN KEY (ShopId) REFERENCES Shop(ShopId),
    FOREIGN KEY (EditionId) REFERENCES [Edition](EditionId)
);

CREATE TABLE Orders (
    OrdersId BIGINT IDENTITY,
    SkuId BIGINT,
    EmployeeId INT,
    SaleDate DATETIME2,
    SalePrice SMALLMONEY,
    PRIMARY KEY (OrdersId),
    FOREIGN KEY (SkuId) REFERENCES Sku(SkuId),
    FOREIGN KEY (EmployeeId) REFERENCES Employee(EmployeeId)
);

--Populate Person
DECLARE @i AS INT
SET @i = 0
WHILE @i < 500
BEGIN
	SET @i += 1;
	INSERT INTO Person (FirstName, MiddleName, LastName, BirthDate)
	VALUES ('FirstName' + CAST(@i AS NVARCHAR(500)), 
			'MiddleName' + CAST(@i AS NVARCHAR(500)),
			'LastName' + CAST(@i AS NVARCHAR(500)), 
			DATEADD(yyyy, -(CAST(RAND()*1000 AS INT)%20 + 10), GETDATE()) )
END


