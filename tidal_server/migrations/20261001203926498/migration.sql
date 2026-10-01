BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "dose_log" ADD COLUMN "painAfter" bigint;
ALTER TABLE "dose_log" ADD COLUMN "checkInDue" boolean NOT NULL DEFAULT false;

--
-- MIGRATION VERSION FOR tidal
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('tidal', '20261001203926498', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261001203926498', "timestamp" = now();

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
