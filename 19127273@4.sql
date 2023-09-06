
USE QLDT
--Q1. Cho biết họ tên và mức lương của các giáo viên nữ
SELECT HOTEN, LUONG
FROM GIAOVIEN
WHERE PHAI = N'Nữ'

--Q2. Cho biết họ tên của các giáo viên và lương của họ sau khi tăng 10%.
SELECT HOTEN, LUONG*1.1 'LUONG MOI'
FROM GIAOVIEN

--Q3. Cho biết mã của các giáo viên có họ tên bắt đầu là “Nguyễn” 
--và lương trên $2000 hoặc, giáo viên là trưởng bộ môn nhận chức sau năm 1995.
SELECT DISTINCT GV.MAGV
FROM GIAOVIEN GV, BOMON BM 
WHERE (GV.HOTEN LIKE N'Nguyễn %' AND GV.LUONG > 2000) OR (GV.MAGV = BM.TRUONGBM AND YEAR(BM.NGAYNHANCHUC) >1995)

--Q4. Cho biết tên những giáo viên khoa Công nghệ thông tin.
SELECT GV.HOTEN
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM
	JOIN KHOA K ON BM.MAKHOA = K.MAKHOA
WHERE K.TENKHOA = N'Công nghệ thông tin'

--Q5. Cho biết thông tin của bộ môn cùng thông tin giảng viên làm trưởng bộ môn đó.
SELECT *
FROM BOMON BM JOIN GIAOVIEN GV ON BM.TRUONGBM = GV.MAGV 

--Q6. Với mỗi giáo viên, hãy cho biết thông tin của bộ môn mà họ đang làm việc.
SELECT GV.MAGV, GV.HOTEN, BM.*
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM

--Q7. Cho biết tên đề tài và giáo viên chủ nhiệm đề tài.
SELECT DT.TENDT, GV.MAGV, GV.HOTEN
FROM DETAI DT JOIN GIAOVIEN GV ON DT.GVCNDT = MAGV

--Q8. Với mỗi khoa cho biết thông tin trưởng khoa.
SELECT K.MAKHOA, K.TENKHOA, GV.*
FROM KHOA K JOIN GIAOVIEN GV ON K.TRUONGKHOA = GV.MAGV

--Q9. Cho biết các giáo viên của bộ môn “Vi sinh” có tham gia đề tài 006.
SELECT distinct GV.*, BM.TENBM, TGDT.MADT
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM
	JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
WHERE TGDT.MADT ='006' AND BM.TENBM = N'Vi sinh'

-- Q10. Với những đề tài thuộc cấp quản lý “Thành phố”, cho biết mã đề tài, đề tài thuộc về chủ
-- đề nào, họ tên người chủ nghiệm đề tài cùng với ngày sinh và địa chỉ của người ấy.
SELECT DT.MADT,CD.TENCD, GV.HOTEN, GV.NGSINH, GV.DIACHI
FROM DETAI DT JOIN CHUDE CD ON DT.MACD = CD.MACD
	JOIN GIAOVIEN GV ON DT.GVCNDT = GV.MAGV
WHERE DT.CAPQL = N'Thành phố' 

--Q11. Tìm họ tên của từng giáo viên và người phụ trách chuyên môn trực tiếp của giáo viên đó
SELECT GV.HOTEN, GVQL.HOTEN 'GVQLCM'
FROM GIAOVIEN GV JOIN GIAOVIEN GVQL ON GV.GVQLCM = GVQL.MAGV

--Q12. Tìm họ tên của những giáo viên được “Nguyễn Thanh Tùng” phụ trách trực tiếp.
SELECT GV.HOTEN
FROM GIAOVIEN GV JOIN GIAOVIEN GVQL ON GV.GVQLCM = GVQL.MAGV
WHERE GVQL.HOTEN = N'Nguyễn Thanh Tùng'

--Q13. Cho biết tên giáo viên là trưởng bộ môn “Hệ thống thông tin”.
SELECT GV.HOTEN
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MAGV = BM.TRUONGBM
WHERE BM.TENBM = N'Hệ thống thông tin'

--Q14. Cho biết tên người chủ nhiệm đề tài của những đề tài thuộc chủ đề Quản lý giáo dục.
SELECT distinct GV.HOTEN
FROM DETAI DT JOIN GIAOVIEN GV ON DT.GVCNDT = GV.MAGV
	JOIN CHUDE CD ON DT.MACD = CD.MACD
WHERE CD.TENCD = N'Quản lý giáo dục'

--Q15. Cho biết tên các công việc của đề tài HTTT quản lý các trường ĐH có thời gian
-- bắt đầu trong tháng 3/2008.
SELECT CV.TENCV
FROM DETAI DT JOIN CONGVIEC CV ON DT.MADT = CV.MADT
WHERE DT.TENDT = N'HTTT quản lý các trường ĐH' AND (CV.NGAYBD BETWEEN '3/1/2008' AND '3/31/2008')

-- Q16. Cho biết tên giáo viên và tên người quản lý chuyên môn của giáo viên đó.
SELECT GV.HOTEN, GVQL.HOTEN
FROM GIAOVIEN GV JOIN GIAOVIEN GVQL ON GV.GVQLCM = GVQL.MAGV

-- Q17. Cho biết các công việc bắt đầu trong khoảng từ 01/01/2007 đến 01/08/2007.
SELECT *
FROM CONGVIEC 
WHERE NGAYBD BETWEEN '1/1/2007' AND '8/1/2007'

-- Q18. Cho biết họ tên các giáo viên cùng bộ môn với giáo viên “Trần Trà Hương”.
SELECT GV2.HOTEN
FROM GIAOVIEN GV1 JOIN GIAOVIEN GV2 ON GV1.MABM = GV2.MABM
WHERE GV1.HOTEN = N'Trần Trà Hương' AND  GV2.HOTEN != N'Trần Trà Hương'

-- Q19. Tìm những giáo viên vừa là trưởng bộ môn vừa chủ nhiệm đề tài.
SELECT DISTINCT GV.HOTEN
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MAGV = BM.TRUONGBM
	JOIN DETAI DT ON GV.MAGV = DT.GVCNDT

-- Q20. Cho biết tên những giáo viên vừa là trưởng khoa và vừa là trưởng bộ môn.
SELECT DISTINCT GV.HOTEN
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MAGV = BM.TRUONGBM
	JOIN KHOA K ON GV.MAGV = K.TRUONGKHOA

-- Q21. Cho biết tên những trưởng bộ môn mà vừa chủ nhiệm đề tài.
SELECT DISTINCT GV.HOTEN
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MAGV = BM.TRUONGBM
	JOIN DETAI DT ON GV.MAGV = DT.GVCNDT

-- Q22. Cho biết mã số các trưởng khoa có chủ nhiệm đề tài.
SELECT DISTINCT GV.MAGV
FROM GIAOVIEN GV JOIN KHOA K ON GV.MAGV = K.TRUONGKHOA
	JOIN DETAI DT ON GV.MAGV = DT.GVCNDT

-- Q23. Cho biết mã số các giáo viên thuộc bộ môn “HTTT” hoặc có tham gia đề tài mã “001”.
SELECT DISTINCT GV.MAGV
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM
	JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
WHERE BM.MABM = 'HTTT' OR TGDT.MADT = '001'

-- Q24. Cho biết giáo viên làm việc cùng bộ môn với giáo viên 002.
SELECT GV2.HOTEN
FROM GIAOVIEN GV1 JOIN GIAOVIEN GV2 ON GV1.MABM = GV2.MABM
WHERE GV1.MAGV = '002' AND GV2.MAGV != '002'

-- Q25. Tìm những giáo viên là trưởng bộ môn.
SELECT *
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MAGV = BM.TRUONGBM

-- Q26. Cho biết họ tên và mức lương của các giáo viên.
SELECT HOTEN, LUONG
FROM GIAOVIEN



