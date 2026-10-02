BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "journal_entry" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "activities" json NOT NULL,
    "bestMoment" text
);

-- Indexes
CREATE UNIQUE INDEX "journal_entry_user_date_idx" ON "journal_entry" USING btree ("userId", "date");


--
-- MIGRATION VERSION FOR tidal
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('tidal', '20261002210506235-journal', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261002210506235-journal', "timestamp" = now();

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
