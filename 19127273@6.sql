
USE QLDT
GO

-- Q30. Cho biết tên giáo viên và số lượng đề tài mà giáo viên đó tham gia.
SELECT GV.HOTEN, COUNT(DISTINCT TGDT.MADT) SODTTG
FROM GIAOVIEN GV JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
GROUP BY GV.HOTEN, GV.MAGV

-- Q31. Cho biết tên giáo viên và số lượng đề tài mà giáo viên đó làm chủ nhiệm.
SELECT GV.HOTEN, COUNT(DT.MADT) SODTCN
FROM GIAOVIEN GV JOIN DETAI DT ON GV.MAGV = DT.GVCNDT
GROUP BY GV.HOTEN

-- Q32. Với mỗi giáo viên cho tên giáo viên và số người thân của giáo viên đó.
SELECT GV.HOTEN, COUNT(NT.MAGV) SONT
FROM GIAOVIEN GV JOIN NGUOITHAN NT ON GV.MAGV = NT.MAGV
GROUP BY GV.HOTEN

-- Q33. Cho biết tên những giáo viên đã tham gia từ 3 đề tài trở lên.
SELECT GV.MAGV, GV.HOTEN, COUNT(DISTINCT TGDT.MADT) SODTTG
FROM GIAOVIEN GV JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
GROUP BY GV.HOTEN, GV.MAGV
HAVING COUNT(DISTINCT TGDT.MADT) >= 3

-- Q34. Cho biết số lượng giáo viên đã tham gia vào đề tài Ứng dụng hóa học xanh.
SELECT COUNT(DISTINCT TGDT.MAGV) SOLUONGGV
FROM DETAI DT JOIN THAMGIADT TGDT ON DT.MADT = TGDT.MADT
WHERE DT.TENDT=N'Ứng dụng hóa học xanh'

