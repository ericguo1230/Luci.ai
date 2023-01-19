/*
  Warnings:

  - A unique constraint covering the columns `[point_id]` on the table `Features` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[uuid]` on the table `Features` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[pond_id]` on the table `WaterLevel` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "Features_point_id_key" ON "Features"("point_id");

-- CreateIndex
CREATE UNIQUE INDEX "Features_uuid_key" ON "Features"("uuid");

-- CreateIndex
CREATE UNIQUE INDEX "WaterLevel_pond_id_key" ON "WaterLevel"("pond_id");
