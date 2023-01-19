-- AlterTable
ALTER TABLE "AirRecords" ADD COLUMN     "sensor_id" INTEGER;

-- AddForeignKey
ALTER TABLE "AirRecords" ADD CONSTRAINT "AirRecords_sensor_id_fkey" FOREIGN KEY ("sensor_id") REFERENCES "Sensor"("id") ON DELETE SET NULL ON UPDATE CASCADE;
