-- Example KPI queries (PostgreSQL) aligned to sql/schema.sql and data/*.csv.
-- Fictional sample data only. Confirm definitions with Alcovia before production.
-- Missing numerators/denominators return NULL, not 0, unless the count is a genuine empty set.

-- 1) Collected revenue by month and type (paid only; skip rows with unknown refund).
SELECT date_trunc('month', paid_at)::date AS month,
       revenue_type,
       SUM(gross_amount_inr - refund_inr) AS net_collected_inr,
       COUNT(*) AS paid_rows_included
FROM payments
WHERE payment_status = 'Paid'
  AND paid_at IS NOT NULL
  AND gross_amount_inr IS NOT NULL
  AND refund_inr IS NOT NULL
GROUP BY 1, 2
ORDER BY 1, 2;

-- 2) Workshop seats using the assignment assumption of 3999 INR per seat.
-- Non-divisible amounts return NULL seats rather than a rounded guess.
SELECT payment_id,
       gross_amount_inr,
       CASE
         WHEN gross_amount_inr IS NULL THEN NULL
         WHEN mod(gross_amount_inr, 3999) = 0 THEN gross_amount_inr / 3999
         ELSE NULL
       END AS workshop_seats
FROM payments
WHERE revenue_type = 'Workshop'
  AND payment_status = 'Paid';

-- 3) Trials vs full programmes (headcount from enrollments; money from payments).
SELECT program_type, COUNT(*) AS enrollments
FROM enrollments
GROUP BY 1
ORDER BY 1;

SELECT revenue_type,
       SUM(gross_amount_inr - refund_inr) AS net_collected_inr
FROM payments
WHERE payment_status = 'Paid'
  AND gross_amount_inr IS NOT NULL
  AND refund_inr IS NOT NULL
GROUP BY 1
ORDER BY 1;

-- 4) Campaign CTR, frequency, cost per qualified lead, landing-page click-to-visit.
SELECT campaign_id,
       SUM(spend_inr) AS spend_inr,
       SUM(impressions) AS impressions,
       SUM(clicks) AS clicks,
       SUM(landing_page_visits) AS landing_page_visits,
       SUM(qualified_leads) AS qualified_leads,
       CASE WHEN SUM(impressions) > 0
            THEN SUM(clicks)::numeric / SUM(impressions) END AS ctr,
       CASE WHEN SUM(impressions) > 0
            THEN SUM(frequency * impressions) / SUM(impressions) END AS impression_weighted_frequency,
       CASE WHEN SUM(clicks) > 0
            THEN SUM(landing_page_visits)::numeric / SUM(clicks) END AS click_to_visit,
       CASE WHEN SUM(qualified_leads) > 0
            THEN SUM(spend_inr) / SUM(qualified_leads) END AS cost_per_qualified_lead
FROM campaigns_daily
GROUP BY campaign_id
ORDER BY campaign_id;

-- 5) Cohort funnel: distinct leads created in a window who reached each stage.
-- Replace :start_ts and :end_ts with your reporting window before running.
-- Denominator is the cohort size, not the same-period event count.
-- Example window for the sample data: '2026-07-24' to '2026-10-23'
WITH cohort AS (
  SELECT lead_id
  FROM leads
  WHERE created_at >= :start_ts   -- e.g. TIMESTAMP '2026-07-24 00:00:00'
    AND created_at <  :end_ts     -- e.g. TIMESTAMP '2026-10-23 00:00:00'
),
reached AS (
  SELECT e.stage, COUNT(DISTINCT e.lead_id) AS leads_reached
  FROM lead_stage_events e
  JOIN cohort c ON c.lead_id = e.lead_id
  GROUP BY e.stage
)
SELECT * FROM reached ORDER BY leads_reached DESC;

-- 6) Outstanding invoices. Do not equate invoice paid_amount with payments.gross.
-- Sample note: INV-SAMPLE-001 (LEAD-002) shows paid_amount = 90,000 while PAY-001 records 120,000.
-- This is an intentional reconciliation example showing that invoice and payment tables
-- can disagree. Do not silently merge them. Treat both rows as separately authoritative.
SELECT invoice_id, lead_id, due_at, status,
       invoice_amount_inr, paid_amount_inr,
       GREATEST(invoice_amount_inr - paid_amount_inr, 0) AS outstanding_inr
FROM invoices
WHERE invoice_amount_inr IS NOT NULL
  AND paid_amount_inr IS NOT NULL
  AND invoice_amount_inr > paid_amount_inr
ORDER BY due_at;

-- 7) Upcoming trial renewals from the demo as-of date.
SELECT enrollment_id, student_id, renewal_date, status
FROM enrollments
WHERE program_type = 'Trial'
  AND renewal_date BETWEEN DATE '2026-10-22' AND DATE '2026-11-12'
ORDER BY renewal_date;

-- 8) Revenue vs monthly target at month grain.
WITH actuals AS (
  SELECT date_trunc('month', paid_at)::date AS month,
         revenue_type,
         SUM(gross_amount_inr - refund_inr) AS net_collected_inr
  FROM payments
  WHERE payment_status = 'Paid'
    AND gross_amount_inr IS NOT NULL
    AND refund_inr IS NOT NULL
  GROUP BY 1, 2
)
SELECT t.target_month,
       t.revenue_type,
       t.target_amount_inr,
       a.net_collected_inr,
       CASE WHEN t.target_amount_inr > 0
            THEN a.net_collected_inr / t.target_amount_inr END AS achievement_ratio
FROM targets t
LEFT JOIN actuals a
  ON a.month = t.target_month AND a.revenue_type = t.revenue_type
ORDER BY t.target_month, t.revenue_type;

-- 9) Student progress by grain. NULLs stay NULL.
SELECT period_grain, student_id, subject,
       syllabus_completion_pct, readiness_score, task_completion_pct,
       goal_status, advisor_review_status, hours_studied
FROM student_progress
ORDER BY student_id, period_grain;

-- 10) Session quantity and quality. Unrated feedback is excluded from the average.
SELECT
  COUNT(*) AS planned_sessions,
  COUNT(*) FILTER (WHERE status = 'Conducted') AS conducted_sessions,
  CASE WHEN COUNT(*) > 0
       THEN COUNT(*) FILTER (WHERE status = 'Conducted')::numeric / COUNT(*) END AS conducted_rate
FROM program_sessions;

SELECT COUNT(*) AS feedback_rows,
       COUNT(rating) AS rated_rows,
       AVG(rating) AS mean_rating_excluding_nulls,
       CASE WHEN COUNT(*) > 0 THEN COUNT(rating)::numeric / COUNT(*) END AS response_rate
FROM session_feedback;
