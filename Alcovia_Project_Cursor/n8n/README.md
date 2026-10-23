# n8n automation materials

These files are **demonstration designs**. They are not connected to Alcovia, ClickUp, Meta Ads, Razorpay, email, or any live student system.

## What you can import

| File | What it does | Credentials needed |
| --- | --- | --- |
| `demo_sample_row_validation.json` | Manual trigger → split fictional payment rows → classify rows eligible for collected-revenue reporting vs excluded | None |
| `demo_trial_renewal_queue.json` | Manual trigger → calculate days to renewal from the fixed demo date (2026-10-22) → queue only active trial enrollments due in 0–21 days | None |

Import in n8n: **Workflows → Import from File**. Then click **Test workflow**. Both workflows use Manual Trigger, Set, Split Out, If, and NoOp nodes. The workflows are designed for manual testing with fictional records only.

The payment workflow demonstrates basic eligibility checks; it is not a complete schema or reconciliation validator. The renewal workflow queues draft-action metadata only; it does not create a CRM task or send a reminder. Scheduled production syncs, source-system connectors, and outbound reminders are **not exported**, because they require approved access and production configuration.

## Proposed production workflows (not built)

### Workflow A — GTM daily sync
Trigger: daily schedule after source access is approved.
1. Read approved ClickUp / Meta Ads / Razorpay extracts.
2. Validate IDs, dates, currency and uniqueness.
3. Upsert into a controlled reporting store.
4. Write rejects to an exception log.
5. Alert the data owner on failure or material count drift.

### Workflow B — Invoice and renewal reminders
Trigger: daily.
1. Select outstanding invoices and trial renewals in an approved window.
2. Apply suppression rules.
3. Create **draft** reminders for a human owner. Do not auto-send in the first release.
4. Log sent/failed/suppressed events.

### Workflow C — Student progress consolidation
Trigger: after an approved input window.
1. Validate required fields and timestamps.
2. Aggregate by student, cohort and grain.
3. Flag missing/stale inputs instead of imputing them.
4. Restrict student-level access by role.

## Controls
- Store secrets only in n8n credentials, never in GitHub or workflow JSON.
- Least-privilege access, retries, idempotency, audit logs.
- Student data requires consent and access control; this repo contains only fictional IDs.


## Manual execution test record

Tested manually in n8n Cloud on **2026-10-23** using the fictional sample records in these exported workflows. These results confirm the imported demo workflows executed; they do not establish production readiness.

### Payment eligibility demo

- Execution completed successfully after connecting the Split Out node to the IF node and routing both IF outputs to their respective Set nodes.
- The split produced **3 items**; the IF node routed **1 item to true** and **2 items to false**.
- The valid output was inspected and showed `PAY-001` (`Paid`, gross amount INR 120,000, refund INR 0) with validation label `eligible_for_collected_revenue_reporting`.
- The excluded branch showed **2 items** and validation label `excluded_check_status_refund_id_or_amount`; `PAY-006` (`Pending`) was visible in the inspected input. The sample data/local logic identifies `PAY-009` as the other excluded row.
- This is an eligibility demonstration, not full payment reconciliation or proof that all edge cases (especially missing refund values) are safely handled.

### Trial renewal queue demo

- Execution completed successfully after connecting the Split Out node to the IF node and routing true to `Queue draft reminder` and false to `Skip non-trial`.
- The IF node routed **2 items to the reminder-candidate branch** and **1 item to the skip branch**.
- Inspected output confirmed:
  - `ENR-004`: renewal date `2026-10-31`, as-of date `2026-10-22`, `days_until_renewal = 9`.
  - `ENR-005`: renewal date `2026-11-03`, as-of date `2026-10-22`, `days_until_renewal = 12`.
  - `ENR-001` (`Full programme`, no renewal date) appeared in `Skip non-trial`.
- Both queued records had `auto_send = false` and `queue_action = draft_reminder_candidate_for_human_review`. No email was sent and no CRM task was created.

### Test limitations / next checks

- These were manual executions against fixed, fictional sample data and a fixed reference date, not scheduled runs against live systems.
- Screenshots of the n8n canvas and node outputs are the execution evidence. The workflows remain demos and should not be published or connected to production data without review.
- Before production use, add/verify explicit handling for missing or null refund values, boundary-date cases, timezone assumptions, duplicate/replayed records, logging, access control, and approved human review. Test each edge case in n8n before claiming it is covered.
