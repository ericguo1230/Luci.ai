/*
  Warnings:

  - A unique constraint covering the columns `[uuid]` on the table `Pond` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "Pond_uuid_key" ON "Pond"("uuid");
