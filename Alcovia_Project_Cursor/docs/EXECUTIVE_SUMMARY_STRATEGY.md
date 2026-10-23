# Executive Summary & Strategy — Alcovia Assessment

**Role:** Product, Systems & Analytics Lead  
**Purpose:** Concise summary of my problem-solving approach, resource allocation, and proposed eight-week delivery plan.

> **Scope note:** I did not have access to Alcovia’s live systems or business data. The dashboards and examples in this submission use fictional sample records and demonstrate a proposed approach, not a live implementation.

## 1. My approach

I would start by understanding the problem before adding more tools or rebuilding existing systems. My first priorities would be to make student progress easier to act on, give the team a clearer view of growth and revenue, and establish reliable processes for deciding what to work on next. I would confirm the available data, agree on metric definitions, and speak with the people using the product before treating any assumption as a confirmed root cause.

### Student engagement and progress

The assessment brief highlights low average app usage relative to a 30-minute aspiration and a small active student base. Those figures are signals to investigate, not proof of why students are disengaging. My hypothesis is that returning to unfinished work or deciding what to study next may create friction. I would test a focused Home-page improvement: a Continue Studying action that resumes a valid checkpoint, with a separate priority-task option only when it is genuinely different. I would validate this with student feedback and usage data before deciding whether to expand it.

### Growth, revenue and reporting

I would bring collected revenue, targets, lead progression, campaign performance, invoices and trial renewals into a consistent reporting view. I would keep payments, invoices, campaign metrics and CRM leads distinct until their definitions and relationships are verified. An invoice amount should not automatically be treated as cash collected, and missing values should not silently become zero.

### Systems and follow-up

I would make ownership and next actions clear across product requests, student support and data-quality issues. The prototype documents automation opportunities for overdue milestones, missing advisor inputs, trial renewals and data checks. The two n8n workflows are manual demonstrations only; they do not send real messages or update Alcovia systems.

## 2. Resource allocation

For planning purposes, I have assumed a three-person team. This is an initial allocation to discuss with the team, not a fixed staffing commitment.

| Role | Proposed focus | Accountability |
|---|---|---|
| Product, Systems & Analytics Lead | 40% discovery and metrics; 30% analysis and prioritisation; 20% coordination; 10% quality review | Problem definition, outcomes, prioritisation and release decisions |
| Full-stack engineer | 50% product changes and instrumentation; 30% data model and reporting; 20% reliability | Implementation, testing and maintainability |
| Process and systems designer | 40% workflow mapping; 30% testing and training; 20% intake and documentation; 10% exception handling | Usability, operational fit and adoption |

I would also protect engineering capacity for reliability and data quality. The exact allocation should change based on team capacity, the condition of the existing systems, and what discovery reveals.

## 3. Timeboxing strategy: first eight weeks

| Timebox | Focus | Expected output |
|---|---|---|
| Weeks 1–2 | Discovery and definitions | Review available data and user journeys; speak with students and advisors; agree on KPI definitions, data ownership and baseline measures. |
| Weeks 3–4 | Build and test small changes | Prototype the Home-page resume flow and initial GTM/student-progress views; test key edge cases and gather feedback. |
| Weeks 5–6 | Reconciliation and readiness | Investigate payment/invoice differences, improve data checks, confirm ownership and review privacy/access requirements. |
| Weeks 7–8 | Evaluate and decide | Review evidence, refine the approach, document remaining risks and recommend whether to expand, iterate or stop each change. |

I would use weekly reviews to check progress, blockers, data quality and decisions needed. Each timebox should end with a reviewable output, rather than assuming that completing tasks means the problem has been solved. This is a proposed plan; delivery depends on team capacity, approved data access and the state of the existing product.

## 4. How I would measure progress

- **Student experience:** successful resume rate, task completion after resuming, seven-day return rate, and failed-resume rate.
- **Growth and revenue:** collected revenue against targets, lead-stage conversion and drop-off, campaign cost per qualified lead, and outstanding invoices.
- **Operational reliability:** data-validation failures, unresolved reconciliation differences, overdue follow-ups, and workflow failure rates once production workflows exist.

I would establish a baseline and agree on definitions before setting numeric targets. With a small cohort, I would treat early results as directional evidence and avoid claiming that a change caused an improvement without a suitable test.

## 5. Deliverables and limitations

The repository contains interactive HTML dashboard prototypes, fictional CSV data, SQL schema and metric queries, metric definitions, a Python sample-data validator, a student Continue Studying PRD, automation specifications, and two manual n8n demo workflows. These materials show how I would structure the problem and validate selected scenarios.

The prototype is not connected to Alcovia’s production systems. It has no production database, authentication or role-based access; the student dashboard must not be used with real student records as currently built. The SQL files are reference material, the automation specifications are proposals, and no live emails, CRM updates or published Power BI Service report are claimed.

## Closing

My priority would be to make the information reliable and the next action clear before expanding the solution. I would validate the problem, build the smallest useful change, measure what happens, and use the evidence to decide what should happen next.
