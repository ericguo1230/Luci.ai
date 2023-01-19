/*
  Warnings:

  - You are about to drop the column `coordinates` on the `Geometry` table. All the data in the column will be lost.
  - You are about to drop the `machine` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "FSM" DROP CONSTRAINT "FSM_do_machine_id_fkey";

-- DropForeignKey
ALTER TABLE "FSM" DROP CONSTRAINT "FSM_ec_machine_id_fkey";

-- DropForeignKey
ALTER TABLE "FSM" DROP CONSTRAINT "FSM_orp_machine_id_fkey";

-- DropForeignKey
ALTER TABLE "FSM" DROP CONSTRAINT "FSM_ph_machine_id_fkey";

-- DropForeignKey
ALTER TABLE "FSM" DROP CONSTRAINT "FSM_salinity_machine_id_fkey";

-- DropForeignKey
ALTER TABLE "FSM" DROP CONSTRAINT "FSM_tds_machine_id_fkey";

-- DropForeignKey
ALTER TABLE "FSM" DROP CONSTRAINT "FSM_turbidity_machine_id_fkey";

-- AlterTable
ALTER TABLE "Geometry" DROP COLUMN "coordinates";

-- DropTable
DROP TABLE "machine";

-- CreateTable
CREATE TABLE "Machine" (
    "id" SERIAL NOT NULL,
    "value" TEXT NOT NULL,
    "transition" VARCHAR(2048) NOT NULL,

    CONSTRAINT "Machine_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CoordOne" (
    "id" SERIAL NOT NULL,
    "geometry_id" INTEGER,

    CONSTRAINT "CoordOne_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CoordTwo" (
    "id" SERIAL NOT NULL,
    "coord_id" INTEGER,
    "coord_one" DOUBLE PRECISION,
    "coord_two" DOUBLE PRECISION,

    CONSTRAINT "CoordTwo_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "FSM" ADD CONSTRAINT "FSM_ph_machine_id_fkey" FOREIGN KEY ("ph_machine_id") REFERENCES "Machine"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FSM" ADD CONSTRAINT "FSM_ec_machine_id_fkey" FOREIGN KEY ("ec_machine_id") REFERENCES "Machine"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FSM" ADD CONSTRAINT "FSM_tds_machine_id_fkey" FOREIGN KEY ("tds_machine_id") REFERENCES "Machine"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FSM" ADD CONSTRAINT "FSM_orp_machine_id_fkey" FOREIGN KEY ("orp_machine_id") REFERENCES "Machine"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FSM" ADD CONSTRAINT "FSM_do_machine_id_fkey" FOREIGN KEY ("do_machine_id") REFERENCES "Machine"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FSM" ADD CONSTRAINT "FSM_turbidity_machine_id_fkey" FOREIGN KEY ("turbidity_machine_id") REFERENCES "Machine"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FSM" ADD CONSTRAINT "FSM_salinity_machine_id_fkey" FOREIGN KEY ("salinity_machine_id") REFERENCES "Machine"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CoordOne" ADD CONSTRAINT "CoordOne_geometry_id_fkey" FOREIGN KEY ("geometry_id") REFERENCES "Geometry"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CoordTwo" ADD CONSTRAINT "CoordTwo_coord_id_fkey" FOREIGN KEY ("coord_id") REFERENCES "CoordOne"("id") ON DELETE SET NULL ON UPDATE CASCADE;
