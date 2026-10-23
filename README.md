# Alcovia — Product, Systems & Analytics Lead Assessment

This project demonstrates how I would approach two related needs: improving visibility into growth and revenue, and helping students and advisors identify progress and follow-up priorities. It includes interactive dashboard prototypes, fictional sample data, SQL reference files, metric definitions, validation checks, and documented automation concepts.

> **Scope note:** I did not have access to Alcovia's live systems or business data. All records and dashboard figures are fictional and demonstrate the proposed logic only.

## Dashboards

- **[Dashboard homepage](https://indemmity.github.io/alcovia-product-analytics/Alcovia_Project_Cursor/dashboards/index.html)**
- [GTM and revenue dashboard](https://indemmity.github.io/alcovia-product-analytics/Alcovia_Project_Cursor/dashboards/gtm_dashboard.html)
- [Student Home and progress dashboard](https://indemmity.github.io/alcovia-product-analytics/Alcovia_Project_Cursor/dashboards/student_dashboard.html)

If a published page does not load, run the project locally using the instructions below.

## Product approach

### Growth and revenue
The GTM dashboard brings together collected revenue, targets, lead-funnel progression, campaign performance, invoices, and upcoming trial renewals. Payment and invoice records remain separate because they may disagree and should be reconciled rather than silently treated as equivalent.

### Student progress and support
The student dashboard includes daily, weekly, monthly, and quarterly progress views, content search, a Continue Studying flow, five-stage chapter readiness, personal-development milestones, study habits, optional wellness fields, extracurricular activities, and advisor-input status.

### Follow-up and data quality
The project documents workflows for overdue milestones, missing advisor inputs, trial renewals, and data-quality checks. Selected alerts appear in the dashboard. The documented workflows and n8n demos do not send real messages or update external systems.

A consistent design rule is that **missing data should not silently become zero**. When a value is unavailable, the prototype distinguishes that from a genuine zero or a failed threshold.

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

The dashboards use browser `fetch()` to read the CSV files, so serve the folder over HTTP rather than opening HTML files directly. On Windows, use `py -m http.server 8080` if `python` is not recognised. Stop the server with Ctrl+C.

## Project files

All project materials are inside [`Alcovia_Project_Cursor/`](Alcovia_Project_Cursor/).

- [Executive write-up and 8-week plan](Alcovia_Project_Cursor/docs/executive_writeup.md) — priorities, assumptions, and proposed delivery sequence.
- [Executive Summary & Strategy](Alcovia_Project_Cursor/docs/EXECUTIVE_SUMMARY_STRATEGY.md) — concise problem-solving approach, resource allocation, and eight-week timeboxing plan.
- [PRD — Student Continue Studying](Alcovia_Project_Cursor/docs/PRD_student_continue_studying.md) — problem hypothesis, requirements, edge cases, acceptance criteria, and success metrics.
- [Assignment coverage and validation notes](Alcovia_Project_Cursor/ASSIGNMENT_COVERAGE.md) — requirement-by-requirement summary and sample checks.
- [Final verification report](Alcovia_Project_Cursor/FINAL_REPORT.md) — what was checked and what remains outside the prototype.
- [Submission checklist](Alcovia_Project_Cursor/SUBMISSION_CHECKLIST.md) — final checks before sending the assessment.
- [Metric definitions](Alcovia_Project_Cursor/docs/METRIC_DEFINITIONS.md) — KPI formulas, data grain, and missing-value rules.
- [Automation workflow specifications](Alcovia_Project_Cursor/docs/AUTOMATION_WORKFLOWS.md) — proposed triggers, actions, and dependencies.
- [SQL schema](Alcovia_Project_Cursor/sql/schema.sql), [metric queries](Alcovia_Project_Cursor/sql/metrics.sql), and [sample SQLite loader](Alcovia_Project_Cursor/sql/load_sample_sqlite.sql) — reference material; the HTML dashboards do not execute SQL.
- [Fictional sample CSVs](Alcovia_Project_Cursor/data/) and [Python validator](Alcovia_Project_Cursor/scripts/validate_sample_data.py).
- [n8n demo workflows and execution notes](Alcovia_Project_Cursor/n8n/) — two manual, credential-free demonstrations.

## Validation and limitations

The Python validator checks defined sample-data rules and relationships. Dashboard scenarios and manual n8n demo results are recorded in the project documentation. These checks provide evidence of prototype behaviour; they do not prove production readiness or replace automated end-to-end tests.

- All student, campaign, payment, activity, and other business records are fictional.
- The dashboards read static CSV files. There is no production database, authentication, or role-based access.
- The student dashboard is a demonstration and is not suitable for real student records in its current form.
- SQL files are proposed/reference queries and have not been connected to a live database.
- n8n workflows are inactive demos; no real emails or CRM/database updates occur.
- No published Power BI Service report or live Alcovia integration is claimed.
- The demo uses a fixed as-of date of 22 October 2026 for date-dependent sample scenarios.
- The sample invoice/payment mismatch is documented to show why those records should not be silently merged.

## Recommended next steps beyond the assessment

Confirm metric definitions and source-system ownership with stakeholders, reconcile records against approved data, define privacy and access controls, and only then implement integrations and production automation. Add automated tests and monitoring before relying on these metrics for operational decisions.
