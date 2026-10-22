# Alcovia Product, Systems & Analytics Lead — Executive approach

**Candidate submission | Proposed start: 1 November 2026**  
**Data status:** every dashboard figure in this repository is calculated from labelled fictional sample CSVs. No Alcovia production system, credential or live student record was available.

## Executive summary
I would treat the first 8 weeks as the build of a small operating system with four outcomes: more purposeful student-app use, visible GTM performance, a single delivery process, and a trusted student-progress view. I would not start with a platform rewrite. I would first lock metric definitions, prove the data can be trusted, then ship thin slices that a student, advisor or GTM owner can actually use.

The 72-hour assessment is a prototype of that approach. It is not a production rollout.

## 1. Student app adoption
The brief reports about 2.15 minutes of average usage against a 30-minute aspiration, 20 students active in 45 days, and interest in Home and Realm. I treat **return friction** as a hypothesis, not a proven root cause: students may struggle to resume unfinished study or to find the next academic task, which would make Home feel like a menu instead of a next action.

What I would test in weeks 1–4:
- Week 1: agree what “active minutes” means, instrument a baseline, and interview active, irregular and inactive students.
- Week 2: ship the smallest Home change that can be measured — Continue studying from a valid checkpoint, plus a search entry point — with event tracking.
- Week 3: limited pilot; watch completion, repeat use, dead clicks and support tickets.
- Week 4: compare with baseline and decide scale / iterate / stop.

The assessment prototype implements that Home hypothesis in `dashboards/student_dashboard.html` using fictional students that cover no history, completed work, stale checkpoints, deleted/locked tasks and a genuine priority switch. It does not claim the hypothesis is confirmed.

Primary measures later: qualifying active minutes, resume-start rate, task completion, 7-day repeat study, and negative signals (errors, rage clicks, “can’t find my work”). The 30-minute aspiration is not a four-week promise. A population this small supports directional learning, not strong causal claims.

## 2. GTM dashboard
Four views: Executive overview, Lead funnel, Campaigns, Revenue & follow-ups.

The model separates leads, stage events, daily campaign metrics, payments, invoices, targets and enrolments. A date window drives period reporting. Monthly targets are compared with monthly collected revenue at the same grain.

Covered in the prototype:
- Collected revenue versus overlapping monthly targets
- Trials versus full programmes (money and headcount)
- Workshop revenue and seats at **₹3,999 per seat**
- Unpaid / part-paid invoices and trial renewals in the next 21 days
- Cohort funnel conversion and drop-off
- Campaign CTR, impression-weighted frequency, cost per ads-qualified lead, and a landing-page click→visit flag

ClickUp, Meta Ads and Razorpay are named sources in the brief. Credentials, scopes and history were not provided, so this submission uses labelled dummy data and does not claim those connectors exist.

## 3. Product and systems delivery
Every request enters one intake backlog with problem, user, evidence, owner, desired outcome, risk and deadline.

- Product lead: outcome, priority, metric definition, rollout decision.
- Process/systems designer: workflow, edge cases, operational adoption, UAT.
- Engineer: estimate, build, instrumentation, tests, reliability.

Work runs discovery → specification → prioritisation → build → QA/UAT → controlled release → measurement → retrospective. Each initiative needs a baseline, hypothesis, acceptance criteria, instrumentation, rollback and a named owner. Weekly reviews look at metric movement and delivery risk, not only tickets closed.

## 4. Student progress dashboard
Three layers: the student Home (role of the learner), advisor caseload, and programme aggregate.

KPI lenses:
- **Quantity:** planned vs conducted sessions, task completion, hours studied, deadline adherence.
- **Quality:** feedback rating and response rate; unrated responses are not scored as zero.
- **Performance:** syllabus completion, chapter readiness, goal status and trend by day / week / month / quarter.

Missing and stale inputs are shown as unavailable or flagged. Wearables, device locks and phone-usage tracking need feasibility, permission, consent and welfare review; they are not in this prototype.

## Resource allocation (proposed, 3 people)
| Person | Time split (first 8 weeks) | Accountable for |
| --- | --- | --- |
| Product, Systems & Analytics Lead (this role) | 40% discovery and metric ownership, 30% GTM/progress analysis, 20% stakeholder cadence, 10% QA of definitions | Outcomes, priority, go/no-go |
| Full-stack engineer | 50% app experiment + instrumentation, 30% data model/dashboard queries, 20% reliability | Working slices and event quality |
| Process/systems designer | 40% workflow mapping, 30% UAT and training, 20% intake hygiene, 10% exception handling | Adopted process, not just documented process |

I would protect a reliability buffer (roughly 20% of engineering time) so dashboard work cannot consume incident and data-quality capacity.

## Delivery sequence
- Weeks 1–2: source audit, written metric dictionary, event map, Home experiment spec.
- Weeks 3–4: first GTM dashboard from approved extracts, student progress MVP, Home pilot.
- Weeks 5–6: reconcile payments vs invoices vs enrolments, tighten access control, train owners.
- Weeks 7–8: iterate from usage, add only approved integrations, review business impact.

The assessment deadline is separate from this roadmap.

## What this 72-hour prototype is, and is not
**Is:** a defensible local demo with traceable sample data, SQL, metric definitions, two interactive HTML dashboards, and honest automation notes.

**Is not:** a live Alcovia integration, a Power BI Service URL, a production n8n deployment, or evidence that the Home hypothesis is true.

## Interview-ready decisions
1. **Cohort funnel, not current-stage counts.** A lead’s current stage cannot reconstruct conversion. Stage events with timestamps can.
2. **Collected ≠ invoiced.** The sample deliberately includes a part-paid invoice next to a paid programme payment so I can show reconciliation instead of hiding it.
3. **Missing is not zero.** A blank refund or blank readiness score is excluded or shown as “—”.
4. **Ads qualified leads ≠ CRM qualified leads.** Cost per qualified lead uses campaign daily counts and is labelled as such.
5. **Resume is conservative.** A stale, deleted or locked checkpoint is not a resume target. That is better than sending a student into a broken lesson.

## Assumptions and limitations
1. No production credentials or live source connections were provided.
2. Power BI Desktop guidance remains in `POWERBI_GUIDE.md`; this package does not include a published Power BI Service link.
3. n8n JSON files are credential-free demos; source syncs are documented, not connected.
4. Student-level views in production need authentication; this HTML file has none.
5. Metric owners at Alcovia must still ratify definitions before any real reporting.
