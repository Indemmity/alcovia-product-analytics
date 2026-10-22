-- SQLite loader for local checks. Paths assume this file is run from the project root:
-- sqlite3 alcovia_sample.db ".read sql/load_sample_sqlite.sql"
-- All data is fictional.
--
-- NOTE: .import --skip 1 requires SQLite 3.37.0 (2021-11-27) or later.
-- Check your version with: sqlite3 --version
-- If you have an older SQLite, remove the --skip 1 flag and manually DELETE the header rows after import.
-- On Windows you can install a current sqlite3 binary from https://www.sqlite.org/download.html

DROP TABLE IF EXISTS session_feedback;
DROP TABLE IF EXISTS program_sessions;
DROP TABLE IF EXISTS student_progress;
DROP TABLE IF EXISTS student_activity;
DROP TABLE IF EXISTS academic_catalog;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS campaigns_daily;
DROP TABLE IF EXISTS lead_stage_events;
DROP TABLE IF EXISTS targets;
DROP TABLE IF EXISTS leads;
DROP TABLE IF EXISTS students;

CREATE TABLE students (
  student_id TEXT PRIMARY KEY, display_name TEXT, cohort TEXT, enrollment_date TEXT,
  status TEXT NOT NULL, advisor TEXT, consent_status TEXT
);
CREATE TABLE leads (
  lead_id TEXT PRIMARY KEY, created_at TEXT NOT NULL, source TEXT, campaign_id TEXT,
  is_qualified TEXT, current_stage TEXT, outcome TEXT
);
CREATE TABLE lead_stage_events (
  event_id TEXT PRIMARY KEY, lead_id TEXT, stage TEXT NOT NULL, occurred_at TEXT NOT NULL
);
CREATE TABLE campaigns_daily (
  campaign_id TEXT NOT NULL, campaign_name TEXT, revenue_type TEXT, metric_date TEXT NOT NULL,
  spend_inr REAL, impressions INTEGER, clicks INTEGER, landing_page_visits INTEGER,
  leads INTEGER, qualified_leads INTEGER, frequency REAL,
  PRIMARY KEY (campaign_id, metric_date)
);
CREATE TABLE payments (
  payment_id TEXT PRIMARY KEY, lead_id TEXT, paid_at TEXT, revenue_type TEXT NOT NULL,
  gross_amount_inr REAL, refund_inr REAL, payment_status TEXT NOT NULL, source_system TEXT, notes TEXT
);
CREATE TABLE invoices (
  invoice_id TEXT PRIMARY KEY, lead_id TEXT, issued_at TEXT, due_at TEXT,
  invoice_amount_inr REAL, paid_amount_inr REAL, status TEXT
);
CREATE TABLE enrollments (
  enrollment_id TEXT PRIMARY KEY, lead_id TEXT, student_id TEXT, program_type TEXT,
  enrollment_date TEXT, renewal_date TEXT, status TEXT, seats INTEGER
);
CREATE TABLE student_activity (
  activity_id TEXT PRIMARY KEY, student_id TEXT, activity_date TEXT NOT NULL, activity_type TEXT NOT NULL,
  task_id TEXT, subject TEXT, chapter TEXT, task_title TEXT, started_at TEXT, completed_at TEXT,
  duration_seconds INTEGER, checkpoint_seconds INTEGER, last_checkpoint_at TEXT, status TEXT,
  priority_rank INTEGER, deleted TEXT, locked TEXT, stale TEXT, source_system TEXT
);
CREATE TABLE student_progress (
  progress_id TEXT PRIMARY KEY, student_id TEXT, recorded_at TEXT NOT NULL, period_grain TEXT NOT NULL,
  subject TEXT, chapter TEXT, syllabus_completion_pct REAL, readiness_score REAL, task_completion_pct REAL,
  goal_status TEXT, hours_studied REAL, advisor_review_status TEXT, entered_by_role TEXT
);
CREATE TABLE academic_catalog (
  item_id TEXT PRIMARY KEY, item_type TEXT NOT NULL, subject TEXT, chapter TEXT, task_title TEXT,
  priority_rank INTEGER, status TEXT, eligible_for_resume TEXT
);
CREATE TABLE program_sessions (
  session_id TEXT PRIMARY KEY, session_type TEXT NOT NULL, scheduled_at TEXT, conducted_at TEXT,
  advisor_id TEXT, cohort TEXT, status TEXT
);
CREATE TABLE session_feedback (
  feedback_id TEXT PRIMARY KEY, session_id TEXT, student_id TEXT, rating REAL, feedback_text TEXT, submitted_at TEXT
);
CREATE TABLE targets (
  target_month TEXT NOT NULL, revenue_type TEXT NOT NULL, target_amount_inr REAL NOT NULL,
  PRIMARY KEY (target_month, revenue_type)
);

.mode csv
.headers on
.import --skip 1 data/students.csv students
.import --skip 1 data/leads.csv leads
.import --skip 1 data/lead_stage_events.csv lead_stage_events
.import --skip 1 data/campaigns_daily.csv campaigns_daily
.import --skip 1 data/payments.csv payments
.import --skip 1 data/invoices.csv invoices
.import --skip 1 data/enrollments.csv enrollments
.import --skip 1 data/student_activity.csv student_activity
.import --skip 1 data/student_progress.csv student_progress
.import --skip 1 data/academic_catalog.csv academic_catalog
.import --skip 1 data/program_sessions.csv program_sessions
.import --skip 1 data/session_feedback.csv session_feedback
.import --skip 1 data/targets.csv targets

-- SQLite stores empty CSV fields as ''. Treat those as NULL for numeric measures.
UPDATE payments SET refund_inr = NULL WHERE refund_inr = '';
UPDATE payments SET gross_amount_inr = NULL WHERE gross_amount_inr = '';
UPDATE student_progress SET syllabus_completion_pct = NULL WHERE syllabus_completion_pct = '';
UPDATE student_progress SET readiness_score = NULL WHERE readiness_score = '';
UPDATE student_progress SET task_completion_pct = NULL WHERE task_completion_pct = '';
UPDATE student_progress SET hours_studied = NULL WHERE hours_studied = '';
UPDATE session_feedback SET rating = NULL WHERE rating = '';
