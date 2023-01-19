/*
  Warnings:

  - A unique constraint covering the columns `[sensor_uuid]` on the table `Record` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "Record" ADD COLUMN     "sensor_uuid" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "Record_sensor_uuid_key" ON "Record"("sensor_uuid");
