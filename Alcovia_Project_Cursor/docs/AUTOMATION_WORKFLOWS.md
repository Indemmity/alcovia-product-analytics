# Automation Workflow Specifications — Alcovia Assessment

## Overview

This document describes eight automation ideas that could reduce manual follow-up and help teams spot issues earlier. They cover student milestones, advisor inputs, trial renewals, chapter readiness, study habits, wellness check-ins, campaign performance, and data quality.

These are proposed workflows, not live Alcovia automations. The prototype uses fictional CSV data and dashboard indicators. It does not send emails, create tasks, run scheduled jobs, or update external systems. The two n8n files in this repository are separate manual demos and do not implement all eight workflows.

**Date handling:** Use the prototype's fixed reference date, `AS_OF_DATE = 2026-10-22`, for reproducible date-based examples. In production, use a configured business timezone and the current date/time.

**Note:** This is a fictional assessment prototype. All automation descriptions are for demonstration purposes only.

---

## 1. Overdue Milestone Reminders

### Trigger
- **Event:** A milestone is eligible for an overdue reminder when `target_date` is present, `target_date < AS_OF_DATE`, and its source status is not `Completed`.
- **Data:** `personal_development.csv`; use the fixed demo reference date above in the prototype. In production, use the configured current date and timezone. A future target date must not be treated as overdue solely because its source status says `Overdue`.
- **Frequency:** Daily check (or real-time on updates)

### Action
1. Query overdue milestones grouped by student
2. Send email to student + assigned advisor (from `students.csv` advisor field)
3. Email content:
   - Student name and ID
   - List of overdue milestones with original target dates
   - Suggested next action (e.g., "Schedule advisor review" or "Update target date")
4. Log action in `advisor_inputs.csv` with `input_type="Overdue reminder sent"` and `input_status="Sent"`

### Sample Trigger Data (Prototype)
```
STU-002: milestone "Attend engineering open day" (target date: 2026-10-15)
        → Source status: Overdue; target date precedes AS_OF_DATE (2026-10-22)
        → Expected production action: reminder to STU-002 and the assigned advisor
        → Prototype: no email is sent
```

### Implementation (n8n workflow)
1. **Trigger:** Cron job daily at 06:00 UTC
2. **Query:** Fetch `personal_development.csv`; select records with a present target date before the configured reference date and source status other than `Completed`. De-duplicate reminders by milestone and reminder window.
3. **Enrich:** Join with `students.csv` and advisor contact details
4. **Branch:** For each student, construct email
5. **Notify:** Send via SMTP or Alcovia email service
6. **Log:** Append record to `advisor_inputs.csv`

---

## 2. Missing Advisor Input Notifications

### Trigger
- **Event:** Advisor input becomes overdue (due_date < today AND input_status = "Missing" or "Overdue")
- **Data:** `advisor_inputs.csv` — input with due_date < today AND input_status IN ("Missing", "Overdue")
- **Frequency:** Daily check

### Action
1. Query missing/overdue advisor inputs grouped by advisor
2. Send summary to assigned advisor (from `advisor_inputs.csv` advisor_id)
3. Email content:
   - List of students awaiting input
   - Input type (e.g., "Weekly check-in", "Milestone review")
   - Days overdue
   - Priority: high (>7 days overdue), medium (3–7 days), low (<3 days)
4. Dashboard indicator on the student's home view (prototype UI only; it does not send a notification)

### Sample Trigger Data (Prototype)
```
ADV-007 (STU-004): "Weekly check-in" due 2026-10-20, current date 2026-10-22
                 → Input status: Missing; 2 days past due as of 2026-10-22
                 → Expected production action: notify the assigned advisor
                 → Prototype: no notification is sent; the dashboard indicator is illustrative
```

### Implementation (n8n workflow)
1. **Trigger:** Cron job daily at 09:00 UTC (after standup)
2. **Query:** Fetch `advisor_inputs.csv`; select records with a present `due_date < AS_OF_DATE` and `input_status` in `Missing` or `Overdue`, excluding submitted items. Calculate days overdue from the same reference date.
3. **Enrich:** Calculate days overdue, categorize priority
4. **Group:** By advisor_id
5. **Notify:** Send summary email to each advisor
6. **Dashboard:** Real-time display via React/Vue state or API endpoint

---

## 3. Trial Programme Renewal Reminders

### Trigger
- **Event:** Trial enrolment approaching 30-day expiry
- **Data:** `enrollments.csv` — enrolment with `programme_type="Trial"` AND `days_until_expiry <= 7`
- **Frequency:** Daily check

### Action
1. Query trial enrolments expiring within 7 days
2. Send email to student with:
   - Current trial status (days remaining)
   - Link to upgrade to full programme or extend trial
   - Pricing and next steps
3. Send internal alert to GTM team for sales follow-up
4. Log activity in `campaigns_daily.csv` as outbound touchpoint

### Sample Trigger Data (Prototype)
```
Example only: Lead LD-009 has a trial expiry date of 2026-10-28 (6 days after 2026-10-22).
                        → Expected production action: send a renewal reminder if the enrolment is still a trial and no upgrade payment is recorded
                        → Expected production action: create a GTM follow-up task
                        → Prototype: neither action is executed
```

### Implementation (n8n workflow)
1. **Trigger:** Cron job daily at 10:00 UTC
2. **Query:** Fetch `enrollments.csv`, join `leads.csv`, filter programme_type="Trial" AND date_diff(expiry_date, today) <= 7
3. **Enrich:** Join `payments.csv` to check if upgrade payment exists
4. **Branch:** If not upgraded, send renewal reminder
5. **Notify:** Email to student, internal task to sales
6. **Log:** Append record to `campaigns_daily.csv` with `activity_type="trial_renewal_reminder"`

---

## 4. Chapter Readiness Status Escalations

### Trigger
- **Event:** Student fails stage 3 (Practice ≥70%) or stage 5 (Exam Readiness ≥80%) in a chapter
- **Data:** `chapter_readiness_stages.csv` — escalate when a recorded stage status is `Failed`, or a present score is below the threshold for stage 3 (70%) or stage 5 (80%). Missing scores are unknown, not zero; do not infer failure from a blank score alone.
- **Frequency:** Real-time (on form submission or daily batch)

### Action
1. Query recently failed stages
2. Flag for advisor review: create record in `advisor_inputs.csv` with `action_required="Academic support needed"`
3. Email student with:
   - Which stage they didn't meet threshold for
   - Suggested tutoring resources or remedial tasks
   - Link to one-on-one advisor booking
4. Alert advisor to check student's wellness and extracurricular balance

### Sample Trigger Data (Prototype)
```
STU-002 (CH-MATH-01, Stage 3): Practice score 65% (target ≥70%)
                              → Expected production action: flag the failed stage for advisor review
                              → Expected production action: create a remediation task and send a supportive message
                              → Prototype: no task or email is created
```

### Implementation (n8n workflow)
1. **Trigger:** On update to `chapter_readiness_stages.csv` OR daily batch
2. **Query:** Filter status="Failed" OR (stage 3 AND score < 70) OR (stage 5 AND score < 80)
3. **Enrich:** Join `students.csv`, `extracurricular_activities.csv`, `wellness_tracking.csv`
4. **Assess:** Check student's current wellness and activity load
5. **Branch:** If student is high-stress or over-committed, escalate to head advisor
6. **Notify:** Email student + advisor, create task
7. **Log:** Record in `advisor_inputs.csv`

---

## 5. Study Habit Consistency Alerts

### Trigger
- **Event:** A study streak decreases or focus time falls below 75% of the student's baseline.
- **Data:** `study_habits.csv` must contain dated historical observations. Compare like-for-like periods and define the baseline window (recommended: the previous 7 complete days). A single snapshot cannot establish a trend; if history is insufficient, skip the alert and record “insufficient history.”
- **Frequency:** Weekly (e.g., Sunday evening)

### Action
1. Query students with broken streaks or declining focus
2. Send motivational email with:
   - "Your study streak was broken" or "Your focus time is down 25%"
   - Suggested micro-habits to rebuild (e.g., "5-minute daily review")
   - Links to calendar/app to re-engage
3. Dashboard notification on student home

### Sample Trigger Data (Prototype)
```
Illustrative example only: a student's recorded streak decreases from 8 days to 2 days across dated snapshots.
        → Expected production action: offer a supportive re-engagement suggestion
        → Prototype: no email is sent; verify historical records exist before evaluating a trend
```

### Implementation (n8n workflow)
1. **Trigger:** Cron job weekly on Sunday 18:00 UTC
2. **Query:** Fetch dated `study_habits.csv` observations for the current and comparison windows; do not compare snapshots without valid dates.
3. **Compare:** Calculate streak delta, focus-time delta
4. **Filter:** Where delta < threshold
5. **Enrich:** Join `personal_development.csv` to see if any milestones are at risk
6. **Notify:** Send email, dashboard alert
7. **Track:** Log in `advisor_inputs.csv` for advisor awareness

---

## 6. Wellness Check-in Escalations

### Trigger
- **Event:** Either (a) high stress and sleep below 6 hours on 3 consecutive dated days, or (b) mood rating below 2 on 2 consecutive dated days.
- **Data:** `wellness_tracking.csv` must contain dated history sufficient to verify the relevant consecutive-day pattern. Missing observations break the verified sequence; do not treat missing values as low sleep or poor mood.
- **Frequency:** Daily

### Action
1. Query students with sustained high stress/low sleep/poor mood
2. Send supportive message with:
   - Mental health and wellness resources
   - Option to schedule wellness check with advisor
   - Suggestion to reduce extracurricular load if needed
3. Notify advisor for 1:1 check-in
4. **Important:** All wellness outreach must be opt-in and compliant with privacy policies

### Sample Trigger Data (Prototype)
```
Illustrative example only: dated records confirm high stress and sleep below 6 hours for 3 consecutive days.
        → Expected production action, only with valid consent and appropriate access: offer a private advisor check-in and support resources
        → Prototype: no wellness message or advisor task is created
```

### Implementation (n8n workflow)
1. **Trigger:** Cron job daily at 08:00 UTC
2. **Query:** Fetch `wellness_tracking.csv` for past 7 days
3. **Aggregate:** By student, rolling 3-day stress/sleep pattern
4. **Filter:** Where pattern meets escalation criteria
5. **Validate:** Verify explicit, current consent for the specific outreach channel and purpose; apply role-based access and minimum-necessary disclosure. If consent is absent, expired, or unclear, do not send outreach.
6. **Notify:** Use an approved, privacy-preserving channel; share sensitive wellness details only with authorized staff and only when necessary. Create an audit record without copying sensitive details into general-purpose logs.
7. **Log:** Timestamp in `advisor_inputs.csv` for audit trail

---

## 7. Campaign Performance Feedback Loop

### Trigger
- **Event:** Lead from specific campaign reaches enrolment stage (full conversion)
- **Data:** `lead_stage_events.csv` + `campaigns_daily.csv` — lead with campaign_id + stage="Enrolled"
- **Frequency:** Real-time or daily batch

### Action
1. Calculate conversion rate and cost-per-acquisition by campaign
2. Send GTM dashboard update with:
   - Campaign performance vs. target CPA
   - Organic vs. paid lead quality comparison
   - Suggested budget reallocation
3. Flag underperforming campaigns for pause/optimization

### Sample Trigger Data (Prototype)
```
Illustrative example only: Campaign CAM-005 (Email nurture) records 3 attributed conversions and ₹8,500 in attributable spend for the same reporting window.
                                 CPA = ₹8,500 / 3 conversions = ₹2,833 per conversion
                                 Target CPA: ₹2,000 → above target
                                 → Recommendation: investigate attribution, sample size, and landing-page performance before changing budget
```

### Implementation (n8n workflow)
1. **Trigger:** Cron job daily at 17:00 UTC (after sales data syncs)
2. **Query:** Fetch `lead_stage_events.csv` for "Enrolled" stage, join `campaigns_daily.csv`
3. **Calculate:** Count conversions, sum spend, compute CPA
4. **Compare:** vs. campaign target CPA (from `targets.csv`)
5. **Flag:** If CPA > 125% of target
6. **Report:** Update GTM dashboard, email GTM lead
7. **Recommend:** Pause/optimize based on historical patterns

---

## 8. Data Quality and Validation Alerts

### Trigger
- **Event:** Missing or inconsistent data in student records.
- **Data:** Required fields are blank, dates are invalid, duplicate identifiers exist, or foreign keys do not resolve. Define required fields and severity per dataset; a missing optional field should not automatically block all workflows.
- **Frequency:** Daily batch validation

### Action
1. Run data validation script (`validate_sample_data.py`)
2. Report results:
   - Orphan records (e.g., activity with missing student_id)
   - Missing required fields (e.g., target_date for a milestone)
   - Inconsistent date ranges
3. Send email to data governance team with:
   - Specific rows and files affected
   - Suggested remediation
4. Block automation workflows if critical data gaps detected

### Sample Output (Prototype)

The Python validator checks the defined sample-data rules and relationships. Its current results should be taken from a fresh run of `python scripts/validate_sample_data.py`, rather than copied into this workflow specification. This document describes the proposed alert format; it is not itself evidence of a live scheduled validation workflow.

### Implementation
- **Tool:** Python script + cron job
- **Trigger:** Daily at 05:00 UTC (before other workflows run)
- **Output:** Email to data team if errors found
- **Escalation:** If critical errors, pause dependent workflows

---

## Dashboard Integration

### Prototype Dashboard Indicators
The prototype displays sample indicators from local data. These are not guaranteed to update in real time and do not represent live automation execution:
- **Overdue milestones** (red alert on home screen)
- **Missing advisor inputs** (yellow notice on home screen)
- **Failed chapter stages** (flag on Chapter Readiness tab)
- **High-stress wellness patterns** (visible in Personal Development tab)

### Mockup
```
┌─────────────────────────────────────────┐
│ ⚠️ Action needed:                        │
│ 1 personal development milestone overdue│
│ · Attend engineering open day           │
│   (due 2026-10-15)                      │
│ Advisor review recommended.             │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ 📋 Advisor check-in needed:             │
│ 2 inputs from advisor                   │
│ · Progress review (due 2026-10-20)      │
│ · Chapter readiness (due 2026-10-21)    │
└─────────────────────────────────────────┘
```

---

## Production Deployment Checklist

To move from prototype to live automation:

1. **Authentication & Authorization**
   - [ ] Connect to live Alcovia credentials (OAuth2 / API keys)
   - [ ] Set up role-based access (student, advisor, GTM, admin)
   - [ ] Audit logging for all workflow triggers

2. **Data Integration**
   - [ ] Replace sample CSVs with live database connections
   - [ ] Configure retry logic and error handling
   - [ ] Set up change data capture (CDC) for real-time triggers

3. **Communication Channels**
   - [ ] Configure SMTP / email service provider
   - [ ] Set up SMS fallback for urgent alerts
   - [ ] Integrate with Alcovia LMS for in-app notifications

4. **Privacy & Compliance**
   - [ ] Validate all automation respects student privacy settings
   - [ ] Implement opt-out mechanisms for wellness alerts
   - [ ] Log consent status for all communications
   - [ ] Comply with GDPR / local data protection laws

5. **Monitoring & Metrics**
   - [ ] Dashboard for workflow execution rates and latency
   - [ ] Alerts if workflows fail to execute
   - [ ] Monthly reporting on automation ROI

6. **Testing**
   - [ ] Dry-run all workflows on sample data before production
   - [ ] Test failure scenarios (e.g., email service down)
   - [ ] Load test with full student population

---

## Notes & Limitations

- **Prototype Status:** This specification describes proposed workflows. The prototype uses fictional sample data and dashboard indicators only.
- **No Live Automation:** No emails, tasks, scheduled jobs, or database updates are executed by the prototype. Examples of production actions are hypothetical until the integrations are built and tested.
- **Date and status consistency:** Use `AS_OF_DATE = 2026-10-22` for reproducible prototype examples. In production, configure the business timezone and calculate due/overdue state from canonical dates and source status; do not label a future-dated item overdue based on status alone.
- **Idempotency and reliability:** Production workflows should prevent duplicate notifications, retry transient failures safely, send failures to an observable error queue, and log workflow IDs, timestamps, outcomes, and record IDs without exposing sensitive data.
- **Data sufficiency:** Trend-based study and wellness alerts require dated history and explicit missing-data handling. Skip evaluation when the required observation window is incomplete.
- **Campaign measurement:** Compute CPA using attributed spend divided by attributed conversions over the same reporting window. Verify attribution and minimum sample size before recommending budget changes.
- **Privacy:** Wellness alerts require explicit consent. The prototype marks all wellness data as fictional.
- **Extensibility:** Each workflow can be triggered by additional conditions (e.g., "and student has tutoring booked", "and goal status = needs review").
- **Performance:** With thousands of students, consider moving from daily cron jobs to event-driven workflows via n8n webhooks.

---


