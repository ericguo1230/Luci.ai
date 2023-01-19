-- AlterTable
ALTER TABLE "Record" ADD COLUMN     "sensor_id" INTEGER;

-- AddForeignKey
ALTER TABLE "Record" ADD CONSTRAINT "Record_sensor_id_fkey" FOREIGN KEY ("sensor_id") REFERENCES "Sensor"("id") ON DELETE SET NULL ON UPDATE CASCADE;
