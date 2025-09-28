INSERT INTO Address (street, city, state, zip) VALUES
('100 Main St', 'Provo', 'UT', '84604'),   
('200 Center St', 'Orem', 'UT', '84057'),  
('300 State St', 'Lehi', 'UT', '84043'),   
('12 Maple Ave', 'Provo', 'UT', '84604'),  
('77 Birch Ln', 'Orem', 'UT', '84057'),    
('9 Oak Ct', 'Lehi', 'UT', '84043'),       
('55 Pine Dr', 'Provo', 'UT', '84604');    


INSERT INTO Store (name, address_id, phone) VALUES
('ChatPizza Provo', 1, '(801) 555-1000'),
('ChatPizza Orem',  2, '(801) 555-2000'),
('ChatPizza Lehi',  3, '(801) 555-3000');


INSERT INTO Customer (first_name, last_name, phone_number, email) VALUES
('Laura', 'Stevenson', '(801) 555-4001', 'laura@example.com'),
('Bob', 'Jones', '(801) 555-4002', 'bob@example.com'),
('Charlie', 'Brown', '(801) 555-4003', 'charlie@example.com'),
('Sydney', 'Smith', '(801) 555-4004', 'sydney@example.com');


INSERT INTO Crust (name, extra_cost) VALUES
('Hand Tossed', 0.00),
('Thin', 0.50),
('Deep Dish', 1.00),
('Gluten Free', 1.50);


INSERT INTO Sauce (name, extra_cost) VALUES
('Tomato', 0.00),
('Garlic White', 0.75),
('Pesto', 1.00);


INSERT INTO Topping (name, extra_cost) VALUES
('Mozzarella', 0.00),
('Pepperoni', 0.75),
('Sausage', 0.75),
('Mushrooms', 0.50),
('Onions', 0.40),
('Olives', 0.50),
('Basil', 0.30);



INSERT INTO "Order" (customer_id, address_id, store_id, order_date, total_amount, delivery) VALUES
(1, NULL, 1, '2025-09-20 18:15:00', 18.50, 0);


INSERT INTO "Order" (customer_id, address_id, store_id, order_date, total_amount, delivery) VALUES
(2, 5, 2, '2025-09-21 19:05:00', 26.25, 1);


INSERT INTO "Order" (customer_id, address_id, store_id, order_date, total_amount, delivery) VALUES
(4, NULL, 3, '2025-09-22 12:30:00', 32.00, 0);



INSERT INTO Pizza (order_id, size, crust_id, sauce_id) VALUES (1, 'Medium', 1, 1); 


INSERT INTO Pizza (order_id, size, crust_id, sauce_id) VALUES (2, 'Large', 3, 1);  
INSERT INTO Pizza (order_id, size, crust_id, sauce_id) VALUES (2, 'Small', 2, 2);  


INSERT INTO Pizza (order_id, size, crust_id, sauce_id) VALUES (3, 'Large', 4, 3);  



INSERT INTO Pizza_Topping (pizza_id, topping_id) VALUES
(1, 1), 
(1, 2), 
(1, 4); 


INSERT INTO Pizza_Topping (pizza_id, topping_id) VALUES
(2, 1), (2, 3), (2, 5), (2, 6); 


INSERT INTO Pizza_Topping (pizza_id, topping_id) VALUES
(3, 1), (3, 4), (3, 6); 


INSERT INTO Pizza_Topping (pizza_id, topping_id) VALUES
(4, 1), (4, 2), (4, 3), (4, 4), (4, 5), (4, 6), (4, 7); 