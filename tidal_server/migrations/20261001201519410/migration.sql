BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "dose_log" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "medicationId" bigint NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "dose" text NOT NULL,
    "painBefore" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "medication" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "name" text NOT NULL,
    "usualDose" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "pain_entry" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "level" bigint NOT NULL,
    "locations" json NOT NULL
);

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
-- MIGRATION VERSION FOR tidal
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('tidal', '20261001201519410', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261001201519410', "timestamp" = now();

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
