-- Proposed PostgreSQL schema for the Alcovia assessment prototype, mapped to requirements in the written assessment brief.
-- Illustrative only; not connected to production. Review with the engineering owner before use.
-- Sample CSVs in ../data contain synthetic demonstration records, not Alcovia exports.
-- Brief-provided baseline observations are context and are not represented as source rows in these tables.

CREATE TABLE students (
  student_id TEXT PRIMARY KEY,
  display_name TEXT,
  cohort TEXT,
  enrollment_date DATE,
  status TEXT NOT NULL,
  advisor TEXT,
  consent_status TEXT
);

CREATE TABLE leads (
  lead_id TEXT PRIMARY KEY,
  created_at TIMESTAMP NOT NULL,
  source TEXT,
  campaign_id TEXT,
  is_qualified BOOLEAN DEFAULT FALSE,
  current_stage TEXT,
  outcome TEXT
);

CREATE TABLE lead_stage_events (
  event_id TEXT PRIMARY KEY,
  lead_id TEXT REFERENCES leads(lead_id),
  stage TEXT NOT NULL,
  occurred_at TIMESTAMP NOT NULL
);

CREATE TABLE campaigns_daily (
  campaign_id TEXT NOT NULL,
  campaign_name TEXT,
  revenue_type TEXT,
  metric_date DATE NOT NULL,
  spend_inr NUMERIC(12,2),
  impressions BIGINT,
  clicks BIGINT,
  landing_page_visits BIGINT,
  leads BIGINT,
  qualified_leads BIGINT,
  frequency NUMERIC(8,2),
  PRIMARY KEY (campaign_id, metric_date)
);

CREATE TABLE payments (
  payment_id TEXT PRIMARY KEY,
  lead_id TEXT REFERENCES leads(lead_id),
  paid_at TIMESTAMP,
  revenue_type TEXT NOT NULL,
  gross_amount_inr NUMERIC(12,2),
  refund_inr NUMERIC(12,2),
  payment_status TEXT NOT NULL,
  source_system TEXT,
  notes TEXT
);

CREATE TABLE invoices (
  invoice_id TEXT PRIMARY KEY,
  lead_id TEXT REFERENCES leads(lead_id),
  issued_at DATE,
  due_at DATE,
  invoice_amount_inr NUMERIC(12,2),
  paid_amount_inr NUMERIC(12,2),
  status TEXT
);

CREATE TABLE enrollments (
  enrollment_id TEXT PRIMARY KEY,
  lead_id TEXT REFERENCES leads(lead_id),
  student_id TEXT REFERENCES students(student_id),
  program_type TEXT,
  enrollment_date DATE,
  renewal_date DATE,
  status TEXT,
  seats INTEGER
);

CREATE TABLE student_activity (
  activity_id TEXT PRIMARY KEY,
  student_id TEXT REFERENCES students(student_id),
  activity_date DATE NOT NULL,
  activity_type TEXT NOT NULL,
  task_id TEXT,
  subject TEXT,
  chapter TEXT,
  task_title TEXT,
  started_at TIMESTAMP,
  completed_at TIMESTAMP,
  duration_seconds INTEGER,
  checkpoint_seconds INTEGER,
  last_checkpoint_at TIMESTAMP,
  status TEXT,
  priority_rank INTEGER,
  deleted BOOLEAN,
  locked BOOLEAN,
  stale BOOLEAN,
  source_system TEXT
);

CREATE TABLE student_progress (
  progress_id TEXT PRIMARY KEY,
  student_id TEXT REFERENCES students(student_id),
  recorded_at TIMESTAMP NOT NULL,
  period_grain TEXT NOT NULL,
  subject TEXT,
  chapter TEXT,
  syllabus_completion_pct NUMERIC(5,2),
  readiness_score NUMERIC(5,2),
  task_completion_pct NUMERIC(5,2),
  goal_status TEXT,
  hours_studied NUMERIC(8,2),
  advisor_review_status TEXT,
  entered_by_role TEXT
);

CREATE TABLE academic_catalog (
  item_id TEXT PRIMARY KEY,
  item_type TEXT NOT NULL,
  subject TEXT,
  chapter TEXT,
  task_title TEXT,
  priority_rank INTEGER,
  status TEXT,
  eligible_for_resume BOOLEAN
);

CREATE TABLE program_sessions (
  session_id TEXT PRIMARY KEY,
  session_type TEXT NOT NULL,
  scheduled_at TIMESTAMP,
  conducted_at TIMESTAMP,
  advisor_id TEXT,
  cohort TEXT,
  status TEXT
);

CREATE TABLE session_feedback (
  feedback_id TEXT PRIMARY KEY,
  session_id TEXT REFERENCES program_sessions(session_id),
  student_id TEXT REFERENCES students(student_id),
  rating NUMERIC(3,1),
  feedback_text TEXT,
  submitted_at TIMESTAMP
);

CREATE TABLE targets (
  target_month DATE NOT NULL,
  revenue_type TEXT NOT NULL,
  target_amount_inr NUMERIC(12,2) NOT NULL,
  PRIMARY KEY (target_month, revenue_type)
);
