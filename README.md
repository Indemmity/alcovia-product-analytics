# Alcovia — Product, Systems & Analytics Lead Assignment

I approached this assignment by looking at two connected problems: how to get a clearer view of growth and revenue, and how to help students and advisors see what needs attention. I built two dashboard prototypes and the supporting data, SQL, and workflow notes to show how I would start.

> **Please note:** I didn't have access to Alcovia's live systems or data. The dashboards use fictional sample records, so the figures are for demonstrating the logic only.

## Open the dashboards

- **[Dashboard homepage](https://indemmity.github.io/alcovia-product-analytics/Alcovia_Project_Cursor/dashboards/index.html)**
- [GTM and revenue](https://indemmity.github.io/alcovia-product-analytics/Alcovia_Project_Cursor/dashboards/gtm_dashboard.html)
- [Student Home and progress](https://indemmity.github.io/alcovia-product-analytics/Alcovia_Project_Cursor/dashboards/student_dashboard.html)

## What I focused on

**Growth and revenue.** The GTM dashboard brings together collected revenue, targets, the lead funnel, campaign performance, invoices, and upcoming trial renewals. I kept payments and invoices separate rather than treating them as interchangeable, because they can disagree and need to be reconciled.

**Student progress.** The student dashboard covers progress over daily, weekly, monthly, and quarterly periods, as well as content search and a Continue Studying flow. I also added chapter readiness across five stages, personal and academic milestones, study habits, optional wellness fields, extracurricular activities, and advisor inputs.

**Follow-up and data quality.** I documented workflows for overdue milestones, missing advisor inputs, trial renewals, and other checks. The dashboard shows indicators for some missing or overdue information, but the email and external-system automations are not connected.

One rule I applied throughout is that **missing data should not silently become zero**. Where a score or input isn't available, the prototype shows it as unavailable rather than suggesting that the student scored zero or completed nothing.

## Files worth reviewing

- [Executive write-up and 8-week plan](Alcovia_Project_Cursor/docs/executive_writeup.md) — my priorities, assumptions, and proposed delivery sequence.
- [Assignment coverage](Alcovia_Project_Cursor/ASSIGNMENT_COVERAGE.md) — a requirement-by-requirement check of what is included.
- [Metric definitions](Alcovia_Project_Cursor/docs/METRIC_DEFINITIONS.md) — the calculation rules and treatment of missing values.
- [Automation workflow notes](Alcovia_Project_Cursor/docs/AUTOMATION_WORKFLOWS.md) — triggers, actions, and what would still need to be connected.
- [SQL schema](Alcovia_Project_Cursor/sql/schema.sql) and [metric queries](Alcovia_Project_Cursor/sql/metrics.sql).
- [Sample CSV data](Alcovia_Project_Cursor/data/) and [validation script](Alcovia_Project_Cursor/scripts/validate_sample_data.py).
- [n8n demos and notes](Alcovia_Project_Cursor/n8n/).

## What is working, and what isn't connected yet

- The two HTML dashboards are interactive prototypes that read the sample CSV files.
- The Python script checks the sample data and its relationships.
- SQL is included for review and local checks; the dashboards themselves do not run SQL.
- The n8n files are demo workflows and the remaining automations are specifications. They do not send real emails or update Alcovia systems.
- The student-level prototype has no authentication, and it should not be used with real student records as-is.

I would validate the metric definitions and data sources with the people who own them before using these numbers for decisions. The next step would be to connect approved data sources, reconcile the records, and test the workflows with the people who would use them.

---

[View the full project folder](Alcovia_Project_Cursor/)