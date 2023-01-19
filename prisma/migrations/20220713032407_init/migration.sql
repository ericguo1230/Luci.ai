/*
  Warnings:

  - You are about to drop the column `sensor_id` on the `Record` table. All the data in the column will be lost.
  - You are about to drop the column `values` on the `Sensor` table. All the data in the column will be lost.
  - You are about to drop the column `uuid` on the `machine` table. All the data in the column will be lost.
  - You are about to drop the `Units` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[values_id]` on the table `Sensor` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[unit_id]` on the table `Sensor` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE "Record" DROP CONSTRAINT "Record_sensor_id_fkey";

-- AlterTable
ALTER TABLE "Record" DROP COLUMN "sensor_id";

-- AlterTable
ALTER TABLE "Sensor" DROP COLUMN "values",
ADD COLUMN     "unit_id" INTEGER,
ADD COLUMN     "values_id" BIGINT;

-- AlterTable
ALTER TABLE "machine" DROP COLUMN "uuid";

-- DropTable
DROP TABLE "Units";

-- CreateTable
CREATE TABLE "Unit" (
    "id" SERIAL NOT NULL,
    "ph" TEXT,
    "conductivity" TEXT,
    "tds" TEXT,
    "orp" TEXT,
    "dissolvedoxygen" TEXT,
    "turbidity" TEXT,
    "salinity" TEXT,
    "temp" TEXT,
    "depth" TEXT,
    "tss" TEXT,
    "airtemperature" TEXT,
    "pressure" TEXT,
    "humidity" TEXT,
    "rain" TEXT,

    CONSTRAINT "Unit_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Sensor_values_id_key" ON "Sensor"("values_id");

-- CreateIndex
CREATE UNIQUE INDEX "Sensor_unit_id_key" ON "Sensor"("unit_id");

-- AddForeignKey
ALTER TABLE "Sensor" ADD CONSTRAINT "Sensor_values_id_fkey" FOREIGN KEY ("values_id") REFERENCES "Record"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Sensor" ADD CONSTRAINT "Sensor_unit_id_fkey" FOREIGN KEY ("unit_id") REFERENCES "Unit"("id") ON DELETE SET NULL ON UPDATE CASCADE;
