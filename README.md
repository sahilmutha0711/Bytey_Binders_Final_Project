# Pharmacy Management System

This repository contains SQL scripts for setting up a Pharmacy Management System database. The system is designed to manage various aspects of a pharmacy, including customer information, prescriptions, drug inventory, employee details, billing, and notifications.

## Table of Contents

1. [Setup Instructions](#setup-instructions)
2. [Database Schema](#database-schema)
3. [Sample Data](#sample-data)
4. [Roles and Permissions](#roles-and-permissions)
5. [Views](#views)

## Setup Instructions

Before running the SQL scripts, ensure that you have a compatible SQL database management system installed. Follow these steps to set up the database:

1. Execute the SQL script provided in your SQL database management system.
2. Run each section of the script sequentially to create tables, insert sample data, manage roles and permissions, and create views.

## Database Schema

The database schema includes the following tables:

- `INSURANCE`: Stores information about insurance companies and their policies.
- `CUSTOMER`: Contains customer details including names, gender, city, and insurance information.
- `PRESCRIPTION`: Records prescriptions issued to customers, including prescription ID, issue date, and doctor ID.
- `PRESCRIBED_DRUGS`: Lists the drugs prescribed in each prescription along with quantities.
- `ROLE`: Defines roles within the system such as Admin, Cashier, and Inventory Manager.
- `EMPLOYEE`: Stores employee information including names, start dates, roles, and salaries.
- `INVENTORY`: Manages drug inventory details such as drug names, quantities, expiry dates, and prices.
- `ORDER_BILL`: Tracks orders placed by customers, including prescription ID, employee ID, and order date.
- `ORDERED_DRUGS`: Specifies the drugs ordered in each order along with quantities.
- `PAYMENT_BILL`: Manages payment details for orders including total amount, customer ID, and payment breakdown.
- `NOTIFICATION`: Stores notifications about low inventory or other system alerts.
- `EMPLOYEE_NOTIFICATION`: Associates employees with notifications for system alerts.

Each table has its own set of columns and constraints, which are detailed within the SQL script.

## Sample Data

Sample data has been provided for each table to demonstrate the functionality of the database. This data includes:

- Customer details
- Prescription information
- Drug inventory records
- Employee information
- Payment details
- System notifications

## Roles and Permissions

Roles have been defined to manage access to different parts of the database. Three roles have been created:

- `Pharmacy_Admin`: This role has full access to all tables in the database. They can create, modify, or delete user accounts and assign roles.
- `Cashier`: This role has access to billing-related information. They can view customer orders and generate bills but cannot access drug inventory details or sensitive employee information.
- `Inventory_Manager`: This role is responsible for managing drug inventory. They can view and update information related to drug inventory, including drug names, restock quantity, available quantity, and expiry dates. However, they cannot access customer or billing information.

Users have been assigned to these roles, and appropriate privileges have been granted to each role to ensure proper access control.

## Views

Several views have been created to provide simplified access to specific data within the database:

- `Inventory_Status`: Displays information about drug inventory including drug names, quantities, and expiry dates. This view is accessible to Inventory Managers.
- `Top_Customers`: Lists the top customers based on their total payment amounts. This view is accessible to Pharmacy Admins and Cashiers.
- `Expiry_Drugs`: Shows drugs that are about to expire within the next 30 days. This view is accessible to Inventory Managers.
- `Customer_Orders`: Provides summary information about customer orders including total orders and total order amounts. This view is accessible to Pharmacy Admins and Cashiers.

These views offer convenient ways to retrieve relevant information from the database.
