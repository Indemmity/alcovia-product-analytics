# n8n Manual Execution Evidence

**Assessment mapping:** These manual demos illustrate two requested operational needs: distinguishing eligible paid rows for revenue reporting and identifying upcoming trial renewals. The input records are synthetic and are not evidence of live Alcovia transactions or enrollments.

**Test date:** 2026-10-23  
**Environment:** n8n Cloud  
**Data:** Fictional sample records only  
**Execution mode:** Manual; workflows remain inactive

## 1. Payment eligibility workflow

Workflow JSON: [demo_sample_row_validation.json](./demo_sample_row_validation.json)

Observed in n8n Cloud:
- The workflow completed successfully after connecting all nodes.
- `Split rows` produced 3 items.
- The IF node routed 1 item to the eligible branch and 2 items to the excluded branch.
- The inspected eligible record was `PAY-001`: Paid, gross amount INR 120,000, refund INR 0. It was labelled `eligible_for_collected_revenue_reporting`.
- The excluded branch contained 2 items; `PAY-006` (Pending) was inspected. `PAY-009` is the other excluded sample row.

**Limitation:** The run demonstrates branch routing on the sample data; it is not a full reconciliation validator. Explicit null/missing-refund handling should be tested before production use.

## 2. Trial renewal queue workflow

Workflow JSON: [demo_trial_renewal_queue.json](./demo_trial_renewal_queue.json)

Observed in n8n Cloud:
- The workflow completed successfully after connecting all nodes.
- The IF node routed 2 items to the draft reminder queue and 1 item to the skip branch.
- `ENR-004`: renewal date `2026-10-31`, as-of date `2026-10-22`, 9 days until renewal.
- `ENR-005`: renewal date `2026-11-03`, as-of date `2026-10-22`, 12 days until renewal.
- `ENR-001` (Full programme; no renewal date) appeared in `Skip non-trial`.
- Queued records had `auto_send = false` and `queue_action = draft_reminder_candidate_for_human_review`.

## Evidence and limitations

Execution screenshots were captured during testing and can be supplied with the assessment. This Markdown record summarizes the outputs observed in n8n Cloud; it is not a raw n8n execution export.

The workflows use fixed fictional sample data and a fixed as-of date. They do not connect to live Alcovia systems, send emails, create CRM tasks, or persist audit logs. Do not treat them as production-ready automations.
