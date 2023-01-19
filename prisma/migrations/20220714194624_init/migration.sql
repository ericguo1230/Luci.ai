/*
  Warnings:

  - You are about to drop the column `cords` on the `Features` table. All the data in the column will be lost.
  - You are about to drop the column `active` on the `Points` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Features" DROP COLUMN "cords",
ADD COLUMN     "coords" INTEGER[];

-- AlterTable
ALTER TABLE "Points" DROP COLUMN "active";

-- AlterTable
ALTER TABLE "Pond" ADD COLUMN     "active" BOOLEAN;
