-- AlterTable
ALTER TABLE "Record" ADD COLUMN     "cable" DOUBLE PRECISION,
ADD COLUMN     "hdop" DOUBLE PRECISION,
ADD COLUMN     "voltage" DOUBLE PRECISION;

-- AlterTable
ALTER TABLE "SensorThreshold" ALTER COLUMN "orp_alert_max" DROP NOT NULL,
ALTER COLUMN "orp_alert_min" DROP NOT NULL,
ALTER COLUMN "ph_alert_max" DROP NOT NULL,
ALTER COLUMN "ph_alert_min" DROP NOT NULL,
ALTER COLUMN "conductivity_alert_max" DROP NOT NULL,
ALTER COLUMN "tds_alert_max" DROP NOT NULL,
ALTER COLUMN "do_above_20_alert_min" DROP NOT NULL,
ALTER COLUMN "do_below_20_alert_min" DROP NOT NULL,
ALTER COLUMN "salinity_alert_max" DROP NOT NULL,
ALTER COLUMN "outflow_1_alert_max" DROP NOT NULL,
ALTER COLUMN "outflow_2_alert_max" DROP NOT NULL;
