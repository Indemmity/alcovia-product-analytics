"""Validate fictional sample CSVs and print dashboard-reconciliation totals.

Run from the project folder:
    python scripts/validate_sample_data.py
"""
from __future__ import annotations

import csv
import sys
import io
from collections import defaultdict
from pathlib import Path

# Force UTF-8 output on Windows
if sys.platform == 'win32':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', line_buffering=True)

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
AS_OF = "2026-10-22"
SEAT = 3999
ERRORS: list[str] = []
WARNINGS: list[str] = []


def load(name: str) -> list[dict[str, str]]:
    path = DATA / name
    if not path.exists():
        ERRORS.append(f"Missing file {name}")
        return []
    with path.open(encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def num(value: str | None):
    if value is None or str(value).strip() == "":
        return None
    try:
        return float(value)
    except ValueError:
        ERRORS.append(f"Non-numeric value {value!r}")
        return None


def main() -> int:
    students = load("students.csv")
    leads = load("leads.csv")
    events = load("lead_stage_events.csv")
    campaigns = load("campaigns_daily.csv")
    payments = load("payments.csv")
    invoices = load("invoices.csv")
    enrollments = load("enrollments.csv")
    activity = load("student_activity.csv")
    progress = load("student_progress.csv")
    catalog = load("academic_catalog.csv")
    sessions = load("program_sessions.csv")
    feedback = load("session_feedback.csv")
    targets = load("targets.csv")
    chapter_readiness = load("chapter_readiness_stages.csv")
    personal_dev = load("personal_development.csv")
    study_habits = load("study_habits.csv")
    wellness = load("wellness_tracking.csv")
    extracurricular = load("extracurricular_activities.csv")
    advisor_inputs = load("advisor_inputs.csv")

    student_ids = {r["student_id"] for r in students}
    lead_ids = {r["lead_id"] for r in leads}
    session_ids = {r["session_id"] for r in sessions}
    catalog_ids = {r["item_id"] for r in catalog}
    chapter_ids = {r["item_id"] for r in catalog if r.get("item_type") == "Chapter"}

    for r in events:
        if r["lead_id"] not in lead_ids:
            ERRORS.append(f"Orphan stage event {r['event_id']} lead {r['lead_id']}")
    for r in payments:
        if r["lead_id"] not in lead_ids:
            ERRORS.append(f"Orphan payment {r['payment_id']}")
    for r in invoices:
        if r["lead_id"] not in lead_ids:
            ERRORS.append(f"Orphan invoice {r['invoice_id']}")
    for r in enrollments:
        if r["lead_id"] not in lead_ids:
            ERRORS.append(f"Orphan enrollment lead {r['enrollment_id']}")
        if r["student_id"] not in student_ids:
            ERRORS.append(f"Orphan enrollment student {r['enrollment_id']}")
    for r in activity:
        if r["student_id"] not in student_ids:
            ERRORS.append(f"Orphan activity student {r['activity_id']}")
        if r["task_id"] and r["task_id"] not in catalog_ids:
            ERRORS.append(f"Activity {r['activity_id']} unknown task {r['task_id']}")
    for r in progress:
        if r["student_id"] not in student_ids:
            ERRORS.append(f"Orphan progress {r['progress_id']}")
    for r in feedback:
        if r["student_id"] not in student_ids:
            ERRORS.append(f"Orphan feedback student {r['feedback_id']}")
        if r["session_id"] not in session_ids:
            ERRORS.append(f"Orphan feedback session {r['feedback_id']}")
    for r in chapter_readiness:
        if r["student_id"] not in student_ids:
            ERRORS.append(f"Orphan chapter readiness student {r['stage_id']}")
        if r["chapter_id"] not in chapter_ids:
            ERRORS.append(f"Chapter readiness {r['stage_id']} unknown chapter {r['chapter_id']}")
    for r in personal_dev:
        if r["student_id"] not in student_ids:
            ERRORS.append(f"Orphan personal dev milestone {r['milestone_id']}")
    for r in study_habits:
        if r["student_id"] not in student_ids:
            ERRORS.append(f"Orphan study habits {r['habit_id']}")
    for r in wellness:
        if r["student_id"] not in student_ids:
            ERRORS.append(f"Orphan wellness tracking {r['wellness_id']}")
    for r in extracurricular:
        if r["student_id"] not in student_ids:
            ERRORS.append(f"Orphan extracurricular {r['activity_id']}")
    for r in advisor_inputs:
        if r["student_id"] not in student_ids:
            ERRORS.append(f"Orphan advisor input {r['input_id']}")

    dates = []
    for rows, field in (
        (leads, "created_at"),
        (payments, "paid_at"),
        (campaigns, "metric_date"),
        (activity, "activity_date"),
    ):
        for r in rows:
            value = (r.get(field) or "")[:10]
            if value:
                dates.append(value)
    if dates and (min(dates) < "2026-08-01" or max(dates) > "2026-10-22"):
        WARNINGS.append(f"Sample dates span {min(dates)} to {max(dates)}")

    collected = 0.0
    excluded_unknown_refund = 0
    seats = 0
    by_type = defaultdict(float)
    for p in payments:
        if p["payment_status"] != "Paid":
            continue
        gross = num(p["gross_amount_inr"])
        refund = num(p["refund_inr"])
        if gross is None or refund is None:
            excluded_unknown_refund += 1
            continue
        net = gross - refund
        collected += net
        by_type[p["revenue_type"]] += net
        if p["revenue_type"] == "Workshop" and gross % SEAT == 0:
            seats += int(gross // SEAT)

    outstanding = 0.0
    for inv in invoices:
        amt = num(inv["invoice_amount_inr"])
        paid = num(inv["paid_amount_inr"])
        if amt is None or paid is None:
            WARNINGS.append(f"Invoice {inv['invoice_id']} has missing amounts")
            continue
        if amt > paid:
            outstanding += amt - paid

    spend = sum(num(r["spend_inr"]) or 0 for r in campaigns)
    imps = sum(num(r["impressions"]) or 0 for r in campaigns)
    clicks = sum(num(r["clicks"]) or 0 for r in campaigns)
    ql = sum(num(r["qualified_leads"]) or 0 for r in campaigns)
    ctr = clicks / imps if imps else None
    cpql = spend / ql if ql else None

    print("Alcovia sample-data validation (fictional records only)")
    print("─" * 60)
    print(f"Records: students={len(students)} | leads={len(leads)} | events={len(events)} | payments={len(payments)}")
    print(f"         enrollments={len(enrollments)} | invoices={len(invoices)} | campaigns={len(campaigns)}")
    print(f"         activity={len(activity)} | progress={len(progress)} | catalog={len(catalog)}")
    print(f"         sessions={len(sessions)} | feedback={len(feedback)} | targets={len(targets)}")
    print(f"         chapter_readiness={len(chapter_readiness)} | personal_dev={len(personal_dev)} | study_habits={len(study_habits)}")
    print(f"         wellness={len(wellness)} | extracurricular={len(extracurricular)} | advisor_inputs={len(advisor_inputs)}")
    print("─" * 60)
    print(f"Collected net revenue (Paid + known refund): INR {collected:.2f}")
    print(f"  Program  {by_type['Program']:.2f}")
    print(f"  Workshop {by_type['Workshop']:.2f}")
    print(f"  Trial    {by_type['Trial']:.2f}")
    print(f"Paid rows excluded (missing refund): {excluded_unknown_refund}")
    print(f"  (PAY-009 is the expected excluded row — Failed status with blank refund)")
    print(f"Paid workshop seats at INR {SEAT}: {seats}")
    print("─" * 60)
    print(f"Invoice outstanding: INR {outstanding:.2f}")
    print(f"  Note: INV-SAMPLE-001 paid_amount=90000 vs PAY-001 gross=120000 — intentional reconciliation example")
    print("─" * 60)
    ctr_str  = f"{ctr:.5f}"  if ctr  else "unavailable"
    cpql_str = f"{cpql:.2f}" if cpql else "unavailable"
    print(f"Campaign spend: INR {spend:.2f} | CTR: {ctr_str} | cost/QL: {cpql_str}")
    print("─" * 60)
    print(f"Enrolment types: trials={sum(1 for e in enrollments if e['program_type']=='Trial')} | "
          f"full programmes={sum(1 for e in enrollments if e['program_type']=='Full programme')} | "
          f"workshops={sum(1 for e in enrollments if e['program_type']=='Workshop')}")
    print(f"Progress rows with missing syllabus: {sum(1 for p in progress if not p.get('syllabus_completion_pct'))}")
    print(f"  (STU-006 is the expected missing-baseline student)")
    print(f"Unrated feedback rows: {sum(1 for f in feedback if not f.get('rating'))}")
    print("─" * 60)

    if WARNINGS:
        print("Warnings:")
        for w in WARNINGS:
            print(" -", w)
    if ERRORS:
        print("Errors:")
        for e in ERRORS:
            print(" -", e)
        return 1
    print("OK: referential checks passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
