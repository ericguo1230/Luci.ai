/*
  Warnings:

  - You are about to drop the column `uuid` on the `Record` table. All the data in the column will be lost.

*/
-- DropIndex
DROP INDEX "Record_uuid_key";

-- AlterTable
ALTER TABLE "Record" DROP COLUMN "uuid",
ADD COLUMN     "hourly" BOOLEAN,
ADD COLUMN     "update_time" TEXT;
