﻿USE MASTER
IF DB_ID('QLPM') IS NOT NULL
	DROP DATABASE QLPM
GO

CREATE DATABASE QLPM
GO

USE QLPM

CREATE TABLE PHONGMAY(
	MAPHONG CHAR(5),
	TENPHONG NVARCHAR(20),
	MAYCHU CHAR(5),
	MANVQL CHAR(5),

	CONSTRAINT PK_PM
	PRIMARY KEY (MAPHONG)
)

CREATE TABLE MAYTINH(
	MAMT CHAR(5),
	TENMT NVARCHAR(20),
	MAPM CHAR(5),
	TINHTRANG BIT,
	MAYGATEWAY CHAR(5)

	CONSTRAINT PK_MT
	PRIMARY KEY (MAMT, MAPM)
)

CREATE TABLE NHANVIEN(
	MANV CHAR(5),
	TENNV NVARCHAR(20),
	MANVQL CHAR(5),
	PHAI NCHAR(5)

	CONSTRAINT PK_NV
	PRIMARY KEY (MANV)
)

ALTER TABLE PHONGMAY
ADD
	CONSTRAINT FK_PM_MT
	FOREIGN KEY ( MAYCHU, MAPHONG)
	REFERENCES MAYTINH(MAMT, MAPM),
	
	CONSTRAINT FK_PM_NV
	FOREIGN KEY (MANVQL)
	REFERENCES NHANVIEN(MANV)

ALTER TABLE MAYTINH
ADD
	CONSTRAINT FK_MT_PM
	FOREIGN KEY (MAPM)
	REFERENCES PHONGMAY(MAPHONG),

	CONSTRAINT FK_PM_PM
	FOREIGN KEY (MAYGATEWAY, MAPM)
	REFERENCES MAYTINH(MAMT, MAPM)

ALTER TABLE NHANVIEN 
ADD
	CONSTRAINT FK_NV_NV
	FOREIGN KEY (MANVQL)
	REFERENCES NHANVIEN(MANV)

ALTER TABLE NHANVIEN
ADD 
	CONSTRAINT CK_NV_PHAI
	CHECK ( PHAI = 'NAM' OR PHAI = N'NỮ')

ALTER TABLE NHANVIEN
ADD 
	CONSTRAINT U_TENNV unique (TENNV)

GO

INSERT INTO NHANVIEN 
VALUES 
	('001', N'Nguyễn Văn A', NULL, 'Nam')
	


