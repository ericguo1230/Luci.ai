/*
  Warnings:

  - You are about to drop the column `coord_one` on the `CoordTwo` table. All the data in the column will be lost.
  - You are about to drop the column `coord_two` on the `CoordTwo` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "CoordTwo" DROP COLUMN "coord_one",
DROP COLUMN "coord_two";

-- CreateTable
CREATE TABLE "CoordThree" (
    "id" SERIAL NOT NULL,
    "coord_id" INTEGER,
    "coord_one" DOUBLE PRECISION,
    "coord_two" DOUBLE PRECISION,

    CONSTRAINT "CoordThree_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "CoordThree" ADD CONSTRAINT "CoordThree_coord_id_fkey" FOREIGN KEY ("coord_id") REFERENCES "CoordTwo"("id") ON DELETE SET NULL ON UPDATE CASCADE;
