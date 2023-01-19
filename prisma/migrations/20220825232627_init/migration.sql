/*
  Warnings:

  - A unique constraint covering the columns `[uuid]` on the table `AirRecords` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "AirRecords" ADD COLUMN     "uuid" TEXT,
ALTER COLUMN "clouds" SET DATA TYPE DOUBLE PRECISION,
ALTER COLUMN "visibility" SET DATA TYPE DOUBLE PRECISION;

-- CreateIndex
CREATE UNIQUE INDEX "AirRecords_uuid_key" ON "AirRecords"("uuid");
