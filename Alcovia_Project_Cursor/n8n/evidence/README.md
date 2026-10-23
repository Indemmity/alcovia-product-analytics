# n8n Execution Evidence

The workflows correspond to operational scenarios raised in Alcovia's written assessment brief. This folder contains screenshots captured from manual test executions using synthetic payment and enrolment records in n8n Cloud; the screenshots do not represent live Alcovia transactions.

## Screenshots

The following screenshots are included in this folder:

1. `payment-workflow-execution.png` — Payment eligibility workflow canvas showing successful execution and branch item counts.
2. `payment-valid-row-output.png.png` — Valid payment output for `PAY-001`.
3. `payment-excluded-rows-output.png.png` — Excluded payment outputs for `PAY-006` and `PAY-009`.
4. `trial-renewal-workflow-execution.png.png` — Trial renewal workflow canvas showing successful execution and branch item counts.
5. `trial-renewal-queue-output.png.png` — Draft reminder queue output for `ENR-004` and `ENR-005`, with `auto_send = false`.
6. `trial-nontrial-skip-output.png.png` — Non-trial enrollment `ENR-001` routed to the skip branch.

These screenshots document manual tests using fictional sample data only. They do not demonstrate integration with live Alcovia systems, and no emails or CRM actions were triggered.
