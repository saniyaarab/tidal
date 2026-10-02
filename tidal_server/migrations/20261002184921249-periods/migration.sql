BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "period" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "startDate" timestamp without time zone NOT NULL,
    "endDate" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "period_user_start_idx" ON "period" USING btree ("userId", "startDate");

--
-- Data: turn existing flow logs into periods (hand-added, see AGENTS.md).
-- Every period start found by the old flow-based rule (a day with flow whose
-- previous day has no flow) becomes a period starting that day with no
-- confirmed end, so it shows with the user's default period length.
--
INSERT INTO "period" ("userId", "startDate", "endDate")
SELECT d."userId", d."date", NULL
FROM "day_log" d
WHERE d."flow" <> 'none'
  AND NOT EXISTS (
    SELECT 1 FROM "day_log" prev
    WHERE prev."userId" = d."userId"
      AND prev."date" = d."date" - INTERVAL '1 day'
      AND prev."flow" <> 'none'
  );


--
-- MIGRATION VERSION FOR tidal
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('tidal', '20261002184921249-periods', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261002184921249-periods', "timestamp" = now();

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
