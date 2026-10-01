BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "day_log" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "flow" text NOT NULL DEFAULT 'none'::text,
    "mood" text,
    "note" text
);

-- Indexes
CREATE UNIQUE INDEX "day_log_user_date_idx" ON "day_log" USING btree ("userId", "date");


--
-- MIGRATION VERSION FOR tidal
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('tidal', '20261001194946073', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261001194946073', "timestamp" = now();

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
