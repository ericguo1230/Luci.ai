/*
  Warnings:

  - A unique constraint covering the columns `[environment_analysis_id]` on the table `Sensor` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "Sensor" ADD COLUMN     "seaOffset" INTEGER,
ALTER COLUMN "lat" SET DATA TYPE DOUBLE PRECISION,
ALTER COLUMN "lng" SET DATA TYPE DOUBLE PRECISION;

-- CreateIndex
CREATE UNIQUE INDEX "Sensor_environment_analysis_id_key" ON "Sensor"("environment_analysis_id");
