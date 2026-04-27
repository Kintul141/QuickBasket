# QuickBasket

QuickBasket is a Java EE / JSP / Servlet based grocery e-commerce application. It supports customer registration and login, category-based product browsing, cart management, checkout, and admin-side product and user management.

## Features

- Customer registration, login, and logout
- Role-based access for normal users and admins
- Product browsing with category filtering and live search
- Add, remove, clear, and checkout cart items
- Session-based bill history for customers
- Admin product management: add, edit, delete products and categories
- Admin user management: list users, update roles, and delete users

## Tech Stack

- Java 17
- JSP, Servlet 4.0, JSTL
- Maven WAR packaging
- MySQL 8
- Tomcat 9
- Bootstrap-based UI

## Project Structure

```text
src/main/java/com/ecommerce/
  bean/        Data beans for users, products, cart items, bills, categories
  controller/  Servlets for login, register, cart, admin, and logout flows
  dao/         Database access layer
  util/        DB connection and helper utilities
src/main/webapp/
  *.jsp        UI pages for home, shop, login, register, cart, and dashboards
  components/  Shared JSP fragments
  assets/     Product images and other static files
quickbasket_schema.sql  MySQL schema and sample seed data
```

## Prerequisites

- JDK 17
- Apache Maven 3.8+
- Apache Tomcat 9
- MySQL 8+

## Database Setup

1. Create a MySQL database named `ecommerce`.
2. Import `quickbasket_schema.sql` into MySQL.
3. Review `src/main/java/com/ecommerce/util/DBConnectionUtil.java` and update the JDBC URL, username, and password for your local MySQL setup.

The schema includes sample users, categories, and products. The default admin account from the seed data is:

- Email: `admin@quickbasket.com`
- Password: `admin123`

## Build

From the project root:

```bash
mvn clean package
```

This generates a WAR named `ecommerce-project.war` in the `target/` directory.

## Run

1. Deploy `target/ecommerce-project.war` to Tomcat 9.
2. Start Tomcat.
3. Open the app in a browser.

The welcome page is `home.jsp`, and the main storefront is `index.jsp`.

## Main Pages

- `home.jsp` - Landing page
- `index.jsp` - Product listing and shopping entry point
- `login.jsp` - Login form
- `register.jsp` - New user registration
- `cart.jsp` - Customer cart and checkout view
- `normaluser.jsp` - Customer dashboard
- `adminuser.jsp` - Admin dashboard

## Core Flow

- New users register through `RegisterServlet` and are assigned the `normal` role.
- Users log in through `LoginServlet`; admins are redirected to the admin dashboard.
- Customers browse products, filter by category, and add items to a session cart through `CartServlet`.
- Checkout creates an in-session bill record and stores it for admin visibility in application scope.
- Admins manage products through `ProductOperationServlet` and users through `UserManagementServlet`.

## Notes

- The app expects product images under `src/main/webapp/assets/products/`.
- Cart data is isolated per logged-in user session.
- Bills are kept in memory for the current runtime, so restarting the server clears them.
