-------------------------------------------------------------------------------------------------------------------------
-- Before Dropping all the tables to rerun entire code, first dropping all constraints associated if any 
-------------------------------------------------------------------------------------------------------------------------
-- STEP 1: -> Dropping all Foreign Key constraints associated with all tables

DECLARE
    v_constraint_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_constraint_exists
    FROM user_constraints
    WHERE constraint_name IN (
        'FK_CUSTOMER_INSURANCE_ID',
        'FK_PRESCRIPTION_CUSTOMER_ID',
        'FK_PRESCRIBED_DRUGS_PRESCRIPTION_ID',
        'FK_EMPLOYEE_ROLE_ID',
        'FK_ORDER_BILL_EMPLOYEE_ID',
        'FK_ORDER_BILL_PRESCRIPTION_ID',
        'FK_ORDERED_DRUGS_DRUG_ID',
        'FK_ORDERED_DRUGS_ORDER_ID',
        'FK_PAYMENT_BILL_CUSTOMER_ID',
        'FK_PAYMENT_BILL_ORDER_ID',
        'FK_NOTIFICATION_DRUG_ID',
        'FK_EMPLOYEE_NOTIFICATION_EMP_ID',
        'FK_EMPLOYEE_NOTIFICATION_NOTIF_ID'
    );

    IF v_constraint_exists > 0 THEN
        -- Drop foreign key constraints using dynamic SQL
        EXECUTE IMMEDIATE 'ALTER TABLE CUSTOMER DROP CONSTRAINT FK_CUSTOMER_INSURANCE_ID';
        EXECUTE IMMEDIATE 'ALTER TABLE PRESCRIPTION DROP CONSTRAINT FK_PRESCRIPTION_CUSTOMER_ID';
        EXECUTE IMMEDIATE 'ALTER TABLE PRESCRIBED_DRUGS DROP CONSTRAINT FK_PRESCRIBED_DRUGS_PRESCRIPTION_ID';
        EXECUTE IMMEDIATE 'ALTER TABLE EMPLOYEE DROP CONSTRAINT FK_EMPLOYEE_ROLE_ID';
        EXECUTE IMMEDIATE 'ALTER TABLE ORDER_BILL DROP CONSTRAINT FK_ORDER_BILL_EMPLOYEE_ID';
        EXECUTE IMMEDIATE 'ALTER TABLE ORDER_BILL DROP CONSTRAINT FK_ORDER_BILL_PRESCRIPTION_ID';
        EXECUTE IMMEDIATE 'ALTER TABLE ORDERED_DRUGS DROP CONSTRAINT FK_ORDERED_DRUGS_DRUG_ID';
        EXECUTE IMMEDIATE 'ALTER TABLE ORDERED_DRUGS DROP CONSTRAINT FK_ORDERED_DRUGS_ORDER_ID';
        EXECUTE IMMEDIATE 'ALTER TABLE PAYMENT_BILL DROP CONSTRAINT FK_PAYMENT_BILL_CUSTOMER_ID';
        EXECUTE IMMEDIATE 'ALTER TABLE PAYMENT_BILL DROP CONSTRAINT FK_PAYMENT_BILL_ORDER_ID';
        EXECUTE IMMEDIATE 'ALTER TABLE NOTIFICATION DROP CONSTRAINT FK_NOTIFICATION_DRUG_ID';
        EXECUTE IMMEDIATE 'ALTER TABLE EMPLOYEE_NOTIFICATION DROP CONSTRAINT FK_EMPLOYEE_NOTIFICATION_EMP_ID';
        EXECUTE IMMEDIATE 'ALTER TABLE EMPLOYEE_NOTIFICATION DROP CONSTRAINT FK_EMPLOYEE_NOTIFICATION_NOTIF_ID';
    END IF;
END;
/

----------------------------------------------------------------------------------------
-- DROPPING ALL TABLES (RERUN PURPOSE)
----------------------------------------------------------------------------------------
DECLARE
    v_table_count NUMBER;
BEGIN
    -- Check if table exists
    SELECT COUNT(*)
    INTO v_table_count
    FROM user_tables
    WHERE table_name IN (
        'INSURANCE',
        'CUSTOMER',
        'PRESCRIPTION',
        'PRESCRIBED_DRUGS',
        'ORDER_BILL',
        'ORDERED_DRUGS',
        'PAYMENT_BILL',
        'INVENTORY',
        'NOTIFICATION',
        'EMPLOYEE_NOTIFICATION',
        'EMPLOYEE',
        'ROLE'
    );

    -- Drop table if it exists
    IF v_table_count > 0 THEN
        EXECUTE IMMEDIATE 'DROP TABLE INSURANCE';
        EXECUTE IMMEDIATE 'DROP TABLE CUSTOMER';
        EXECUTE IMMEDIATE 'DROP TABLE PRESCRIPTION';
        EXECUTE IMMEDIATE 'DROP TABLE PRESCRIBED_DRUGS';
        EXECUTE IMMEDIATE 'DROP TABLE ORDER_BILL';
        EXECUTE IMMEDIATE 'DROP TABLE ORDERED_DRUGS';
        EXECUTE IMMEDIATE 'DROP TABLE PAYMENT_BILL';
        EXECUTE IMMEDIATE 'DROP TABLE INVENTORY';
        EXECUTE IMMEDIATE 'DROP TABLE NOTIFICATION';
        EXECUTE IMMEDIATE 'DROP TABLE EMPLOYEE_NOTIFICATION';
        EXECUTE IMMEDIATE 'DROP TABLE EMPLOYEE';
        EXECUTE IMMEDIATE 'DROP TABLE ROLE';
    END IF;
END;
/

----------------------------------------------------------------------------------------
-- CREATING NEW TABLES
----------------------------------------------------------------------------------------

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

------------------------------------------------------------------------
-------------------- INSERTING DATA INTO ALL TABLES --------------------
------------------------------------------------------------------------

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

INSERT INTO INSURANCE (INSURANCE_ID, COMPANY_NAME, START_DATE, END_DATE, INSURANCE_BALANCE) 
VALUES ('INS006', 'MNO Insurance', TO_DATE('2022-06-01', 'YYYY-MM-DD'), TO_DATE('2023-06-01', 'YYYY-MM-DD'), 8000);

INSERT INTO INSURANCE (INSURANCE_ID, COMPANY_NAME, START_DATE, END_DATE, INSURANCE_BALANCE) 
VALUES ('INS007', 'PQR Insurance', TO_DATE('2022-07-01', 'YYYY-MM-DD'), TO_DATE('2023-07-01', 'YYYY-MM-DD'), 5500);

INSERT INTO INSURANCE (INSURANCE_ID, COMPANY_NAME, START_DATE, END_DATE, INSURANCE_BALANCE) 
VALUES ('INS008', 'STU Insurance', TO_DATE('2022-08-01', 'YYYY-MM-DD'), TO_DATE('2023-08-01', 'YYYY-MM-DD'), 7000);

INSERT INTO INSURANCE (INSURANCE_ID, COMPANY_NAME, START_DATE, END_DATE, INSURANCE_BALANCE) 
VALUES ('INS009', 'VWX Insurance', TO_DATE('2022-09-01', 'YYYY-MM-DD'), TO_DATE('2023-09-01', 'YYYY-MM-DD'), 6500);

INSERT INTO INSURANCE (INSURANCE_ID, COMPANY_NAME, START_DATE, END_DATE, INSURANCE_BALANCE) 
VALUES ('INS010', 'YZA Insurance', TO_DATE('2022-10-01', 'YYYY-MM-DD'), TO_DATE('2023-10-01', 'YYYY-MM-DD'), 9000);


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

INSERT INTO CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, CITY, INSURANCE_ID) 
VALUES ('CUST008', 'Laura', 'Garcia', 'Female', 'Miami', 'INS006');

INSERT INTO CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, CITY, INSURANCE_ID) 
VALUES ('CUST009', 'Kevin', 'Martinez', 'Male', 'Los Angeles', 'INS007');

INSERT INTO CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, CITY, INSURANCE_ID) 
VALUES ('CUST010', 'Jessica', 'Taylor', 'Female', 'Chicago', NULL);

INSERT INTO CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, CITY, INSURANCE_ID) 
VALUES ('CUST011', 'Daniel', 'Rodriguez', 'Male', 'New York', NULL);

INSERT INTO CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, CITY, INSURANCE_ID) 
VALUES ('CUST012', 'Sophia', 'Lopez', 'Female', 'Houston', 'INS008');

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

INSERT INTO PRESCRIPTION (CUSTOMER_ID, PRES_ID, PRES_DATE, DOC_ID) 
VALUES ('CUST006', 'PRES006', TO_DATE('2023-06-15', 'YYYY-MM-DD'), 'DOC006');

INSERT INTO PRESCRIPTION (CUSTOMER_ID, PRES_ID, PRES_DATE, DOC_ID) 
VALUES ('CUST007', 'PRES007', TO_DATE('2023-07-20', 'YYYY-MM-DD'), 'DOC007');

INSERT INTO PRESCRIPTION (CUSTOMER_ID, PRES_ID, PRES_DATE, DOC_ID) 
VALUES ('CUST008', 'PRES008', TO_DATE('2023-08-25', 'YYYY-MM-DD'), 'DOC008');

INSERT INTO PRESCRIPTION (CUSTOMER_ID, PRES_ID, PRES_DATE, DOC_ID) 
VALUES ('CUST009', 'PRES009', TO_DATE('2023-09-10', 'YYYY-MM-DD'), 'DOC009');

INSERT INTO PRESCRIPTION (CUSTOMER_ID, PRES_ID, PRES_DATE, DOC_ID) 
VALUES ('CUST010', 'PRES010', TO_DATE('2023-10-05', 'YYYY-MM-DD'), 'DOC010');

-- Generate sample data for PRESCRIBED_DRUGS table
INSERT INTO PRESCRIBED_DRUGS (PRES_ID, DRUG_NAME, QUANTITY) 
VALUES ('PRES001', 'Drug A', 10);

INSERT INTO PRESCRIBED_DRUGS (PRES_ID, DRUG_NAME, QUANTITY) 
VALUES ('PRES001', 'Drug B', 5);

INSERT INTO PRESCRIBED_DRUGS (PRES_ID, DRUG_NAME, QUANTITY) 
VALUES ('PRES002', 'Drug C', 15);

INSERT INTO PRESCRIBED_DRUGS (PRES_ID, DRUG_NAME, QUANTITY) 
VALUES ('PRES002', 'Drug D', 20);

INSERT INTO PRESCRIBED_DRUGS (PRES_ID, DRUG_NAME, QUANTITY) 
VALUES ('PRES002', 'Drug E', 10);

INSERT INTO PRESCRIBED_DRUGS (PRES_ID, DRUG_NAME, QUANTITY) 
VALUES ('PRES003', 'Drug F', 15);

INSERT INTO PRESCRIBED_DRUGS (PRES_ID, DRUG_NAME, QUANTITY) 
VALUES ('PRES004', 'Drug G', 12);

INSERT INTO PRESCRIBED_DRUGS (PRES_ID, DRUG_NAME, QUANTITY) 
VALUES ('PRES005', 'Drug H', 18);

INSERT INTO PRESCRIBED_DRUGS (PRES_ID, DRUG_NAME, QUANTITY) 
VALUES ('PRES006', 'Drug I', 10);

INSERT INTO PRESCRIBED_DRUGS (PRES_ID, DRUG_NAME, QUANTITY) 
VALUES ('PRES007', 'Drug J', 7);

INSERT INTO PRESCRIBED_DRUGS (PRES_ID, DRUG_NAME, QUANTITY) 
VALUES ('PRES008', 'Drug I', 10);

INSERT INTO PRESCRIBED_DRUGS (PRES_ID, DRUG_NAME, QUANTITY) 
VALUES ('PRES009', 'Drug J', 7);

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
VALUES ('EMP003', 'Anusha', 'Poojary', TO_DATE('2020-02-01', 'YYYY-MM-DD'), NULL, 'RL002', 7500);

INSERT INTO EMPLOYEE (EMP_ID, FIRST_NAME, LAST_NAME, START_DATE, END_DATE, ROLE_ID, SALARY) 
VALUES ('EMP004', 'Akshay', 'Kyle', TO_DATE('2020-03-01', 'YYYY-MM-DD'), NULL, 'RL003', 6000);

INSERT INTO EMPLOYEE (EMP_ID, FIRST_NAME, LAST_NAME, START_DATE, END_DATE, ROLE_ID, SALARY) 
VALUES ('EMP005', 'David', 'Brown', TO_DATE('2020-03-01', 'YYYY-MM-DD'), NULL, 'RL003', 6500);

-- Generate sample data for ORDER_BILL table
INSERT INTO ORDER_BILL (ORDER_ID, PRES_ID, EMP_ID, ORDER_DATE) 
VALUES ('ORDER001', 'PRES001', 'EMP002', TO_DATE('2023-01-20', 'YYYY-MM-DD'));

INSERT INTO ORDER_BILL (ORDER_ID, PRES_ID, EMP_ID, ORDER_DATE) 
VALUES ('ORDER002', 'PRES002', 'EMP003', TO_DATE('2023-02-25', 'YYYY-MM-DD'));

INSERT INTO ORDER_BILL (ORDER_ID, PRES_ID, EMP_ID, ORDER_DATE) 
VALUES ('ORDER003', 'PRES003', 'EMP002', TO_DATE('2023-03-30', 'YYYY-MM-DD'));

INSERT INTO ORDER_BILL (ORDER_ID, PRES_ID, EMP_ID, ORDER_DATE) 
VALUES ('ORDER004', 'PRES004', 'EMP003', TO_DATE('2023-04-20', 'YYYY-MM-DD'));

INSERT INTO ORDER_BILL (ORDER_ID, PRES_ID, EMP_ID, ORDER_DATE) 
VALUES ('ORDER005', 'PRES005', 'EMP002', TO_DATE('2023-05-25', 'YYYY-MM-DD'));

INSERT INTO ORDER_BILL (ORDER_ID, PRES_ID, EMP_ID, ORDER_DATE) 
VALUES ('ORDER006', 'PRES006', 'EMP003', TO_DATE('2023-06-30', 'YYYY-MM-DD'));

INSERT INTO ORDER_BILL (ORDER_ID, PRES_ID, EMP_ID, ORDER_DATE) 
VALUES ('ORDER007', 'PRES007', 'EMP002', TO_DATE('2023-07-10', 'YYYY-MM-DD'));

INSERT INTO ORDER_BILL (ORDER_ID, PRES_ID, EMP_ID, ORDER_DATE) 
VALUES ('ORDER008', 'PRES008', 'EMP003', TO_DATE('2023-08-05', 'YYYY-MM-DD'));

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

INSERT INTO INVENTORY (DRUG_ID, DRUG_NAME, MANUFACTURER, INV_QUANTITY, BUY_DATE, EXPIRY_DATE, PRICE, THRESHOLD_QUANTITY, RESTOCK_QUANTITY) 
VALUES ('DRG006', 'Drug F', 'Manufacturer F', 35, TO_DATE('2022-06-01', 'YYYY-MM-DD'), TO_DATE('2023-06-01', 'YYYY-MM-DD'), 12, 15, 25);

INSERT INTO INVENTORY (DRUG_ID, DRUG_NAME, MANUFACTURER, INV_QUANTITY, BUY_DATE, EXPIRY_DATE, PRICE, THRESHOLD_QUANTITY, RESTOCK_QUANTITY) 
VALUES ('DRG007', 'Drug G', 'Manufacturer G', 25, TO_DATE('2022-07-01', 'YYYY-MM-DD'), TO_DATE('2023-07-01', 'YYYY-MM-DD'), 18, 10, 20);

INSERT INTO INVENTORY (DRUG_ID, DRUG_NAME, MANUFACTURER, INV_QUANTITY, BUY_DATE, EXPIRY_DATE, PRICE, THRESHOLD_QUANTITY, RESTOCK_QUANTITY) 
VALUES ('DRG008', 'Drug H', 'Manufacturer H', 40, TO_DATE('2022-08-01', 'YYYY-MM-DD'), TO_DATE('2023-08-01', 'YYYY-MM-DD'), 22, 10, 20);

INSERT INTO INVENTORY (DRUG_ID, DRUG_NAME, MANUFACTURER, INV_QUANTITY, BUY_DATE, EXPIRY_DATE, PRICE, THRESHOLD_QUANTITY, RESTOCK_QUANTITY) 
VALUES ('DRG009', 'Drug I', 'Manufacturer I', 30, TO_DATE('2022-09-01', 'YYYY-MM-DD'), TO_DATE('2023-09-01', 'YYYY-MM-DD'), 20, 10, 20);

INSERT INTO INVENTORY (DRUG_ID, DRUG_NAME, MANUFACTURER, INV_QUANTITY, BUY_DATE, EXPIRY_DATE, PRICE, THRESHOLD_QUANTITY, RESTOCK_QUANTITY) 
VALUES ('DRG010', 'Drug J', 'Manufacturer J', 50, TO_DATE('2022-10-01', 'YYYY-MM-DD'), TO_DATE('2023-10-01', 'YYYY-MM-DD'), 30, 15, 25);

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

INSERT INTO ORDERED_DRUGS (ORDER_ID, DRUG_ID, ORDER_QUANTITY) 
VALUES ('ORDER004', 'DRG006', 8);

INSERT INTO ORDERED_DRUGS (ORDER_ID, DRUG_ID, ORDER_QUANTITY) 
VALUES ('ORDER005', 'DRG007', 5);

INSERT INTO ORDERED_DRUGS (ORDER_ID, DRUG_ID, ORDER_QUANTITY) 
VALUES ('ORDER006', 'DRG008', 10);

INSERT INTO ORDERED_DRUGS (ORDER_ID, DRUG_ID, ORDER_QUANTITY) 
VALUES ('ORDER007', 'DRG009', 12);

INSERT INTO ORDERED_DRUGS (ORDER_ID, DRUG_ID, ORDER_QUANTITY) 
VALUES ('ORDER008', 'DRG010', 15);

-- Generate sample data for PAYMENT_BILL table
INSERT INTO PAYMENT_BILL (BILL_ID, ORDER_ID, TOTAL_AMOUNT, CUSTOMER_ID, PATIENT_PAY, INSURANCE_PAY) 
VALUES ('BILL001', 'ORDER001', 200, 'CUST001', 180, 20);

INSERT INTO PAYMENT_BILL (BILL_ID, ORDER_ID, TOTAL_AMOUNT, CUSTOMER_ID, PATIENT_PAY, INSURANCE_PAY) 
VALUES ('BILL002', 'ORDER002', 300, 'CUST002', 300, 0);

INSERT INTO PAYMENT_BILL (BILL_ID, ORDER_ID, TOTAL_AMOUNT, CUSTOMER_ID, PATIENT_PAY, INSURANCE_PAY) 
VALUES ('BILL003', 'ORDER003', 150, 'CUST003', 150, 0);

INSERT INTO PAYMENT_BILL (BILL_ID, ORDER_ID, TOTAL_AMOUNT, CUSTOMER_ID, PATIENT_PAY, INSURANCE_PAY) 
VALUES ('BILL004', 'ORDER004', 250, 'CUST006', 250, 0);

INSERT INTO PAYMENT_BILL (BILL_ID, ORDER_ID, TOTAL_AMOUNT, CUSTOMER_ID, PATIENT_PAY, INSURANCE_PAY) 
VALUES ('BILL005', 'ORDER005', 180, 'CUST007', 180, 0);

INSERT INTO PAYMENT_BILL (BILL_ID, ORDER_ID, TOTAL_AMOUNT, CUSTOMER_ID, PATIENT_PAY, INSURANCE_PAY) 
VALUES ('BILL006', 'ORDER006', 320, 'CUST008', 300, 20);

INSERT INTO PAYMENT_BILL (BILL_ID, ORDER_ID, TOTAL_AMOUNT, CUSTOMER_ID, PATIENT_PAY, INSURANCE_PAY) 
VALUES ('BILL007', 'ORDER007', 400, 'CUST009', 400, 0);

INSERT INTO PAYMENT_BILL (BILL_ID, ORDER_ID, TOTAL_AMOUNT, CUSTOMER_ID, PATIENT_PAY, INSURANCE_PAY) 
VALUES ('BILL008', 'ORDER008', 450, 'CUST010', 450, 0);


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

INSERT INTO NOTIFICATION (NOTIF_ID, NOTIF_DATE, MESSAGE, DRUG_ID) 
VALUES ('NOTIF006', TO_DATE('2023-06-20', 'YYYY-MM-DD'), 'Drug F is running low in inventory. Restock needed.', 'DRG006');

INSERT INTO NOTIFICATION (NOTIF_ID, NOTIF_DATE, MESSAGE, DRUG_ID) 
VALUES ('NOTIF007', TO_DATE('2023-07-25', 'YYYY-MM-DD'), 'Drug G is running low in inventory. Restock needed.', 'DRG007');

INSERT INTO NOTIFICATION (NOTIF_ID, NOTIF_DATE, MESSAGE, DRUG_ID) 
VALUES ('NOTIF008', TO_DATE('2023-08-30', 'YYYY-MM-DD'), 'Drug H is running low in inventory. Restock needed.', 'DRG008');

INSERT INTO NOTIFICATION (NOTIF_ID, NOTIF_DATE, MESSAGE, DRUG_ID) 
VALUES ('NOTIF009', TO_DATE('2023-09-10', 'YYYY-MM-DD'), 'Drug I is running low in inventory. Restock needed.', 'DRG009');

INSERT INTO NOTIFICATION (NOTIF_ID, NOTIF_DATE, MESSAGE, DRUG_ID) 
VALUES ('NOTIF010', TO_DATE('2023-10-05', 'YYYY-MM-DD'), 'Drug J is running low in inventory. Restock needed.', 'DRG010');

-- Generate sample data for EMPLOYEE_NOTIFICATION table
INSERT INTO EMPLOYEE_NOTIFICATION (EMP_NOTIF_ID, NOTIF_ID, EMP_ID) 
VALUES ('EMP_NOTIF001', 'NOTIF001', 'EMP004');

INSERT INTO EMPLOYEE_NOTIFICATION (EMP_NOTIF_ID, NOTIF_ID, EMP_ID) 
VALUES ('EMP_NOTIF002', 'NOTIF002', 'EMP004');

INSERT INTO EMPLOYEE_NOTIFICATION (EMP_NOTIF_ID, NOTIF_ID, EMP_ID) 
VALUES ('EMP_NOTIF003', 'NOTIF003', 'EMP005');

INSERT INTO EMPLOYEE_NOTIFICATION (EMP_NOTIF_ID, NOTIF_ID, EMP_ID) 
VALUES ('EMP_NOTIF004', 'NOTIF004', 'EMP005');

INSERT INTO EMPLOYEE_NOTIFICATION (EMP_NOTIF_ID, NOTIF_ID, EMP_ID) 
VALUES ('EMP_NOTIF005', 'NOTIF005', 'EMP005');

INSERT INTO EMPLOYEE_NOTIFICATION (EMP_NOTIF_ID, NOTIF_ID, EMP_ID) 
VALUES ('EMP_NOTIF006', 'NOTIF006', 'EMP004');

INSERT INTO EMPLOYEE_NOTIFICATION (EMP_NOTIF_ID, NOTIF_ID, EMP_ID) 
VALUES ('EMP_NOTIF007', 'NOTIF007', 'EMP005');

INSERT INTO EMPLOYEE_NOTIFICATION (EMP_NOTIF_ID, NOTIF_ID, EMP_ID) 
VALUES ('EMP_NOTIF008', 'NOTIF008', 'EMP004');

INSERT INTO EMPLOYEE_NOTIFICATION (EMP_NOTIF_ID, NOTIF_ID, EMP_ID) 
VALUES ('EMP_NOTIF009', 'NOTIF009', 'EMP005');

INSERT INTO EMPLOYEE_NOTIFICATION (EMP_NOTIF_ID, NOTIF_ID, EMP_ID) 
VALUES ('EMP_NOTIF010', 'NOTIF010', 'EMP004');
----------------------------------------------------------------------------------------
-- Display all the tables 
----------------------------------------------------------------------------------------
--
--SELECT * FROM INSURANCE;
--
--SELECT * FROM CUSTOMER;
--
--SELECT * FROM PRESCRIPTION;
--
--SELECT * FROM PRESCRIBED_DRUGS;
--
--SELECT * FROM EMPLOYEE;
--
--SELECT * FROM ORDER_BILL;
--
--SELECT * FROM ORDERED_DRUGS;
--
--SELECT * FROM PAYMENT_BILL;
--
--SELECT * FROM INVENTORY;
--
--SELECT * FROM NOTIFICATION;
--
--SELECT * FROM EMPLOYEE_NOTIFICATION;

----------------------------------------------------------------------------------------
-- Dropping all the Users and Roles when rerun entire code
----------------------------------------------------------------------------------------
BEGIN
    -- Drop role if it exists
    FOR role_rec IN (SELECT * FROM dba_roles WHERE role IN ('PHARMACY_ADMIN', 'CASHIER', 'INVENTORY_MANAGER')) LOOP
        EXECUTE IMMEDIATE 'DROP ROLE ' || role_rec.role;
    END LOOP;

    -- Drop user if it exists
    FOR user_rec IN (SELECT * FROM dba_users WHERE username IN ('ADMIN_USER1', 'CASHIER_USER1', 'INVENTORY_MANAGER_USER1')) LOOP
        EXECUTE IMMEDIATE 'DROP USER ' || user_rec.username || ' CASCADE';
    END LOOP;
END;
/

SELECT * FROM dba_users;

-- Creating Roles and assigning tables to roles, followed by assigning roles to users
CREATE ROLE Pharmacy_Admin;
CREATE ROLE Cashier;
CREATE ROLE Inventory_Manager;

-- Granting privileges to Admin role
BEGIN
    FOR tbl IN (SELECT table_name FROM user_tables) LOOP
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON ' || tbl.table_name || ' TO Pharmacy_Admin';
    END LOOP;
END;
/

-- Role Admin & Cashier should only have access to order and pay bill tables
GRANT SELECT, INSERT, UPDATE, DELETE ON ORDER_BILL TO Cashier;
GRANT SELECT, INSERT, UPDATE, DELETE ON PAYMENT_BILL TO Cashier;

-- Grant INSERT privilege on additional tables for Cashier role
GRANT INSERT ON CUSTOMER TO Cashier;
GRANT INSERT ON PRESCRIPTION TO Cashier;
GRANT INSERT ON PRESCRIBED_DRUGS TO Cashier;

-- Role Inventory Manager should have access to inventory and notification tables
GRANT SELECT, INSERT, UPDATE, DELETE ON INVENTORY TO Inventory_Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON NOTIFICATION TO Inventory_Manager;


-- Creating new users and granting resources to each
CREATE USER admin_user1 IDENTIFIED BY BostonSpring2024#;
CREATE USER cashier_user1 IDENTIFIED BY BostonSpring2024##;
CREATE USER inventory_manager_user1 IDENTIFIED BY BostonSpring2024###;

GRANT CONNECT, RESOURCE TO admin_user1;
GRANT CONNECT, RESOURCE TO cashier_user1;
GRANT CONNECT, RESOURCE TO inventory_manager_user1;

-- Assigning database quota for the users
ALTER USER admin_user1 QUOTA 50 M ON DATA;
ALTER USER cashier_user1 QUOTA 10 M ON DATA;
ALTER USER inventory_manager_user1 QUOTA 10 M ON DATA;

-- Assigning roles to users
GRANT Pharmacy_Admin TO admin_user1;
GRANT Cashier TO cashier_user1;
GRANT Inventory_Manager TO inventory_manager_user1;

----------------------------------------------------------------------------------------
-- Creating views and dropping views if Exists
----------------------------------------------------------------------------------------
DECLARE
    view_count INTEGER;
BEGIN
    -- Check if Inventory_Status view exists
    SELECT COUNT(*) INTO view_count FROM user_views WHERE view_name = 'INVENTORY_STATUS';
    IF view_count > 0 THEN
        EXECUTE IMMEDIATE 'DROP VIEW Inventory_Status';
    END IF;

    -- Check if Top_Customers view exists
    SELECT COUNT(*) INTO view_count FROM user_views WHERE view_name = 'TOP_CUSTOMERS';
    IF view_count > 0 THEN
        EXECUTE IMMEDIATE 'DROP VIEW Top_Customers';
    END IF;

    -- Check if Expiry_Drugs view exists
    SELECT COUNT(*) INTO view_count FROM user_views WHERE view_name = 'EXPIRY_DRUGS';
    IF view_count > 0 THEN
        EXECUTE IMMEDIATE 'DROP VIEW Expiry_Drugs';
    END IF;

    -- Check if Customer_Orders view exists
    SELECT COUNT(*) INTO view_count FROM user_views WHERE view_name = 'CUSTOMER_ORDERS';
    IF view_count > 0 THEN
        EXECUTE IMMEDIATE 'DROP VIEW Customer_Orders';
    END IF;
END;
/


-- View 1 => Inventory Status:
--This will display information like drug names, quantities, and expiry dates only to the employee responsible for handling the inventory.

CREATE VIEW Inventory_Status AS
SELECT DRUG_NAME, INV_QUANTITY, EXPIRY_DATE
FROM INVENTORY;

--SELECT * FROM Inventory_Status;

-- View 2 => Top-Customers

CREATE VIEW Top_Customers AS
SELECT CUSTOMER.CUSTOMER_ID, CUSTOMER.FIRST_NAME, CUSTOMER.LAST_NAME, SUM(PAYMENT_BILL.PATIENT_PAY) AS TOTAL_AMOUNT
FROM PAYMENT_BILL
JOIN CUSTOMER ON PAYMENT_BILL.CUSTOMER_ID = CUSTOMER.CUSTOMER_ID
GROUP BY CUSTOMER.CUSTOMER_ID, CUSTOMER.FIRST_NAME, CUSTOMER.LAST_NAME
ORDER BY TOTAL_AMOUNT DESC;


--select * from Top_Customers;

-- View 3 => Expiry Drugs

CREATE VIEW Expiry_Drugs AS
SELECT DRUG_NAME, EXPIRY_DATE
FROM INVENTORY
WHERE EXPIRY_DATE <= SYSDATE + 30; -- Assuming "about to expire" means expiring within the next 30 days


--select * from Expiry_Drugs;

-- View 4 => Customer Orders:

CREATE VIEW Customer_Orders AS
SELECT CUSTOMER.CUSTOMER_ID, FIRST_NAME, LAST_NAME, COUNT(ORDER_ID) AS TOTAL_ORDERS, SUM(TOTAL_AMOUNT) AS TOTAL_ORDER_AMOUNT
FROM CUSTOMER
LEFT JOIN PAYMENT_BILL ON CUSTOMER.CUSTOMER_ID = PAYMENT_BILL.CUSTOMER_ID
GROUP BY CUSTOMER.CUSTOMER_ID, FIRST_NAME, LAST_NAME;

--select * from Customer_Orders;