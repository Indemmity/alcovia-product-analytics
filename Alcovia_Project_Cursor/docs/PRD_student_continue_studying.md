# Product Requirements Document: Student Continue Studying Flow

**Project:** Alcovia assessment prototype  
**Status:** Proposed PRD for assessment  
**Owner:** Product, Systems & Analytics Lead (proposed)  
**Scope:** Student Home experience  
**Data and evidence note:** This PRD is based on the written assessment brief and the prototype built to address it. The brief reports average app usage of about 2.15 minutes against a 30-minute aspiration, alongside a small active base and low use of several study features. These are assessment-provided observations, not independently verified live analytics. The student-level CSVs and prototype scenarios are synthetic; success measures and hypotheses must be validated with real users and approved product data.

## 1. Context and problem

The assessment brief describes low average app usage compared with a 30-minute aspiration and a small active student base. That is a signal worth investigating, but it does not tell us why students are not returning or how much time they should spend in the app.

One hypothesis is that students may find it difficult to resume unfinished work or decide what to study next. If they return and have to search for their previous activity again, that creates avoidable friction.

I would test this hypothesis before treating it as the confirmed cause of low engagement. The first step would be to review existing usage data and speak with students who use the app regularly, occasionally, or not at all.

## 2. Product goal

Make it easier for a student to return to a useful next step without having to work out where they left off.

The feature should:
- Resume a valid unfinished activity when one exists.
- Offer a different priority task only when it is genuinely different from the resume task.
- Avoid sending students to completed, deleted, locked, stale, or otherwise unavailable activities.
- Give a clear next step or useful empty state when there is nothing valid to resume.

This is a focused improvement to test, not a claim that it will by itself solve app engagement.

## 3. Users and needs

**Primary user — Student**

Needs a clear way to continue unfinished work or start a relevant task without unnecessary searching.

**Secondary user — Advisor**

Needs the student experience to make sensible recommendations and avoid confusing students with outdated or unavailable activities.

## 4. Proposed user experience

1. When a student opens Home, check whether they have a valid unfinished activity checkpoint.
2. If a valid checkpoint exists, show a **Continue Studying** action.
3. Identify the next eligible priority task.
4. Show **Switch to priority task** only if the priority task is different from the resume activity.
5. If both point to the same task, show only one action.
6. If the previous activity is not valid, do not offer it as a resume option. Offer an eligible priority task if one exists.
7. If there is no valid checkpoint and no eligible task, explain that there is nothing to continue yet and provide a clear next step where possible.

The prototype includes scenario-based behaviour for these cases. It uses fictional sample data and is not connected to Alcovia's live application.

## 5. Functional requirements

| ID | Requirement | Expected behaviour |
|---|---|---|
| FR-01 | Resume valid work | Offer the latest eligible unfinished checkpoint when its activity still exists and is available. |
| FR-02 | Exclude completed work | Do not offer a completed activity as unfinished work. |
| FR-03 | Exclude deleted or locked work | Do not direct the student to an activity they cannot access. |
| FR-04 | Handle stale checkpoints | Do not resume a checkpoint considered stale under the agreed product rule. The staleness window must be confirmed with the team. |
| FR-05 | Show priority task | Offer the next eligible unfinished task when one is available. |
| FR-06 | Avoid duplicate actions | Show one action when the resume task and priority task are the same. |
| FR-07 | Handle no history | If there is no previous activity, offer a suitable starting task when available. |
| FR-08 | Handle unavailable data | Do not invent progress or treat missing values as zero. Explain when there is no valid activity to resume. |
| FR-09 | Preserve accessibility | Use clear labels, visible focus states, keyboard-operable controls, and responsive layout. |
| FR-10 | Measure outcomes | Track feature use and subsequent study activity only through approved, privacy-conscious event instrumentation. |

## 6. Acceptance criteria

The feature is ready for a controlled test when the following conditions can be demonstrated:

- A valid unfinished activity displays a single Continue Studying action.
- A different eligible priority task displays a separate switch action.
- When resume and priority tasks match, duplicate actions are not shown.
- Completed, deleted, locked, and stale activities are not offered as valid checkpoints.
- With no previous activity, the student sees a suitable start option if a task is available.
- With no valid checkpoint and no eligible task, the student sees a clear empty state.
- Missing progress data is not displayed as zero or as evidence of completion.
- The layout and controls remain usable on supported screen sizes and with keyboard navigation.
- Analytics events can distinguish a displayed suggestion, a selected action, a successful resume, and a task completion, subject to an agreed event schema and privacy review.

## 7. Success metrics

I would establish a baseline before setting numerical targets. The 30-minute usage figure in the assessment brief is an aspiration, not a target this feature can guarantee.

| Metric | Definition | Why it matters |
|---|---|---|
| Continue action rate | Students who select Continue Studying ÷ students shown a valid Continue Studying action | Indicates whether the entry point is useful enough to select. |
| Successful resume rate | Resume attempts that open the intended valid activity ÷ all resume attempts | Checks whether the flow works as expected. |
| Task completion rate | Resumed activities completed ÷ resumed activities started, measured over an agreed window | Helps assess whether students progress after resuming. |
| Seven-day return rate | Students who return for a study activity within seven days ÷ students in the defined eligible cohort | Measures repeat study behaviour, not just opening the app. |
| Failed-resume rate | Resume attempts that fail to open the intended activity ÷ all resume attempts | Helps identify stale checkpoints, access issues, or technical problems. |

Metrics should be segmented where useful, with small cohort sizes and privacy risks considered. I would not claim a causal improvement from a small sample without an appropriate test design.

## 8. Instrumentation to consider

Subject to agreement with the product and engineering team, record events such as:
- `continue_studying_impression`
- `continue_studying_selected`
- `priority_task_selected`
- `resume_attempt_succeeded`
- `resume_attempt_failed`
- `study_activity_completed`

Each event should have a clear definition, timestamp, activity identifier where appropriate, and enough context to analyse the journey without collecting unnecessary personal information. The event schema, retention policy, and access permissions need to be agreed before using real student data.

## 9. Edge cases and safeguards

- **Activity was deleted or locked:** Exclude it and provide another eligible option if available.
- **Checkpoint is stale:** Apply a documented staleness rule; do not guess that old progress is still usable.
- **Task already completed:** Do not present it as unfinished.
- **Resume task equals priority task:** Show one action, not two.
- **No checkpoint exists:** Offer a starting task or a clear empty state.
- **Progress or catalogue data is missing:** Treat it as unavailable and avoid inventing a recommendation.
- **Priority task is no longer eligible:** Recalculate or fall back to a safe empty state.
- **Student cannot access the recommended task:** Do not repeatedly route them to it; record a failure event and provide a recovery path.

## 10. Scope and dependencies

**In scope**
- Home-page resume and next-task decision logic.
- Clear states for valid, invalid, and missing checkpoints.
- Basic instrumentation proposal for evaluating the feature.
- Scenario-based testing using fictional records.

**Out of scope for this prototype**
- A production change to Alcovia's live app.
- Live student accounts, production analytics, or real student records.
- A claim that the feature has improved engagement.
- A complete recommendation engine or personalised learning model.

**Dependencies**
- Agreement on what makes a checkpoint stale.
- A reliable source for activity status, completion, locks, and catalogue eligibility.
- An approved analytics event schema.
- Product, engineering, and student/advisor input before any production release.

## 11. Validation plan

1. Review the hypothesis with students and advisors; include people with different usage patterns.
2. Check existing data to understand where students stop or fail to resume, if that data is available and approved.
3. Test the prototype scenarios and record usability issues.
4. Before any live experiment, confirm event definitions, privacy controls, and a baseline.
5. Run a small, controlled test if feasible, then review successful resumes, task completion, seven-day return, and failed resumes.
6. Decide whether to iterate, expand, or stop based on the evidence.

## 12. Current status and next steps

The repository contains an interactive student dashboard prototype with a Continue Studying flow and fictional scenarios for valid checkpoints, priority tasks, and empty or invalid states. This PRD records the proposed behaviour and how I would evaluate it.

The next step is not to assume the hypothesis is correct. It is to validate the problem, confirm the product rules with stakeholders, and test the feature with suitable users and approved data before considering a production rollout.
