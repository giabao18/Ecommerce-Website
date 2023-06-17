create database MultiClientWebsiteShopping;

use MultiClientWebsiteShopping;

-- CREATE TABLE -----------------------------------------------

CREATE TABLE Clients
(
  Client_ContactNumber VARCHAR(20) NOT NULL,
  Client_Address VARCHAR(255) NOT NULL,
  Client_ID INT NOT NULL auto_increment,
  Client_Name VARCHAR(255) NOT NULL,
  CONSTRAINT CHECK (Client_ContactNumber REGEXP '^[0-9]{10,15}$'),
  PRIMARY KEY (Client_ID)
);

CREATE TABLE Make_Order
(
  Make_Order_Date DATE NOT NULL,
  Make_Order_Product_Quantity INT NOT NULL,
  Make_Order_Total_Price INT NOT NULL,
  Make_Order_ID INT NOT NULL auto_increment,
  Client_ID INT,
  PRIMARY KEY (Make_Order_ID),
  FOREIGN KEY (Client_ID) REFERENCES Clients(Client_ID)
);

CREATE TABLE Provider
(
  Provider_Brand VARCHAR(255) NOT NULL,
  Provider_Email varchar(255) NOT NULL CHECK (Provider_Email LIKE '%@%.%') unique,
  Provider_Product_Name VARCHAR(255) NOT NULL,
  PRIMARY KEY (Provider_Brand)
);

CREATE TABLE Product_Category
(
  Category_ID INT NOT NULL auto_increment,
  Category_Name VARCHAR(255) NOT NULL,
  PRIMARY KEY (Category_ID)
);

CREATE TABLE Shopping_Website
(
  Website_URL varchar(255) NOT NULL ,
  Website_Email varchar(255) NOT NULL CHECK (Website_Email LIKE '%@%.%') unique,
  Website_ContactNumber VARCHAR(20) NOT NULL CHECK (Website_ContactNumber REGEXP '^[0-9]{10,15}$'),
  primary key (Website_URL)
);


CREATE TABLE Admin
(
  Admin_ID INT NOT NULL auto_increment,
  Admin_Name VARCHAR(255) NOT NULL,
  Admin_Email varchar(255) NOT NULL CHECK (Admin_Email LIKE '%@%.%') unique,
  Admin_ContactNumber VARCHAR(20) CHECK (Admin_ContactNumber REGEXP '^[0-9]{10,15}$'),
  Website_URL varchar(255) NOT NULL,
  PRIMARY KEY (Admin_ID),
  FOREIGN KEY (Website_URL) REFERENCES Shopping_Website(Website_URL)
);

CREATE TABLE Menu
(
  Website_URL varchar(255) NOT NULL ,
  Category_ID INT NOT NULL auto_increment,
  PRIMARY KEY (Website_URL, Category_ID),
  FOREIGN KEY (Website_URL) REFERENCES Shopping_Website(Website_URL),
  FOREIGN KEY (Category_ID) REFERENCES Product_Category(Category_ID)
);-- 

CREATE TABLE Product
(
  Product_ID INT NOT NULL auto_increment,
  Product_Price INT NOT NULL,
  Product_Name VARCHAR(255) NOT NULL,
  Product_Quantity INT NOT NULL,
  Category_ID INT NOT NULL,
  PRIMARY KEY (Product_ID),
  FOREIGN KEY (Category_ID) REFERENCES Product_Category(Category_ID)
);

CREATE TABLE Selection
(
  Make_Order_ID INT NOT NULL auto_increment,
  Product_ID INT NOT NULL,
  PRIMARY KEY (Make_Order_ID, Product_ID),
  FOREIGN KEY (Make_Order_ID) REFERENCES Make_Order(Make_Order_ID),
  FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);

CREATE TABLE Distribution
(
  Product_ID INT NOT NULL auto_increment,
  Provider_Brand VARCHAR(255) NOT NULL,
  PRIMARY KEY (Product_ID, Provider_Brand),
  FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID),
  FOREIGN KEY (Provider_Brand) REFERENCES Provider(Provider_Brand)
);

-- CREATE VIEW -------------------------------------------------------
  
  CREATE VIEW MyView_Client_Order_Product AS
SELECT 
  Clients.Client_ID, Clients.Client_Name, Clients.Client_ContactNumber, Clients.Client_Address,
  Make_Order.Make_Order_ID, Make_Order.Make_Order_Date, Make_Order.Make_Order_Product_Quantity, Make_Order.Make_Order_Total_Price,
  GROUP_CONCAT(Product.Product_Name) AS Ordered_Products , Product.Product_Price
FROM
  Clients
  JOIN Make_Order ON Clients.Client_ID = Make_Order.Client_ID
  JOIN Selection ON Make_Order.Make_Order_ID = Selection.Make_Order_ID
  JOIN Product ON Selection.Product_ID = Product.Product_ID
GROUP BY
  Clients.Client_ID, Clients.Client_Name, Clients.Client_ContactNumber, Clients.Client_Address,
  Make_Order.Make_Order_ID, Make_Order.Make_Order_Date, Make_Order.Make_Order_Total_Price;



  CREATE VIEW MyView_Provider_Products AS
SELECT 
  Distribution.Provider_brand,Provider.Provider_Email,Provider.Provider_Product_name,
  Distribution.Product_ID,Product.Product_Name,Product.Product_Price
FROM
  Provider
  JOIN Distribution ON Provider.Provider_Brand = Distribution.Provider_Brand
  JOIN Product ON Distribution.Product_ID = Product.Product_ID;



CREATE VIEW MyView_Admin_Website_ProductCategory AS
SELECT 
  Shopping_Website.Website_URL,Shopping_Website.Website_Email,Shopping_Website.Website_ContactNumber,
  Admin.Admin_Name,Admin.Admin_Email,
  Product_Category.Category_ID,Product_Category.Category_Name
FROM
  Shopping_Website
  JOIN Admin ON Admin.Website_URL = Shopping_Website.Website_URL
  JOIN Menu ON Shopping_Website.Website_URL = Menu.Website_URL
  JOIN Product_Category ON Menu.Category_ID = Product_Category.Category_ID;


-- INSERT ALL DATA -------------------------------------------------------------

INSERT INTO Clients (Client_ContactNumber, Client_Address, Client_Name)
VALUES
  ('1234567890', '123 Main Street', 'John Smith'),
  ('9876543210', '456 Elm Avenue', 'Jane Doe'),
  ('5551112222', '789 Oak Road', 'Michael Johnson'),
  ('9998887777', '321 Pine Lane', 'Emily Wilson'),
  ('4445556666', '654 Cedar Court', 'David Thompson'),
  ('7778889999', '987 Maple Drive', 'Sarah Brown'),
  ('2223334444', '123 Oak Street', 'Robert Davis'),
  ('6667778888', '456 Pine Avenue', 'Jennifer Miller'),
  ('1112223333', '789 Elm Road', 'Daniel Wilson'),
  ('8889990000', '321 Cedar Lane', 'Jessica Anderson');

INSERT INTO Make_Order (Make_Order_Date, Make_Order_Product_Quantity, Make_Order_Total_Price, Client_ID)
VALUES
  ('2023-05-01', 3, 300, 1),
  ('2023-05-02', 2, 400, 2),
  ('2023-05-03', 1, 999, 3),
  ('2023-05-04', 4, 1998, 4),
  ('2023-05-05', 2, 798, 5),
  ('2023-05-06', 3, 1200, 6),
  ('2023-05-07', 1, 1500, 7),
  ('2023-05-08', 2, 3000, 8),
  ('2023-05-09', 3, 1497, 9),
  ('2023-05-10', 4, 1996, 10),
  ('2023-05-11', 2, 6000, 1),
  ('2023-05-12', 3, 6000, 2),
  ('2023-05-13', 1, 399, 3),
  ('2023-05-14', 4, 1996, 4),
  ('2023-05-15', 2, 1000, 5),
  ('2023-05-16', 3, 897, 6),
  ('2023-05-17', 1, 299, 7),
  ('2023-05-18', 2, 20000, 8),
  ('2023-05-19', 3, 897, 9),
  ('2023-05-20', 4, 1196, 10);

INSERT INTO Provider (Provider_Brand, Provider_Email, Provider_Product_Name)
VALUES
  ('Nike', 'nike@example.com', 'Air Jordan 1'),
  ('Adidas', 'adidas@example.com', 'Ultraboost 21'),
  ('Apple', 'apple@example.com', 'iPhone 13 Pro'),
  ('Samsung', 'samsung@example.com', 'Galaxy Watch 4'),
  ('Gucci', 'gucci@example.com', 'GG Marmont Mini Bag'),
  ('Sony', 'sony@example.com', 'PlayStation 5'),
  ('Canon', 'canon@example.com', 'EOS R5'),
  ('Tiffany & Co.', 'tiffany@example.com', 'Diamond Necklace'),
  ('KitchenAid', 'kitchenaid@example.com', 'Stand Mixer'),
  ('DJI', 'dji@example.com', 'Mavic Air 2'),
  ('Patagonia', 'patagonia@example.com', 'Down Jacket'),
  ('Bose', 'bose@example.com', 'QuietComfort Earbuds'),
  ('Rolex', 'rolex@example.com', 'Submariner'),
  ('Nintendo', 'nintendo@example.com', 'Switch'),
  ('Swarovski', 'swarovski@example.com', 'Crystal Earrings');
  
  
INSERT INTO Product_Category (Category_Name)
VALUES
  ('Shoes'),
  ('Electronics'),
  ('Bags'),
  ('Gaming'),
  ('Jewelry'),
  ('Kitchen Appliances'),
  ('Clothing');


INSERT INTO Product (Product_Price, Product_Name, Product_Quantity, Category_ID)
VALUES
  (100, 'Air Jordan 1', 5, 1),
  (200, 'Ultraboost 21', 8, 1),
  (999, 'iPhone 13 Pro', 3, 2),
  (399, 'Galaxy Watch 4', 6, 2),
  (1500, 'GG Marmont Mini Bag', 2, 3),
  (499, 'PlayStation 5', 4, 4),
  (3000, 'EOS R5', 3, 4),
  (2000, 'Diamond Necklace', 2, 3),
  (399, 'Stand Mixer', 5, 5),
  (999, 'Mavic Air 2', 4, 6),
  (299, 'Down Jacket', 10, 1),
  (299, 'QuietComfort Earbuds', 7, 7),
  (10000, 'Rolex Submariner', 1, 3),
  (299, 'Nintendo Switch', 9, 6),
  (500, 'Crystal Earrings', 3, 3);



INSERT INTO Shopping_Website (Website_URL, Website_Email, Website_ContactNumber)
VALUES
  ('https://www.shoestore.com', 'info@shoestore.com', '1234567890'),
  ('https://www.electronicsstore.com', 'info@electronicsstore.com', '2345678101'),
  ('https://www.bagstore.com', 'info@bagstore.com', '3456789012'),
  ('https://www.gamingstore.com', 'info@gamingstore.com', '4567890123'),
('https://www.jewelrystore.com', 'info@jewelrystore.com', '1334567890'),
  ('https://www.kitchenappliances.com', 'info@kitchenappliances.com', '1345678901'),
  ('https://www.clothingstore.com', 'info@clothingstore.com', '3416789012');


INSERT INTO Admin (Admin_Name, Admin_Email, Admin_ContactNumber, Website_URL)
VALUES
  ('Admin 1', 'admin1@shoestore.com', '9876543210', 'https://www.shoestore.com'),
  ('Admin 2', 'admin2@electronicsstore.com', '8765432109', 'https://www.electronicsstore.com'),
  ('Admin 3', 'admin3@bagstore.com', '7654321098', 'https://www.bagstore.com'),
  ('Admin 4', 'admin4@gamingstore.com', '6543210987', 'https://www.gamingstore.com'),
  ('Admin 5', 'admin5@jewelrystore.com', '8725432109', 'https://www.jewelrystore.com'),
  ('Admin 6', 'admin6@kitchenappliances.com', '7654321091', 'https://www.kitchenappliances.com'),
  ('Admin 7', 'admin7@clothingstore.com', '6543213987', 'https://www.clothingstore.com');


INSERT INTO Menu (Website_URL, Category_ID)
VALUES
  ('https://www.shoestore.com', 1),   -- fashionstore.com belongs to category ID 1
  ('https://www.electronicsstore.com', 2),  -- electronicsstore.com belongs to category ID 2
  ('https://www.bagstore.com', 3),   -- fashionstore.com also belongs to category ID 3
  ('https://www.gamingstore.com', 4),  -- kitchenappliances.com belongs to category ID 3
  ('https://www.jewelrystore.com', 5),   -- fashionstore.com also belongs to category ID 4
  ('https://www.kitchenappliances.com', 6),  -- sportinggoodsstore.com belongs to category ID 4
  ('https://www.clothingstore.com', 7);  -- electronicsstore.com also belongs to category ID 5


  select * from Product_Category;
  
INSERT INTO Selection (Make_Order_ID, Product_ID)
VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 3),
  (5, 4),
  (6, 4),
  (7, 5),
  (8, 5),
  (9, 6),
  (10, 6),
  (11, 7),
  (12, 8),
  (13, 9),
  (14, 10),
  (15, 15),
  (16, 11),
  (17, 12),
  (18, 13),
  (19, 14),
  (20, 14);
  
  INSERT INTO Distribution (Product_ID, Provider_Brand)
VALUES
  (1, 'Nike'),
  (2, 'Adidas'),
  (3, 'Apple'),
  (4, 'Samsung'),
  (5, 'Gucci'),
  (6, 'Sony'),
  (7, 'Canon'),
  (8, 'Tiffany & Co.'),
  (9, 'KitchenAid'),
  (10, 'DJI'),
  (11, 'Patagonia'),
  (12, 'Bose'),
  (13, 'Rolex'),
  (14, 'Nintendo'),
  (15, 'Swarovski');



select * from MyView_Client_Order_Product;
select * from MyView_Provider_Products;
select * from MyView_Admin_Website_ProductCategory;
