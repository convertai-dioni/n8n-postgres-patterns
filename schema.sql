-- Tables used by the example workflows.
CREATE TABLE IF NOT EXISTS leads (
  id         bigserial PRIMARY KEY,
  email      text UNIQUE NOT NULL,
  name       text,
  source     text,
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS contacts (
  external_id text PRIMARY KEY,
  email       text,
  updated_at  timestamptz
);

CREATE TABLE IF NOT EXISTS sync_state (
  job            text PRIMARY KEY,
  last_synced_at timestamptz NOT NULL
);
