# Assignment Coverage & Validation Notes

**Prototype as of:** 22 October 2026

## Purpose

This document summarises the assignment requirements covered by the Alcovia prototype, the validation performed using fictional sample data, and the work required before production use.

The prototype brings student progress, chapter readiness, personal development, study habits, advisor follow-ups, and go-to-market metrics into one place. It is designed to help the team identify where students may need support while tracking acquisition, conversion, and revenue performance.

## Implementation and validation

The prototype includes a five-stage chapter-readiness model, personal development and study-habit tracking, optional fictional wellness data, advisor-input alerts, and eight documented automation workflows. The existing go-to-market and student dashboards were checked against defined sample scenarios.

The sample-data validator passes its defined checks. Dashboard interactions and calculations were checked using the prototype's sample data. These checks provide evidence of basic functionality, but they do not establish production readiness or confirm that every workflow has been tested end to end.

## Important limitations and next steps

All student, campaign, payment, and activity records are fictional. The dashboards are prototypes, the automation workflows are documented rather than live, and there is no production database, authentication, or live integration with Alcovia systems.

Before production use, the priority is to reconcile data and metric inconsistencies, validate the main student and advisor journeys, review privacy and access controls, and implement and test the required integrations and automation.

---

## Original Assignment Requirements

### A. Chapter Readiness (5-stage breakdown)

> Implement the five stages: Reading, Notes/recall, Practice or worksheet accuracy above 70%, Timed past-paper attempt, Exam readiness above 80% exam accuracy.

| Requirement | Status | Details |
|-------------|--------|---------|
| **5-stage data model** | ✅ **Implemented** | `data/chapter_readiness_stages.csv` (40 rows) with columns: stage_number (1–5), stage_name, status, score_pct, evidence_date, notes |
| **Stage 1: Reading** | ✅ **Implemented** | Status field only. Sample data: mostly "Complete" or "In progress". |
| **Stage 2: Notes/Recall** | ✅ **Implemented** | Status field only. Sample data: "Complete", "In progress", or "Not started". |
| **Stage 3: Practice Accuracy ≥70%** | ✅ **Implemented** | Score field with ≥70% threshold. Sample: STU-001 82% (✓), STU-002 65% (✗), STU-005 78% (✓). |
| **Stage 4: Timed Past-Paper** | ✅ **Implemented** | Status field only. Sample data: "Complete", "Failed", or "Not started". |
| **Stage 5: Exam Readiness ≥80%** | ✅ **Implemented** | Score field with ≥80% threshold. Sample: STU-001 85% (✓), STU-005 75% (✗), STU-003 92% (✓). |
| **Display each stage separately** | ✅ **Implemented** | Dashboard "Chapter readiness" tab shows per-chapter, per-stage rows with status + score. |
| **Use completion status (stages 1,2,4)** | ✅ **Implemented** | No numerical thresholds invented for stages 1, 2, 4; status only. |
| **Use numerical thresholds (stages 3,5)** | ✅ **Implemented** | 70% for practice, 80% for exam readiness. |
| **Missing evidence as "unavailable"** | ✅ **Implemented** | Score "—" means not assessed. Status "Not assessed" also used. Not shown as 0% or "complete". |
| **Overall readiness explainable** | ✅ **Implemented** | Badge shows "✓ Ready for exam" only when all 5 stages complete + thresholds met. Otherwise "⚠ Not ready". |
| **Clearly labelled fictional data** | ✅ **Implemented** | Each row has "Fictional sample" note. METRIC_DEFINITIONS.md documents rules. |
| **Test incomplete chapters** | ✅ **Tested** | STU-001 CH-ENG-01: stage 2 incomplete, stages 3–5 not started. Shows "⚠ Not ready". |
| **Test failed thresholds** | ✅ **Tested** | STU-002 CH-MATH-01: practice score 65% < 70% marked as failed. |
| **Test fully ready chapters** | ✅ **Tested** | STU-003 CH-SCI-01: all 5 complete, practice 88%, readiness 92%. Shows "✓ Ready for exam". |
| **Test missing scores** | ✅ **Tested** | STU-004 CH-HUM-01: all stages "Not assessed" (new student). Shows "⚠ Not ready". |

---

### B. Personal Development, Focus, Wellness & Extracurriculars

#### B.1 Personal Development Metrics

> Add a small, coherent MVP for personal, academic and career roadmap milestones using clearly fictional records.

| Requirement | Status | Details |
|-------------|--------|---------|
| **Personal development milestones** | ✅ **Implemented** | `data/personal_development.csv` (18 rows). Fields: milestone_type (Academic/Career/Personal), target_date, status (Not started / In progress / Completed / Overdue). |
| **Academic milestones** | ✅ **Implemented** | e.g., "Complete Linear Equations chapter", "Complete Reading Comprehension chapter" (6 total). |
| **Career milestones** | ✅ **Implemented** | e.g., "Research apprenticeships", "Attend engineering open day", "Prepare CV" (6 total). |
| **Personal milestones** | ✅ **Implemented** | e.g., "Establish study routine", "Improve sleep", "Regular exercise" (6 total). |
| **Dashboard display** | ✅ **Implemented** | "Personal development" tab shows milestones table with target date, status, completion date. |
| **Overdue flag** | ⚠️ **Needs data reconciliation** | `MIL-005` (STU-002, “Attend engineering open day”) is marked `Overdue`, but its target date is 2026-11-05, after the 2026-10-22 prototype as-of date. Correct the sample date or status, then verify the Home-screen alert. |
| **Clearly fictional** | ✅ **Implemented** | All rows have "Fictional sample" label in notes. |

#### B.2 Focus Time & Study Habits

> Add focus time and study habits using clearly fictional records.

| Requirement | Status | Details |
|-------------|--------|---------|
| **Study habits tracking** | ✅ **Implemented** | `data/study_habits.csv` (6 rows, one per student). |
| **Daily focus time** | ✅ **Implemented** | focus_minutes_daily: STU-001 285 min (excellent), STU-004 120 min (inconsistent), STU-006 90 min (new student). |
| **Study streak** | ✅ **Implemented** | study_streak_days: STU-003 18 days (excellent), STU-004 2 days (broken). |
| **Session length** | ✅ **Implemented** | longest_session_minutes: STU-001 65 min, STU-003 85 min. |
| **Break ratio** | ✅ **Implemented** | break_ratio_pct: 30–50% range. |
| **Environment quality** | ✅ **Implemented** | Descriptive text: "Quiet home study space", "Shared family space", "Classroom + home". |
| **Dashboard display** | ✅ **Implemented** | Personal development tab shows 2×2 card layout (focus time, streak, session, break ratio) + environment. |
| **Clearly fictional** | ✅ **Implemented** | All rows have "Fictional sample" label. |

#### B.3 Wellness (Optional, Consent-Aware)

> Add wellness or wearable active minutes/recovery only as optional, consented sample information. Do not imply real wearable integrations.

| Requirement | Status | Details |
|-------------|--------|---------|
| **Wellness tracking table** | ✅ **Implemented** | `data/wellness_tracking.csv` (9 rows). |
| **Active minutes** | ✅ **Implemented** | Optional field. STU-001 45–52 min, STU-002 15–20 min, STU-006 null (missing baseline). |
| **Sleep hours** | ✅ **Implemented** | 6.0–8.5 hour range. STU-002 low (6.0–6.5h, stress high). |
| **Stress level** | ✅ **Implemented** | Low / Medium / High / Unknown. STU-002 High (pattern). |
| **Mood rating** | ✅ **Implemented** | Happy / Content / Neutral / Stressed / Anxious / Undetermined. |
| **Consent-aware** | ✅ **Implemented** | All rows: consent_status = "Fictional / not applicable". Production workflow checks consent before showing. |
| **Not real wearables** | ✅ **Implemented** | data_source = "Wearable sample" or "Self-report" (both fictional). METRIC_DEFINITIONS.md emphasizes this. |
| **Dashboard notice** | ✅ **Implemented** | "Consent-aware · fictional" badge. Clearly marked as sample data. |
| **Missing active_minutes shown as "—"** | ✅ **Implemented** | STU-006: active_minutes null → "—", not 0 min. |
| **Clearly fictional** | ✅ **Implemented** | All rows have "Fictional sample" label. Consent status explicitly marked. |

#### B.4 Extracurricular & Tutoring

> Add extracurricular activities, tutoring and free time using clearly fictional records.

| Requirement | Status | Details |
|-------------|--------|---------|
| **Extracurricular activities table** | ✅ **Implemented** | `data/extracurricular_activities.csv` (12 rows). |
| **Tutoring** | ✅ **Implemented** | STU-001 "Mathematics peer tutoring" (weekly, 2h), STU-002 "English mentoring" (dropped), STU-006 "Maths support" (planned). |
| **Sports** | ✅ **Implemented** | STU-001 "Basketball team" (3x weekly, 4h), STU-003 "Swimming" (4x weekly, 6h). |
| **Clubs** | ✅ **Implemented** | STU-002 "Debate society", STU-004 "Technology club", STU-006 "Art club". |
| **Volunteer** | ✅ **Implemented** | STU-003 "Community tutor" (weekly, 3h), STU-005 "Charity events" (monthly, 4h). |
| **Frequency tracking** | ✅ **Implemented** | Daily / 3x weekly / Weekly / Fortnightly / Monthly. |
| **Status tracking** | ✅ **Implemented** | Active / Inactive / Just started / Planned. |
| **Hours commitment** | ✅ **Implemented** | Weekly hours: 1–6 hour range. |
| **Advisor notes** | ✅ **Implemented** | Context: "Strong commitment", "Early morning sessions", "High commitment · early balance good". |
| **Dashboard display** | ✅ **Implemented** | Personal development tab shows activity table with type, frequency, status, hours. |
| **Clearly fictional** | ✅ **Implemented** | All rows have "Fictional sample" label. |

#### B.5 Advisor Review & Missing-Input Status

| Requirement | Status | Details |
|-------------|--------|---------|
| **Advisor inputs table** | ✅ **Implemented** | `data/advisor_inputs.csv` (12 rows, 2 per student). |
| **Input type tracking** | ✅ **Implemented** | "Weekly check-in", "Personal dev review", "Wellness check", "Chapter readiness", "Onboarding". |
| **Status tracking** | ✅ **Implemented** | "Submitted", "Overdue", "Missing". |
| **Due date tracking** | ✅ **Implemented** | ISO dates. Compared to as-of date (2026-10-22) to flag overdue. |
| **Overdue/missing flags** | ✅ **Implemented** | ADV-003 (STU-002) overdue. ADV-007, ADV-012 missing. |
| **Dashboard indicators** | ✅ **Implemented** | Yellow notice on Home screen shows missing/overdue inputs with due dates. |
| **Action required** | ✅ **Implemented** | Field shows next step (e.g., "Remind student", "Schedule overdue input"). |
| **Clearly fictional** | ✅ **Implemented** | All rows have "Fictional sample" label. |

---

### C. Minimum Manual Intervention

> Demonstrate reminders for overdue milestones, missing advisor inputs and upcoming renewals. Document workflows if not live.

| Requirement | Status | Details |
|-------------|--------|---------|
| **Overdue milestone reminders** | ✅ **Documented** | AUTOMATION_WORKFLOWS.md workflow #1. Trigger: milestone status="Overdue". Action: email student + advisor. Live in dashboard as red alert. |
| **Missing advisor input notifications** | ✅ **Documented** | AUTOMATION_WORKFLOWS.md workflow #2. Trigger: input_status="Missing" or "Overdue" AND due_date < today. Action: email advisor + dashboard alert. Live in dashboard as yellow notice. |
| **Trial renewal reminders** | ✅ **Documented** | AUTOMATION_WORKFLOWS.md workflow #3. Trigger: trial enrolment expiring in ≤7 days. Action: email student + GTM team. Sample data: ENR-004 expires 2026-10-28 (6 days remaining). |
| **Chapter readiness escalations** | ✅ **Documented** | AUTOMATION_WORKFLOWS.md workflow #4. Trigger: failed stage 3 or 5. Action: flag for advisor, offer remedial resources. |
| **Study habit consistency alerts** | ✅ **Documented** | AUTOMATION_WORKFLOWS.md workflow #5. Trigger: streak breaks or focus time drops 25%. Action: motivational email. |
| **Wellness check-in escalations** | ✅ **Documented** | AUTOMATION_WORKFLOWS.md workflow #6. Trigger: stress="High" + sleep<6h for 3+ days. Action: supportive outreach + advisor task. Sample: STU-002. |
| **Campaign performance feedback** | ✅ **Documented** | AUTOMATION_WORKFLOWS.md workflow #7. Trigger: lead from campaign reaches enrolment. Action: GTM dashboard update. |
| **Data quality validation** | ✅ **Documented** | AUTOMATION_WORKFLOWS.md workflow #8. Trigger: daily validation. Action: alert data team if errors. Current: passes all checks. |
| **Dashboard indicators live** | ✅ **Implemented** | Home screen shows real-time overdue milestones (red) and missing inputs (yellow). |
| **Not live automation** | ✅ **Documented** | No emails, tasks or database updates occur. All workflows are documented for reference. |

---

### D. Quality Checks

#### D.1 Existing GTM metrics preserved

| Requirement | Status | Details |
|-------------|--------|---------|
| **GTM dashboard still works** | ✅ **Verified** | Opens, filters work (period, lead source, revenue type). |
| **Revenue metrics intact** | ✅ **Verified** | Collected revenue ₹368,994 (Program ₹330k, Workshop ₹24k, Trial ₹15k). |
| **Target variance intact** | ✅ **Verified** | Revenue & follow-ups tab shows target bars and variance. |
| **CTR formula** | ⚠️ **Formula definition verified; reported example corrected** | CTR is clicks ÷ impressions. Across the campaign sample: 5,695 clicks ÷ 210,300 impressions = 2.71%. The earlier description using “9 qualified / 330 impressions” was incorrect and has been removed. |
| **Cost per qualified lead** | ✅ **Recalculated from campaign data** | ₹104,500 spend ÷ 144 campaign-reported qualified leads = ₹725.69 (about ₹726). Use campaign-level `qualified_leads`, not CRM `is_qualified` counts. |
| **Funnel conversion intact** | ✅ **Verified** | Lead funnel tab calculates distinct lead counts per stage. |
| **Journey time intact** | ✅ **Verified** | Avg journey time shows in KPI card. |
| **Filters work** | ✅ **Verified** | Period, cohort, lead source, revenue type all filter correctly. |

#### D.2 Existing student dashboard preserved

| Requirement | Status | Details |
|-------------|--------|---------|
| **Continue Studying card works** | ✅ **Verified** | Persona selector shows 8 test scenarios. Each calculates resume logic correctly. |
| **Academic search works** | ✅ **Verified** | Searches fictional catalogue. `linear` → 3 hits. `zzz` → empty state. |
| **Period selectors work** | ✅ **Verified** | Daily / Weekly / Monthly / Quarterly all update progress table. |
| **Empty states show, not zeros** | ✅ **Verified** | STU-006 no numeric baseline → "—" not 0%. |
| **All original tabs present** | ✅ **Verified** | Home, My progress, Find content, Programme overview, Advisor caseload, Activity delivery. |

#### D.3 Data validator passes

| Requirement | Status | Details |
|-------------|--------|---------|
| **Validator exits 0** | ✅ **Verified** | `python scripts/validate_sample_data.py` passes all checks. |
| **Record counts correct** | ✅ **Verified** | 40 chapter_readiness, 18 personal_dev, 6 study_habits, 9 wellness, 12 extracurricular, 12 advisor_inputs. |
| **Referential integrity** | ✅ **Verified** | All student_id, lead_id, chapter_id references valid. No orphan records. |
| **Revenue reconciliation** | ⚠️ **Exception documented** | ₹368,994 net collected in the sample. The `INV-SAMPLE-001` vs `PAY-001` mismatch is intentional and documented; invoice and payment records are not force-matched. |

#### D.4 Documentation updated

| Requirement | Status | Details |
|-------------|--------|---------|
| **README.md updated** | ✅ **Done** | Added new tabs, CSVs, test scenarios for chapter readiness and personal development. |
| **METRIC_DEFINITIONS.md updated** | ✅ **Done** | Added 5-stage rules, personal dev formulas, wellness privacy notes, extracurricular field definitions. |
| **ASSIGNMENT_COVERAGE.md created** | ✅ **Done** | This file. Requirement-by-requirement status. |
| **AUTOMATION_WORKFLOWS.md created** | ✅ **Done** | 8 workflows documented with triggers, actions, implementation notes. |
| **Fictional data clearly labeled** | ✅ **Done** | All CSVs and docs include "Fictional sample" labels and consent notices where applicable. |

---

## Summary

| Area | Requirement | Status |
|------|-------------|--------|
| **A. Chapter readiness** | 5-stage breakdown, missing = unavailable, test all scenarios | ✅ **Complete** |
| **B.1 Personal development** | Milestones (academic/career/personal), sample data, dashboard | ⚠️ **Implemented; one sample status needs reconciliation** |
| **B.2 Study habits** | Focus time, streaks, session length, environment, sample data | ✅ **Complete** |
| **B.3 Wellness** | Active minutes, sleep, stress, mood, consent-aware, fictional labeled | ✅ **Complete** |
| **B.4 Extracurriculars** | Tutoring, sports, clubs, volunteer, frequency, hours, advisor notes | ✅ **Complete** |
| **B.5 Advisor review** | Missing input flags, overdue tracking, dashboard indicators | ✅ **Complete** |
| **C. Automation workflows** | 8 workflows documented, dashboard indicators live, not email-live | ✅ **Complete (documented)** |
| **D. GTM preservation** | Revenue, CTR, cost per qualified lead, funnel, filters, empty states | ✅ **Verified against sample data; KPI descriptions corrected** |
| **D. Student dashboard preservation** | Continue card, search, periods, empty states, all tabs present | ✅ **Verified** |
| **D. Validator** | Exits 0, all checks pass, 6 new CSVs included | ✅ **Verified** |
| **D. Documentation** | README, METRIC_DEFINITIONS, ASSIGNMENT_COVERAGE, AUTOMATION_WORKFLOWS | ✅ **Updated** |

---

## Files Changed

### New Files
- `data/chapter_readiness_stages.csv` — 40 rows
- `data/personal_development.csv` — 18 rows
- `data/study_habits.csv` — 6 rows
- `data/wellness_tracking.csv` — 9 rows
- `data/extracurricular_activities.csv` — 12 rows
- `data/advisor_inputs.csv` — 12 rows
- `docs/AUTOMATION_WORKFLOWS.md` — 8 workflows, 3500+ words
- `ASSIGNMENT_COVERAGE.md` — this file

### Modified Files
- `dashboards/student_dashboard.html` — Added chaptersHtml(), personalHtml(), automation indicators
- `dashboards/data_loader.js` — Added 6 new CSV loads to loadStudentData()
- `scripts/validate_sample_data.py` — Added validation for 6 new CSV files + chapter_id integrity
- `docs/METRIC_DEFINITIONS.md` — Added 5-stage rules, personal dev formulas, wellness notes, extracurricular definitions
- `README.md` — Updated folder structure, test scenarios, deliverables checklist

---

## Prioritised Next Steps

1. **Reconcile sample-data exceptions:** Correct the `MIL-005` target-date/status mismatch and recheck the Home-screen overdue alert. Keep the documented invoice/payment mismatch explicitly labelled as an intentional test case.
2. **Validate KPI definitions and outputs:** Re-run CTR and cost-per-qualified-lead calculations from the campaign source data; preserve the formulas in `docs/METRIC_DEFINITIONS.md`.
3. **Validate key user journeys:** Test chapter readiness, missing-data states, advisor alerts, filters, and student resume logic across the documented scenarios.
4. **Review privacy and access controls:** Require explicit consent for any real wellness data and define role-based access for students, advisors, GTM, and admins.
5. **Move from sample files to a live data layer:** Replace static CSV fetches with documented API/database contracts and reconcile Alcovia's actual schema.
6. **Implement and test automation:** Add production credentials and error handling for email/task workflows; test retries, duplicate notifications, and audit logs.
7. **Test for production use:** Check responsive behaviour, accessibility (WCAG 2.1 AA), and performance at the expected student volume before rollout.

---

**Prepared by:** Alcovia Product, Systems & Analytics Lead (assessment prototype)  
**Date:** 2026-10-22  
**Status:** Assignment coverage documented; one sample milestone date/status inconsistency remains to be corrected in the source data before final sign-off.
