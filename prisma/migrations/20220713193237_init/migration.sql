/*
  Warnings:

  - You are about to drop the column `environment_analysis_id` on the `Sensor` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[sensor_id]` on the table `EnvironmentAnalysis` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE "Sensor" DROP CONSTRAINT "Sensor_environment_analysis_id_fkey";

-- DropIndex
DROP INDEX "Sensor_environment_analysis_id_key";

-- AlterTable
ALTER TABLE "EnvironmentAnalysis" ADD COLUMN     "sensor_id" INTEGER;

-- AlterTable
ALTER TABLE "Sensor" DROP COLUMN "environment_analysis_id";

-- CreateIndex
CREATE UNIQUE INDEX "EnvironmentAnalysis_sensor_id_key" ON "EnvironmentAnalysis"("sensor_id");

-- AddForeignKey
ALTER TABLE "EnvironmentAnalysis" ADD CONSTRAINT "EnvironmentAnalysis_sensor_id_fkey" FOREIGN KEY ("sensor_id") REFERENCES "Sensor"("id") ON DELETE SET NULL ON UPDATE CASCADE;
