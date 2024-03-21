# Pharmacy Management System

This repository contains SQL scripts for setting up a Pharmacy Management System database. The scripts include table creations, data insertion, role management, user creation, view creations, and other necessary database operations.

## Table of Contents
- [Setup Instructions](#setup-instructions)
- [Database Schema](#database-schema)
- [Sample Data](#sample-data)
- [Roles and Permissions](#roles-and-permissions)
- [Views](#views)

## Setup Instructions

Before running the SQL scripts, ensure that you have a compatible SQL database management system installed. Follow these steps to set up the database:

1. Execute the SQL script provided in your SQL database management system.
2. Run each section of the script sequentially to create tables, insert sample data, manage roles and permissions, and create views.

## Database Schema

The database schema includes the following tables:

- `INSURANCE`
- `CUSTOMER`
- `PRESCRIPTION`
- `PRESCRIBED_DRUGS`
- `ROLE`
- `EMPLOYEE`
- `INVENTORY`
- `ORDER_BILL`
- `ORDERED_DRUGS`
- `PAYMENT_BILL`
- `NOTIFICATION`
- `EMPLOYEE_NOTIFICATION`

Each table has its own set of columns and constraints, which are detailed within the SQL script.

## Sample Data

Sample data has been provided for each table to demonstrate the functionality of the database. This data includes information such as customer details, prescriptions, drug inventory, employee details, and more.

## Roles and Permissions

Roles have been defined to manage access to different parts of the database. Three roles have been created:

1. `Pharmacy_Admin`: This role has full access to all tables in the database.
2. `Cashier`: This role has limited access to the `ORDER_BILL` and `PAYMENT_BILL` tables.
3. `Inventory_Manager`: This role has access to the `INVENTORY` and `NOTIFICATION` tables.

Users have been assigned to these roles, and appropriate privileges have been granted to each role to ensure proper access control.

## Views

Several views have been created to provide simplified access to specific data within the database:

1. `Inventory_Status`: Displays information about drug inventory including drug names, quantities, and expiry dates.
2. `Top_Customers`: Lists the top customers based on their total payment amounts.
3. `Expiry_Drugs`: Shows drugs that are about to expire within the next 30 days.
4. `Customer_Orders`: Provides summary information about customer orders including total orders and total order amounts.

These views offer convenient ways to retrieve relevant information from the database.

