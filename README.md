# SQL and Analytics Bootcamp

Welcome to my personal repository for the **SQL and Analytics Bootcamp** provided by **[Jornada de Dados](https://suajornadadedados.com.br/)**. This intensive program is designed to develop both **data engineering** and **data analytics** skills through hands-on activities, live sessions, and interactive learning resources.

Below, you will find a comprehensive overview of the bootcamp, the resources used, and how to use the repository!


## Table of Contents

1. [About the Bootcamp](#about-the-bootcamp)
2. [Curriculum](#curriculum)
3. [What I Learned](#what-i-learned)
4. [Prerequisites](#prerequisites)
5. [Getting Started](#getting-started)
6. [Additional Notes](#additional-notes)


## About the Bootcamp

This bootcamp focuses on building a strong foundation in **SQL** and **Analytics**, covering topics such as database design, querying, data manipulation, and advanced techniques like window functions and database partitioning. By the end of the program, participants will have hands-on experience in managing, analyzing, and transforming data for real-world use cases.


## Curriculum

1. **Lesson 01:** Overview & SQL Environment Setup
2. **Lesson 02:** SQL for Analytics - First Queries
3. **Lesson 03:** SQL for Analytics - Joins and HAVING Clause
4. **Lesson 04:** Window Functions
5. **Lesson 05:** [Data Analysis Project](https://github.com/lvgalvao/Northwind-SQL-Analytics)
6. **Lesson 06:** CTE vs Subqueries vs Views vs Temporary Tables vs Materialized Views
7. **Lesson 07:** Table creation
8. **Lesson 08:** Stored Procedures
9. **Lesson 09:** [Triggers & Practical Project II](https://github.com/lvgalvao/northwind-sql-etl)
10. **Lesson 10:** Transactions
11. **Lesson 11:** Query Execution Order
12. **Lesson 12:** Database Indexing
13. **Lesson 13:** Database Partitioning


## What I Learned

Throughout this bootcamp, I’ve gained expertise in:
- **SQL Fundamentals:** Writing queries, filtering data, using joins, and grouping results.  
- **Analytics Techniques:** Employing window functions, ranking, and aggregations for deeper insights.  
- **Database Design & Optimization:** Understanding CTEs, subqueries, indexing strategies, and partitioning for performance.  
- **Advanced Features:** Stored procedures, triggers, and transaction management.  
- **Real-World Applications:** Building practical projects to analyze data, create dashboards, and optimize database operations.


## Prerequisites

Before getting started, ensure you have the following installed:
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Getting Started

Follow these steps to explore the materials and run the examples:

1. **Clone the repository:**
   ```bash
   git clone git@github.com:BrunoChiconato/sql-bootcamp.git
   ```

2. **Navigate to the project folder:**
   ```bash
   cd sql-bootcamp
   ```

3. **Review the files:**  
   Each file contains SQL queries corresponding to specific days and lesson examples.

4. **Run Docker Compose:**  
   - The root folder contains a `docker-compose.yml` file that sets up a PgAdmin client and a PostgreSQL database.
   - The `scripts` folder contains an `init.sql` script that populates the PostgreSQL database with the Northwind tables provided by Microsoft during the build process.
   - To start the services, run:
     ```bash
     docker compose build && docker compose up
     ```

5. **Log in to PgAdmin:**  
   - After running Docker Compose, navigate to `http://localhost:8181` (please verify this URL based on your configuration).
   - Use the following credentials as set in the Docker Compose configuration:
     ```bash
     Email Address: admin@admin.com
     Password: admin
     ```

6. **Register the database in PgAdmin:**  
   - Right-click on **Servers** and select **Register** > **Server...**
   - Enter the following details:
     - **Name:** (e.g., `northwind`)
     - **Host name/address:** `postgres`
     - **Port:** `5432`
     - **Maintenance database:** `northwind`
     - **Username:** `admin`
     - **Password:** `admin`

7. **Test the queries:**  
   Now you can run the provided SQL queries to see the results.

## Additional Notes

- Make sure Docker and Docker Compose are properly installed and configured on your machine.
- If any adjustments or custom configurations are required (such as changing port numbers or volume settings), refer to the `docker-compose.yml` file and update accordingly.

