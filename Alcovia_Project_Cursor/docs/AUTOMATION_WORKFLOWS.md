# Automation Workflows · Alcovia Assessment

## Overview
This document describes the envisioned automation workflows for the Alcovia student success platform. The prototype includes sample data and dashboard indicators; live automation integration would require n8n configuration and production credentials.

**Note:** This is a fictional assessment prototype. All automation descriptions are for demonstration purposes only.

---

## 1. Overdue Milestone Reminders

### Trigger
- **Event:** Milestone status transitions to "Overdue" (target date has passed, status not "Completed")
- **Data:** `personal_development.csv` — milestone with target_date < today AND status != "Completed"
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
STU-002: milestone "Attend engineering open day" (due 2026-11-05)
        → Status: Overdue, Target: 2026-11-05, Current date: 2026-10-22
        → Email sent to STU-002 + Advisor 2
```

### Implementation (n8n workflow)
1. **Trigger:** Cron job daily at 06:00 UTC
2. **Query:** Fetch `personal_development.csv`, filter status="Overdue"
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
4. Dashboard alert on student's home view (implemented in prototype)

### Sample Trigger Data (Prototype)
```
ADV-007 (STU-004): "Weekly check-in" due 2026-10-20, current date 2026-10-22
                 → Input status: Missing → 2 days overdue
                 → Alert sent to Advisor 2
                 → Dashboard shows on STU-004 home screen
```

### Implementation (n8n workflow)
1. **Trigger:** Cron job daily at 09:00 UTC (after standup)
2. **Query:** Fetch `advisor_inputs.csv`, filter due_date < today AND status IN ("Missing", "Overdue")
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
Student 1 (Lead LD-009): Trial enrolment expires 2026-10-28 (6 days remaining)
                        → Email sent: "Your trial is ending soon—upgrade now"
                        → Sales task created for GTM team
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
- **Data:** `chapter_readiness_stages.csv` — stage with status="Failed" OR (stage_number=3 AND score_pct < 70) OR (stage_number=5 AND score_pct < 80)
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
                              → Status: Failed
                              → Advisor input created: "Practice remediation needed"
                              → Email: "You scored 65% on practice—let's review"
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
- **Event:** Study streak breaks OR focus time drops below weekly average
- **Data:** `study_habits.csv` — habit with `study_streak_days < previous_streak` OR `focus_minutes_daily < rolling_average * 0.75`
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
STU-005: Study streak was 8 days, now 2 days
        → Email: "Your study streak broke—let's get back on track"
        → Habit recommendation: Daily 15-minute review
```

### Implementation (n8n workflow)
1. **Trigger:** Cron job weekly on Sunday 18:00 UTC
2. **Query:** Fetch `study_habits.csv` from this week and last week
3. **Compare:** Calculate streak delta, focus-time delta
4. **Filter:** Where delta < threshold
5. **Enrich:** Join `personal_development.csv` to see if any milestones are at risk
6. **Notify:** Send email, dashboard alert
7. **Track:** Log in `advisor_inputs.csv` for advisor awareness

---

## 6. Wellness Check-in Escalations

### Trigger
- **Event:** Stress level "High" + sleep < 6 hours for 3+ consecutive days OR mood rating < 2 for 2+ consecutive days
- **Data:** `wellness_tracking.csv` — wellness with `stress_level="High"` AND `sleep_hours < 6` repeatedly
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
STU-002: Stress "High" for 3 days, sleep <6 hours each day
        → Wellness alert: "We've noticed patterns—let's talk"
        → Advisor task: Schedule wellness check-in within 48 hours
        → Email includes counseling/support resources
```

### Implementation (n8n workflow)
1. **Trigger:** Cron job daily at 08:00 UTC
2. **Query:** Fetch `wellness_tracking.csv` for past 7 days
3. **Aggregate:** By student, rolling 3-day stress/sleep pattern
4. **Filter:** Where pattern meets escalation criteria
5. **Validate:** Check student's `wellness_tracking.consent_status` = "Yes" before outreach
6. **Notify:** Email student + advisor, create task
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
Campaign CAM-005 (Email nurture): 3 conversions this week
                                 Cost: ₹8,500 / 3 leads = ₹2,833 CPA
                                 Target: ₹2,000 CPA → OVER BUDGET
                                 → Recommendation: Pause and optimize landing page
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
- **Event:** Missing or inconsistent data in student records
- **Data:** Any CSV row with required fields NULL or referential integrity violations
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
```
Validation passed: 40 chapter_readiness, 18 personal_dev, 6 study_habits, 9 wellness
Referential checks passed. No orphan records detected.
```

### Implementation
- **Tool:** Python script + cron job
- **Trigger:** Daily at 05:00 UTC (before other workflows run)
- **Output:** Email to data team if errors found
- **Escalation:** If critical errors, pause dependent workflows

---

## Dashboard Integration

### Real-Time Indicators
The prototype dashboard displays automation statuses in real-time:
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
│   (due 2026-11-05)                      │
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

- **Prototype Status:** This specification describes intended workflows. The current implementation uses fictional sample data and dashboard indicators only.
- **No Live Automation:** No actual emails, tasks, or database updates occur when using the prototype dashboard. All automation is documented for reference.
- **Privacy:** Wellness alerts require explicit consent. The prototype marks all wellness data as fictional.
- **Extensibility:** Each workflow can be triggered by additional conditions (e.g., "and student has tutoring booked", "and goal status = needs review").
- **Performance:** With thousands of students, consider moving from daily cron jobs to event-driven workflows via n8n webhooks.

---

## Contact & Support

For questions about these workflows or implementation in production:
- **Product:** Alcovia Product Team
- **Engineering:** Alcovia Systems Team
- **Data:** Alcovia Analytics Team

**Last updated:** 2026-10-22
