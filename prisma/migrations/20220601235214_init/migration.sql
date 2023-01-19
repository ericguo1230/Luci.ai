-- CreateTable
CREATE TABLE "Area" (
    "id" SERIAL NOT NULL,
    "name" TEXT,
    "creation" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" INTEGER,

    CONSTRAINT "Area_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Pond" (
    "id" SERIAL NOT NULL,
    "government" TEXT,
    "area_id" INTEGER,
    "environment_analysis_id" INTEGER,
    "points" INTEGER[],
    "status" INTEGER,

    CONSTRAINT "Pond_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Sensor" (
    "id" SERIAL NOT NULL,
    "pond_id" INTEGER NOT NULL,
    "environment_analysis_id" INTEGER NOT NULL,

    CONSTRAINT "Sensor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Record" (
    "id" BIGSERIAL NOT NULL,
    "sensor_id" INTEGER NOT NULL,
    "creation" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "orp" DOUBLE PRECISION,
    "ph" DOUBLE PRECISION,
    "turbidity" DOUBLE PRECISION,
    "conductivity" DOUBLE PRECISION,
    "depth" DOUBLE PRECISION,
    "salinity" DOUBLE PRECISION,
    "temp" DOUBLE PRECISION,
    "tds" DOUBLE PRECISION,
    "tss" DOUBLE PRECISION,
    "dissolved_oxygen" DOUBLE PRECISION,

    CONSTRAINT "Record_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Threshold" (
    "id" SERIAL NOT NULL,
    "min" INTEGER,
    "max" INTEGER,

    CONSTRAINT "Threshold_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Alert" (
    "id" SERIAL NOT NULL,
    "sensor_id" INTEGER NOT NULL,
    "pond_id" INTEGER,
    "record_id" BIGINT NOT NULL,
    "creation" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "type" TEXT,
    "value" INTEGER,
    "unit" TEXT,
    "level" INTEGER,
    "status" INTEGER,
    "threshold_id" INTEGER,
    "history" TEXT[],
    "email_notification" BOOLEAN,
    "timestamp" TIMESTAMP(3) NOT NULL,
    "block_rate" INTEGER,

    CONSTRAINT "Alert_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AlertResponse" (
    "id" SERIAL NOT NULL,
    "operator_id" INTEGER,
    "timestamp" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "status" INTEGER,
    "comment" TEXT,
    "resolved" BOOLEAN,
    "alert_id" INTEGER,

    CONSTRAINT "AlertResponse_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "username" TEXT,
    "display_name" TEXT,
    "aid" INTEGER,
    "status" BOOLEAN,
    "creation" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "password" TEXT,
    "role" TEXT[],

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UsersID" (
    "user_id" INTEGER NOT NULL,

    CONSTRAINT "UsersID_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "EnvironmentAnalysis" (
    "id" SERIAL NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL,
    "depth_id" INTEGER,
    "ph_id" INTEGER,
    "ec_id" INTEGER,
    "tds_id" INTEGER,
    "orp_id" INTEGER,
    "do_id" INTEGER,
    "turbidity_id" INTEGER,
    "tss_id" INTEGER,
    "rainfall_id" INTEGER,
    "salinity_id" INTEGER,

    CONSTRAINT "EnvironmentAnalysis_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EnvironmentStatus" (
    "id" SERIAL NOT NULL,
    "value" DOUBLE PRECISION,
    "orp_ph7" DOUBLE PRECISION,
    "failed" DOUBLE PRECISION,
    "category" TEXT,
    "block_rate" DOUBLE PRECISION,

    CONSTRAINT "EnvironmentStatus_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FSM" (
    "id" SERIAL NOT NULL,
    "pond_id" INTEGER,
    "ph_machine_id" INTEGER,
    "ec_machine_id" INTEGER,
    "tds_machine_id" INTEGER,
    "orp_machine_id" INTEGER,
    "do_machine_id" INTEGER,
    "turbidity_machine_id" INTEGER,
    "salinity_machine_id" INTEGER,

    CONSTRAINT "FSM_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "machine" (
    "id" SERIAL NOT NULL,
    "value" TEXT NOT NULL,
    "transition" VARCHAR(2048) NOT NULL,

    CONSTRAINT "machine_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ModelMapping" (
    "id" SERIAL NOT NULL,
    "model" INTEGER NOT NULL,
    "sensor" INTEGER NOT NULL,
    "air" INTEGER NOT NULL,
    "pond" INTEGER NOT NULL,

    CONSTRAINT "ModelMapping_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Pond_environment_analysis_id_key" ON "Pond"("environment_analysis_id");

-- CreateIndex
CREATE UNIQUE INDEX "AlertResponse_operator_id_key" ON "AlertResponse"("operator_id");

-- CreateIndex
CREATE UNIQUE INDEX "EnvironmentAnalysis_depth_id_key" ON "EnvironmentAnalysis"("depth_id");

-- CreateIndex
CREATE UNIQUE INDEX "EnvironmentAnalysis_ph_id_key" ON "EnvironmentAnalysis"("ph_id");

-- CreateIndex
CREATE UNIQUE INDEX "EnvironmentAnalysis_ec_id_key" ON "EnvironmentAnalysis"("ec_id");

-- CreateIndex
CREATE UNIQUE INDEX "EnvironmentAnalysis_tds_id_key" ON "EnvironmentAnalysis"("tds_id");

-- CreateIndex
CREATE UNIQUE INDEX "EnvironmentAnalysis_orp_id_key" ON "EnvironmentAnalysis"("orp_id");

-- CreateIndex
CREATE UNIQUE INDEX "EnvironmentAnalysis_do_id_key" ON "EnvironmentAnalysis"("do_id");

-- CreateIndex
CREATE UNIQUE INDEX "EnvironmentAnalysis_turbidity_id_key" ON "EnvironmentAnalysis"("turbidity_id");

-- CreateIndex
CREATE UNIQUE INDEX "EnvironmentAnalysis_tss_id_key" ON "EnvironmentAnalysis"("tss_id");

-- CreateIndex
CREATE UNIQUE INDEX "EnvironmentAnalysis_rainfall_id_key" ON "EnvironmentAnalysis"("rainfall_id");

-- CreateIndex
CREATE UNIQUE INDEX "EnvironmentAnalysis_salinity_id_key" ON "EnvironmentAnalysis"("salinity_id");

-- CreateIndex
CREATE UNIQUE INDEX "FSM_pond_id_key" ON "FSM"("pond_id");

-- CreateIndex
CREATE UNIQUE INDEX "FSM_ph_machine_id_key" ON "FSM"("ph_machine_id");

-- CreateIndex
CREATE UNIQUE INDEX "FSM_ec_machine_id_key" ON "FSM"("ec_machine_id");

-- CreateIndex
CREATE UNIQUE INDEX "FSM_tds_machine_id_key" ON "FSM"("tds_machine_id");

-- CreateIndex
CREATE UNIQUE INDEX "FSM_orp_machine_id_key" ON "FSM"("orp_machine_id");

-- CreateIndex
CREATE UNIQUE INDEX "FSM_do_machine_id_key" ON "FSM"("do_machine_id");

-- CreateIndex
CREATE UNIQUE INDEX "FSM_turbidity_machine_id_key" ON "FSM"("turbidity_machine_id");

-- CreateIndex
CREATE UNIQUE INDEX "FSM_salinity_machine_id_key" ON "FSM"("salinity_machine_id");

-- AddForeignKey
ALTER TABLE "Pond" ADD CONSTRAINT "Pond_area_id_fkey" FOREIGN KEY ("area_id") REFERENCES "Area"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Pond" ADD CONSTRAINT "Pond_environment_analysis_id_fkey" FOREIGN KEY ("environment_analysis_id") REFERENCES "EnvironmentAnalysis"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Sensor" ADD CONSTRAINT "Sensor_pond_id_fkey" FOREIGN KEY ("pond_id") REFERENCES "Pond"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Sensor" ADD CONSTRAINT "Sensor_environment_analysis_id_fkey" FOREIGN KEY ("environment_analysis_id") REFERENCES "EnvironmentAnalysis"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Record" ADD CONSTRAINT "Record_sensor_id_fkey" FOREIGN KEY ("sensor_id") REFERENCES "Sensor"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Alert" ADD CONSTRAINT "Alert_pond_id_fkey" FOREIGN KEY ("pond_id") REFERENCES "Pond"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Alert" ADD CONSTRAINT "Alert_sensor_id_fkey" FOREIGN KEY ("sensor_id") REFERENCES "Sensor"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Alert" ADD CONSTRAINT "Alert_record_id_fkey" FOREIGN KEY ("record_id") REFERENCES "Record"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Alert" ADD CONSTRAINT "Alert_threshold_id_fkey" FOREIGN KEY ("threshold_id") REFERENCES "Threshold"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AlertResponse" ADD CONSTRAINT "AlertResponse_alert_id_fkey" FOREIGN KEY ("alert_id") REFERENCES "Alert"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AlertResponse" ADD CONSTRAINT "AlertResponse_operator_id_fkey" FOREIGN KEY ("operator_id") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_aid_fkey" FOREIGN KEY ("aid") REFERENCES "Area"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UsersID" ADD CONSTRAINT "UsersID_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EnvironmentAnalysis" ADD CONSTRAINT "EnvironmentAnalysis_depth_id_fkey" FOREIGN KEY ("depth_id") REFERENCES "EnvironmentStatus"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EnvironmentAnalysis" ADD CONSTRAINT "EnvironmentAnalysis_ph_id_fkey" FOREIGN KEY ("ph_id") REFERENCES "EnvironmentStatus"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EnvironmentAnalysis" ADD CONSTRAINT "EnvironmentAnalysis_ec_id_fkey" FOREIGN KEY ("ec_id") REFERENCES "EnvironmentStatus"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EnvironmentAnalysis" ADD CONSTRAINT "EnvironmentAnalysis_tds_id_fkey" FOREIGN KEY ("tds_id") REFERENCES "EnvironmentStatus"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EnvironmentAnalysis" ADD CONSTRAINT "EnvironmentAnalysis_orp_id_fkey" FOREIGN KEY ("orp_id") REFERENCES "EnvironmentStatus"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EnvironmentAnalysis" ADD CONSTRAINT "EnvironmentAnalysis_do_id_fkey" FOREIGN KEY ("do_id") REFERENCES "EnvironmentStatus"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EnvironmentAnalysis" ADD CONSTRAINT "EnvironmentAnalysis_turbidity_id_fkey" FOREIGN KEY ("turbidity_id") REFERENCES "EnvironmentStatus"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EnvironmentAnalysis" ADD CONSTRAINT "EnvironmentAnalysis_tss_id_fkey" FOREIGN KEY ("tss_id") REFERENCES "EnvironmentStatus"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EnvironmentAnalysis" ADD CONSTRAINT "EnvironmentAnalysis_rainfall_id_fkey" FOREIGN KEY ("rainfall_id") REFERENCES "EnvironmentStatus"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EnvironmentAnalysis" ADD CONSTRAINT "EnvironmentAnalysis_salinity_id_fkey" FOREIGN KEY ("salinity_id") REFERENCES "EnvironmentStatus"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FSM" ADD CONSTRAINT "FSM_pond_id_fkey" FOREIGN KEY ("pond_id") REFERENCES "Pond"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FSM" ADD CONSTRAINT "FSM_ph_machine_id_fkey" FOREIGN KEY ("ph_machine_id") REFERENCES "machine"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FSM" ADD CONSTRAINT "FSM_ec_machine_id_fkey" FOREIGN KEY ("ec_machine_id") REFERENCES "machine"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FSM" ADD CONSTRAINT "FSM_tds_machine_id_fkey" FOREIGN KEY ("tds_machine_id") REFERENCES "machine"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FSM" ADD CONSTRAINT "FSM_orp_machine_id_fkey" FOREIGN KEY ("orp_machine_id") REFERENCES "machine"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FSM" ADD CONSTRAINT "FSM_do_machine_id_fkey" FOREIGN KEY ("do_machine_id") REFERENCES "machine"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FSM" ADD CONSTRAINT "FSM_turbidity_machine_id_fkey" FOREIGN KEY ("turbidity_machine_id") REFERENCES "machine"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FSM" ADD CONSTRAINT "FSM_salinity_machine_id_fkey" FOREIGN KEY ("salinity_machine_id") REFERENCES "machine"("id") ON DELETE SET NULL ON UPDATE CASCADE;
