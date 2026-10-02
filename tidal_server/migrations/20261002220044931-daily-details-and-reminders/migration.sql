BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bowel_movement" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "loggedAt" timestamp without time zone NOT NULL,
    "bristolType" bigint NOT NULL
);

-- Indexes
CREATE INDEX "bowel_movement_user_date_idx" ON "bowel_movement" USING btree ("userId", "date");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "cycle_settings" ADD COLUMN "weightUnit" text NOT NULL DEFAULT 'kg'::text;
ALTER TABLE "cycle_settings" ADD COLUMN "temperatureUnit" text NOT NULL DEFAULT 'celsius'::text;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "day_log" ADD COLUMN "waterGlasses" bigint NOT NULL DEFAULT 0;
ALTER TABLE "day_log" ADD COLUMN "caffeineDrinks" bigint NOT NULL DEFAULT 0;
ALTER TABLE "day_log" ADD COLUMN "alcoholDrinks" bigint NOT NULL DEFAULT 0;
ALTER TABLE "day_log" ADD COLUMN "sleepQuality" bigint;
ALTER TABLE "day_log" ADD COLUMN "sleepHours" double precision;
ALTER TABLE "day_log" ADD COLUMN "bloating" text;
ALTER TABLE "day_log" ADD COLUMN "acidReflux" text;
ALTER TABLE "day_log" ADD COLUMN "weightKg" double precision;
ALTER TABLE "day_log" ADD COLUMN "temperatureC" double precision;
ALTER TABLE "day_log" ADD COLUMN "mucus" text;
ALTER TABLE "day_log" ADD COLUMN "love" text;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "medication" ADD COLUMN "reminderEveryHours" bigint;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "medication_reminder" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "medicationId" bigint NOT NULL,
    "dueAt" timestamp without time zone NOT NULL,
    "isDue" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE UNIQUE INDEX "medication_reminder_medication_idx" ON "medication_reminder" USING btree ("medicationId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "medication_reminder"
    ADD CONSTRAINT "medication_reminder_fk_0"
    FOREIGN KEY("medicationId")
    REFERENCES "medication"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR tidal
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('tidal', '20261002220044931-daily-details-and-reminders', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261002220044931-daily-details-and-reminders', "timestamp" = now();

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
