# Alcovia Product, Systems & Analytics Lead — Assessment Prototype

> **Important:** This is an assessment prototype using **fictional sample data**. It is not connected to Alcovia's production systems. Do not present sample values as actual business or student performance.

---

## Project overview

This repository demonstrates how I would work as Product, Systems and Analytics Lead at Alcovia:

1. A written approach, priorities and 8-week plan (`docs/executive_writeup.md`).
2. A proposed data model, KPI definitions and SQL (`sql/`, `docs/METRIC_DEFINITIONS.md`).
3. Two **local interactive HTML dashboards** that calculate from the same fictional CSVs.
4. Credential-free n8n demo workflows, plus an honest description of automations that are *not* connected.

**Architecture:** static HTML + JavaScript reads `data/*.csv` over HTTP. There is no application server, no database for the HTML demos, and no secret store.

```
Browser  →  dashboards/*.html + data_loader.js  →  fetch ../data/*.csv
SQL files are for review / local SQLite checks; the dashboards do not run SQL.
```

---

## Folder structure

```
README.md                       This file
SUBMISSION_CHECKLIST.md         Pre-submit checks
CURSOR_START_HERE.md            Agent/IDE guidance
POWERBI_GUIDE.md                Optional Power BI Desktop recreation
ASSIGNMENT_COVERAGE.md          Detailed requirement-by-requirement status

dashboards/
  index.html                    Landing page linking to both dashboards
  gtm_dashboard.html            GTM / revenue dashboard
  student_dashboard.html        Student Home + progress + chapter readiness + personal development
  data_loader.js                Shared CSV parser and fetch helpers

data/                           Fictional CSVs (see Data dictionary below)
  academic_catalog.csv
  campaigns_daily.csv
  enrollments.csv
  invoices.csv
  leads.csv
  lead_stage_events.csv
  payments.csv
  program_sessions.csv
  README.md
  session_feedback.csv
  students.csv
  student_activity.csv
  student_progress.csv
  targets.csv
  chapter_readiness_stages.csv       NEW: 5-stage readiness per chapter per student
  personal_development.csv           NEW: academic/career/personal milestones
  study_habits.csv                   NEW: daily focus time, streaks, session length
  wellness_tracking.csv              NEW: active minutes, sleep, stress, mood (consent-aware)
  extracurricular_activities.csv     NEW: tutoring, sports, clubs, volunteer activities
  advisor_inputs.csv                 NEW: weekly check-ins, reviews, overdue flags

docs/
  executive_writeup.md          Written approach, priorities, 8-week plan
  METRIC_DEFINITIONS.md         Data dictionary and all KPI formulas
  AUTOMATION_WORKFLOWS.md        NEW: 8 automation workflow specifications

sql/
  schema.sql                    Proposed PostgreSQL schema (review only)
  metrics.sql                   PostgreSQL KPI queries (review only)
  load_sample_sqlite.sql        Local SQLite import for optional cross-checks

n8n/
  demo_sample_row_validation.json     Importable credential-free demo
  demo_trial_renewal_queue.json       Importable credential-free demo
  README.md                           Proposed production workflows (not built)

scripts/
  validate_sample_data.py       Referential-integrity and reconciliation check (now validates 6 new CSVs)

supporting/
  Alcovia_Executive_Writeup_Final_Day_Plan.docx   Word version of write-up
  Alcovia_GTM_PowerBI_Starter.xlsx                Illustrative Power BI starter
```

---

## Local setup (no Node packages needed)

The dashboards must be served over HTTP. Opening the HTML file directly (`file://`) will fail because browsers block local `fetch()` calls.

**Prerequisite:** Python 3 (standard library only).

```bash
# From the Alcovia_Project_Cursor folder:
python scripts/validate_sample_data.py   # check CSV integrity first
python -m http.server 8080               # start the local server
```

If `python` is not found, try `py -m http.server 8080`.

Then open in a browser:

| URL | What you see |
|-----|-------------|
| http://localhost:8080/dashboards/index.html | Landing page |
| http://localhost:8080/dashboards/gtm_dashboard.html | GTM / revenue |
| http://localhost:8080/dashboards/student_dashboard.html | Student Home & progress |

---

## How to test each dashboard

### GTM / revenue

1. Confirm the yellow dummy-data banner is visible.
2. Leave period on **Last 90 days**. Collected revenue is calculated from paid sample payments, not an invented figure.
3. Change **period**, **revenue type** and **lead source**. Empty periods should show empty states, not fake zeros.
4. **Lead funnel** tab: check stage conversion and drop-off for your selected cohort.
5. **Campaigns** tab: verify CTR, frequency, cost per qualified lead. Workshop Reminder (META-WORK-02) on 18 Oct 2026 should show a "Low click→visit" flag (95/210 = 45%).
6. **Revenue & follow-ups** tab: monthly target bars, unpaid invoices (INV-SAMPLE-001, INV-SAMPLE-003, INV-SAMPLE-004), trial renewals ENR-004 (31 Oct) and ENR-005 (3 Nov).
7. **Metric definitions** tab: review formulas before the interview.

### Student Home & progress

The persona selector labels describe each test scenario:

| Persona | Scenario | Expected result |
|---------|----------|----------------|
| STU-001 | Resume = priority (same task) | One "Continue studying" button |
| STU-002 | Resume + different priority task | "Continue studying" + "Switch to priority task" |
| STU-003 | All activity completed | "Start priority task" (from catalogue) |
| STU-004 | Stale checkpoint only | "Start priority task" (stale not offered) |
| STU-005 | Deleted + locked activities | No resume · explains why |
| STU-006 | No previous activity | Empty continue + message + start if catalogue task exists |
| STU-007 | Trial student, completed activity | "Start priority task" from catalogue |
| STU-008 | New student, one unfinished | "Continue studying" (valid checkpoint) |

Additional checks:
- **Student Home**: Automation indicators show on home screen (overdue milestones red alert, missing advisor inputs yellow notice)
- **Chapter readiness** tab (NEW): Select any student → shows all chapters they're working on with 5-stage breakdown:
  - Stage 1 (Reading): status only
  - Stage 2 (Notes/Recall): status only
  - Stage 3 (Practice Accuracy): status + score% (✓ if ≥70%, ✗ if <70%)
  - Stage 4 (Timed Past-Paper): status only
  - Stage 5 (Exam Readiness): status + score% (✓ if ≥80%, ✗ if <80%)
  - Overall badge: ✓ Ready for exam (all 5 complete + thresholds met) or ⚠ Not ready
  - Test cases: STU-001 (CH-MATH-01 ready, CH-ENG-01 incomplete), STU-002 (CH-MATH-01 failed practice), STU-003 (CH-SCI-01 fully ready), STU-004 (CH-HUM-01 not started)
- **Personal development** tab (NEW): Select any student → shows:
  - **Milestones**: Academic, career, and personal goals with target dates and completion tracking
  - **Study habits**: Daily focus time, study streak, longest session, break ratio, environment quality
  - **Wellness**: Active minutes, sleep, stress, mood (all marked as fictional sample with consent status)
  - **Extracurricular**: Tutoring, sports, clubs, volunteer activities with frequency and advisor notes
  - **Automation alerts**: Shows overdue advisor inputs at the top (if any exist for this student)
  - Test cases: STU-002 (overdue milestone "Attend engineering open day"), STU-003 (excellent wellness), STU-006 (new student, missing active_minutes)
- **Find content** tab: search `linear` → 3 results; search `zzz` → empty state with message.
- **My progress** tab: switch Daily / Weekly / Monthly / Quarterly — progress table updates.
- **Programme overview**: cohort/advisor filters update averages. STU-006 syllabus shows "—", not 0%.
- **Advisor caseload**: verify STU-006 columns show "—" for numeric scores.
- **Activity delivery**: avg. feedback shows one decimal place (e.g. `4.4 / 5`).

---

## SQL setup

### PostgreSQL (proposed production shape)

Review `sql/schema.sql` and `sql/metrics.sql`. Do **not** run against a real Alcovia database. The funnel query in `metrics.sql` uses `:start_ts` / `:end_ts` placeholders — replace before running.

### SQLite (optional local cross-check)

```bash
# Requires SQLite 3.37.0 or later (check with sqlite3 --version)
sqlite3 alcovia_sample.db ".read sql/load_sample_sqlite.sql"

# Spot-check collected revenue (should be 368994.00)
sqlite3 alcovia_sample.db "
  SELECT revenue_type,
         ROUND(SUM(gross_amount_inr - refund_inr), 2) AS net_collected
  FROM payments
  WHERE payment_status = 'Paid'
    AND gross_amount_inr != ''
    AND refund_inr != ''
  GROUP BY revenue_type;"
```

If SQLite is not installed, the Python validator (`validate_sample_data.py`) is sufficient for CSV integrity checks.

---

## Data dictionary and KPIs

See `docs/METRIC_DEFINITIONS.md` for the full dictionary. Condensed rules:

| KPI | Formula | Missing/zero rule |
|-----|---------|------------------|
| Collected revenue | Paid gross − refund, where both are present | Missing refund → row excluded, not treated as 0 |
| Workshop seats | Paid workshop gross ÷ ₹3,999 when divisible | Non-divisible → unavailable (—) |
| Target achievement | Collected in month ÷ target for that month | No target row → unavailable; zero paid → genuine 0 |
| Funnel conversion | Distinct cohort leads reaching stage N ÷ reaching stage N−1 | Empty cohort → empty state |
| CTR | Clicks ÷ impressions | Impressions = 0 → unavailable |
| Cost per qualified lead | Spend ÷ campaign qualified_leads | QL = 0 → unavailable |
| Outstanding invoice | max(invoice_amount − paid_amount, 0) | Invoice and payments tables not force-matched |
| Session completion | Conducted ÷ planned | Missed/scheduled ≠ conducted |
| Feedback quality | Mean of non-null ratings | Null ≠ 0; response rate = rated ÷ total rows |

### Reconciliation note

**INV-SAMPLE-001 vs PAY-001 (LEAD-002):** The invoice shows `paid_amount = 90,000`; the payment record shows `gross = 120,000`. This is an intentional design choice to demonstrate that the two tables are not silently merged — reconciliation is surfaced, not hidden. The Python validator prints a note about this.

---

## n8n workflows

Import either file into n8n: **Workflows → Import from File → Test workflow**.

| File | What it does | Credentials |
|------|-------------|-------------|
| `demo_sample_row_validation.json` | Manual trigger → inspect hardcoded fictional payment rows → split valid vs invalid | None |
| `demo_trial_renewal_queue.json` | Manual trigger → inspect hardcoded fictional trial enrolments → queue draft reminders | None |

Both workflows use only Manual Trigger, Set, SplitOut, If, and NoOp nodes. Neither connects to any external system.

Production workflows (GTM daily sync, invoice/renewal reminders, student progress consolidation) are described in `n8n/README.md` and are **not implemented** — they require credentials and source-system access that were not provided for this assessment.

---

## How to deploy the demo (GitHub Pages)

1. Create an empty GitHub repository (public only if the employer allows fictional data to be public).
2. Copy the contents of this folder. **Never add `.env` files, API keys, or real student records.**
3. Push to GitHub.
4. Go to **Settings → Pages → Deploy from branch**. Set the branch to `main` and the folder to `/` (or `/Alcovia_Project_Cursor` if the outer folder is also in the repo).
5. Open the Pages URL in a private window. Confirm the dashboards load their CSVs — relative `fetch('../data/...')` paths work if the site is served from this project's root. If you publish only the `dashboards/` folder, copy `data/` alongside it.
6. Paste the verified URLs into the employer form. Do not send `localhost` links.

Power BI Service publishing is optional. See `POWERBI_GUIDE.md`.

---

## Known limitations and assumptions

- No authentication, no role-based access, no production database.
- All numbers are calculated from **fictional CSVs** — not Alcovia business data.
- Demo as-of date is fixed at **2026-10-22** so the sample remains stable.
- The "Low click→visit" landing-page flag uses a 70% threshold — a prototype heuristic, not a confirmed Alcovia policy.
- "High frequency" flag uses ≥ 3.5 — same: prototype heuristic.
- The `--skip 1` flag in the SQLite loader requires SQLite ≥ 3.37.
- The supporting Word/Excel files may contain older illustrative figures. The HTML dashboards + CSVs are the source of truth for this submission.
- There is no automated JS test suite. Verification is the Python validator, optional SQLite import, and manual dashboard checks.

---

## Deliverables checklist

See `ASSIGNMENT_COVERAGE.md` for detailed requirement-by-requirement verification.

| Deliverable | Status |
|------------|--------|
| Executive write-up | ✅ Done — `docs/executive_writeup.md` |
| Revenue target, variance, achievement % | ✅ Done — Revenue & follow-ups tab |
| Average journey time (funnel) | ✅ Done — Lead funnel tab, 5th KPI card |
| Student Home continue/resume + search | ✅ Done — prototype, fictional data |
| GTM dashboard with all required views | ✅ Done — calculates from CSVs |
| Student progress D/W/M/Q + qty/quality/performance | ✅ Done — sample snapshots |
| Schema, metrics SQL, sample CSVs, data dictionary | ✅ Done |
| n8n importable credential-free demos | ✅ Done — two JSON files |
| Python CSV validator | ✅ Done — exits 0, all checks pass |
| **Chapter-readiness 5-stage breakdown** | ✅ **Done** — `data/chapter_readiness_stages.csv` + new dashboard tab |
| **Personal development metrics** | ✅ **Done** — milestones, study habits, wellness, extracurriculars (`data/personal_development.csv` + 3 supporting CSVs) |
| **Automation workflows** | ✅ **Done (documented)** — `docs/AUTOMATION_WORKFLOWS.md` + dashboard indicators for overdue milestones & missing inputs |
| **Wellness tracking** | ✅ **Done (fictional, consent-aware)** — `data/wellness_tracking.csv` with opt-in flags |
| Live ClickUp / Meta Ads / Razorpay integrations | ❌ Not done — no credentials provided |
| Public dashboard URL | ❌ Not done until you publish (see deploy instructions above) |
| Power BI Service link | ❌ Not done |
| Automated browser/unit tests | ❌ Not done — no JS test runner in this repo |
