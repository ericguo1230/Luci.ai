-- CreateTable
CREATE TABLE "AirRecords" (
    "id" SERIAL NOT NULL,
    "sensor_uuid" TEXT,
    "created_at" TIMESTAMP(3),
    "update_time" TIMESTAMP(3),
    "sunrise_time" TIMESTAMP(3),
    "sunset_time" TIMESTAMP(3),
    "temp" DOUBLE PRECISION,
    "feels_like_temp" DOUBLE PRECISION,
    "pressure" DOUBLE PRECISION,
    "humidity" DOUBLE PRECISION,
    "dew_point_atmos_temp" DOUBLE PRECISION,
    "clouds" INTEGER,
    "uvi" INTEGER,
    "visibility" INTEGER,
    "wind_speed" DOUBLE PRECISION,
    "wind_gust" DOUBLE PRECISION,
    "wind_deg" DOUBLE PRECISION,
    "rain" DOUBLE PRECISION,
    "snow" DOUBLE PRECISION,

    CONSTRAINT "AirRecords_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "AirRecords_id_key" ON "AirRecords"("id");
