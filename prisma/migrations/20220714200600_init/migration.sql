/*
  Warnings:

  - You are about to drop the column `coord_one` on the `CoordThree` table. All the data in the column will be lost.
  - You are about to drop the column `coord_two` on the `CoordThree` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "CoordThree" DROP COLUMN "coord_one",
DROP COLUMN "coord_two",
ADD COLUMN     "coords" DOUBLE PRECISION[];
