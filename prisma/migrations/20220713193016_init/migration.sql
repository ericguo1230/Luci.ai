/*
  Warnings:

  - You are about to drop the column `environment_analysis_id` on the `Pond` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[pond_id]` on the table `EnvironmentAnalysis` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE "Pond" DROP CONSTRAINT "Pond_environment_analysis_id_fkey";

-- DropIndex
DROP INDEX "Pond_environment_analysis_id_key";

-- AlterTable
ALTER TABLE "EnvironmentAnalysis" ADD COLUMN     "pond_id" INTEGER;

-- AlterTable
ALTER TABLE "Pond" DROP COLUMN "environment_analysis_id";

-- CreateIndex
CREATE UNIQUE INDEX "EnvironmentAnalysis_pond_id_key" ON "EnvironmentAnalysis"("pond_id");

-- AddForeignKey
ALTER TABLE "EnvironmentAnalysis" ADD CONSTRAINT "EnvironmentAnalysis_pond_id_fkey" FOREIGN KEY ("pond_id") REFERENCES "Pond"("id") ON DELETE SET NULL ON UPDATE CASCADE;
