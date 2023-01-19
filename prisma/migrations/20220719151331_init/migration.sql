/*
  Warnings:

  - You are about to drop the column `aid` on the `User` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "User" DROP CONSTRAINT "User_aid_fkey";

-- AlterTable
ALTER TABLE "User" DROP COLUMN "aid";

-- CreateTable
CREATE TABLE "UsersInArea" (
    "area_id" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,

    CONSTRAINT "UsersInArea_pkey" PRIMARY KEY ("area_id","user_id")
);

-- AddForeignKey
ALTER TABLE "UsersInArea" ADD CONSTRAINT "UsersInArea_area_id_fkey" FOREIGN KEY ("area_id") REFERENCES "Area"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UsersInArea" ADD CONSTRAINT "UsersInArea_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
