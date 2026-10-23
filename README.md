# Alcovia — Product, Systems & Analytics Lead Assessment

This repository demonstrates my approach to improving student engagement and progress visibility, and bringing greater clarity to growth, revenue, and operational follow-up. It includes interactive dashboard prototypes, fictional sample data, SQL reference files, metric definitions, validation checks, and n8n workflow demonstrations.

> **Scope note:** I did not have access to Alcovia's live systems or business data. All records and dashboard figures are fictional and demonstrate proposed logic only.

## Key priorities

- **Improve student continuation:** Identify where students disengage and make it easier for them to resume studying.
- **Improve growth visibility:** Track lead progression, campaign performance, revenue targets, invoices, and upcoming trial renewals in one place.
- **Strengthen operational follow-up:** Surface missing advisor inputs, overdue milestones, and data-quality issues before they become larger problems.
- **Build toward reliable decision-making:** Establish clear KPI definitions, validate source data, and introduce appropriate access controls before moving from prototype to production.

These are proposed priorities based on the assessment scope and fictional sample data, not conclusions verified against Alcovia's live business performance.

## Quick links

- **[Open dashboard homepage](https://indemmity.github.io/alcovia-product-analytics/Alcovia_Project_Cursor/dashboards/index.html)**
- [GTM and revenue dashboard](https://indemmity.github.io/alcovia-product-analytics/Alcovia_Project_Cursor/dashboards/gtm_dashboard.html)
- [Student progress dashboard](https://indemmity.github.io/alcovia-product-analytics/Alcovia_Project_Cursor/dashboards/student_dashboard.html)
- [Executive Summary & Strategy](Alcovia_Project_Cursor/docs/EXECUTIVE_SUMMARY_STRATEGY.md)
- [Product Requirements Document — Continue Studying](Alcovia_Project_Cursor/docs/PRD_student_continue_studying.md)
- [SQL schema](Alcovia_Project_Cursor/sql/schema.sql) · [KPI queries](Alcovia_Project_Cursor/sql/metrics.sql)
- [n8n workflow exports](Alcovia_Project_Cursor/n8n/) · [manual execution evidence](Alcovia_Project_Cursor/n8n/EXECUTION_EVIDENCE.md)
- [Assignment coverage and validation notes](Alcovia_Project_Cursor/ASSIGNMENT_COVERAGE.md)

If a published dashboard does not load, use the local run instructions below.

## Reviewer walkthrough

1. Start with the [live dashboards](https://indemmity.github.io/alcovia-product-analytics/Alcovia_Project_Cursor/dashboards/index.html) to review the interactive prototypes.
2. Read the [Executive Summary & Strategy](Alcovia_Project_Cursor/docs/EXECUTIVE_SUMMARY_STRATEGY.md) and [Continue Studying PRD](Alcovia_Project_Cursor/docs/PRD_student_continue_studying.md) to understand prioritisation, resource allocation, delivery timeboxing, product hypothesis, requirements, and success measures.
3. Review [metric definitions](Alcovia_Project_Cursor/docs/METRIC_DEFINITIONS.md), the [SQL schema](Alcovia_Project_Cursor/sql/schema.sql), and [KPI queries](Alcovia_Project_Cursor/sql/metrics.sql).
4. Inspect the [n8n workflow exports](Alcovia_Project_Cursor/n8n/) and [execution evidence](Alcovia_Project_Cursor/n8n/EXECUTION_EVIDENCE.md).
5. Use the [assignment coverage notes](Alcovia_Project_Cursor/ASSIGNMENT_COVERAGE.md) to review what was checked and what remains out of scope.

## How to review the prototype

1. Open the [dashboard homepage](https://indemmity.github.io/alcovia-product-analytics/Alcovia_Project_Cursor/dashboards/index.html) and explore both dashboards.
2. Review how the GTM view brings funnel, campaign, revenue, invoice, and renewal information together.
3. Explore the student view's time filters, progress/readiness indicators, and continuation flow.
4. Read the strategy and PRD to understand the proposed priorities, delivery plan, and success measures.
5. Check the metric definitions, SQL references, and n8n demo evidence to see how the proposed reporting and follow-up logic is documented.

## What the prototype covers

### Growth and revenue
The GTM dashboard presents collected revenue, targets, lead-funnel progression, campaign performance, invoices, and upcoming trial renewals. Payment and invoice records are kept separate because they may disagree and should be reconciled rather than silently treated as equivalent.

### Student progress and support
The student dashboard includes daily, weekly, monthly, and quarterly views, content search, a Continue Studying flow, five-stage chapter readiness, personal-development milestones, study habits, optional wellness fields, extracurricular activities, and advisor-input status.

### Follow-up and data quality
The repository documents workflow concepts for overdue milestones, missing advisor inputs, trial renewals, and data-quality checks. Two n8n workflows are included as importable, manually tested demonstrations. They do not send real messages or update external systems.

A consistent design rule is that **missing data should not silently become zero**. The prototype distinguishes unavailable values from genuine zeros or failed thresholds where specified.

## Repository contents 

All project files are organised under [`Alcovia_Project_Cursor/`](Alcovia_Project_Cursor/). Select any file or folder below to open it in GitHub.

### Dashboards
- [Dashboard homepage / navigation](Alcovia_Project_Cursor/dashboards/index.html)
- [GTM and revenue dashboard](Alcovia_Project_Cursor/dashboards/gtm_dashboard.html)
- [Student progress dashboard](Alcovia_Project_Cursor/dashboards/student_dashboard.html)
- [Dashboard data loader](Alcovia_Project_Cursor/dashboards/data_loader.js)
- [All dashboard files](Alcovia_Project_Cursor/dashboards/)

### Product, strategy and delivery documentation
- [Executive Summary & Strategy](Alcovia_Project_Cursor/docs/EXECUTIVE_SUMMARY_STRATEGY.md)
- [Continue Studying PRD](Alcovia_Project_Cursor/docs/PRD_student_continue_studying.md)
- [Assignment coverage and validation notes](Alcovia_Project_Cursor/ASSIGNMENT_COVERAGE.md)

### Analytics, SQL and metrics
- [PostgreSQL database schema](Alcovia_Project_Cursor/sql/schema.sql)
- [KPI and metric queries](Alcovia_Project_Cursor/sql/metrics.sql)
- [Sample SQLite loader](Alcovia_Project_Cursor/sql/load_sample_sqlite.sql)
- [Metric definitions and formulas](Alcovia_Project_Cursor/docs/METRIC_DEFINITIONS.md)
- [Python sample-data validator](Alcovia_Project_Cursor/scripts/validate_sample_data.py)
- [All SQL files](Alcovia_Project_Cursor/sql/)
- [All scripts](Alcovia_Project_Cursor/scripts/)

### n8n workflow exports and evidence
- [Payment-row eligibility workflow JSON](Alcovia_Project_Cursor/n8n/demo_sample_row_validation.json)
- [Trial-renewal queue workflow JSON](Alcovia_Project_Cursor/n8n/demo_trial_renewal_queue.json)
- [n8n workflow guide and manual test record](Alcovia_Project_Cursor/n8n/README.md)
- [Execution evidence summary](Alcovia_Project_Cursor/n8n/EXECUTION_EVIDENCE.md)
- [Evidence folder and screenshots](Alcovia_Project_Cursor/n8n/evidence/)
- [Automation workflow specifications (proposed, not live)](Alcovia_Project_Cursor/docs/AUTOMATION_WORKFLOWS.md)
- [All n8n materials](Alcovia_Project_Cursor/n8n/)

### Fictional sample datasets

The CSV files support the dashboards and sample validation checks. They cover academic catalogue data, student records and progress, study activity and habits, chapter readiness, advisor inputs, milestones, programme sessions and feedback, extracurricular activities, optional wellness fields, leads, campaign performance, enrolments, payments, invoices, and revenue targets.

- [Dataset guide](Alcovia_Project_Cursor/data/README.md)
- [Browse all sample data files](Alcovia_Project_Cursor/data/)

### Repository setup
- [Project .gitignore](Alcovia_Project_Cursor/.gitignore)
- [Repository homepage](index.html)

## Run locally

Requires Python 3; no Node packages are needed.

From the `Alcovia_Project_Cursor` directory, run:

```bash
python scripts/validate_sample_data.py
python -m http.server 8080
```

Then open:
- `http://localhost:8080/dashboards/index.html`
- `http://localhost:8080/dashboards/gtm_dashboard.html`
- `http://localhost:8080/dashboards/student_dashboard.html`

The dashboards use browser `fetch()` to read CSV files, so serve the folder over HTTP rather than opening HTML files directly. On Windows, use `py -m http.server 8080` if `python` is not recognised. Stop the server with Ctrl+C.

## Validation and limitations

- All student, campaign, payment, activity, and other business records are fictional.
- The dashboards read static CSV files. There is no production database, authentication, or role-based access.
- The student dashboard is a demonstration and must not be used with real student records as currently built.
- SQL files are proposed/reference queries and are not connected to a live database.
- The n8n workflows are inactive manual demos; they do not send real emails or update Alcovia systems.
- The automation specifications describe proposed workflows, not deployed automations.
- No published Power BI Service report or live Alcovia integration is claimed.
- The prototype uses a fixed as-of date of 22 October 2026 for date-dependent sample scenarios.
- The sample invoice/payment mismatch is documented to demonstrate why payment and invoice records must be reconciled.

The Python validator checks defined sample-data rules and relationships. Dashboard interactions and manual n8n demo results are documented, but these checks do not prove production readiness or replace end-to-end testing.

## Recommended next steps beyond the assessment

Confirm KPI definitions and source-system ownership with stakeholders, reconcile records against approved data, validate student and advisor journeys, define privacy and access controls, and then implement approved integrations. Add automated tests and monitoring before relying on the metrics operationally.
