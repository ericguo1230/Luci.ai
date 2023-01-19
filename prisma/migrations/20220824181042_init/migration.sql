-- CreateTable
CREATE TABLE "WeatherSensor" (
    "id" SERIAL NOT NULL,
    "uuid" TEXT NOT NULL,
    "name" TEXT,
    "geo_id" INTEGER,
    "pond_uuid" TEXT,

    CONSTRAINT "WeatherSensor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Geo" (
    "id" SERIAL NOT NULL,
    "lat" DOUBLE PRECISION,
    "lng" DOUBLE PRECISION,

    CONSTRAINT "Geo_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "WeatherSensor_id_key" ON "WeatherSensor"("id");

-- CreateIndex
CREATE UNIQUE INDEX "WeatherSensor_uuid_key" ON "WeatherSensor"("uuid");

-- CreateIndex
CREATE UNIQUE INDEX "WeatherSensor_geo_id_key" ON "WeatherSensor"("geo_id");

-- CreateIndex
CREATE UNIQUE INDEX "Geo_id_key" ON "Geo"("id");

-- AddForeignKey
ALTER TABLE "WeatherSensor" ADD CONSTRAINT "WeatherSensor_geo_id_fkey" FOREIGN KEY ("geo_id") REFERENCES "Geo"("id") ON DELETE SET NULL ON UPDATE CASCADE;
