/*
  Warnings:

  - You are about to drop the column `government` on the `Pond` table. All the data in the column will be lost.
  - You are about to drop the column `points` on the `Pond` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[uuid]` on the table `Alert` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[uuid]` on the table `AlertResponse` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[uuid]` on the table `Area` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[uuid]` on the table `EnvironmentAnalysis` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[uuid]` on the table `FSM` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[uuid]` on the table `ModelMapping` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[uuid]` on the table `Pond` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[shape_id]` on the table `Pond` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[points_id]` on the table `Pond` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[uuid]` on the table `Record` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[uuid]` on the table `Sensor` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[threshold_id]` on the table `Sensor` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[uuid]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `record_uuid` to the `Alert` table without a default value. This is not possible if the table is not empty.
  - Added the required column `sensor_uuid` to the `Alert` table without a default value. This is not possible if the table is not empty.
  - Added the required column `threshold_id` to the `Sensor` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Alert" ADD COLUMN     "pond_uuid" TEXT,
ADD COLUMN     "record_uuid" TEXT NOT NULL,
ADD COLUMN     "sensor_uuid" TEXT NOT NULL,
ADD COLUMN     "uuid" TEXT;

-- AlterTable
ALTER TABLE "AlertResponse" ADD COLUMN     "operator_uuid" TEXT,
ADD COLUMN     "uuid" TEXT;

-- AlterTable
ALTER TABLE "Area" ADD COLUMN     "ponds_uuid" TEXT[],
ADD COLUMN     "users_uuid" TEXT[],
ADD COLUMN     "uuid" TEXT;

-- AlterTable
ALTER TABLE "EnvironmentAnalysis" ADD COLUMN     "pond_uuid" TEXT,
ADD COLUMN     "sensor_uuid" TEXT,
ADD COLUMN     "uuid" TEXT;

-- AlterTable
ALTER TABLE "EnvironmentStatus" ADD COLUMN     "unit" TEXT;

-- AlterTable
ALTER TABLE "FSM" ADD COLUMN     "pond_uuid" TEXT,
ADD COLUMN     "uuid" TEXT;

-- AlterTable
ALTER TABLE "ModelMapping" ADD COLUMN     "uuid" TEXT,
ALTER COLUMN "model" DROP NOT NULL,
ALTER COLUMN "model" SET DATA TYPE TEXT,
ALTER COLUMN "sensor" DROP NOT NULL,
ALTER COLUMN "sensor" SET DATA TYPE TEXT,
ALTER COLUMN "air" DROP NOT NULL,
ALTER COLUMN "air" SET DATA TYPE TEXT,
ALTER COLUMN "pond" DROP NOT NULL,
ALTER COLUMN "pond" SET DATA TYPE TEXT;

-- AlterTable
ALTER TABLE "Pond" DROP COLUMN "government",
DROP COLUMN "points",
ADD COLUMN     "area_uuid" TEXT,
ADD COLUMN     "name" TEXT,
ADD COLUMN     "points_id" INTEGER,
ADD COLUMN     "sensors_uuid" TEXT[],
ADD COLUMN     "shape_id" INTEGER,
ADD COLUMN     "uuid" TEXT;

-- AlterTable
ALTER TABLE "Record" ADD COLUMN     "uuid" TEXT;

-- AlterTable
ALTER TABLE "Sensor" ADD COLUMN     "creation" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "lat" INTEGER,
ADD COLUMN     "lng" INTEGER,
ADD COLUMN     "name" TEXT,
ADD COLUMN     "status" INTEGER,
ADD COLUMN     "threshold_id" INTEGER NOT NULL,
ADD COLUMN     "update" INTEGER,
ADD COLUMN     "uuid" TEXT,
ADD COLUMN     "values" INTEGER;

-- AlterTable
ALTER TABLE "Threshold" ADD COLUMN     "uuid" TEXT;

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "aid_uuid" TEXT[],
ADD COLUMN     "recipient_uuid" TEXT[],
ADD COLUMN     "uuid" TEXT;

-- AlterTable
ALTER TABLE "machine" ADD COLUMN     "uuid" TEXT;

-- CreateTable
CREATE TABLE "WaterLevel" (
    "id" SERIAL NOT NULL,
    "type" TEXT,
    "value" TEXT,
    "pond_id" INTEGER NOT NULL,

    CONSTRAINT "WaterLevel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SensorThreshold" (
    "id" SERIAL NOT NULL,
    "orp_alert_max" INTEGER NOT NULL,
    "orp_alert_min" INTEGER NOT NULL,
    "ph_alert_max" INTEGER NOT NULL,
    "ph_alert_min" DOUBLE PRECISION NOT NULL,
    "conductivity_alert_max" INTEGER NOT NULL,
    "tds_alert_max" INTEGER NOT NULL,
    "do_above_20_alert_min" DOUBLE PRECISION NOT NULL,
    "do_below_20_alert_min" DOUBLE PRECISION NOT NULL,
    "salinity_alert_max" DOUBLE PRECISION NOT NULL,
    "outflow_1_alert_max" DOUBLE PRECISION NOT NULL,
    "outflow_2_alert_max" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "SensorThreshold_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Units" (
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

    CONSTRAINT "Units_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Shape" (
    "id" SERIAL NOT NULL,
    "type" TEXT,
    "property_id" INTEGER,
    "geometry_id" INTEGER,

    CONSTRAINT "Shape_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Properties" (
    "id" SERIAL NOT NULL,
    "fid" INTEGER,
    "object_id" INTEGER,
    "name" TEXT,
    "classifica" TEXT,
    "shape_leng" DOUBLE PRECISION,
    "shape_area" DOUBLE PRECISION,
    "shape__area" DOUBLE PRECISION,
    "shape__length" DOUBLE PRECISION,

    CONSTRAINT "Properties_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Geometry" (
    "id" SERIAL NOT NULL,
    "type" TEXT,
    "coordinates" INTEGER[],

    CONSTRAINT "Geometry_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Points" (
    "id" SERIAL NOT NULL,
    "active" BOOLEAN,

    CONSTRAINT "Points_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Features" (
    "id" SERIAL NOT NULL,
    "point_id" INTEGER,
    "name" TEXT,
    "value" INTEGER,
    "uuid" INTEGER,
    "cords" INTEGER[],

    CONSTRAINT "Features_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "WaterLevel_pond_id_key" ON "WaterLevel"("pond_id");

-- CreateIndex
CREATE UNIQUE INDEX "Shape_property_id_key" ON "Shape"("property_id");

-- CreateIndex
CREATE UNIQUE INDEX "Shape_geometry_id_key" ON "Shape"("geometry_id");

-- CreateIndex
CREATE UNIQUE INDEX "Features_point_id_key" ON "Features"("point_id");

-- CreateIndex
CREATE UNIQUE INDEX "Features_uuid_key" ON "Features"("uuid");

-- CreateIndex
CREATE UNIQUE INDEX "Alert_uuid_key" ON "Alert"("uuid");

-- CreateIndex
CREATE UNIQUE INDEX "AlertResponse_uuid_key" ON "AlertResponse"("uuid");

-- CreateIndex
CREATE UNIQUE INDEX "Area_uuid_key" ON "Area"("uuid");

-- CreateIndex
CREATE UNIQUE INDEX "EnvironmentAnalysis_uuid_key" ON "EnvironmentAnalysis"("uuid");

-- CreateIndex
CREATE UNIQUE INDEX "FSM_uuid_key" ON "FSM"("uuid");

-- CreateIndex
CREATE UNIQUE INDEX "ModelMapping_uuid_key" ON "ModelMapping"("uuid");

-- CreateIndex
CREATE UNIQUE INDEX "Pond_uuid_key" ON "Pond"("uuid");

-- CreateIndex
CREATE UNIQUE INDEX "Pond_shape_id_key" ON "Pond"("shape_id");

-- CreateIndex
CREATE UNIQUE INDEX "Pond_points_id_key" ON "Pond"("points_id");

-- CreateIndex
CREATE UNIQUE INDEX "Record_uuid_key" ON "Record"("uuid");

-- CreateIndex
CREATE UNIQUE INDEX "Sensor_uuid_key" ON "Sensor"("uuid");

-- CreateIndex
CREATE UNIQUE INDEX "Sensor_threshold_id_key" ON "Sensor"("threshold_id");

-- CreateIndex
CREATE UNIQUE INDEX "User_uuid_key" ON "User"("uuid");

-- AddForeignKey
ALTER TABLE "Pond" ADD CONSTRAINT "Pond_shape_id_fkey" FOREIGN KEY ("shape_id") REFERENCES "Shape"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Pond" ADD CONSTRAINT "Pond_points_id_fkey" FOREIGN KEY ("points_id") REFERENCES "Points"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WaterLevel" ADD CONSTRAINT "WaterLevel_pond_id_fkey" FOREIGN KEY ("pond_id") REFERENCES "Pond"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Sensor" ADD CONSTRAINT "Sensor_threshold_id_fkey" FOREIGN KEY ("threshold_id") REFERENCES "SensorThreshold"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Shape" ADD CONSTRAINT "Shape_property_id_fkey" FOREIGN KEY ("property_id") REFERENCES "Properties"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Shape" ADD CONSTRAINT "Shape_geometry_id_fkey" FOREIGN KEY ("geometry_id") REFERENCES "Geometry"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Features" ADD CONSTRAINT "Features_point_id_fkey" FOREIGN KEY ("point_id") REFERENCES "Points"("id") ON DELETE SET NULL ON UPDATE CASCADE;
