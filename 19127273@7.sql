
USE QLDT

-- Q35. Cho biết mức lương cao nhất của các giảng viên.
SELECT DISTINCT LUONG
FROM GIAOVIEN
WHERE LUONG >= ALL ( SELECT LUONG 
					FROM GIAOVIEN)

-- Q36. Cho biết những giáo viên có lương lớn nhất.
SELECT *
FROM GIAOVIEN
WHERE LUONG >= ALL (SELECT LUONG
					FROM GIAOVIEN)

-- Q37. Cho biết lương cao nhất trong bộ môn “HTTT”.
SELECT LUONG
FROM GIAOVIEN
WHERE MABM = 'HTTT' AND LUONG >= ALL (SELECT LUONG 
										FROM GIAOVIEN 
										WHERE MABM = 'HTTT')

-- Q38. Cho biết tên giáo viên lớn tuổi nhất của bộ môn Hệ thống thông tin.
SELECT *
FROM GIAOVIEN
WHERE MABM = 'HTTT' AND YEAR(NGSINH) >= ALL (SELECT YEAR(NGSINH)
												FROM GIAOVIEN
												WHERE MABM = 'HTTT')

-- Q39. Cho biết tên giáo viên nhỏ tuổi nhất khoa Công nghệ thông tin.
SELECT *
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM
				JOIN KHOA K ON BM.MAKHOA = K.MAKHOA
WHERE K.TENKHOA = N'Công nghệ thông tin' AND YEAR(GV.NGSINH) >= ALL (SELECT YEAR(GV.NGSINH)
																	FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM
																	JOIN KHOA K ON BM.MAKHOA = K.MAKHOA
																	WHERE K.TENKHOA = N'Công nghệ thông tin')

-- Q40. Cho biết tên giáo viên và tên khoa của giáo viên có lương cao nhất.
SELECT GV.HOTEN, K.TENKHOA
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM
					JOIN KHOA K ON BM.MAKHOA = K.MAKHOA
WHERE GV.LUONG >= ALL (SELECT LUONG
						FROM GIAOVIEN)

-- Q41. Cho biết những giáo viên có lương lớn nhất trong bộ môn của họ.
SELECT GV.*
FROM GIAOVIEN GV
WHERE GV.LUONG = (SELECT MAX(GV1.LUONG)
					FROM GIAOVIEN GV1
					WHERE GV1.MABM = GV.MABM)

-- Q42. Cho biết tên những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia.
SELECT DT.TENDT
FROM DETAI DT 
WHERE DT.MADT NOT IN (SELECT TG.MADT
						FROM THAMGIADT TG JOIN GIAOVIEN GV ON TG.MAGV = GV.MAGV
						WHERE GV.HOTEN = N'Nguyễn Hoài An')

-- Q43. Cho biết những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia. Xuất ra tên đề tài,
-- tên người chủ nhiệm đề tài.
SELECT DT.TENDT, GV.HOTEN
FROM DETAI DT JOIN GIAOVIEN GV ON DT.GVCNDT = GV.MAGV
WHERE DT.MADT NOT IN (SELECT TG.MADT
						FROM THAMGIADT TG JOIN GIAOVIEN GV ON TG.MAGV = GV.MAGV
						WHERE GV.HOTEN = N'Nguyễn Hoài An')

-- Q44. Cho biết tên những giáo viên khoa Công nghệ thông tin mà chưa tham gia đề tài nào.
SELECT GV.HOTEN
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM
				JOIN KHOA K ON BM.MAKHOA = K.MAKHOA
WHERE K.TENKHOA = N'Công nghệ thông tin' AND GV.MAGV NOT IN (SELECT TG.MAGV
																FROM THAMGIADT TG)

-- Q45. Tìm những giáo viên không tham gia bất kỳ đề tài nào
SELECT GV.*
FROM GIAOVIEN GV
WHERE GV.MAGV NOT IN (SELECT TG.MAGV FROM THAMGIADT TG)

-- Q46. Cho biết giáo viên có lương lớn hơn lương của giáo viên “Nguyễn Hoài An”
SELECT GV.*
FROM GIAOVIEN GV
WHERE GV.LUONG > (SELECT LUONG
					FROM GIAOVIEN
					WHERE HOTEN = N'Nguyễn Hoài An')

-- Q47. Tìm những trưởng bộ môn tham gia tối thiểu 1 đề tài

SELECT GV.*
FROM GIAOVIEN GV JOIN BOMON BM ON BM.TRUONGBM = GV.MAGV
WHERE (SELECT COUNT(TG.MADT) 
		FROM THAMGIADT TG
		WHERE GV.MAGV = TG.MAGV) >= 1

-- Q48. Tìm giáo viên trùng tên và cùng giới tính với giáo viên khác trong cùng bộ môn
SELECT GV.*
FROM GIAOVIEN GV
WHERE EXISTS ( SELECT *
				FROM GIAOVIEN GV1
				WHERE GV.HOTEN = GV1.HOTEN AND GV.PHAI = GV1.PHAI AND GV.MABM = GV1.MABM AND GV.MAGV != GV1.MAGV)

-- Q49. Tìm những giáo viên có lương lớn hơn lương của ít nhất một giáo viên bộ môn “Công
-- nghệ phần mềm”
SELECT *
FROM GIAOVIEN 
WHERE LUONG > ANY (SELECT GV.LUONG 
					FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM
					WHERE BM.TENBM = N'Công nghệ phần mềm')

-- Q50. Tìm những giáo viên có lương lớn hơn lương của tất cả giáo viên thuộc bộ môn “Hệ
-- thống thông tin”
SELECT *
FROM GIAOVIEN GV
WHERE GV.LUONG > ALL (SELECT GV.LUONG
						FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM
						WHERE BM.TENBM = N'Hệ thống thông tin')

-- Q51. Cho biết tên khoa có đông giáo viên nhất
SELECT K.TENKHOA
FROM KHOA K JOIN BOMON BM ON K.MAKHOA = BM.MAKHOA
			JOIN GIAOVIEN GV ON GV.MABM = BM.MABM
GROUP BY K.TENKHOA
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
						FROM KHOA K JOIN BOMON BM ON K.MAKHOA = BM.MAKHOA
						JOIN GIAOVIEN GV ON GV.MABM = BM.MABM
						GROUP BY K.TENKHOA)

-- Q52. Cho biết họ tên giáo viên chủ nhiệm nhiều đề tài nhất
SELECT GV.HOTEN
FROM GIAOVIEN GV JOIN DETAI DT ON GV.MAGV = DT.GVCNDT
GROUP BY GV.MAGV, GV.HOTEN
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
						FROM GIAOVIEN GV JOIN DETAI DT ON GV.MAGV = DT.GVCNDT
						GROUP BY GV.MAGV)

-- Q53. Cho biết mã bộ môn có nhiều giáo viên nhất
SELECT GV.MABM
FROM GIAOVIEN GV
GROUP BY GV.MABM
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
						FROM GIAOVIEN GV
						GROUP BY GV.MABM)

-- Q54. Cho biết tên giáo viên và tên bộ môn của giáo viên tham gia nhiều đề tài nhất.
SELECT GV.HOTEN, BM.TENBM
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM
				JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
GROUP BY GV.MAGV, GV.HOTEN, BM.TENBM
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
						FROM GIAOVIEN GV JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
						GROUP BY GV.MAGV)

-- Q55. Cho biết tên giáo viên tham gia nhiều đề tài nhất của bộ môn HTTT.
SELECT GV.HOTEN
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM
				JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
WHERE BM.TENBM = N'Hệ thống thông tin'
GROUP BY GV.MAGV, GV.HOTEN
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
						FROM GIAOVIEN GV JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
										JOIN BOMON BM ON BM.MABM = GV.MABM
						WHERE BM.TENBM = N'Hệ thống thông tin'
						GROUP BY GV.MAGV)

-- Q56. Cho biết tên giáo viên và tên bộ môn của giáo viên có nhiều người thân nhất.
SELECT GV.HOTEN, BM.TENBM
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM
					JOIN NGUOITHAN NT ON GV.MAGV = NT.MAGV
GROUP BY GV.MAGV, GV.HOTEN, BM.TENBM
HAVING COUNT(*) >= ALL ( SELECT COUNT(*)
							FROM NGUOITHAN NT
							GROUP BY MAGV)

-- Q57. Cho biết tên trưởng bộ môn mà chủ nhiệm nhiều đề tài nhất.
SELECT GV.HOTEN
FROM GIAOVIEN GV JOIN DETAI DT ON GV.MAGV = DT.GVCNDT
				JOIN BOMON BM  ON GV.MAGV = BM.TRUONGBM
GROUP BY GV.MAGV, GV.HOTEN
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
						FROM GIAOVIEN GV JOIN DETAI DT ON GV.MAGV = DT.GVCNDT
											JOIN BOMON BM ON GV.MAGV = BM.TRUONGBM
						GROUP BY GV.MAGV)

