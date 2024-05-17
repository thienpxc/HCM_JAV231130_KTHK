--tạo CSDL
CREATE DATABASE QLBHLEVANTHIEN

USE QLBHLEVANTHIEN

--Tạo bảng Customer
CREATE TABLE Customer
(
    cID INT PRIMARY KEY,
    cName NVARCHAR(25),
    cAge tinyint
   
)

--Tạo bảng Product
CREATE TABLE Product
(
    pID INT PRIMARY KEY,
    pName NVARCHAR(25),
    pPrice INT
)

--Tạo bảng Order
CREATE TABLE Orders
(
    oID INT PRIMARY KEY,
    cID INT,
    oDate DATETIME,
    oTotallPrice INT
)

--Tạo bảng OrderDetail
CREATE TABLE OrderDetail
(
    oID INT,
    pID INT,
    odQTY INT
)

--Tạo khóa phu Orders
ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Customer
FOREIGN KEY (cID) REFERENCES Customer(cID)

--Tạo khóa phu OrderDetail
ALTER TABLE OrderDetail
ADD CONSTRAINT FK_OrderDetail_Orders
FOREIGN KEY (oID) REFERENCES Orders(oid),
ADD CONSTRAINT FK_OrderDetail_Product
FOREIGN KEY (pID) REFERENCES Product(pID);

--1. them du lieu Customer
INSERT INTO Customer(cID,cName,cAge) VALUES (1,'Minh Quan', 10),
(2,'Ngoc Oanh', 20),
(3,'Hong Ha', 50);

--2. them du lieu Product
INSERT INTO Product(pID,pName,pPrice) VALUES (1,'May Giat', 3),
(2,'Tu Lanh', 5),
(3,'Dieu Hoa', 7),
(4,'Quat', 1),
(5,'Bep Dien', 2);

--3. them du lieu Order
INSERT INTO Orders(oID,cID,oDate,oTotallPrice) VALUES (1,1,'2006-03-21', NULL),
(2,2,'2006-03-23', NULL),
(3,1,'2006-03-16', NULL);

--4. them du lieu OrderDetail
INSERT INTO OrderDetail(oID,pID,odQTY) VALUES (1,1, 3),
(1,3, 7),
(1,4, 2),
(2,1, 1),
(3,1, 8),
(2,5, 4),
(2,3, 3);

--2. Hiển thị các thông tin  gồm oID, oDate, oPrice 
SELECT oID,cID, oDate, oTotallPrice
FROM Orders
ORDER BY oDate DESC;

--3.Hiển thị tên và giá của các sản phẩm có giá cao nhất
SELECT pName, pPrice
FROM Product
ORDER BY pPrice DESC
LIMIT 1;

--4.Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách đó
SELECT cName, pName
FROM Customer
JOIN Orders ON Customer.cID = Orders.cID
JOIN OrderDetail ON Orders.oID = OrderDetail.oID
JOIN Product ON OrderDetail.pID = Product.pID;

--5.Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào
SELECT cName
FROM Customer
LEFT JOIN Orders ON Customer.cID = Orders.cID
LEFT JOIN OrderDetail ON Orders.oID = OrderDetail.oID
WHERE OrderDetail.oID IS NULL;

--6. Hiển thị chi tiết của từng hóa đơn
SELECT o.oID, o.oDate, od.odQTY, p.pName, p.pPrice
FROM Orders o
JOIN OrderDetail od ON o.oID = od.oID
JOIN Product p ON od.pID = p.pID;

--7. Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn 
SELECT o.oID, o.oDate, SUM(odQTY*pPrice) AS Total
FROM orders o
JOIN OrderDetail r ON o.oID = r.oID
JOIN Product p ON r.pID = p.pID
GROUP BY o.oID, o.oDate;

-- 8.Tạo một view tên là Sales để hiển thị tổng doanh thu của siêu thị 
CREATE VIEW Sales AS
SELECT SUM(odQTY*pPrice) AS Sales
FROM orders o
JOIN OrderDetail r ON o.oID = r.oID
JOIN Product p ON r.pID = p.pID;

--9.Xóa tất cả các ràng buộc khóa ngoại, khóa chính của tất cả các bảng
--xoa thẻ phụ OrderDetail
ALTER TABLE OrderDetail
DROP FOREIGN KEY FK_OrderDetail_Orders,
DROP FOREIGN KEY FK_OrderDetail_Product;

--xoa thẻ phu Orders
ALTER TABLE Orders
DROP FOREIGN KEY FK_Orders_Customer;

--xoa thẻ chính của bảng Order
ALTER TABLE Orders
DROP PRIMARY KEY;

--xoa thẻ chính của bảng Product
ALTER TABLE Product
DROP PRIMARY KEY;

--xoa thẻ chính của bảng Customer
ALTER TABLE Customer
DROP PRIMARY KEY;

--10.Tạo một trigger tên là cusUpdate trên bảng Customer, sao cho khi sửa mã khách (cID) thì mã khách trong bảng Order cũng được sửa theo
DELIMITER //
CREATE TRIGGER cusUpdate
AFTER UPDATE ON Customer
FOR EACH ROW
BEGIN
    UPDATE Orders
    SET cID = NEW.cID
    WHERE cID = OLD.cID;
END;//
DELIMITER ;


--chỉnh sưa cột cID trong bảng Customer 1 thành 10
UPDATE Customer
SET cID = 10
WHERE cID = 1;

--11. Tạo một stored procedure tên là delProduct nhận vào 1 tham số là tên của  một sản phẩm, strored procedure này sẽ xóa sản phẩm có tên được truyên  vào thông qua tham số, và các thông tin liên quan đến sản phẩm đó ở trong bảng OrderDetail
DELIMITER //
CREATE PROCEDURE delProduct(IN input_pName VARCHAR(25))
BEGIN
    DECLARE v_pID INT;
    SELECT pID INTO v_pID
    FROM product
    WHERE pName = input_pName;
    DELETE FROM orderdetail
    WHERE pID = v_pID;
    DELETE FROM product
    WHERE pName = input_pName;
END//
DELIMITER ;



