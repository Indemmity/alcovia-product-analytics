# Assessment prototype data

This project is based on the requirements and baseline observations in Alcovia's written assessment brief; no screenshots are required to establish that connection. Every CSV in this folder contains **synthetic demonstration records** created to exercise the requested dashboards, calculations, and workflows. These records are not Alcovia's actual leads, revenue, student records, or outcomes.

Keep source-derived facts from the brief separate from synthetic CSV rows. For example, the brief states an average app usage of about 2.15 minutes against a 30-minute aspiration, 20 students used the app in the previous 45 days, and 7 had not opened it in the previous two weeks. Those are brief-provided observations; the individual student records in these CSVs are not the underlying records behind those observations.

The HTML dashboards load these files with `fetch` when served over HTTP. They do not invent a second conflicting dataset.

See `docs/METRIC_DEFINITIONS.md` for grain, keys, KPI formulas and the missing-versus-zero rules.

Do not add real student data or credentials here.
