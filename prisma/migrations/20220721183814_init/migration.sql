/*
  Warnings:

  - A unique constraint covering the columns `[uuid]` on the table `Record` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `uuid` to the `Record` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Record" ADD COLUMN     "uuid" TEXT NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "Record_uuid_key" ON "Record"("uuid");
