/*
  Warnings:

  - The `update` column on the `Sensor` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- AlterTable
ALTER TABLE "Sensor" DROP COLUMN "update",
ADD COLUMN     "update" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP;
