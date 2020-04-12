--!!Not finished!!--
CREATE DATABASE restaurant;
GO
USE restaurant;
GO

CREATE TABLE Person (
	PersonId INT IDENTITY,
	FirstName NVARCHAR(500),
	MiddleName NVARCHAR(500),
	LastName NVARCHAR(500) NOT NULL,
	BirthDate DATE NOT NULL,
	PRIMARY KEY (PersonId),
);

--Measure units
CREATE TABLE MeasureUnit (
    MeasureUnitId INT IDENTITY,
    Title NVARCHAR(500) NOT NULL UNIQUE,
    Details NVARCHAR(2000),
    PRIMARY KEY (MeasureUnitId),
);

--Item represents foodstuffs
CREATE TABLE Item (
    ItemId INT IDENTITY,
    Title NVARCHAR(500) NOT NULL UNIQUE,
    MeasureUnitId INT,
    Details NVARCHAR(2000),
    PRIMARY KEY (ItemId),
    CONSTRAINT fk_MeasureUnitId
        FOREIGN KEY (MeasureUnitId) 
        REFERENCES MeasureUnit(MeasureUnitId)
        ON UPDATE CASCADE,
);

--Stock
CREATE TABLE Stock (
    StockId INT IDENTITY,
    ItemId INT NOT NULL UNIQUE,
    Quantity INT DEFAULT 0,
    PRIMARY KEY (StockId),
    CONSTRAINT fk_ItemId
        FOREIGN KEY (ItemId)
        REFERENCES Item(ItemId)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
);

--Recipe
CREATE TABLE Recipe (
    RecipeId INT IDENTITY,
    Title NVARCHAR(500) NOT NULL,
    Details NVARCHAR(2000),
    OutputWeight INT DEFAULT 0,
    Price SMALLMONEY DEFAULT 0,
    PRIMARY KEY (RecipeId),
);

--RecipeItem
CREATE TABLE RecipeItem (
    RecipeId INT NOT NULL,
    ItemId INT NOT NULL,
    Quantity INT DEFAULT 0,
    PRIMARY KEY (RecipeId, ItemId),
    CONSTRAINT fk_RecipeId
        FOREIGN KEY (RecipeId)
        REFERENCES Recipe(RecipeId)
        ON DELETE CASCADE,
    CONSTRAINT fk_ItemId
        FOREIGN KEY (ItemId)
        REFERENCES Item(ItemId),
);

--Suppliers
CREATE TABLE Supplier (
    SupplierId INT IDENTITY,
    Title NVARCHAR(500) NOT NULL UNIQUE,
    Phone NVARCHAR(30),
    PRIMARY KEY (SupplierId)
);

--Purchase order (PO)
CREATE TABLE PurchaseOrder (
    PurchaseOrderId INT IDENTITY,
    SupplierId INT,
    PersonId INT,
    PurchaseOrderDate DATETIME2 DEFAULT GETDATE(),
    PRIMARY KEY (PurchaseOrderId),
    CONSTRAINT fk_SupplierId
        FOREIGN KEY (SupplierId)
        REFERENCES Supplier(SupplierId),
    CONSTRAINT fk_PersonId
        FOREIGN KEY (PersonId)
        REFERENCES Person(PersonId),
);

--Purchase order items
CREATE TABLE PurchaseOrderItem (
    PurchaseOrderId INT NOT NULL,
    ItemId INT NOT NULL,
    Quantity INT DEFAULT 0,
    Price SMALLMONEY DEFAULT 0,
    PRIMARY KEY (PurchaseOrderId, ItemId),
    CONSTRAINT fk_PurchaseOrderId
        FOREIGN KEY (PurchaseOrderId)
        REFERENCES PurchaseOrder(PurchaseOrderId)
        ON DELETE CASCADE,
    CONSTRAINT fk_PurchaseOrderItemId
        FOREIGN KEY (ItemId)
        REFERENCES Item(ItemId),
);

CREATE TABLE SaleOrder (
    SaleOrderId INT IDENTITY,
    PersonId INT,
    SaleOrderDate DATETIME2 DEFAULT GETDATE(),
    PRIMARY KEY (SaleOrderId),
    CONSTRAINT fk_SaleOrderPersonId
        FOREIGN KEY (PersonId)
        REFERENCES Person(PersonId),
);

CREATE TABLE SaleOrderItem (
    SaleOrderId INT NOT NULL,
    RecipeId INT NOT NULL,
    Quantity INT DEFAULT 1,
    Price SMALLMONEY DEFAULT 0,
    PRIMARY KEY (SaleOrderId, RecipeId),
    CONSTRAINT fk_SaleOrderId
        FOREIGN KEY (SaleOrderId)
        REFERENCES SaleOrder(SaleOrderId)
        ON DELETE CASCADE,
    CONSTRAINT fk_SaleOrderRecipeId
        FOREIGN KEY (RecipeId)
        REFERENCES Recipe(RecipeId),
);

GO

--Stored procedures

--Create person
CREATE OR ALTER PROCEDURE dbo.up_CreatePerson
	@FirstName NVARCHAR(500),
	@MiddleName NVARCHAR(500),
	@LastName NVARCHAR(500),
	@BirthDate DATE
AS
BEGIN
    INSERT INTO Person(FirstName, MiddleName, LastName, BirthDate)
    VALUES (@FirstName, @MiddleName, @LastName, @BirthDate);
END;
GO

--Create MeasureUnit
CREATE OR ALTER PROCEDURE dbo.up_CreateMeasureUnit
    @Title NVARCHAR(500),
    @Details NVARCHAR(2000)
AS
BEGIN
    INSERT INTO MeasureUnit (Title, Details)
    VALUES (@Title, @Details);
END;
GO

--Create Item
CREATE OR ALTER PROCEDURE dbo.up_CreateItem
    @Title NVARCHAR(500),
    @MeasureUnitTitle NVARCHAR(500),
    @Details NVARCHAR(2000)
AS
BEGIN
    DECLARE @MeasureUnitId INT 
        = (SELECT MeasureUnitId 
            FROM MeasureUnit 
            WHERE Title = @MeasureUnitTitle);
    INSERT INTO Item (Title, MeasureUnitId, Details)
    VALUES (@Title, @MeasureUnitId, @Details);
END;
GO

--Create recipe
CREATE OR ALTER PROCEDURE dbo.up_CreateRecipe
    @Title NVARCHAR(500),
    @Details NVARCHAR(2000),
    @OutputWeight INT,
    @Price SMALLMONEY,
    @RecipeId INT OUTPUT
AS
BEGIN
    INSERT INTO Recipe (Title, Details, OutputWeight, Price)
    VALUES (@Title, @Details, @OutputWeight, @Price);
    SET @RecipeId = SCOPE_IDENTITY();
END;
GO

--Create recipe item
CREATE OR ALTER PROCEDURE dbo.up_CreateRecipeItem
    @RecipeId INT,
    @ItemId INT,
    @Quantity INT
AS
BEGIN
    INSERT INTO RecipeItem (RecipeId, ItemId, Quantity)
    VALUES (@RecipeId, @ItemId, @Quantity);
END;
GO

--Create supplier
CREATE OR ALTER PROCEDURE dbo.up_CreateSupplier
    @Title NVARCHAR(500),
    @Phone NVARCHAR(30)
AS
BEGIN
    INSERT INTO Supplier (Title, Phone)
    VALUES (@Title, @Phone);
END;
GO

--Create purchase order
CREATE OR ALTER PROCEDURE dbo.up_CreatePurchaseOrder
    @SupplierId INT,
    @PersonId INT,
    @PurchaseOrderDate DATETIME2,
    @PurchaseOrderId INT OUTPUT
AS
BEGIN
    INSERT INTO PurchaseOrder (SupplierId, PersonId, PurchaseOrderDate)
    VALUES (@SupplierId, @PersonId, @PurchaseOrderDate);
    SET @PurchaseOrderId = SCOPE_IDENTITY();
END;
GO

--Create purchase order item
CREATE OR ALTER PROCEDURE dbo.up_CreatePurchaseOrderItem
    @PurchaseOrderId INT,
    @ItemId INT,
    @Quantity INT,
    @Price SMALLMONEY
AS
BEGIN
    INSERT INTO PurchaseOrderItem (PurchaseOrderId, ItemId, Quantity, Price)
    VALUES (@PurchaseOrderId, @ItemId, @Quantity, @Price);
END;
GO

--Create sale order
CREATE OR ALTER PROCEDURE dbo.up_CreateSaleOrder
    @PersonId INT,
    @SaleOrderDate DATETIME2,
    @SaleOrderId INT OUTPUT
AS
BEGIN
    INSERT INTO SaleOrder (PersonId, SaleOrderDate)
    VALUES (@PersonId, @SaleOrderDate);
    SET @SaleOrderId = SCOPE_IDENTITY();
END;
GO

--Create sale order item
CREATE OR ALTER PROCEDURE dbo.up_CreateSaleOrderItem
    @SaleOrderId INT,
    @RecipeId INT,
    @Quantity INT,
    @Price SMALLMONEY
AS
BEGIN
    INSERT INTO SaleOrderItem (SaleOrderId, RecipeId, Quantity, Price)
    VALUES (@SaleOrderId, @RecipeId, @Quantity, @Price);
END;
GO

--Populate data

--Populate person
TRUNCATE TABLE Person;
DECLARE @FirstName NVARCHAR(500);
DECLARE @MiddleName NVARCHAR(500);
DECLARE @LastName NVARCHAR(500);
DECLARE @Date DATE;
DECLARE @i INT = 0;
WHILE @i < 5
BEGIN
    SET @i += 1;
    SET @FirstName = 'FirstName' + CAST(@i AS NVARCHAR(500));
    SET @MiddleName = 'MiddleName' + CAST(@i AS NVARCHAR(500));
    SET @LastName = 'LastName' + CAST(@i AS NVARCHAR(500));
    SET @Date = DATEADD(yyyy, -(CAST(RAND()*1000 AS int)%20 + 10), GETDATE());
    EXEC up_CreatePerson 
            @FirstName = @FirstName, 
            @MiddleName = @MiddleName, 
            @LastName = @LastName,
            @BirthDate = @Date;
END;
GO

--Populate MeasureUnit
TRUNCATE TABLE MeasureUnit;
EXEC up_CreateMeasureUnit 'g', 'gram';
EXEC up_CreateMeasureUnit 'ml', 'milliliter';
EXEC up_CreateMeasureUnit 'pc', 'piece';

--Populate Item
TRUNCATE TABLE Item;
DECLARE @Title NVARCHAR(500);
DECLARE @MeasureUnitTitle NVARCHAR(500);
DECLARE @Details NVARCHAR(2000);
DECLARE @i INT = 0;
WHILE @i < 20
BEGIN
    SET @i += 1;
    SET @Title = 'Title' + CAST(@i AS NVARCHAR(500));
    SET @MeasureUnitTitle = 'g';
    SET @Details = 'ItemDetails' + CAST(@i AS NVARCHAR(500));
    EXEC up_CreateItem 
            @Title = @Title, 
            @MeasureUnitTitle = @MeasureUnitTitle, 
            @Details = @Details
END;
GO

--Populate recipe
DECLARE @id INT;
DECLARE @Title NVARCHAR(500);
DECLARE @Details NVARCHAR(2000);
DECLARE @OutputWeight INT;
DECLARE @Price SMALLMONEY;
DECLARE @i INT = 0;
WHILE @i < 10
BEGIN
    SET @i += 1;
    SET @Title = 'RecipeTitle' + CAST(@i AS NVARCHAR(500));
    SET @Details = 'RecipeDetails' + CAST(@i AS NVARCHAR(2000));
    SET @OutputWeight = CAST(RAND()*500 AS INT);
    SET @Price = CAST(RAND()*600 + 20 AS SMALLMONEY);
    EXEC up_CreateRecipe @Title, @Details, 
        @OutputWeight, @Price, @RecipeId = @id OUTPUT;
    DECLARE @ItemId INT = CAST(RAND()*20 AS INT);
    DECLARE @Quantity INT;
    DECLARE @j INT = 0;
    DECLARE @mval INT = CAST(RAND()*9 + 2 AS INT);
    WHILE @j < @mval
    BEGIN
        SET @j += 1;
        SET @ItemId = (@ItemId + 1) % 20 + 1;
        SET @Quantity = CAST(RAND()*100 + 1 AS INT);
        EXEC up_CreateRecipeItem @id, @ItemId, @Quantity;
    END
END;
GO

--Populate supplier
TRUNCATE TABLE Supplier;
DECLARE @Title NVARCHAR(500);
DECLARE @Phone NVARCHAR(30);
DECLARE @i INT = 0;
WHILE @i < 5
BEGIN
    SET @i += 1;
    SET @Title = 'SupplierTitle' + CAST(@i AS NVARCHAR(500));
    SET @Phone = CAST(CAST(RAND()*10000000 + 10000000 AS INT) AS NVARCHAR(30));
    EXEC up_CreateSupplier @Title, @Phone;
END;
GO

--Populate purchase order
DECLARE @id INT;
DECLARE @SupplierId INT;
DECLARE @PersonId INT;
DECLARE @PurchaseOrderDate DATETIME2;
DECLARE @i INT = 0;
WHILE @i < 10
BEGIN
    SET @i += 1;
    SET @SupplierId = CAST(RAND()*4 + 1 AS INT);
    SET @PersonId = CAST(RAND()*4 + 1 AS INT);
    SET @PurchaseOrderDate = DATEADD(dy, -(CAST(RAND()*100 AS INT)), GETDATE()); 
    EXEC up_CreatePurchaseOrder @SupplierId, @PersonId, 
        @PurchaseOrderDate, @PurchaseOrderId = @id OUTPUT;
    DECLARE @ItemId INT = CAST(RAND()*20 AS INT);
    DECLARE @Quantity INT;
    DECLARE @Price SMALLMONEY;
    DECLARE @j INT = 0;
    DECLARE @mval INT = CAST(RAND()*9 + 2 AS INT);
    WHILE @j < @mval
    BEGIN
        SET @j += 1;
        SET @ItemId = (@ItemId + 1) % 20 + 1;
        SET @Quantity = CAST(RAND()*1000 AS INT);
        SET @Price = CAST(RAND()*100 + 20 AS SMALLMONEY);
        EXEC up_CreatePurchaseOrderItem @id, @ItemId, @Quantity, @Price;
    END
END;
GO

--Populate sale order
DECLARE @id INT;
DECLARE @PersonId INT;
DECLARE @SaleOrderDate DATETIME2;
DECLARE @i INT = 0;
WHILE @i < 30
BEGIN
    SET @i += 1;
    SET @PersonId = CAST(RAND()*4 + 1 AS INT);
    SET @SaleOrderDate = DATEADD(dy, -(CAST(RAND()*100 AS INT)), GETDATE()); 
    EXEC up_CreateSaleOrder @PersonId, @SaleOrderDate,
        @SaleOrderId = @id OUTPUT;
    DECLARE @RecipeId INT = CAST(RAND()*10 AS INT);
    DECLARE @Quantity INT;
    DECLARE @Price SMALLMONEY;
    DECLARE @j INT = 0;
    DECLARE @mval INT = CAST(RAND()*9 + 2 AS INT);
    WHILE @j < @mval
    BEGIN
        SET @j += 1;
        SET @RecipeId = (@RecipeId + 1) % 10 + 1;
        SET @Quantity = CAST(RAND()*5 + 1 AS INT);
        SET @Price = CAST(RAND()*500 + 20 AS SMALLMONEY);
        EXEC up_CreateSaleOrderItem @id, @RecipeId, @Quantity, @Price;
    END
END;
GO
