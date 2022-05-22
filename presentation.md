---
marp : true
title: Presentation T-SQL games
theme: gaia
_class: lead
paginate: true
backgroundColor: #fff
backgroundImage: url('https://marp.app/assets/hero-background.svg')
footer: Data Saturday Zagreb 2022, June 6
---

![bg left:40% 80%](https://upload.wikimedia.org/wikipedia/de/8/8c/Microsoft_SQL_Server_Logo.svg)

# **Writing boardgames with T-SQL**

T-SQL games for SQL Server and Azure SQL

(Tomaž Kaštrun,MVP)

http://github.com/tomaztk/t-sql-games

---

# About me

- ..
- ..

---
# Agenda

    * T-SQL functions
    * Matrix problems (inputs and boards)
    * Time complex problems O(n)
    * Input controls (looping through user inputs?)
    * Quazi AI ?
    * Viewing results
    * Comparison with script languages and benchmark

**Games / Demos:**
    - Sudoku
    - Tic-Tac-Toe
    - Mastermind
    - Battleship
    - Tic-Tac-Toe
    - Walking through the maze
    - Classical (Mystery, maze,…)


---

# T-SQL Functions

- Mathematical (abs, cos, sin, pi, rand, power, ceiling,…)
- Ranking and Analytical (lag, lead, first_value, dense_rank, rank, row_number, …)
- Aggregate (avg, count, max,min, grouping, var, stdev,…)
- String (replace, ltrim, rtrim,stuff, substring, nchar, patindex,…)

What about matrix() ?
And dictionary? Tuples? Lists?

---

# Matrix

- Scripting languages (R, Python, JS, Julia, …) have matrix
- Can iterate matrix[i][y], read, write
- T-SQL ?
    * CREATE TABLE
    * POPULATE TABLE
    * Function to get data from the table

:satisfied: >> Demo:  Show demo with Py vs. SQL matrix
