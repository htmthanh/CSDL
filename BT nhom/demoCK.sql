USE QLDT

-- CAU 1
SELECT BM.MABM, BM.TENBM, COUNT(DT.DIENTHOAI) as 'SLGV co DT'
FROM BOMON BM, GIAOVIEN GV, GV_DT DT
WHERE BM.MABM = GV.MABM AND GV.MAGV = DT.MAGV
GROUP BY BM.MABM, BM.TENBM
HAVING COUNT(DT.DIENTHOAI) >= ALL (
	SELECT COUNT(DT.DIENTHOAI)
	FROM BOMON BM, GIAOVIEN GV, GV_DT DT
	WHERE BM.MABM = GV.MABM AND GV.MAGV = DT.MAGV
	GROUP BY BM.MABM, BM.TENBM
	)
-- CAU 2
SELECT GV.MAGV
FROM GIAOVIEN GV
WHERE NOT EXISTS ( (SELECT DT.MADT 
					FROM DETAI DT JOIN GIAOVIEN GVCN ON GVCN.MAGV = DT.GVCNDT
					WHERE GVCN.HOTEN=N'Trương Nam Sơn')
					
					EXCEPT

					(SELECT TG.MADT
					FROM THAMGIADT TG 
					WHERE GV.MAGV = TG.MAGV)
					)


--CAU 3
SELECT DISTINCT GV.*
FROM GIAOVIEN GV
WHERE NOT EXISTS ((SELECT DISTINCT DT.MADT
					FROM DETAI DT JOIN THAMGIADT TG ON TG.MADT = DT.MADT
					WHERE DT.KINHPHI >80)
					EXCEPT
					(SELECT DISTINCT TG.MADT
					FROM THAMGIADT TG WHERE TG.MAGV = GV.MAGV))
-- 
USE QLDT

SELECT DISTINCT GV.*
FROM THAMGIADT TG1 JOIN GIAOVIEN GV ON TG1.MAGV = GV.MAGV
WHERE NOT EXISTS ((SELECT DT.MADT
					FROM DETAI DT JOIN THAMGIADT TG ON TG.MADT = DT.MADT
					WHERE DT.KINHPHI >80)
					EXCEPT
					(SELECT TG2.MADT
					FROM THAMGIADT TG2 WHERE TG2.MAGV = TG1.MAGV))

--CAU 4
DROP PROCEDURE spHienThi_DSGV_ThamGia_DeTai

CREATE PROCEDURE spHienThi_DSGV_ThamGia_DeTai @tu_ngay date, @den_ngay date
AS
	BEGIN
		IF @tu_ngay > @den_ngay 
			BEGIN
				PRINT N'Không hợp lệ'
				RETURN
			END
		DECLARE @table_Detai TABLE (MADT CHAR(3), GVCNDT CHAR(3))

		INSERT INTO @table_Detai
			SELECT MADT, GVCNDT
			FROM DETAI
			WHERE (@Tu_Ngay <= NGAYBD AND NGAYBD <= @Den_Ngay )
				OR (@Tu_Ngay <= NGAYKT AND NGAYKT <= @Den_Ngay )

			DECLARE @SLDT INT
			SELECT @SLDT = COUNT(*) FROM @table_Detai

			PRINT N'Số lượng đề tài thỏa yêu cầu: ' + CAST (@SLDT AS CHAR(10))
			SELECT * FROM @table_Detai
			IF (@SLDT = 0) RETURN
			
			DECLARE @i int, @MADT char(10), @GVCNDT char(10), @SL_GVTG int;
			SET @i = 0
			WHILE (@i < @SLDT)
			BEGIN 
				SELECT '== DE TAI #  ' + CAST(@i as char(3)) + ' / ' + CAST(@SLDT as char(3)) + '======================================================================'
				SELECT TOP 1 @MADT = MADT, @GVCNDT = GVCNDT FROM @table_Detai

				SET @SL_GVTG = (SELECT COUNT(DISTINCT MAGV)
								FROM THAMGIADT
								WHERE MADT = @MADT AND MAGV <> @GVCNDT)
									
				SELECT DT.*, @SL_GVTG 'SLGVTG'
				FROM DETAI DT
				WHERE MADT = @MADT

				SELECT GV.*
				FROM GIAOVIEN GV
				WHERE MAGV = @GVCNDT

				IF(@SL_GVTG > 0)
					SELECT GV.* 
					FROM GIAOVIEN GV 
					WHERE GV.MAGV <> @GVCNDT AND
						GV.MAGV IN (SELECT DISTINCT TG.MAGV
									FROM THAMGIADT TG
									WHERE TG.MADT = @MADT)
					ORDER BY (YEAR(GETDATE()) - YEAR(GV.NGSINH)) DESC
				
				SET @i = @i + 1
				DELETE @table_Detai WHERE MADT = @MADT
			END
	END

EXEC spHienThi_DSGV_ThamGia_DeTai '2008-1-1', '2010-1-1'


-------------------------------------------------------------------------------------------
USE QLDT 

-- CÂU 1:
SELECT BM.MABM, BM.TENBM
FROM BOMON BM JOIN GIAOVIEN GV ON BM.MABM = GV.MABM
				JOIN GV_DT DT ON GV.MAGV = DT.MAGV
GROUP BY BM.MABM, BM.TENBM
HAVING COUNT(DT.DIENTHOAI) >= ALL (SELECT COUNT(DT.DIENTHOAI)
									FROM  BOMON BM JOIN GIAOVIEN GV ON BM.MABM = GV.MABM
											JOIN GV_DT DT ON GV.MAGV = DT.MAGV
									GROUP BY BM.MABM, BM.TENBM)

-- CÂU 2
SELECT DISTINCT TG.MAGV, GV.HOTEN
FROM THAMGIADT TG JOIN GIAOVIEN GV ON TG.MAGV = GV.MAGV
WHERE NOT EXISTS ( (SELECT DT.MADT
					FROM DETAI DT JOIN GIAOVIEN GV ON DT.GVCNDT = GV.MAGV
					WHERE GV.HOTEN = N'Trương Nam Sơn')

					EXCEPT
					
					(SELECT TG1.MADT
					FROM THAMGIADT TG1 
					WHERE TG1.MAGV = TG.MAGV))


-- CÂU 3
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV
WHERE NOT EXISTS ( (SELECT DT.MADT
					FROM DETAI DT JOIN THAMGIADT TG ON DT.MADT = TG.MADT
					WHERE DT.KINHPHI > 80)
					EXCEPT
					(SELECT TG.MADT
					FROM THAMGIADT TG
					WHERE TG.MAGV = GV.MAGV))




-- CÂU 4
drop  PROCEDURE spHienThi_DSGV_ThamGia_DeTai 
CREATE PROCEDURE spHienThi_DSGV_ThamGia_DeTai @from date, @to date
AS
	BEGIN
		IF @from > @to
		begin
			print 'khong hop le'
			return
		end

		declare @table_dt TABLE (MADT CHAR(3), GVCNDT CHAR (3))
		declare @MADT CHAR(3), @GVCNDT CHAR(3)
		INSERT INTO @table_dt
			SELECT MADT, GVCNDT
			FROM DETAI
			WHERE (@from <= NGAYBD and NGAYBD <= @to)
				or (@from <= NGAYKT AND NGAYKT <= @to)

		declare @sldt_thoayc int
		SELECT @sldt_thoayc = COUNT(*) FROM @table_dt
		PRINT 'SO DT: ' + CAST(@sldt_thoayc as char(10))
		if(@sldt_thoayc = 0)
			return

		declare @i int
		set @i = @sldt_thoayc

		while (@i > 0)
		begin
			
			SELECT TOP 1 @MADT = MADT, @GVCNDT = GVCNDT FROM @table_dt

			declare @slgvtg int
			SET @slgvtg = (SELECT COUNT( DISTINCT TG.MAGV)
							FROM THAMGIADT TG
							WHERE TG.MADT = @MADT AND @GVCNDT <> TG.MAGV )

			SELECT DT.*, @slgvtg AS 'SLGV'
			FROM DETAI DT
			WHERE DT.MADT = @MADT

			SELECT GV.MAGV, GV.HOTEN AS 'HOTEN GVCNDT'
			FROM GIAOVIEN GV
			WHERE GV.MAGV = @GVCNDT

			set @i = @i - 1
			delete @table_dt where MADT = @MADT
		end
	END

EXEC spHienThi_DSGV_ThamGia_DeTai '2008-1-1', '2010-1-1'




















































































































































































































































