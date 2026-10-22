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
