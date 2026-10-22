# Alcovia Product, Systems & Analytics Lead — Executive Write-up

**Candidate submission | Proposed start: 1 November 2026**

**Data note:** I did not have access to Alcovia’s live systems or student records. All figures shown in the dashboards come from fictional sample data created for this assignment.

## Executive summary

For the first eight weeks, I would focus on four things: helping students get more value from the app, making growth and revenue easier to track, improving how work moves from idea to delivery, and giving students and advisors a clearer view of progress.

I would not start by rebuilding the platform or adding more tools. I would first understand the existing data, agree on how the key metrics should be calculated, and identify where the current process is causing problems. From there, I would work with the team to test smaller changes, measure the results, and decide what to improve next.

The dashboards and supporting files I built for this assignment show how I would approach that work. They are prototypes using sample data, not a live implementation.

## 1. Improving student app adoption

The assignment brief mentions average app usage of around 2.15 minutes against a 30-minute aspiration, with 20 students active over 45 days. It also highlights interest in the Home and Realm experience.

My first question would be: **what is stopping students from coming back and continuing their work?**

One possibility is that students find it difficult to pick up where they left off or identify what they should study next. I would investigate this before treating it as the main problem.

My proposed first four weeks would look like this:

- **Week 1:** Understand how app usage is currently measured, review the available data, and speak with students who use the app regularly, occasionally, or not at all.
- **Week 2:** Build and instrument a small Home-page improvement. I would start with a Continue Studying option that takes students back to a valid checkpoint, alongside a way to find relevant academic content.
- **Week 3:** Test the change with a small group of students. Check whether they resume studying, complete tasks, return to the app, or run into problems.
- **Week 4:** Compare the results with the starting point. Based on the evidence, decide whether to expand the test, make changes, or stop it.

I included this idea in `dashboards/student_dashboard.html`. The prototype covers different situations, including students with no previous activity, completed tasks, outdated checkpoints, deleted or locked activities, and cases where another task should take priority.

These are test scenarios, not proof that the problem has been solved.

I would track active study time, successful study resumption, task completion, repeat study within seven days, and errors or cases where students cannot find their work. The 30-minute figure is an aspiration, not a result I would promise within four weeks. With a small number of students, I would use the findings to guide further testing rather than claim a definite causal improvement.

## 2. Making GTM and revenue easier to track

I organised the GTM dashboard into four views: Executive Overview, Lead Funnel, Campaigns, and Revenue & Follow-ups.

The aim is to help someone answer practical questions without having to piece together several reports: How much revenue has been collected? How are we performing against targets? Where are leads dropping out? Which campaigns are working? Which invoices or trial renewals need attention?

The prototype includes:

- Collected revenue compared with monthly targets.
- Trial and full-programme enrolments, including revenue and enrolment counts.
- Workshop revenue and seats, using the stated price of **₹3,999 per seat**.
- Unpaid and partly paid invoices, plus upcoming trial renewals.
- Lead conversion and drop-off between funnel stages.
- Campaign click-through rate (CTR), frequency, cost per ads-qualified lead, and a flag for a possible landing-page drop-off.

I kept leads, lead-stage events, campaigns, payments, invoices, targets, and enrolments as separate data sets because they answer different questions.

For example, an invoice does not necessarily tell us how much money has actually been collected. The prototype includes a sample payment and invoice that do not match. Rather than silently combining them, I have made the discrepancy visible so it can be investigated.

The brief names ClickUp, Meta Ads, and Razorpay as potential data sources. I did not receive the credentials, access permissions, or historical data needed to connect them. The dashboard therefore uses fictional records and does not claim to have live integrations.

## 3. How I would organise product and systems delivery

I would start by making sure that new requests are recorded in one place. Each request should explain the problem, who is affected, what evidence supports it, what outcome is expected, who owns it, and when it is needed.

I would divide responsibilities across three roles:

- **Product, Systems & Analytics Lead:** Decide what problem to solve first, define success, agree on priorities, and review whether the result achieved its purpose.
- **Full-stack engineer:** Estimate and build the solution, add tracking, test it, and maintain its reliability.
- **Process and systems designer:** Map the current process, identify exceptions, prepare testing and training, and help the team adopt the change.

The team would move through discovery, requirements, prioritisation, development, testing, release, and review. Before starting work, I would want a clear problem statement and a way to measure success. Before release, I would want agreed acceptance criteria, appropriate testing, and a plan for handling problems if the change does not work as expected.

I would also review progress weekly. The discussion should cover what has improved, what is blocked, what risks have emerged, and what decision is needed next—not just how many tasks have been completed.

## 4. Making student progress easier to understand

I approached the student dashboard from three perspectives: the student, the advisor, and the overall programme.

Each needs different information.

- **Quantity:** Planned versus conducted sessions, completed tasks, study time, and whether deadlines are being met.
- **Quality:** Student feedback and response rates. An unanswered feedback field should not count as a zero rating.
- **Performance:** Syllabus progress, chapter readiness, goal status, and progress over daily, weekly, monthly, and quarterly periods.

I also added a five-stage chapter-readiness view covering reading, notes and recall, practice accuracy, timed past-paper attempts, and exam readiness. The model uses the specified 70% practice threshold and 80% exam-readiness threshold. It does not invent percentage thresholds for stages that are based on completion status.

The personal development section includes academic, career, and personal milestones, study habits, extracurricular activities, optional wellness fields, and advisor inputs. Overdue milestones and missing advisor information are flagged so they are easier to follow up.

One rule I applied across the dashboard is that **missing information should not automatically be treated as zero**. If a score has not been recorded, showing zero would give the wrong impression. The prototype instead marks unavailable information clearly.

Wellness, wearable data, device restrictions, and phone-usage tracking would need a separate review of feasibility, permissions, consent, and student welfare before being considered for a real implementation. The wellness records in this assignment are fictional; no real wearable integration exists.

## Proposed resource allocation

For planning purposes, I have assumed a three-person team. The percentages below are an initial proposal, not a fixed commitment.

| Role | Proposed time allocation | Main responsibility |
|---|---|---|
| Product, Systems & Analytics Lead | 40% discovery and metrics; 30% GTM and student-progress analysis; 20% stakeholder coordination; 10% quality checks | Priorities, outcomes, and release decisions |
| Full-stack engineer | 50% app improvements and instrumentation; 30% data model and dashboard queries; 20% reliability | Building and maintaining the technical solution |
| Process and systems designer | 40% workflow mapping; 30% testing and training; 20% intake management; 10% exception handling | Making sure the new process works for the people using it |

I would also protect around 20% of engineering time for reliability and data-quality work. Otherwise, new features could take priority over problems that affect the trustworthiness of the whole system.

## Proposed eight-week plan

- **Weeks 1–2:** Review available data sources, agree on metric definitions, map the important events, and prepare the Home-page experiment.
- **Weeks 3–4:** Build the first GTM and student-progress views from approved data, then run the initial Home-page test.
- **Weeks 5–6:** Reconcile payments, invoices, and enrolments; review access controls; and train the people responsible for maintaining and using the reports.
- **Weeks 7–8:** Review the results, improve the areas that need attention, connect only approved data sources, and assess whether the work is making a useful difference.

The assessment deadline is separate from this proposed delivery plan. The actual timeline would depend on the team's capacity, the quality of the existing data, and access to the relevant systems.

## Decisions behind the prototype

There were a few decisions I considered important enough to make explicit.

1. **Use lead-stage history to understand conversion.** A lead's current status alone cannot show the full journey. Timestamped stage events provide a better basis for measuring where leads progress or drop out.

2. **Keep collected revenue separate from invoices.** Payments and invoices can disagree. That difference should be investigated rather than hidden by combining the figures without checking them.

3. **Treat missing data as unavailable, not zero.** A missing readiness score, refund value, or feedback rating does not automatically mean the value is zero.

4. **Keep campaign-qualified leads separate from CRM-qualified leads.** The cost-per-qualified-lead calculation in the campaign view uses the campaign data available in the sample. It should not be confused with a CRM funnel metric.

5. **Do not resume a student at an invalid checkpoint.** If an activity is deleted, locked, or outdated, the dashboard should not direct the student back to it. It should offer an appropriate alternative when one is available.

These decisions affect whether the resulting reports and product experience can be trusted, not just how the dashboard looks.

## What I completed and what remains

The assignment includes two interactive HTML dashboard prototypes, fictional CSV data, SQL schema and metric queries, metric definitions, a Python data-validation script, and documented workflow specifications. The sample-data validation script passes its checks.

I also included two credential-free n8n demo workflows. The other workflows describe how I would handle reminders, missing information, trial renewals, and data-quality checks.

There are important limits to what I have built:

- The dashboards are not connected to Alcovia's production systems.
- The data is fictional and cannot establish Alcovia's actual performance.
- The SQL files are provided for review and local checks; the HTML dashboards do not execute SQL.
- The workflow documentation does not mean that all automations are running. No production emails or external-system updates are triggered.
- The package does not include a published Power BI Service report.
- The student dashboard has no authentication and is not suitable for displaying real student records as-is.

Before using this approach in the business, I would validate the metric definitions with their owners, confirm the source data, reconcile discrepancies, and test the workflows with the people responsible for them.

My priority would be to make the information reliable and useful first, then build on it based on what the team and students actually need.
