# QuickBasket

QuickBasket is a Java EE grocery e-commerce application built with JSP, Servlets, and MySQL. It provides a simple shopping flow for customers and a separate admin workflow for managing products, categories, and users.

## Overview

The application is designed around two roles:

- Normal users can register, log in, browse grocery products, manage a session cart, and checkout.
- Admin users can manage product inventory, categories, and registered users.

The storefront supports category filtering, live search, discounts, and product image rendering from the web assets folder.

## Key Features

- User registration, login, and logout
- Role-based routing for admin and customer accounts
- Product browsing with category filters and instant search
- Cart operations: add, remove, clear, and checkout
- Bill records stored during runtime for customer and admin views
- Admin product management for categories and inventory
- Admin user management for role changes and account deletion

## Tech Stack

- Java 17
- JSP, Servlets, JSTL
- Maven WAR packaging
- MySQL 8+
- Tomcat 9
- Bootstrap-based frontend styling

## Project Structure

```text
src/main/java/com/ecommerce/
  bean/        POJOs for users, products, cart items, bills, and categories
  controller/  Servlets for authentication, cart actions, admin actions, and logout
  dao/         Database access logic
  util/        Connection and helper utilities
src/main/webapp/
  *.jsp        UI pages for landing, auth, storefront, cart, and dashboards
  components/  Shared JSP fragments
  assets/     Static assets and product images
quickbasket_schema.sql  Database schema and sample data
```

## Requirements

- JDK 17
- Apache Maven 3.8 or newer
- Apache Tomcat 9
- MySQL 8 or newer

## Database Setup

1. Start MySQL and create a database named `ecommerce`.
2. Import `quickbasket_schema.sql` into that database.
3. Review `src/main/java/com/ecommerce/util/DBConnectionUtil.java` and update the JDBC URL, username, and password for your local environment.

The schema includes sample records for users, categories, and products. The seeded admin account is:

- Email: `admin@quickbasket.com`
- Password: `admin123`

The default connection settings in the code currently point to `jdbc:mysql://localhost:3306/ecommerce` with the MySQL username `root`.

## Build Instructions

From the project root, run:

```bash
mvn clean package
```

This produces `target/ecommerce-project.war`.

## Deployment and Run

1. Copy `target/ecommerce-project.war` into Tomcat 9's `webapps` directory.
2. Start Tomcat.
3. Open the application in a browser.

The welcome page is `home.jsp`. The main product storefront is `index.jsp`.

## Main Pages

- `home.jsp` - Landing page
- `index.jsp` - Main storefront and product listing
- `login.jsp` - Login page
- `register.jsp` - Registration page
- `cart.jsp` - Cart and checkout page
- `normaluser.jsp` - Customer dashboard
- `adminuser.jsp` - Admin dashboard

## Core Application Flow

### Registration and login

New accounts are created through `RegisterServlet`. Users are assigned the `normal` role during registration. `LoginServlet` loads the user record, applies the stored role, and redirects the user to the correct dashboard.

### Shopping

Customers browse products on `index.jsp`, filter by category, and search live on the page. Cart actions are handled by `CartServlet`, which keeps cart data in the session and isolates it per logged-in user.

### Checkout

When a customer checks out, the cart is converted into an in-memory bill record. Those records are kept in the user session and in application scope so the admin side can see them while the server is running.

### Admin management

Admins can add, edit, and delete products and categories through `ProductOperationServlet`. User administration, including role updates and deletions, is handled by `UserManagementServlet`.

## Data Model

The schema defines three main tables:

- `users` - stores account details and role type
- `category` - stores product categories
- `product` - stores inventory items linked to categories

The `product` table includes price, discount, quantity, and category ID fields, which are reflected in the storefront and admin forms.

## Configuration Notes

- Product images are expected under `src/main/webapp/assets/products/`.
- Cart data is session-based and does not persist across server restarts.
- Bill data is also runtime-only and clears when the application is restarted.
- Admin and customer access is controlled from the `usertype` field in the `users` table.

## Troubleshooting

- If login fails, confirm that the MySQL connection settings in `DBConnectionUtil` match your local setup.
- If products do not render, check that the image files exist in `src/main/webapp/assets/products/`.
- If Tomcat reports `javax.servlet` errors, make sure you are using Tomcat 9, not Tomcat 10.
- If the database import fails, verify that the `ecommerce` schema exists and that MySQL is running.

## Quick Start

1. Import `quickbasket_schema.sql`.
2. Update database credentials in `DBConnectionUtil.java`.
3. Run `mvn clean package`.
4. Deploy the WAR to Tomcat 9.
5. Open `home.jsp` and log in with the seeded admin or user account.
