BEGIN;

--
-- Data (hand-added, see AGENTS.md): keep existing pain entries and doses.
-- The generated SQL below drops and recreates both tables, so copy their
-- rows aside first and put them back afterwards.
--
CREATE TEMP TABLE "_dose_log_backup" ON COMMIT DROP AS SELECT * FROM "dose_log";
CREATE TEMP TABLE "_pain_entry_backup" ON COMMIT DROP AS SELECT * FROM "pain_entry";

--
-- ACTION DROP TABLE
--
DROP TABLE "dose_log" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "dose_log" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "medicationId" bigint NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "loggedAt" timestamp without time zone NOT NULL,
    "dose" text NOT NULL
);

-- Indexes
CREATE INDEX "dose_log_user_date_idx" ON "dose_log" USING btree ("userId", "date");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "medication" ADD COLUMN "type" text;
--
-- ACTION DROP TABLE
--
DROP TABLE "pain_entry" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "pain_entry" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "loggedAt" timestamp without time zone NOT NULL,
    "level" bigint NOT NULL,
    "locations" json NOT NULL
);

-- Indexes
CREATE INDEX "pain_entry_user_date_idx" ON "pain_entry" USING btree ("userId", "date");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "dose_log"
    ADD CONSTRAINT "dose_log_fk_0"
    FOREIGN KEY("medicationId")
    REFERENCES "medication"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- Data (hand-added): restore the rows. Old entries had no separate day or
-- saved-at time, so both come from their original timestamp.
--
INSERT INTO "pain_entry" ("id", "userId", "date", "timestamp", "loggedAt", "level", "locations")
SELECT "id", "userId", date_trunc('day', "timestamp"), "timestamp", "timestamp", "level", "locations"
FROM "_pain_entry_backup";
SELECT setval(pg_get_serial_sequence('"pain_entry"', 'id'), COALESCE(MAX("id"), 1), MAX("id") IS NOT NULL) FROM "pain_entry";

INSERT INTO "dose_log" ("id", "userId", "medicationId", "date", "timestamp", "loggedAt", "dose")
SELECT "id", "userId", "medicationId", date_trunc('day', "timestamp"), "timestamp", "timestamp", "dose"
FROM "_dose_log_backup";
SELECT setval(pg_get_serial_sequence('"dose_log"', 'id'), COALESCE(MAX("id"), 1), MAX("id") IS NOT NULL) FROM "dose_log";

--
-- MIGRATION VERSION FOR tidal
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('tidal', '20261002193126284-log-times-and-med-types', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261002193126284-log-times-and-med-types', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260910193913364-string-rate-limit-keys', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260910193913364-string-rate-limit-keys', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260824182354731', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182354731', "timestamp" = now();


COMMIT;
