# Start here in Cursor — Alcovia assignment

## Your role
Act as a senior product-minded full-stack engineer helping finish an assessment prototype. First inspect the repository and explain the current state. Do not claim live Alcovia access or production integrations. All CSV sample records are fictional.

## Goal
Prepare a clear, reliable, easy-to-demo assessment project with two local interactive HTML dashboards (GTM/revenue and student progress), documented SQL/schema, sample CSVs, an executive write-up and a credible README. Prioritise finishing and testing over adding features.

## Product direction for the student dashboard
1. Make the home dashboard action-oriented rather than a grid of equal-priority features.
2. Add a compact “Continue studying” card near the top of the student Home view. It should resume a valid unfinished activity; show “Switch to priority task” only when it is a different, genuinely higher-priority task. If both actions are the same, show one action. Handle no prior activity, completed/deleted/locked activity, stale progress and no priority task gracefully.
3. Add a visible academic search entry point for subjects, chapters and tasks if this can be implemented consistently with the current static prototype. Search should be clearly labelled as a prototype.
4. Do not invent real student data or claim the changes are connected to Alcovia.
5. Keep the design responsive, accessible, low-clutter and consistent with the existing visual system.

## GTM dashboard checks
- Verify date range, revenue type and lead-source filters work and are understandable.
- Make metric definitions clear: collected revenue vs targets, lead funnel stages, campaign CTR/frequency/cost per qualified lead, outstanding invoices and upcoming renewals.
- Do not misrepresent the sample numbers as actual company performance. Flag any mismatch between the sample CSVs and the embedded demo data.
- Prefer accurate labelling and traceable calculations over decorative charts.

## Data and SQL tasks
- Review `sql/schema.sql` and `sql/metrics.sql` against the CSV headers in `data/`.
- Add or update a data dictionary describing grain, keys, field meanings and assumptions.
- Check SQL syntax and avoid silently treating missing data as zero. Clarify the cohort denominator for conversion metrics.
- Keep all sample data fictional and avoid personal data.

## Required workflow
1. Inspect files and report what is already implemented and what is missing before editing.
2. Propose a short prioritized change list.
3. Implement only changes that can be tested within the available time.
4. Test HTML/JS locally, verify filter and tab interactions, check responsive layout and console errors if possible.
5. Update `README.md` with exact run steps, file inventory, limitations, and GitHub Pages/static-hosting instructions.
6. Do not add credentials, `.env` secrets, real student data or unverified live integrations.
7. Do not say a URL is live unless it has actually been published and verified.

## Final output expected
- A concise summary of changed files.
- Exact local run instructions.
- A test checklist with pass/fail/untested status.
- Remaining limitations that must be disclosed in the assessment.

Start by inspecting the project; do not rewrite everything from scratch.
