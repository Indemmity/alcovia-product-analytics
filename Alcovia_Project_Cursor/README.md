# Alcovia — Product, Systems & Analytics Lead Assessment

This project demonstrates how I would approach two related needs: improving visibility into growth and revenue, and helping students and advisors identify progress and follow-up priorities. It includes two interactive dashboard prototypes, fictional sample data, SQL reference files, metric definitions, validation checks, and documented automation concepts.

> **Scope note:** I did not have access to Alcovia's live systems or business data. All records and dashboard figures are fictional and are included only to demonstrate the proposed logic.

## Dashboards

- **[Dashboard homepage](https://indemmity.github.io/alcovia-product-analytics/Alcovia_Project_Cursor/dashboards/index.html)**
- [GTM and revenue dashboard](https://indemmity.github.io/alcovia-product-analytics/Alcovia_Project_Cursor/dashboards/gtm_dashboard.html)
- [Student Home and progress dashboard](https://indemmity.github.io/alcovia-product-analytics/Alcovia_Project_Cursor/dashboards/student_dashboard.html)

If a published page does not load, use the local setup steps below to run the prototype.

## Product approach

### Growth and revenue
The GTM dashboard brings together collected revenue, targets, lead-funnel progression, campaign performance, invoices, and upcoming trial renewals. Payment and invoice records remain separate because they may disagree and should be reconciled rather than silently treated as equivalent.

### Student progress and support
The student dashboard includes daily, weekly, monthly, and quarterly progress views, content search, a Continue Studying flow, five-stage chapter readiness, personal-development milestones, study habits, optional wellness fields, extracurricular activities, and advisor-input status.

### Follow-up and data quality
The project documents workflows for overdue milestones, missing advisor inputs, trial renewals, and data-quality checks. Selected alerts appear in the dashboard. The documented workflows and n8n demos do not send real messages or update external systems.

A consistent design rule is that **missing data should not silently become zero**. When a value is unavailable, the prototype should distinguish that from a genuine zero or a failed threshold.

## Run locally

Requires Python 3; no Node packages are needed.

From the `Alcovia_Project_Cursor` directory:

```bash
python scripts/validate_sample_data.py
python -m http.server 8080
```

Open these URLs in your browser:

- `http://localhost:8080/dashboards/index.html`
- `http://localhost:8080/dashboards/gtm_dashboard.html`
- `http://localhost:8080/dashboards/student_dashboard.html`

The dashboards use browser `fetch()` to read the CSV files, so serve the folder over HTTP rather than opening the HTML files directly. Use `py -m http.server 8080` if your Windows setup does not recognise `python`.

## What to review

- [Executive write-up and 8-week plan](docs/executive_writeup.md) — priorities, assumptions, and proposed delivery sequence.
- [Assignment coverage and validation notes](ASSIGNMENT_COVERAGE.md) — requirement-by-requirement summary and sample checks.
- [Final verification report](FINAL_REPORT.md) — what was checked and what remains outside the prototype.
- [Metric definitions](docs/METRIC_DEFINITIONS.md) — KPI formulas, data grain, and missing-value rules.
- [Automation workflow specifications](docs/AUTOMATION_WORKFLOWS.md) — proposed triggers, actions, and dependencies.
- [SQL schema and metric queries](sql/schema.sql) and [metrics.sql](sql/metrics.sql) — reference material for review; the HTML dashboards do not execute SQL.
- [Sample CSV data](data/) and [Python validator](scripts/validate_sample_data.py).
- [n8n demo workflows and execution notes](n8n/) — two manual, credential-free demonstrations.

## Validation and limitations

The Python validator checks the defined sample-data rules and relationships. Dashboard scenarios and manual n8n demo results are recorded in the project documentation. These checks are useful evidence of prototype behaviour, but they do not prove production readiness or replace automated end-to-end tests.

- All data is fictional; dashboard values are not Alcovia performance figures.
- The dashboards read static CSV files. There is no production database, authentication, or role-based access.
- The student dashboard is not suitable for real student records in its current form.
- SQL files are proposed/reference queries and have not been connected to a live database.
- n8n workflows are inactive demos; no real emails or CRM/database updates occur.
- No Power BI Service report is claimed as published.
- The demo logic uses a fixed as-of date of 22 October 2026 for date-dependent sample scenarios.

## Recommended next steps beyond the assessment

Validate the metric definitions and source systems with their owners, reconcile the sample approach against approved data, define privacy and access controls, and only then implement integrations and production automation. Add automated tests and monitoring before relying on these metrics for operational decisions.
