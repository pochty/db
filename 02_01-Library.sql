--IF DB_ID('lib') IS NULL 
BEGIN
	--CREATE DATABASE lib;
	USE lib;
	CREATE TABLE author (
		pk_author INT PRIMARY KEY CLUSTERED IDENTITY(1,1),
		last_name NVARCHAR(250) NOT NULL,
		first_name NVARCHAR(250),
		birthday DATE,
	);
	CREATE TABLE publisher (
		pk_publisher INT PRIMARY KEY CLUSTERED IDENTITY(1,1),
		pub_name NVARCHAR(250) NOT NULL,
		descr NVARCHAR(1000),
	);
	CREATE TABLE genre (
		pk_genre INT PRIMARY KEY CLUSTERED IDENTITY(1,1),		
		title NVARCHAR(250) NOT NULL,
		descr NVARCHAR(1000),
	);
	CREATE TABLE book (
		pk_book INT PRIMARY KEY CLUSTERED IDENTITY(1,1),
		isbn CHAR(13) NOT NULL,
		title NVARCHAR(250) NOT NULL,
		descr NVARCHAR(1000),
		published DATE NOT NULL,
		CONSTRAINT fk_author FOREIGN KEY (pk_book)
		REFERENCES author (pk_author),
		CONSTRAINT fk_publisher FOREIGN KEY (pk_book)
		REFERENCES publisher (pk_publisher),
		CONSTRAINT fk_genre FOREIGN KEY (pk_book)
		REFERENCES genre (pk_genre),
	);
END;
	

