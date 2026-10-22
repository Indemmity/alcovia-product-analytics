/**
 * Shared CSV loader for the static Alcovia assessment dashboards.
 * Fictional sample data only. Requires HTTP (not file://) so fetch can read ../data/*.csv
 */
(function (global) {
  const AS_OF_DATE = "2026-10-22";
  const WORKSHOP_SEAT_INR = 3999;

  function parseCsv(text) {
    const rows = [];
    let row = [];
    let cell = "";
    let inQuotes = false;
    const src = String(text).replace(/^\uFEFF/, "");
    for (let i = 0; i < src.length; i++) {
      const ch = src[i];
      const next = src[i + 1];
      if (inQuotes) {
        if (ch === '"' && next === '"') {
          cell += '"';
          i++;
        } else if (ch === '"') {
          inQuotes = false;
        } else {
          cell += ch;
        }
      } else if (ch === '"') {
        inQuotes = true;
      } else if (ch === ",") {
        row.push(cell);
        cell = "";
      } else if (ch === "\n") {
        row.push(cell);
        if (row.some((v) => v !== "")) rows.push(row);
        row = [];
        cell = "";
      } else if (ch !== "\r") {
        cell += ch;
      }
    }
    if (cell !== "" || row.length) {
      row.push(cell);
      if (row.some((v) => v !== "")) rows.push(row);
    }
    if (!rows.length) return [];
    const headers = rows[0].map((h) => h.trim());
    return rows.slice(1).map((values) => {
      const obj = {};
      headers.forEach((h, idx) => {
        obj[h] = values[idx] == null ? "" : String(values[idx]).trim();
      });
      return obj;
    });
  }

  function toNumber(value) {
    if (value === "" || value == null) return null;
    const n = Number(value);
    return Number.isFinite(n) ? n : null;
  }

  function toBool(value) {
    return String(value).toLowerCase() === "true";
  }

  function parseDate(value) {
    if (!value) return null;
    const d = new Date(value.replace(" ", "T"));
    return Number.isNaN(d.getTime()) ? null : d;
  }

  function isoDate(value) {
    const d = parseDate(value);
    if (!d) return null;
    return d.toISOString().slice(0, 10);
  }

  function addDays(iso, days) {
    const d = new Date(iso + "T00:00:00");
    d.setDate(d.getDate() + days);
    return d.toISOString().slice(0, 10);
  }

  function inRange(iso, start, end) {
    return iso && iso >= start && iso <= end;
  }

  async function loadCsv(path) {
    const res = await fetch(path, { cache: "no-store" });
    if (!res.ok) {
      throw new Error("Could not load " + path + " (HTTP " + res.status + ")");
    }
    return parseCsv(await res.text());
  }

  async function loadGtmData() {
    const base = "../data/";
    const [leads, events, campaigns, payments, targets, invoices, enrollments] = await Promise.all([
      loadCsv(base + "leads.csv"),
      loadCsv(base + "lead_stage_events.csv"),
      loadCsv(base + "campaigns_daily.csv"),
      loadCsv(base + "payments.csv"),
      loadCsv(base + "targets.csv"),
      loadCsv(base + "invoices.csv"),
      loadCsv(base + "enrollments.csv"),
    ]);
    return { leads, events, campaigns, payments, targets, invoices, enrollments };
  }

  async function loadStudentData() {
    const base = "../data/";
    const [students, progress, activity, catalog, sessions, feedback, chapterReadiness, personalDev, studyHabits, wellness, extracurricular, advisorInputs] = await Promise.all([
      loadCsv(base + "students.csv"),
      loadCsv(base + "student_progress.csv"),
      loadCsv(base + "student_activity.csv"),
      loadCsv(base + "academic_catalog.csv"),
      loadCsv(base + "program_sessions.csv"),
      loadCsv(base + "session_feedback.csv"),
      loadCsv(base + "chapter_readiness_stages.csv"),
      loadCsv(base + "personal_development.csv"),
      loadCsv(base + "study_habits.csv"),
      loadCsv(base + "wellness_tracking.csv"),
      loadCsv(base + "extracurricular_activities.csv"),
      loadCsv(base + "advisor_inputs.csv"),
    ]);
    return { students, progress, activity, catalog, sessions, feedback, chapterReadiness, personalDev, studyHabits, wellness, extracurricular, advisorInputs };
  }

  global.AlcoviaData = {
    AS_OF_DATE,
    WORKSHOP_SEAT_INR,
    parseCsv,
    toNumber,
    toBool,
    parseDate,
    isoDate,
    addDays,
    inRange,
    loadCsv,
    loadGtmData,
    loadStudentData,
  };
})(window);
