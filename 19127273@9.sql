USE QLDT

GO

--Q75. Cho biết họ tên giáo viên và tên bộ môn họ làm trưởng bộ môn nếu có
SELECT GV.HOTEN, BM.TENBM
FROM GIAOVIEN GV LEFT JOIN BOMON BM ON BM.TRUONGBM = GV.MAGV

--Q76. Cho danh sách tên bộ môn và họ tên trưởng bộ môn đó nếu có
SELECT BM.TENBM, GV.HOTEN
FROM BOMON BM LEFT JOIN GIAOVIEN GV ON GV.MAGV = BM.TRUONGBM
--Q77. Cho danh sách tên giáo viên và các đề tài giáo viên đó chủ nhiệm nếu có
SELECT GV.MAGV, GV.HOTEN, DT.MADT
FROM GIAOVIEN GV LEFT JOIN DETAI DT ON GV.MAGV = DT.GVCNDT

--Q78. Xuất ra thông tin của giáo viên (MAGV, HOTEN) và mức lương của giáo viên. Mức
--lương được xếp theo quy tắc: Lương của giáo viên < $1800 : “THẤP” ; Từ $1800 đến
--$2200: TRUNG BÌNH; Lương > $2200: “CAO”
SELECT MAGV, HOTEN,( CASE 
						WHEN LUONG < 1800 THEN N'THẤP'
						WHEN LUONG >= 1800 AND LUONG <= 2200 THEN N'TRUNG BÌNH'
						WHEN LUONG > 2200 THEN 'CAO'
					END ) AS MUCLUONG
FROM GIAOVIEN

--Q79. Xuất ra thông tin giáo viên (MAGV, HOTEN) và xếp hạng dựa vào mức lương. Nếu giáo
--viên có lương cao nhất thì hạng là 1.
ALTER TABLE GIAOVIEN
ADD HANG INT

UPDATE GIAOVIEN
SET HANG = (SELECT COUNT(*) 
			FROM GIAOVIEN GV
			WHERE GV.LUONG >= GIAOVIEN.LUONG )

SELECT GV.MAGV, GV.HOTEN, GV.HANG
FROM GIAOVIEN GV

--Q80. Xuất ra thông tin thu nhập của giáo viên. Thu nhập của giáo viên được tính bằng
--LƯƠNG + PHỤ CẤP. Nếu giáo viên là trưởng bộ môn thì PHỤ CẤP là 300, và giáo viên là
--trưởng khoa thì PHỤ CẤP là 600. // nếu vừa là trưởng khoa vừa là trưởng bm thì có dc phụ cấp 900 hay không?
SELECT GV.MAGV, GV.HOTEN, (CASE 
							--WHEN BM.TRUONGBM = GV.MAGV AND K.TRUONGKHOA = GV.MAGV THEN LUONG + 900
							WHEN K.TRUONGKHOA = GV.MAGV THEN LUONG + 600
							WHEN BM.TRUONGBM = GV.MAGV THEN LUONG + 300
							
							
						END
							) PHUCAP
FROM GIAOVIEN GV LEFT JOIN BOMON BM ON BM.TRUONGBM = GV.MAGV
				LEFT JOIN KHOA K ON K.TRUONGKHOA = GV.MAGV


--Q81. Xuất ra năm mà giáo viên dự kiến sẽ nghĩ hưu với quy định: Tuổi nghỉ hưu của Nam là
--60, của Nữ là 55.
SELECT MAGV, HOTEN, (CASE PHAI
						WHEN 'NAM' THEN YEAR(NGSINH) + 60
						WHEN N'Nữ' THEN YEAR(NGSINH) + 55
						END) NAMVEHUU
FROM GIAOVIEN

--------------------------
--Q82. Cho biết danh sách tất cả giáo viên (magv, hoten) và họ tên giáo viên là quản lý chuyên
--môn của họ.
SELECT GV.MAGV, GV.HOTEN, GVQL.HOTEN GVQL
FROM GIAOVIEN GV LEFT JOIN GIAOVIEN GVQL ON GV.GVQLCM = GVQL.MAGV

--Q83. Cho biếtdanh sách tất cả bộ môn (mabm, tenbm), tên trưởng bộ môn cùng số lượng
--giáo viên của mỗi bộ môn.
SELECT BM.MABM, BM.TENBM, GVT.HOTEN, COUNT(DISTINCT GV.MAGV) SOGV
FROM BOMON BM LEFT JOIN GIAOVIEN GVT ON BM.TRUONGBM = GVT.MAGV
			LEFT JOIN GIAOVIEN GV ON BM.MABM = GV.MABM
GROUP BY BM.MABM, BM.TENBM, GVT.HOTEN
--Q84. Cho biết danh sách tất cả các giáo viên nam và thông tin các công việc mà họ đã tham
--gia.
SELECT DISTINCT GV.MAGV, GV.HOTEN, CV.TENCV
FROM GIAOVIEN GV LEFT JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
				LEFT JOIN CONGVIEC CV ON TG.MADT = CV.MADT
WHERE GV.PHAI = 'Nam'
--Q85. Cho biết danh sách tất cả các giáo viên và thông tin các công việc thuộc đề tài 001 mà
--họ tham gia.
SELECT DISTINCT GV.HOTEN, CV.TENCV
FROM GIAOVIEN GV LEFT JOIN THAMGIADT TG ON TG.MAGV = GV.MAGV
				LEFT JOIN CONGVIEC CV ON CV.MADT = TG.MADT
WHERE CV.MADT = '001'
--Q86. Cho biết thông tin các trưởng bộ môn (magv, hoten) sẽ về hưu vào năm 2014. Biết
--rằng độ tuổi về hưu của giáo viên nam là 60 còn giáo viên nữ là 55.

SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV JOIN BOMON BM ON BM.TRUONGBM = GV.MAGV
WHERE 2014-YEAR(GV.NGSINH) >= (CASE GV.PHAI 
									WHEN 'Nam' THEN 60
									WHEN N'Nữ' THEN 55
									END)

--Q87. Cho biết thông tin các trưởng khoa (magv) và năm họ sẽ về hưu.
SELECT GV.MAGV, (CASE PHAI
					WHEN 'Nam' THEN YEAR(NGSINH) +60
					WHEN N'Nữ' THEN YEAR(NGSINH) +55
					END) NAMVEHUU
FROM GIAOVIEN GV JOIN KHOA K ON K.TRUONGKHOA = GV.MAGV


--Q88. Tạo bảng DANHSACHTHIDUA (magv, sodtdat, danhhieu) gồm thông tin mã giáo viên,
--số đề tài họ tham gia đạt kết quả và danh hiệu thi đua:



CREATE TABLE DANHSACHTHIDUA 
(
	MAGV CHAR(3),
	SODTDAT INT,
	DANHHIEU NVARCHAR(50)

)

ALTER TABLE DANHSACHTHIDUA
ADD
	CONSTRAINT FK_DS_GV
	FOREIGN KEY(MAGV)
	REFERENCES GIAOVIEN

--a. Insert dữ liệu cho bảng này (để trống cột danh hiệu)
INSERT INTO DANHSACHTHIDUA
SELECT GV.MAGV, COUNT(DISTINCT TG.KETQUA), NULL
FROM GIAOVIEN GV JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
WHERE TG.KETQUA = N'Đạt'
GROUP BY GV.MAGV


--b. Dựa vào cột sldtdat (số lượng đề tài tham gia có kết quả là “đạt”) để cập nhật dữ
--liệu cho cột danh hiệu theo quy định:
--i. Sodtdat = 0 thì danh hiệu “chưa hoàn thành nhiệm vụ”
--ii. 1 <= Sodtdat <= 2 thì danh hiệu “hoàn thành nhiệm vụ”
--iii. 3 <= Sodtdat <= 5 thì danh hiệu “tiên tiến”
--iv. Sodtdat >= 6 thì danh hiệu “lao động xuất sắc”
UPDATE DANHSACHTHIDUA
SET DANHHIEU = (CASE 
					WHEN SODTDAT=0 THEN N'chưa hoàn thành nhiệm vụ'
					WHEN SODTDAT >= 1 AND SODTDAT <=2 THEN N'hoàn thành nhiệm vụ'
					WHEN SODTDAT >= 3 AND SODTDAT <=5 THEN N'tiên tiến'
					WHEN SODTDAT >= 6 THEN N'lao động xuất sắc'
					END)


SELECT * FROM DANHSACHTHIDUA