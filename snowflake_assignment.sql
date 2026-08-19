-- Snowflake Assignment - All Commands

-- Q1: Connection Details
SELECT CURRENT_USER();
SELECT CURRENT_ROLE();
SELECT CURRENT_WAREHOUSE();
SELECT CURRENT_DATABASE();
SELECT CURRENT_SCHEMA();

-- Q2: Object Creation and CRUD Operations
CREATE OR REPLACE DATABASE assignment_db;
USE DATABASE assignment_db;
CREATE OR REPLACE SCHEMA assignment_schema;
USE SCHEMA assignment_schema;
CREATE OR REPLACE WAREHOUSE assignment_wh WAREHOUSE_SIZE = 'X-SMALL' AUTO_SUSPEND = 300 AUTO_RESUME = TRUE;
USE WAREHOUSE assignment_wh;
CREATE OR REPLACE TABLE students (student_id INTEGER, student_name VARCHAR(100), course VARCHAR(100), grade VARCHAR(2), enrollment_date DATE);
INSERT INTO students VALUES (1, 'John Doe', 'Data Warehousing', 'A', '2026-08-01'), (2, 'Jane Smith', 'Data Mining', 'B+', '2026-08-02'), (3, 'Bob Johnson', 'Data Warehousing', 'A-', '2026-08-03'), (4, 'Alice Brown', 'Data Mining', 'B', '2026-08-04');
SELECT * FROM students;
UPDATE students SET grade = 'A+' WHERE student_id = 2;
INSERT INTO students VALUES (5, 'Charlie Wilson', 'Data Warehousing', 'B+', '2026-08-05');
DELETE FROM students WHERE student_id = 4;
SELECT * FROM students;

-- Q3: Data Loading from CSV
CREATE OR REPLACE TABLE courses (course_id INTEGER, course_name VARCHAR(50), score INTEGER, exam_date DATE);
CREATE OR REPLACE STAGE my_stage;
PUT file://C:\Users\Avani\Documents\OneDrive\Desktop\courses.csv @my_stage;
COPY INTO courses FROM @my_stage FILE_FORMAT = (TYPE = CSV FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);
SELECT * FROM courses;

-- Q4: Time Travel Demo
CREATE OR REPLACE TABLE employees (emp_id INTEGER, emp_name VARCHAR(50), department VARCHAR(50), salary INTEGER);
INSERT INTO employees VALUES (1, 'Mike Ross', 'Legal', 75000), (2, 'Rachel Zane', 'Legal', 70000), (3, 'Harvey Specter', 'Legal', 120000), (4, 'Louis Litt', 'Legal', 90000);
SELECT CURRENT_TIMESTAMP();
UPDATE employees SET salary = 80000 WHERE emp_id = 2;
DELETE FROM employees WHERE emp_id = 4;
SELECT * FROM employees;
SELECT * FROM employees AT(TIMESTAMP => '2026-08-19 12:15:00.649'::TIMESTAMP_LTZ);

-- Q5: Data Recovery Using Time Travel
CREATE OR REPLACE TABLE employees_recovered AS SELECT * FROM employees AT(TIMESTAMP => '2026-08-19 12:15:00.649'::TIMESTAMP_LTZ);
SELECT * FROM employees_recovered;
INSERT INTO employees SELECT * FROM employees_recovered WHERE emp_id NOT IN (SELECT emp_id FROM employees);
SELECT * FROM employees ORDER BY emp_id;