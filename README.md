# Alcovia Product, Systems & Analytics Lead — Assessment Prototype

> **Data disclaimer:** This is an assessment prototype using fictional sample data. It is not connected to Alcovia's production systems. Sample values must not be interpreted as actual business or student performance.

## Live dashboards

- **[Open dashboard homepage](https://indemmity.github.io/alcovia-product-analytics/Alcovia_Project_Cursor/dashboards/index.html)**
- [GTM / revenue dashboard](https://indemmity.github.io/alcovia-product-analytics/Alcovia_Project_Cursor/dashboards/gtm_dashboard.html)
- [Student Home & progress dashboard](https://indemmity.github.io/alcovia-product-analytics/Alcovia_Project_Cursor/dashboards/student_dashboard.html)

## Project overview

This repository demonstrates a proposed approach to the Product, Systems & Analytics Lead assessment through:

- An executive write-up with priorities and an 8-week plan.
- A proposed data model, metric definitions, and SQL queries.
- Two interactive static HTML dashboards powered by fictional CSV data.
- Eight documented automation workflow specifications, plus credential-free n8n demo workflows.

## Explore the repository

The project files are organized in the [`Alcovia_Project_Cursor/`](Alcovia_Project_Cursor/) folder.

- [Executive write-up](Alcovia_Project_Cursor/docs/executive_writeup.md)
- [Final report](Alcovia_Project_Cursor/FINAL_REPORT.md)
- [Assignment coverage](Alcovia_Project_Cursor/ASSIGNMENT_COVERAGE.md)
- [Metric definitions](Alcovia_Project_Cursor/docs/METRIC_DEFINITIONS.md)
- [Automation workflow specifications](Alcovia_Project_Cursor/docs/AUTOMATION_WORKFLOWS.md)
- [SQL schema](Alcovia_Project_Cursor/sql/schema.sql)
- [SQL metrics](Alcovia_Project_Cursor/sql/metrics.sql)
- [Sample data folder](Alcovia_Project_Cursor/data/)
- [n8n demo workflows and notes](Alcovia_Project_Cursor/n8n/)

## Important implementation notes

- The dashboards are static HTML/JavaScript prototypes and load CSV files over HTTP.
- The SQL files are provided for review and local SQLite/PostgreSQL checks; the dashboards do not execute SQL.
- Workflow specifications are documentation, not connected production automations.
- No Alcovia production systems, credentials, or live student/business records are connected.

## Review guidance

Start with the [executive write-up](Alcovia_Project_Cursor/docs/executive_writeup.md), then explore the live dashboards and inspect the supporting SQL, sample data, metric definitions, and workflow specifications.