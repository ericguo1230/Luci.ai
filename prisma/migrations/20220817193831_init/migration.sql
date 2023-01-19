/*
  Warnings:

  - The `update_time` column on the `Record` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- AlterTable
ALTER TABLE "Record" DROP COLUMN "update_time",
ADD COLUMN     "update_time" TIMESTAMP(3);
