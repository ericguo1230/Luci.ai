-- AlterTable
ALTER TABLE "Alert" ALTER COLUMN "creation" DROP NOT NULL,
ALTER COLUMN "sensor_uuid" DROP NOT NULL;
