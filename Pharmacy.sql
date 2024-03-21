CREATE USER cashier IDENTIFIED BY Fianlproject4DMDD1#;
CREATE USER inventory_manager IDENTIFIED BY Fianlproject4DMDD2#;

CREATE USER admin_user IDENTIFIED BY Fianlproject4DMDD3#;

CREATE ROLE Admins;
CREATE ROLE Cashiers;
CREATE ROLE Inventory_Managers;


GRANT Admins TO admin_user;
GRANT Cashiers TO cashier;
GRANT Inventory_Managers TO inventory_manager;

GRANT CREATE SESSION, ALTER SESSION TO cashier;

GRANT CREATE SESSION, CREATE VIEW, CREATE TABLE, ALTER SESSION, CREATE SEQUENCE TO cashier;

CREATE TABLE INSURANCE(
    INSURANCE_ID  VARCHAR(10),
    COMPANY_NAME  VARCHAR(25),
    START_DATE DATE,
    END_DATE DATE,
    INSURANCE_BALANCE NUMBER(6,0),
    CONSTRAINT PK_INSURANCE PRIMARY KEY (INSURANCE_ID)
);

CREATE TABLE CUSTOMER(
    CUSTOMER_ID VARCHAR(10),
    FIRST_NAME VARCHAR(25),
    LAST_NAME VARCHAR(25),
    GENDER VARCHAR(10),
    CITY VARCHAR(20),
    INSURANCE_ID VARCHAR(10),
    CONSTRAINT PK_CUSTOMER_ID PRIMARY KEY (CUSTOMER_ID),
    CONSTRAINT FK_CUSTOMER_INSURANCE_ID FOREIGN KEY (INSURANCE_ID) REFERENCES INSURANCE(INSURANCE_ID) ON DELETE CASCADE
);

CREATE TABLE PRESCRIPTION(
    CUSTOMER_ID VARCHAR(10),
    PRES_ID VARCHAR(10),
    PRES_DATE DATE,
    DOC_ID VARCHAR(10),
    CONSTRAINT PK_PRESCRIPTION_ID PRIMARY KEY (PRES_ID),
    CONSTRAINT FK_PRESCRIPTION_CUSTOMER_ID FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID) ON DELETE CASCADE
);



CREATE TABLE PRESCRIBED_DRUGS(
    PRES_ID VARCHAR(10),
    DRUG_NAME VARCHAR(25),
    QUANTITY NUMBER(3,0),
    CONSTRAINT PK_PRESCRIBED_DRUGS PRIMARY KEY (PRES_ID, DRUG_NAME),
    CONSTRAINT FK_PRESCRIBED_DRUGS_PRESCRIPTION_ID FOREIGN KEY (PRES_ID) REFERENCES PRESCRIPTION(PRES_ID) ON DELETE CASCADE
);

CREATE TABLE ROLE(
    ROLE_ID VARCHAR(10),
    ROLE_NAME VARCHAR(25),
    CONSTRAINT PK_ROLE_ID PRIMARY KEY(ROLE_ID),
    CONSTRAINT CHK_ROLE_NAME CHECK (ROLE_NAME IN ('Admin', 'Cashier', 'Inventory Manager')) -- Restricting entering of Role_name to just these 3 roles
);

CREATE TABLE EMPLOYEE(
    EMP_ID VARCHAR(10),
    FIRST_NAME VARCHAR(25),
    LAST_NAME VARCHAR(25),
    START_DATE DATE,
    END_DATE DATE,
    ROLE_ID VARCHAR(10),
    SALARY NUMERIC(6,0),
    CONSTRAINT PK_EMPLOYEE PRIMARY KEY (EMP_ID),
    CONSTRAINT FK_EMPLOYEE_ROLE_ID FOREIGN KEY (ROLE_ID) REFERENCES ROLE(ROLE_ID) ON DELETE CASCADE
);

CREATE TABLE INVENTORY(
    DRUG_ID VARCHAR(10),
    DRUG_NAME VARCHAR(25),
    MANUFACTURER VARCHAR(25),
    INV_QUANTITY NUMERIC(5,0),
    BUY_DATE DATE,
    EXPIRY_DATE DATE,
    PRICE NUMERIC(5,0),
    THRESHOLD_QUANTITY NUMERIC(5,0),
    RESTOCK_QUANTITY NUMERIC(5,0),
    CONSTRAINT PK_INVENTORY PRIMARY KEY (DRUG_ID)
);

CREATE TABLE ORDER_BILL(
    ORDER_ID VARCHAR(10),
    PRES_ID VARCHAR(10),
    EMP_ID VARCHAR(10),
    ORDER_DATE DATE,
    CONSTRAINT PK_ORDER_ID PRIMARY KEY (ORDER_ID),
    CONSTRAINT FK_ORDER_BILL_PRESCRIPTION_ID FOREIGN KEY (PRES_ID) REFERENCES PRESCRIPTION(PRES_ID) ON DELETE CASCADE,
    CONSTRAINT FK_ORDER_BILL_EMPLOYEE_ID FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEE(EMP_ID) ON DELETE CASCADE
);

CREATE TABLE ORDERED_DRUGS(
    ORDER_ID VARCHAR(10),
    DRUG_ID VARCHAR(10),
    ORDER_QUANTITY NUMBER(5,0),
    CONSTRAINT PK_ORDERED_DRUGS PRIMARY KEY (ORDER_ID, DRUG_ID),
    CONSTRAINT FK_ORDERED_DRUGS_ORDER_ID FOREIGN KEY (ORDER_ID) REFERENCES ORDER_BILL(ORDER_ID) ON DELETE CASCADE,
    CONSTRAINT FK_ORDERED_DRUGS_DRUG_ID FOREIGN KEY (DRUG_ID) REFERENCES INVENTORY(DRUG_ID) ON DELETE CASCADE
);

CREATE TABLE PAYMENT_BILL(
    BILL_ID VARCHAR(10),
    ORDER_ID VARCHAR(10),
    TOTAL_AMOUNT NUMERIC(5,0),
    CUSTOMER_ID VARCHAR(10),
    PATIENT_PAY NUMERIC(5,0),
    INSURANCE_PAY NUMERIC(10),
    CONSTRAINT PK_PAYMENT_BILL_ID PRIMARY KEY (BILL_ID),
    CONSTRAINT FK_PAYMENT_BILL_ORDER_ID FOREIGN KEY (ORDER_ID) REFERENCES ORDER_BILL(ORDER_ID) ON DELETE CASCADE,
    CONSTRAINT FK_PAYMENT_BILL_CUSTOMER_ID FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID) ON DELETE CASCADE
);

CREATE TABLE NOTIFICATION(
    NOTIF_ID VARCHAR(10),
    NOTIF_DATE DATE,
    MESSAGE VARCHAR(100),
    DRUG_ID VARCHAR(10),
    CONSTRAINT PK_NOTIFICATION_ID PRIMARY KEY (NOTIF_ID),
    CONSTRAINT FK_NOTIFICATION_DRUG_ID FOREIGN KEY (DRUG_ID) REFERENCES INVENTORY(DRUG_ID) ON DELETE CASCADE
);

CREATE TABLE EMPLOYEE_NOTIFICATION(
    EMP_NOTIF_ID VARCHAR(15),
    NOTIF_ID VARCHAR(10),
    EMP_ID VARCHAR(10),
    CONSTRAINT PK_EMPLOYEE_NOTIFICATION_ID PRIMARY KEY (EMP_NOTIF_ID),
    CONSTRAINT FK_EMPLOYEE_NOTIFICATION_NOTIF_ID FOREIGN KEY (NOTIF_ID) REFERENCES NOTIFICATION(NOTIF_ID) ON DELETE CASCADE,
    CONSTRAINT FK_EMPLOYEE_NOTIFICATION_EMP_ID FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEE(EMP_ID) ON DELETE CASCADE
);


// INSERTING DATA INTO ALL TABLES 

-- Generate sample data for INSURANCE table
INSERT INTO INSURANCE (INSURANCE_ID, COMPANY_NAME, START_DATE, END_DATE, INSURANCE_BALANCE) 
VALUES ('INS001', 'ABC Insurance', TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2023-01-01', 'YYYY-MM-DD'), 5000);

INSERT INTO INSURANCE (INSURANCE_ID, COMPANY_NAME, START_DATE, END_DATE, INSURANCE_BALANCE) 
VALUES ('INS002', 'XYZ Insurance', TO_DATE('2022-02-01', 'YYYY-MM-DD'), TO_DATE('2023-02-01', 'YYYY-MM-DD'), 7000);

INSERT INTO INSURANCE (INSURANCE_ID, COMPANY_NAME, START_DATE, END_DATE, INSURANCE_BALANCE) 
VALUES ('INS003', 'DEF Insurance', TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2023-03-01', 'YYYY-MM-DD'), 4500);

INSERT INTO INSURANCE (INSURANCE_ID, COMPANY_NAME, START_DATE, END_DATE, INSURANCE_BALANCE) 
VALUES ('INS004', 'GHI Insurance', TO_DATE('2022-04-01', 'YYYY-MM-DD'), TO_DATE('2023-04-01', 'YYYY-MM-DD'), 6000);

INSERT INTO INSURANCE (INSURANCE_ID, COMPANY_NAME, START_DATE, END_DATE, INSURANCE_BALANCE) 
VALUES ('INS005', 'JKL Insurance', TO_DATE('2022-05-01', 'YYYY-MM-DD'), TO_DATE('2023-05-01', 'YYYY-MM-DD'), 5500);
SELECT * FROM CUSTOMER;


-- Generate sample data for CUSTOMER table
INSERT INTO CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, CITY, INSURANCE_ID) 
VALUES ('CUST001', 'John', 'Doe', 'Male', 'New York', 'INS001');

INSERT INTO CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, CITY, INSURANCE_ID) 
VALUES ('CUST002', 'Alice', 'Smith', 'Female', 'LA', 'INS002');

INSERT INTO CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, CITY, INSURANCE_ID) 
VALUES ('CUST003', 'Bob', 'Johnson', 'Male', 'Chicago', NULL);

INSERT INTO CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, CITY, INSURANCE_ID) 
VALUES ('CUST004', 'Emma', 'Brown', 'Female', 'Houston', NULL);

INSERT INTO CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, CITY, INSURANCE_ID) 
VALUES ('CUST005', 'Michael', 'Wilson', 'Male', 'Phoenix', 'INS005');

INSERT INTO CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, CITY, INSURANCE_ID) 
VALUES ('CUST006', 'Sarah', 'Jones', 'Female', 'Miami', NULL);

INSERT INTO CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, CITY, INSURANCE_ID) 
VALUES ('CUST007', 'David', 'Lee', 'Male', 'Dallas', 'INS003');

-- Generate sample data for PRESCRIPTION table
INSERT INTO PRESCRIPTION (CUSTOMER_ID, PRES_ID, PRES_DATE, DOC_ID) 
VALUES ('CUST001', 'PRES001', TO_DATE('2023-01-15', 'YYYY-MM-DD'), 'DOC001');

INSERT INTO PRESCRIPTION (CUSTOMER_ID, PRES_ID, PRES_DATE, DOC_ID) 
VALUES ('CUST002', 'PRES002', TO_DATE('2023-02-20', 'YYYY-MM-DD'), 'DOC002');

INSERT INTO PRESCRIPTION (CUSTOMER_ID, PRES_ID, PRES_DATE, DOC_ID) 
VALUES ('CUST003', 'PRES003', TO_DATE('2023-03-25', 'YYYY-MM-DD'), 'DOC003');

INSERT INTO PRESCRIPTION (CUSTOMER_ID, PRES_ID, PRES_DATE, DOC_ID) 
VALUES ('CUST004', 'PRES004', TO_DATE('2023-04-10', 'YYYY-MM-DD'), 'DOC004');

INSERT INTO PRESCRIPTION (CUSTOMER_ID, PRES_ID, PRES_DATE, DOC_ID) 
VALUES ('CUST005', 'PRES005', TO_DATE('2023-05-05', 'YYYY-MM-DD'), 'DOC005');

-- Generate sample data for PRESCRIBED_DRUGS table
INSERT INTO PRESCRIBED_DRUGS (PRES_ID, DRUG_NAME, QUANTITY) 
VALUES ('PRES001', 'Drug A', 10);

INSERT INTO PRESCRIBED_DRUGS (PRES_ID, DRUG_NAME, QUANTITY) 
VALUES ('PRES001', 'Drug B', 5);

INSERT INTO PRESCRIBED_DRUGS (PRES_ID, DRUG_NAME, QUANTITY) 
VALUES ('PRES002', 'Drug C', 15);

INSERT INTO PRESCRIBED_DRUGS (PRES_ID, DRUG_NAME, QUANTITY) 
VALUES ('PRES003', 'Drug D', 20);

INSERT INTO PRESCRIBED_DRUGS (PRES_ID, DRUG_NAME, QUANTITY) 
VALUES ('PRES004', 'Drug E', 10);

-- Generate sample data for ROLE table
INSERT INTO ROLE (ROLE_ID, ROLE_NAME) 
VALUES ('RL001', 'Admin');

INSERT INTO ROLE (ROLE_ID, ROLE_NAME) 
VALUES ('RL002', 'Cashier');

INSERT INTO ROLE (ROLE_ID, ROLE_NAME) 
VALUES ('RL003', 'Inventory Manager');


-- Generate sample data for EMPLOYEE table
INSERT INTO EMPLOYEE (EMP_ID, FIRST_NAME, LAST_NAME, START_DATE, END_DATE, ROLE_ID, SALARY) 
VALUES ('EMP001', 'Michael', 'Johnson', TO_DATE('2020-01-01', 'YYYY-MM-DD'), NULL, 'RL001', 5000);

INSERT INTO EMPLOYEE (EMP_ID, FIRST_NAME, LAST_NAME, START_DATE, END_DATE, ROLE_ID, SALARY) 
VALUES ('EMP002', 'Emily', 'Williams', TO_DATE('2020-02-01', 'YYYY-MM-DD'), NULL, 'RL002', 5500);

INSERT INTO EMPLOYEE (EMP_ID, FIRST_NAME, LAST_NAME, START_DATE, END_DATE, ROLE_ID, SALARY) 
VALUES ('EMP003', 'David', 'Brown', TO_DATE('2020-03-01', 'YYYY-MM-DD'), NULL, 'RL003', 6000);


-- Generate sample data for ORDER_BILL table
INSERT INTO ORDER_BILL (ORDER_ID, PRES_ID, EMP_ID, ORDER_DATE) 
VALUES ('ORDER001', 'PRES001', 'EMP001', TO_DATE('2023-01-20', 'YYYY-MM-DD'));

INSERT INTO ORDER_BILL (ORDER_ID, PRES_ID, EMP_ID, ORDER_DATE) 
VALUES ('ORDER002', 'PRES002', 'EMP002', TO_DATE('2023-02-25', 'YYYY-MM-DD'));

INSERT INTO ORDER_BILL (ORDER_ID, PRES_ID, EMP_ID, ORDER_DATE) 
VALUES ('ORDER003', 'PRES003', 'EMP003', TO_DATE('2023-03-30', 'YYYY-MM-DD'));

-- Generate sample data for INVENTORY table
INSERT INTO INVENTORY (DRUG_ID, DRUG_NAME, MANUFACTURER, INV_QUANTITY, BUY_DATE, EXPIRY_DATE, PRICE, THRESHOLD_QUANTITY, RESTOCK_QUANTITY) 
VALUES ('DRG001', 'Drug A', 'Manufacturer A', 50, TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2023-01-01', 'YYYY-MM-DD'), 10, 10, 20);

INSERT INTO INVENTORY (DRUG_ID, DRUG_NAME, MANUFACTURER, INV_QUANTITY, BUY_DATE, EXPIRY_DATE, PRICE, THRESHOLD_QUANTITY, RESTOCK_QUANTITY) 
VALUES ('DRG002', 'Drug B', 'Manufacturer B', 30, TO_DATE('2022-02-01', 'YYYY-MM-DD'), TO_DATE('2023-02-01', 'YYYY-MM-DD'), 15, 10, 20);

INSERT INTO INVENTORY (DRUG_ID, DRUG_NAME, MANUFACTURER, INV_QUANTITY, BUY_DATE, EXPIRY_DATE, PRICE, THRESHOLD_QUANTITY, RESTOCK_QUANTITY) 
VALUES ('DRG003', 'Drug C', 'Manufacturer C', 20, TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2023-03-01', 'YYYY-MM-DD'), 20, 10, 20);

INSERT INTO INVENTORY (DRUG_ID, DRUG_NAME, MANUFACTURER, INV_QUANTITY, BUY_DATE, EXPIRY_DATE, PRICE, THRESHOLD_QUANTITY, RESTOCK_QUANTITY) 
VALUES ('DRG004', 'Drug D', 'Manufacturer D', 40, TO_DATE('2022-04-01', 'YYYY-MM-DD'), TO_DATE('2023-04-01', 'YYYY-MM-DD'), 25, 10, 20);

INSERT INTO INVENTORY (DRUG_ID, DRUG_NAME, MANUFACTURER, INV_QUANTITY, BUY_DATE, EXPIRY_DATE, PRICE, THRESHOLD_QUANTITY, RESTOCK_QUANTITY) 
VALUES ('DRG005', 'Drug E', 'Manufacturer E', 60, TO_DATE('2022-05-01', 'YYYY-MM-DD'), TO_DATE('2023-05-01', 'YYYY-MM-DD'), 50, 20, 30);


-- Generate sample data for ORDERED_DRUGS table
INSERT INTO ORDERED_DRUGS (ORDER_ID, DRUG_ID, ORDER_QUANTITY) 
VALUES ('ORDER001', 'DRG001', 5);

INSERT INTO ORDERED_DRUGS (ORDER_ID, DRUG_ID, ORDER_QUANTITY) 
VALUES ('ORDER001', 'DRG002', 3);

INSERT INTO ORDERED_DRUGS (ORDER_ID, DRUG_ID, ORDER_QUANTITY) 
VALUES ('ORDER002', 'DRG003', 10);

INSERT INTO ORDERED_DRUGS (ORDER_ID, DRUG_ID, ORDER_QUANTITY) 
VALUES ('ORDER002', 'DRG004', 8);

INSERT INTO ORDERED_DRUGS (ORDER_ID, DRUG_ID, ORDER_QUANTITY) 
VALUES ('ORDER002', 'DRG005', 12);

-- Generate sample data for PAYMENT_BILL table
INSERT INTO PAYMENT_BILL (BILL_ID, ORDER_ID, TOTAL_AMOUNT, CUSTOMER_ID, PATIENT_PAY, INSURANCE_PAY) 
VALUES ('BILL001', 'ORDER001', 200, 'CUST001', 180, 20);

INSERT INTO PAYMENT_BILL (BILL_ID, ORDER_ID, TOTAL_AMOUNT, CUSTOMER_ID, PATIENT_PAY, INSURANCE_PAY) 
VALUES ('BILL002', 'ORDER002', 300, 'CUST002', 300, 0);

INSERT INTO PAYMENT_BILL (BILL_ID, ORDER_ID, TOTAL_AMOUNT, CUSTOMER_ID, PATIENT_PAY, INSURANCE_PAY) 
VALUES ('BILL003', 'ORDER003', 150, 'CUST003', 150, 0);


-- Generate sample data for NOTIFICATION table
INSERT INTO NOTIFICATION (NOTIF_ID, NOTIF_DATE, MESSAGE, DRUG_ID) 
VALUES ('NOTIF001', TO_DATE('2023-01-25', 'YYYY-MM-DD'), 'Drug A is running low in inventory. Restock needed.', 'DRG001');

INSERT INTO NOTIFICATION (NOTIF_ID, NOTIF_DATE, MESSAGE, DRUG_ID) 
VALUES ('NOTIF002', TO_DATE('2023-02-28', 'YYYY-MM-DD'), 'Drug B is running low in inventory. Restock needed.', 'DRG002');

INSERT INTO NOTIFICATION (NOTIF_ID, NOTIF_DATE, MESSAGE, DRUG_ID) 
VALUES ('NOTIF003', TO_DATE('2023-03-15', 'YYYY-MM-DD'), 'Drug C is running low in inventory. Restock needed.', 'DRG003');

INSERT INTO NOTIFICATION (NOTIF_ID, NOTIF_DATE, MESSAGE, DRUG_ID) 
VALUES ('NOTIF004', TO_DATE('2023-04-10', 'YYYY-MM-DD'), 'Drug D is running low in inventory. Restock needed.', 'DRG004');

INSERT INTO NOTIFICATION (NOTIF_ID, NOTIF_DATE, MESSAGE, DRUG_ID) 
VALUES ('NOTIF005', TO_DATE('2023-05-05', 'YYYY-MM-DD'), 'Drug E is running low in inventory. Restock needed.', 'DRG005');

-- Generate sample data for EMPLOYEE_NOTIFICATION table
INSERT INTO EMPLOYEE_NOTIFICATION (EMP_NOTIF_ID, NOTIF_ID, EMP_ID) 
VALUES ('EMP_NOTIF001', 'NOTIF001', 'EMP001');

INSERT INTO EMPLOYEE_NOTIFICATION (EMP_NOTIF_ID, NOTIF_ID, EMP_ID) 
VALUES ('EMP_NOTIF002', 'NOTIF002', 'EMP001');

INSERT INTO EMPLOYEE_NOTIFICATION (EMP_NOTIF_ID, NOTIF_ID, EMP_ID) 
VALUES ('EMP_NOTIF003', 'NOTIF003', 'EMP002');

INSERT INTO EMPLOYEE_NOTIFICATION (EMP_NOTIF_ID, NOTIF_ID, EMP_ID) 
VALUES ('EMP_NOTIF004', 'NOTIF004', 'EMP003');

INSERT INTO EMPLOYEE_NOTIFICATION (EMP_NOTIF_ID, NOTIF_ID, EMP_ID) 
VALUES ('EMP_NOTIF005', 'NOTIF005', 'EMP003');


-- Role Admin & Cashier should only have access to order and pay bill tables
GRANT SELECT, INSERT, UPDATE, DELETE ON ORDER_BILL TO Cashiers;
GRANT SELECT, INSERT, UPDATE, DELETE ON PAYMENT_BILL TO Cashiers;

-- Role Inventory Manager should have access to inventory and notification tables
GRANT SELECT, INSERT, UPDATE, DELETE ON INVENTORY TO Inventory_Managers;
GRANT SELECT, INSERT, UPDATE, DELETE ON NOTIFICATION TO Inventory_Managers;