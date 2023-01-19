-- DropForeignKey
ALTER TABLE "Alert" DROP CONSTRAINT "Alert_record_id_fkey";

-- AlterTable
ALTER TABLE "Alert" ALTER COLUMN "record_id" DROP NOT NULL,
ALTER COLUMN "record_uuid" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Alert" ADD CONSTRAINT "Alert_record_id_fkey" FOREIGN KEY ("record_id") REFERENCES "Record"("id") ON DELETE SET NULL ON UPDATE CASCADE;
