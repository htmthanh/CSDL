
-- BÀI TẬP TẠI LỚP
--a. In ra câu chào “Hello World !!!”.
create procedure HELLO
as
	print 'HELLO WORLD'

exec HELLO

--b. In ra tổng 2 số.
create procedure Tong @a int, @b int, @sum int out
as
	set @sum = @a + @b

declare @sum int
exec Tong 1,-2,@sum out
print @sum

--c. Tính tổng 2 số (sử dụng biến output để lưu kết quả trả về).
create procedure Tong2 @a int, @b int, @sum int out
AS
	SET @sum = @a + @b
	RETURN @sum

declare @sum int
exec @sum = Tong2 1,-2, @sum out
print @sum
--d. In ra tổng 3 số (Sử dụng lại stored procedure Tính tổng 2 số).

create procedure Tong3 @a int, @b int, @c int, @sum int out
as
	declare @sum2 int
	exec @sum2 = Tong2 @a, @b, @sum2
	exec @sum = Tong2 @sum2, @c, @sum
	return @sum

declare @sum int
exec @sum = Tong3 1,1,1,@sum
print @sum

--e. In ra tổng các số nguyên từ m đến n.
create procedure Tong4 @m int, @n int
as
	declare @tong int
	set @tong = 0
	
	declare @i int
	set @i = @m
	while(@i<=@n)
	begin
		set @tong = @tong + @i
		set @i = @i + 1
	end
	print @tong

exec Tong4 1,5
--f. Kiểm tra 1 số nguyên có phải là số nguyên tố hay không.
create procedure ktnguyento @a int
as
	if @a < 2
	begin
		print N'Không phải số nguyên tố'
	end
	else 
	begin
		declare @i int
		set @i = 2
		declare @cnt int
		set @cnt = 0
		while (@i < @a)
		begin
			if @a % @i = 0 
			begin
				set @cnt = @cnt + 1
			end
			set @i = @i +1
		end
		if @cnt = 0
		begin
			print N'Là số nguyên tố'
		end
		else
		begin
			print N'Không phải số nguyên tố'
		end
	end


exec ktnguyento 7
			
--g. In ra tổng các số nguyên tố trong đoạn m, n.
 
create procedure Tong5 @m int, @n int
as
	declare @tong int
	set @tong = 0
	
	declare @i int
	set @i = @m
	while(@i<=@n)
	begin
		declare @j int
		set @j = 2
		declare @cnt int
		set @cnt = 0
		while (@j < @i)
		begin
			if @i % @j = 0 
			begin
				set @cnt = @cnt + 1
			end
			set @j = @j +1
		end
		if @cnt = 0
		begin
			set @tong = @tong + @i
		end
		set @i = @i + 1
	end
	print @tong

exec Tong5 3,5
--h. Tính ước chung lớn nhất của 2 số nguyên.
create procedure UCLN @a int, @b int
as
	while (@a != @b )
	begin
		if @a > @b
		begin 
			set @a = @a - @b
		end
		else
		begin
			set @b = @b - @a
		end
	end
	return @a

declare @uc int
exec @uc = UCLN 10,20
print @uc
--i. Tính bội chung nhỏ nhất của 2 số nguyên.
create procedure BCNN @a int, @b int
as
	declare @res int
	exec @res = UCLN @a,@b
	return @a * @b / @res;

declare @bc int
exec @bc = BCNN 2,3
print @bc

--j. Xuất ra toàn bộ danh sách giáo viên.

USE QLDT
create procedure dsgv
as
	SELECT * FROM GIAOVIEN

exec dsgv

--k. Tính số lượng đề tài mà một giáo viên đang thực hiện.
create procedure dem_dt
	@magv char(3),
	@sl_dt int out
as
	select @sl_dt = count(DISTINCT TG.MADT)
	from GIAOVIEN GV left join THAMGIADT TG on GV.MAGV = TG.MAGV
	where GV.MAGV = @magv

declare @sl_dt int
exec dem_dt '003', @sl_dt out
print @sl_dt

--l. In thông tin chi tiết của một giáo viên(sử dụng lệnh print): Thông tin cá
--nhân, Số lượng đề tài tham gia, Số lượng thân nhân của giáo viên đó.

--m. Kiểm tra xem một giáo viên có tồn tại hay không (dựa vào MAGV).
create procedure KiemTraGVTonTai @MaGV char(9)
as
	if ( EXISTS (SELECT * FROM GIAOVIEN WHERE MAGV=@MAGV) )
	print N'Giáo viên tồn tại'
	else
	print N'Không tồn tại giáo viên ' + @MaGV

Exec KiemTraGVTonTai '011'

--n. Kiểm tra quy định của một giáo viên: Chỉ được thực hiện các đề tài mà bộ
--môn của giáo viên đó làm chủ nhiệm.

--o. Thực hiện thêm một phân công cho giáo viên thực hiện một công việc của
--đề tài:
	--o Kiểm tra thông tin đầu vào hợp lệ: giáo viên phải tồn tại, công việc
	--phải tồn tại, thời gian tham gia phải >0
	--o Kiểm tra quy định ở câu n.

--p. Thực hiện xoá một giáo viên theo mã. Nếu giáo viên có thông tin liên quan
--(Có thân nhân, có làm đề tài, ...) thì báo lỗi.

--q. In ra danh sách giáo viên của một phòng ban nào đó cùng với số lượng đề
--tài mà giáo viên tham gia, số thân nhân, số giáo viên mà giáo viên đó quản
--lý nếu có, ...

--r. Kiểm tra quy định của 2 giáo viên a, b: Nếu a là trưởng bộ môn c của b thì
--lương của a phải cao hơn lương của b. (a, b: mã giáo viên)

--s. Thêm một giáo viên: Kiểm tra các quy định: Không trùng tên, tuổi > 18,
--lương > 0

--t. Mã giáo viên được xác định tự động theo quy tắc: Nếu đã có giáo viên 001,
--002, 003 thì MAGV của giáo viên mới sẽ là 004. Nếu đã có giáo viên 001,
--002, 005 thì MAGV của giáo viên mới là 003.

-- BÀI TẬP VỀ NHÀ

CREATE DATABASE PHONG
GO

USE PHONG
GO

CREATE TABLE PHONG
(
	MAPHONG INT,
	TINHTRANG NCHAR(55),
	LOAIPHONG CHAR(1),
	DONGIA NUMERIC(8,2)

	CONSTRAINT PK_PHONG
	PRIMARY KEY (MAPHONG)

)

CREATE TABLE KHACH
(
	MAKH INT,
	HOTEN NVARCHAR(50),
	DIACHI NVARCHAR(100),
	DIENTHOAI CHAR(11)

	CONSTRAINT PK_KHACH
	PRIMARY KEY (MAKH)
)

CREATE TABLE DATPHONG
(
	MA INT,
	MAKH INT,
	MAPHONG INT,
	NGAYDAT DATE,
	NGAYTRA DATE,
	THANHTIEN NUMERIC (8,2)

	CONSTRAINT PK_DP
	PRIMARY KEY(MA)
)

ALTER TABLE DATPHONG
ADD
	CONSTRAINT FK_DP_K
	FOREIGN KEY (MAKH)
	REFERENCES KHACH,

	CONSTRAINT FK_DP_P
	FOREIGN KEY (MAPHONG)
	REFERENCES PHONG

INSERT KHACH(MAKH)
VALUES (1),(2),(3)

INSERT PHONG(MAPHONG, TINHTRANG, DONGIA)
VALUES
	(1,N'Rảnh',1000),
	(2,N'Bận', 1500),
	(3, N'Rảnh', 1000)

GO

create procedure sp_datphong @makh int, @maphong int, @ngaydat date
as
	declare @valid int
	set @valid = 1

	-- không tồn tại khách hàng 
	if @makh not in (SELECT MAKH FROM KHACH)
		begin
			set @valid = 0
			print N'Không có khách hàng'
		end

	-- không có phòng trống
	if not exists (SELECT * FROM PHONG 
					WHERE MAPHONG = @maphong AND TINHTRANG = N'Rảnh')
		begin
			set @valid = 0
			print N'Không tồn tại phòng rảnh'
		end

	if @valid = 1
		begin
		
			declare @ma int
			SELECT @ma = ISNULL (max(MA),0) + 1
			FROM DATPHONG

		-- ghi thông tin vào CSDL
			INSERT DATPHONG(MA, MAKH, MAPHONG, NGAYDAT) 
			VALUES (@ma, @makh, @maphong, @ngaydat)
		-- cập nhật phòng không còn trống
			UPDATE PHONG
				SET TINHTRANG = N'Bận'
				WHERE MAPHONG = @maphong
			print N'Thêm vào CSDL thành công'
		end
	else 
		print N'Thất bại'


exec sp_datphong 1,1,'02/20/2023'
SELECT * FROM DATPHONG
SELECT * FROM PHONG

GO

create procedure sp_traphong @madp int, @makh int
as
	declare @valid int
	set @valid = 1
	
	-- kiểm tra hợp lệ
	if(not exists (SELECT *
				   FROM DATPHONG
				   WHERE MA = @madp AND MAKH = @makh))
		begin
			print N'Không tồn tại mã phòng và mã khách hàng'
			set @valid =0
		end

	-- thực hiện trả phòng
	if(@valid = 1)
		begin
		-- lấy đơn giá
			declare @dongia numeric(8,2), @maphong int
			SELECT @dongia = P.DONGIA, @maphong = P.MAPHONG
			FROM PHONG P JOIN DATPHONG D ON P.MAPHONG = D.MAPHONG
			WHERE D.MA = @madp
			
			print @dongia
		-- trả phòng
			UPDATE DATPHONG
				SET NGAYTRA = GETDATE(), THANHTIEN = DATEDIFF(D, NGAYDAT, GETDATE()) * @dongia
				WHERE MA = @madp
		-- cập nhật phòng trống
			UPDATE PHONG
			SET TINHTRANG = N'Rảnh'
			WHERE MAPHONG = @maphong
			print N'Trả phòng thành công'
		end
	else
		print N'Trả phòng thất bại'

exec sp_traphong 1,1
SELECT * FROM PHONG
SELECT * FROM DATPHONG