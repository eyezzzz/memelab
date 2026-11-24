CREATE TABLE IF NOT EXISTS collection_runs (bucket INTEGER PRIMARY KEY, attempted_at TEXT NOT NULL, status TEXT NOT NULL, detail TEXT NOT NULL);
