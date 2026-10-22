# Data dictionary and KPI definitions

**All records are fictional.** They exist so the assessment dashboards, SQL and validation script can be checked. They are not Alcovia business or student performance.

Demo as-of date used by the dashboards: **2026-10-22**.

## Files

| File | Grain | Primary key | Notes |
| --- | --- | --- | --- |
| `leads.csv` | 1 row per lead | `lead_id` | Current stage plus source. Historical path is in stage events. |
| `lead_stage_events.csv` | 1 row per stage visit | `event_id` | A lead can have many events. Funnel counts distinct `lead_id`. |
| `campaigns_daily.csv` | campaign × date | `campaign_id`,`metric_date` | Ads-platform metrics. Do not add `leads` here to CRM leads. |
| `payments.csv` | 1 row per payment attempt | `payment_id` | `Pending` and `Failed` are not collected revenue. |
| `invoices.csv` | 1 row per invoice | `invoice_id` | Paid amount can differ from the payments table. |
| `targets.csv` | month × revenue type | `target_month`,`revenue_type` | Compare at month grain. |
| `enrollments.csv` | 1 row per enrolment | `enrollment_id` | Trial / full programme / workshop headcount. |
| `students.csv` | 1 row per fictional student | `student_id` | Pseudonymous IDs only. |
| `student_activity.csv` | 1 row per activity attempt | `activity_id` | Resume logic uses checkpoint flags. |
| `student_progress.csv` | student × subject × grain | `progress_id` | Daily, weekly, monthly, quarterly snapshots. |
| `academic_catalog.csv` | 1 row per searchable item | `item_id` | Subjects, chapters, tasks. |
| `program_sessions.csv` | 1 row per session | `session_id` | Planned vs conducted. |
| `session_feedback.csv` | 1 row per feedback | `feedback_id` | Null rating ≠ 0. |

## KPI formulas used in the HTML dashboards

| KPI | Formula | Missing / zero rule |
| --- | --- | --- |
| Collected revenue | Sum `gross_amount_inr - refund_inr` where status is `Paid` and both amounts are present | A missing refund **excludes** the row. It is not treated as 0. |
| Target (period sum) | Sum monthly `target_amount_inr` for months overlapping the period, filtered by revenue type | If no target row exists, target is unavailable (—). |
| Variance (vs target) | Collected revenue minus target | Positive = above target, negative = below target, no target = unavailable. |
| Achievement % | Collected ÷ target | If no target row exists, achievement is unavailable, not 0%. A month with target but no paid rows is a genuine 0 collected. |
| Average journey time | Mean days from "New lead" to "Enrolled" stage events, counting only enrolled leads | Calculated from `lead_stage_events.occurred_at` timestamps. Missing timestamps → unavailable. |
| Workshop seats | Paid workshop `gross_amount_inr / 3999` when that divides evenly | Non-divisible amounts are unavailable, not rounded. Pending payments add 0 seats. |
| Trials vs programmes (money) | Sum collected revenue by `payments.revenue_type` | Trial, Program, Workshop are separate. |
| Trials vs programmes (headcount) | Count `enrollments` by `program_type` | Uses enrolments, not payments. |
| Funnel conversion | Distinct cohort leads who reached stage N ÷ distinct cohort leads who reached stage N−1 | Cohort = leads **created** in the selected period, after source/type filters. |
| Funnel drop-off | Reached N minus reached N+1 | Can be 0. Empty cohort shows an empty state, not 0% conversion. |
| CTR | Clicks ÷ impressions | Unavailable if impressions are 0. |
| Impression-weighted frequency | Sum(frequency × impressions) ÷ sum(impressions) | Unavailable if impressions are 0. |
| Cost per qualified lead | Campaign spend ÷ campaign `qualified_leads` | Uses ads qualified counts, not CRM `is_qualified`. Unavailable if qualified_leads is 0. |
| Click→visit | Landing-page visits ÷ clicks | Flag if below 70% (prototype heuristic). |
| Outstanding invoice | `max(invoice_amount_inr - paid_amount_inr, 0)` | Invoices and payments are not force-matched. |
| Upcoming trial renewals | Trial enrolments with `renewal_date` between as-of and as-of+21 days | No row means none in the sample, not a system outage. |
| Session completion | Conducted sessions ÷ planned sessions | Missed/scheduled are not conducted. |
| Feedback quality | Mean of non-null ratings | Null ratings excluded from the mean; response rate is rated ÷ feedback rows. |
| Student syllabus / readiness / tasks | Average of numeric snapshots in the selected grain | Blank snapshots display as "—". |
| **Chapter readiness (5-stage breakdown)** | **NEW:** Per-chapter readiness calculated from 5 completion stages | See "Chapter readiness rules" below |
| **Personal development milestone** | **NEW:** Academic/career/personal goals with target dates and status tracking | Status: Not started, In progress, Completed, Overdue, On track. Missing data shown as "—". |
| **Study habits** | **NEW:** Daily focus minutes, study streak (days), longest session (min), break ratio (%) | Aggregate by student. All values are fictional sample data. |
| **Wellness tracking** | **NEW:** Active minutes, sleep hours, stress level, mood rating | Marked as fictional sample. Consent status explicitly tracked. Missing active_minutes shown as "—", not 0. |
| **Extracurricular activities** | **NEW:** Tutoring, sports, clubs, volunteer with frequency and hours/week | Active, inactive, just started, planned statuses. |
| **Overdue milestones flag** | **NEW:** Personal development milestones with status = "Overdue" | Red alert on student Home screen. Due date < today AND status ≠ "Completed". |
| **Missing advisor input flag** | **NEW:** Advisor inputs with input_status IN ("Missing", "Overdue") | Yellow notice on student Home. Due date < today AND status not "Submitted". |

## Resume-card product rules (student Home)

Hypothesis, not a proven root cause: students may face extra friction when returning to unfinished work or finding academic content.

1. Resume the latest **valid** checkpoint: not deleted, not locked, not completed, not stale, task still in the catalogue and marked eligible.
2. Priority task = lowest `priority_rank` among non-stale eligible unfinished activities, else the next catalogue task not completed/blocked.
3. Show **Switch to priority task** only when that task is different from the resume task.
4. If they are the same, show one Continue action.
5. If there is no valid checkpoint, do not pretend there is. Offer Start priority task when one exists, or an empty state.

## Assumptions that still need Alcovia confirmation

- Revenue is cash collected net of refunds, not booked or invoiced revenue.
- Workshop list price is ₹3,999 per seat.
- Funnel is cohort-based on lead created date.
- “Qualified lead” in ads metrics may differ from CRM `is_qualified`.
- Chapter readiness is an advisor-entered sample score, not a validated assessment instrument.
- 70% click→visit and frequency ≥ 3.5 are demo flags, not Alcovia policy.


---

## Chapter readiness 5-stage framework (NEW)

The student dashboard includes a **Chapter readiness** tab that displays the 5-stage progression for each chapter a student is studying:

### The 5 stages

| Stage | Stage name | Measured by | Threshold | Missing rule |
|-------|-----------|------------|-----------|--------------|
| 1 | Reading | Completion status | Complete / In progress / Not started | Status only; do not infer from blank |
| 2 | Notes/Recall | Completion status | Complete / In progress / Not started | Status only; do not infer from blank |
| 3 | Practice Accuracy | Score (%) | ≥70% to pass | Score "—" means not assessed. <70% shown explicitly as failed. |
| 4 | Timed Past-Paper | Completion status | Complete / In progress / Not started | Status only; do not infer from blank |
| 5 | Exam Readiness | Score (%) | ≥80% to pass | Score "—" means not assessed. <80% shown explicitly as not ready. |

### Overall readiness badge

A chapter is marked **✓ Ready for exam** only when:
- Stage 1 status = "Complete"
- Stage 2 status = "Complete"
- Stage 3 status = "Complete" **AND** score_pct ≥ 70
- Stage 4 status = "Complete"
- Stage 5 status = "Complete" **AND** score_pct ≥ 80

Otherwise, the badge shows **⚠ Not ready** and lists which stages are incomplete or failed thresholds.

### Sample data interpretation

From `chapter_readiness_stages.csv`:

- **STU-001, CH-MATH-01:** All 5 stages complete, practice 82% (✓), readiness 85% (✓) → **✓ Ready for exam**
- **STU-001, CH-ENG-01:** Stage 1 complete, stage 2 in progress, stages 3–5 not started → **⚠ Not ready**
- **STU-002, CH-MATH-01:** Stages 1–2 complete, stage 3 (practice) shows 65% (failed <70%), stage 4 failed, stage 5 not assessed → **⚠ Not ready**
- **STU-003, CH-SCI-01:** All 5 complete, practice 88% (✓), readiness 92% (✓) → **✓ Ready for exam**
- **STU-004, CH-HUM-01:** All stages "Not assessed" (new student, just enrolled) → **⚠ Not ready**

### Missing data vs zero performance

- A student with no chapter readiness records: "No chapter readiness data for this student" (empty state)
- A chapter with stage 3 missing: score shown as "—" (not assessed), not counted as 0% failure
- A chapter with stage 3 score 65%: explicitly shown as "Failed" with the numeric score

### Reconciliation note

The chapter_id field references `academic_catalog.item_id` where `item_type = "Chapter"`. All 40 rows in the sample set are valid (pass referential integrity check).

---

## Personal development, wellness and extracurricular metrics (NEW)

### Personal development milestones

**CSV:** `personal_development.csv`

| Field | Notes |
|-------|-------|
| milestone_id | Primary key |
| student_id | Foreign key to students.csv |
| milestone_type | "Academic Goal", "Career Milestone", or "Personal Goal" |
| milestone_description | Human-readable goal (e.g., "Complete Linear Equations chapter") |
| target_date | ISO date: 2026-10-31 |
| status | One of: "Not Started", "In Progress", "Completed", "Overdue" |
| completion_date | ISO date or null if not completed |
| owner | Student ID (self) or other stakeholder |
| notes | Fictional context (e.g., "early completion") |

**Rules:**
- A milestone is "Overdue" if target_date < today AND status ≠ "Completed"
- Overdue milestones trigger a red alert on the student Home screen
- Missing target_date displays as "—"
- 18 fictional milestones across 6 students: 3 Academic, 3 Career, 3 Personal per cohort

### Study habits

**CSV:** `study_habits.csv`

| Field | Notes |
|-------|-------|
| habit_id | Primary key |
| student_id | Foreign key |
| recorded_date | ISO date (snapshot date) |
| focus_minutes_daily | Average daily focus minutes |
| study_streak_days | Consecutive days of study |
| longest_session_minutes | Single session max duration |
| break_ratio_pct | % of time spent on breaks (0–100) |
| environment_quality | Description (e.g., "Quiet home study space") |
| notes | Fictional context |

**Rules:**
- One row per student (or update to latest snapshot if tracking over time)
- Missing focus_minutes_daily → unavailable (shown as "—"), not 0 minutes
- 6 fictional records: STU-001 (excellent), STU-002 (needs improvement), STU-006 (new student establishing routine)

### Wellness tracking

**CSV:** `wellness_tracking.csv`

| Field | Notes |
|-------|-------|
| wellness_id | Primary key |
| student_id | Foreign key |
| recorded_date | ISO date |
| active_minutes | Daily activity (minutes) or null |
| sleep_hours | Sleep duration (hours) |
| stress_level | "Low", "Medium", "High", "Unknown" |
| mood_rating | "Happy", "Content", "Neutral", "Stressed", "Anxious", "Undetermined" |
| wellness_notes | Fictional context |
| data_source | "Wearable sample" or "Self-report" |
| consent_status | **Always** "Fictional / not applicable" in this prototype |

**Rules:**
- **Privacy:** All wellness data is explicitly marked as fictional sample. No real wearable data.
- **Consent:** Every wellness row includes `consent_status` field. In production, only show rows where consent = "Yes".
- **Missing active_minutes:** Shown as "—", not 0 minutes. Distinguishes "data not collected" from "student was inactive".
- **Stress + low sleep escalation:** When stress="High" AND sleep_hours < 6 for 3+ consecutive days, triggers wellness check-in workflow (documented in AUTOMATION_WORKFLOWS.md)
- **Unrated mood:** "Unknown" or "Undetermined" are valid values, not failures
- 9 fictional records: STU-002 (high stress, low sleep), STU-003 (excellent wellness), STU-006 (baseline establishing, active_minutes null)

### Extracurricular activities

**CSV:** `extracurricular_activities.csv`

| Field | Notes |
|-------|-------|
| activity_id | Primary key |
| student_id | Foreign key |
| activity_type | "Tutoring", "Sport", "Club", "Volunteer" |
| activity_name | e.g., "Mathematics peer tutoring", "School basketball team" |
| frequency | "Daily", "3x weekly", "Weekly", "Fortnightly", "Monthly" |
| status | "Active", "Inactive", "Just started", "Planned" |
| hours_commitment | Weekly hours |
| advisor_notes | Context (e.g., "Develops communication skills") |
| start_date | ISO date |
| end_date | ISO date or null if ongoing |
| notes | Fictional context |

**Rules:**
- A student may have 0–n activities (12 total in sample across 6 students)
- Status "Inactive" includes reason in notes (e.g., "dropped due to revision needs")
- "Hours commitment" is indicative; not formally validated against calendar
- Advisor can add notes such as "balance vs study load good" or "early morning sessions"
- 12 fictional records: STU-001 (tutoring + sports), STU-006 (just started art club + planned math support)

### Advisor inputs

**CSV:** `advisor_inputs.csv`

| Field | Notes |
|-------|-------|
| input_id | Primary key |
| student_id | Foreign key |
| input_type | e.g., "Weekly check-in", "Milestone review", "Wellness check", "Chapter readiness" |
| input_date | When the input was recorded |
| input_status | "Submitted", "Missing", "Overdue" |
| due_date | When the input was due |
| advisor_id | Advisor ID (not a foreign key to advisors table; just text) |
| subject | What the input is about |
| action_required | What needs to happen next |
| notes | Additional context |

**Rules:**
- An input is "Overdue" if due_date < today AND input_status ≠ "Submitted"
- An input is "Missing" if due_date has passed and no submission record exists
- Overdue/missing inputs trigger:
  - Yellow notice on student Home screen
  - Email to assigned advisor (in production workflow)
- 12 fictional records: 2 per student; varying statuses including "Overdue" and "Missing" examples for automation testing

---

## Automation workflow indicators (NEW)

See `docs/AUTOMATION_WORKFLOWS.md` for the full 8 workflows. The dashboard exposes:

1. **Overdue milestones** → Red alert on Home screen
2. **Missing advisor inputs** → Yellow notice on Home screen
3. **Failed chapter stages** → Visible in Chapter readiness tab
4. **High stress + low sleep pattern** → Visible in Personal development tab

All automation is **documented but not live** — no emails are actually sent from this prototype.
