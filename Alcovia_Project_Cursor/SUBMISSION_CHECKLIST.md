# Final Submission Checklist

Use this list for the final review before sending the assessment.

## 1. Check the repository
- [ ] Read `docs/executive_writeup.md` and `docs/METRIC_DEFINITIONS.md`; be ready to explain the main assumptions and formulas.
- [ ] Review `ASSIGNMENT_COVERAGE.md` and `FINAL_REPORT.md` for scope and limitations.
- [ ] Confirm that no credentials, `.env` files, private keys, or real student records are committed.

## 2. Run the local checks
From the `Alcovia_Project_Cursor` directory, run:

```bash
python scripts/validate_sample_data.py
python -m http.server 8080
```

Then open:
- `http://localhost:8080/dashboards/index.html`
- `http://localhost:8080/dashboards/gtm_dashboard.html`
- `http://localhost:8080/dashboards/student_dashboard.html`

Stop the server with Ctrl+C when finished.

## 3. Smoke-test the dashboards
- [ ] GTM: change the period, revenue type, and lead-source filters.
- [ ] GTM: review the funnel, campaign metrics, invoices, targets, and trial renewals.
- [ ] Student: test the Continue Studying scenarios, content search, progress period selectors, and advisor filters.
- [ ] Student: review chapter readiness, milestone alerts, missing advisor inputs, and unavailable-value states.
- [ ] Confirm the fictional-data notice is visible and no real data is displayed.

## 4. Confirm the n8n demo claims
- [ ] Both workflow JSON files import and run manually.
- [ ] Payment validation routes sample rows into eligible and excluded outputs.
- [ ] Trial renewal candidates remain drafts for human review.
- [ ] Do not claim that the workflows send real emails or update Alcovia systems.

## 5. Submit
- [ ] Open each published dashboard URL in a private/incognito window and confirm that the pages and CSV data load. If a URL fails, fix it or provide the repository and local run instructions instead.
- [ ] Include only the links and files requested by the employer.
- [ ] Describe the work as a prototype using fictional data; do not claim live integrations, production readiness, or a published Power BI Service report unless those have actually been completed and verified.
- [ ] Submit before the deadline and keep a copy of the final links.
