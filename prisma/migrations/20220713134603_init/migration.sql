/*
  Warnings:

  - You are about to drop the column `uuid` on the `Threshold` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "Alert" DROP CONSTRAINT "Alert_sensor_id_fkey";

-- DropForeignKey
ALTER TABLE "Sensor" DROP CONSTRAINT "Sensor_environment_analysis_id_fkey";

-- DropForeignKey
ALTER TABLE "Sensor" DROP CONSTRAINT "Sensor_pond_id_fkey";

-- DropForeignKey
ALTER TABLE "Sensor" DROP CONSTRAINT "Sensor_threshold_id_fkey";

-- DropForeignKey
ALTER TABLE "WaterLevel" DROP CONSTRAINT "WaterLevel_pond_id_fkey";

-- AlterTable
ALTER TABLE "Alert" ALTER COLUMN "sensor_id" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Sensor" ADD COLUMN     "pond_uuid" TEXT,
ALTER COLUMN "pond_id" DROP NOT NULL,
ALTER COLUMN "environment_analysis_id" DROP NOT NULL,
ALTER COLUMN "threshold_id" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Threshold" DROP COLUMN "uuid";

-- AlterTable
ALTER TABLE "WaterLevel" ALTER COLUMN "pond_id" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "WaterLevel" ADD CONSTRAINT "WaterLevel_pond_id_fkey" FOREIGN KEY ("pond_id") REFERENCES "Pond"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Sensor" ADD CONSTRAINT "Sensor_pond_id_fkey" FOREIGN KEY ("pond_id") REFERENCES "Pond"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Sensor" ADD CONSTRAINT "Sensor_threshold_id_fkey" FOREIGN KEY ("threshold_id") REFERENCES "SensorThreshold"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Sensor" ADD CONSTRAINT "Sensor_environment_analysis_id_fkey" FOREIGN KEY ("environment_analysis_id") REFERENCES "EnvironmentAnalysis"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Alert" ADD CONSTRAINT "Alert_sensor_id_fkey" FOREIGN KEY ("sensor_id") REFERENCES "Sensor"("id") ON DELETE SET NULL ON UPDATE CASCADE;
