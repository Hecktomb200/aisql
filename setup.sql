PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS Pizza_Topping;
DROP TABLE IF EXISTS Pizza;
DROP TABLE IF EXISTS Topping;
DROP TABLE IF EXISTS Sauce;
DROP TABLE IF EXISTS Crust;
DROP TABLE IF EXISTS "Order";
DROP TABLE IF EXISTS Address;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Store;

CREATE TABLE Address (
    address_id INTEGER PRIMARY KEY AUTOINCREMENT,
    street TEXT NOT NULL,
    city TEXT NOT NULL,
    state TEXT NOT NULL,
    zip TEXT NOT NULL
);

CREATE TABLE Store (
    store_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    address_id INTEGER,
    phone TEXT,
    FOREIGN KEY (address_id) REFERENCES Address(address_id)
);

CREATE TABLE Customer (
    customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    phone_number TEXT,
    email TEXT
);

CREATE TABLE "Order" (
    order_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL,
    address_id INTEGER,
    store_id INTEGER NOT NULL,
    order_date TEXT NOT NULL, 
    total_amount REAL NOT NULL,
    delivery INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES Address(address_id),
    FOREIGN KEY (store_id) REFERENCES Store(store_id)
);

CREATE TABLE Crust (
    crust_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    extra_cost REAL DEFAULT 0.0
);

CREATE TABLE Sauce (
    sauce_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    extra_cost REAL DEFAULT 0.0
);

CREATE TABLE Topping (
    topping_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    extra_cost REAL DEFAULT 0.0
);

CREATE TABLE Pizza (
    pizza_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    size TEXT NOT NULL,
    crust_id INTEGER NOT NULL,
    sauce_id INTEGER NOT NULL,
    FOREIGN KEY (order_id) REFERENCES "Order"(order_id),
    FOREIGN KEY (crust_id) REFERENCES Crust(crust_id),
    FOREIGN KEY (sauce_id) REFERENCES Sauce(sauce_id)
);

CREATE TABLE Pizza_Topping (
    pizza_id INTEGER NOT NULL,
    topping_id INTEGER NOT NULL,
    PRIMARY KEY (pizza_id, topping_id),
    FOREIGN KEY (pizza_id) REFERENCES Pizza(pizza_id),
    FOREIGN KEY (topping_id) REFERENCES Topping(topping_id)
);

CREATE TABLE Employee (
    employee_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    store_id INTEGER NOT NULL,
    role TEXT,
    hourly_rate REAL NOT NULL,
    date_hired TEXT NOT NULL,
    phone_number TEXT,
    FOREIGN KEY (store_id) REFERENCES Store(store_id)
);
