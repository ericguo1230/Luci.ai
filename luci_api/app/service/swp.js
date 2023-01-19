const axios = require('axios');
const moment = require('moment-timezone');

const categories = [
    { uuid: 'temp', label: 'Water Temperature' },
    { uuid: 'ph', label: 'PH' },
    { uuid: 'depth', label: 'Depth' },
    { uuid: 'orp', label: 'ORP' },
    { uuid: 'dissolvedoxygen', label: 'Dissolved Oxygen' },
    { uuid: 'conductivity', label: 'Conductivity' },
    { uuid: 'turbidity', label: 'Turbidity' },
    { uuid: 'tds', label: 'TDS' },
    { uuid: 'tss', label: 'TSS' },
    { uuid: 'salinity', label: 'Salinity' },
  ];

const airCategories = [
    { uuid: 'airtemperature', label: 'Air Temperature' },
    { uuid: 'humidity', label: 'Humidity' },
    { uuid: 'pressure', label: 'Air Pressure' },
    { uuid: 'rain', label: 'Rain' },
  ];

const onlineTimeLimit = 1000 * 60 * 60 * 1.5;

const Service = require('egg').Service;
const {PrismaClient, Prisma} = require('@prisma/client')
const prisma = new PrismaClient();

class SWP extends Service{
    async getSWPReportOptions(area){
        if (!area) return [];
        const response = {ponds: [], indicators: []};
        response.ponds.push(await prisma.Pond.findMany({
            where:{
            area_uuid: area
        },
        select: {
            uuid: true,
            name_id: true,
            name: true
        }
        }));
        response.indicators = categories;
        response.indicatorsAll = categories.concat(airCategories);
        return response
    }

    async getPondsLatestRecord(area){
        const data = []
        var sensors = []
        if (!area) return ['Error'];
        const onlineTime = new Date().valueOf() - onlineTimeLimit;
        const ponds = await prisma.Pond.findMany({
            where:{
                area_uuid: area,
            },
            select:{
                id: true,
                name_id: true,
            }
        })
        for (const items in ponds){
            const element = ponds[items]
            const sen = await prisma.Sensor.findMany({
                where: {
                    pond_id: element.id
                },
                select:{
                    id: true,
                    values_id: true,
                    unit_id: true,
                    threshold_id: true,
                    uuid: true,
                    update:true,
                }
            })
            sensors = sensors.concat(sen);
        }
        for (const items in sensors){
            const element = sensors[items];
            let time = element.update.valueOf();
            const online = time > onlineTime;
            let records = await prisma.Record.findUnique({
                where: {
                    id: element.values_id,
                },
                select:{
                    depth: true,
                    ph: true,
                    orp: true,
                    dissolved_oxygen: true,
                    conductivity: true,
                    tds: true,
                    turbidity: true,
                    tss: true,
                    temp: true,
                    salinity: true,
                    voltage: true,
                    cable: true,
                    hdop: true,
                    bgm: true,
                    phmv: true,
                    update_time: true,
                }
            })
            const units = await prisma.Unit.findUnique({
                where:{
                    id: element.unit_id,
                },
            })
            const thresholds = await prisma.SensorThreshold.findUnique({
                where:{
                    id: element.threshold_id,
                }
            })
            const pond = await prisma.Pond.findFirst({
                where:{
                    id: element.pond_id
                },
                select:{
                    name_id: true,
                },
                orderBy:{
                    id: "desc"
                }
            })
            const dayStart = moment.tz('America/Toronto').startOf('day').valueOf();
            const { ctx } = this;
            let previous24hR = {};
            const dayInfo = await ctx.service.water.getWaterRecordsByTimeRange(dayStart - 86400000 * 2, dayStart);
            for (const record of dayInfo) {
                record.sensor = record.sensor_uuid.replace('water_', '');
                record.creation = parseInt(record.update_time);
                const daystartLatest = new Date(record.creation).setHours(0, 0, 0, 0);
                if (record.sensor !== records.sensor || record.creation > (daystartLatest + 86400000) || record.creation < daystartLatest - 86400000 * 2) continue;
                const timeC = Math.abs(record.creation - (start - 86400000));
                if (!previous24hR.timeC || (previous24hR.timeC && timeC < previous24hR.timeC)) {
                  record.timeC = timeC;
                  previous24hR = record;
                }
            }
            let orpDOD = (records.orp || records.orp === 0) || (previous24hR.orp || previous24hR.orp === 0) ? parseFloat((records.orp - previous24hR.orp).toFixed(2)) : null;
            let phDOD = (records.ph || records.ph === 0) || (previous24hR.ph || previous24hR.ph === 0) ? parseFloat((records.ph - previous24hR.ph).toFixed(2)) : null;
            let turbidityDOD = (records.turbidity || records.turbidity === 0) || (previous24hR.turbidity || previous24hR.turbidity === 0) ? parseFloat((records.turbidity - previous24hR.turbidity).toFixed(2)) : null;
            let conductivityDOD = (records.conductivity || records.conductivity === 0) || (previous24hR.conductivity || previous24hR.conductivity === 0) ? parseFloat((records.conductivity - previous24hR.conductivity).toFixed(2)) : null;
            let depthDOD = (records.depth || records.depth === 0) || (previous24hR.depth || previous24hR.depth === 0) ? parseFloat((records.depth - previous24hR.depth).toFixed(2)) : null;
            let salinityDOD = (records.salinity || records.salinity === 0) || (previous24hR.salinity || previous24hR.salinity === 0) ? parseFloat((records.salinity - previous24hR.salinity).toFixed(2)) : null;
            let tempDOD = (records.temp || records.temp === 0) || (previous24hR.temp || previous24hR.temp === 0) ? parseFloat((records.temp - previous24hR.temp).toFixed(2)) : null;
            let tdsDOD = (records.tds || records.tds === 0) || (previous24hR.tds || previous24hR.tds === 0) ? parseFloat((records.tds - previous24hR.tds).toFixed(2)) : null;
            let tssDOD = (records.tss || records.tss === 0) || (previous24hR.tss || previous24hR.tss === 0) ? parseFloat((records.tss - previous24hR.tss).toFixed(2)) : null;
            let dissolvedoxygenDOD = (records.dissolvedoxygen || records.dissolvedoxygen === 0) || (previous24hR.dissolvedoxygen || previous24hR.dissolvedoxygen === 0) ? parseFloat((records.dissolvedoxygen - previous24hR.dissolvedoxygen).toFixed(2)) : null;
            
            const response = {
                depth: records.depth,
                ph: records.ph,
                orp: records.orp,
                dissolvedoxygen: records.dissolvedoxygen,
                conductivity: records.conductivity,
                tds: records.tds,
                turbidity: records.turbidity,
                tss: records.tss,
                temp: records.temp,
                salinity: records.salinity,
                voltage: records.voltage,
                cable: records.cable,
                hdop: records.hdop,
                bgm: records.bgm,
                phmv: records.phmv,
                latestTime: element.update,
                id: pond.name_id,
                thresholds,
                sensor: element.uuid,
                units: units,
                online: online,
                orpDOD: orpDOD,
                phDOD: phDOD,
                turbidityDOD: turbidityDOD,
                conductivityDOD: conductivityDOD,
                depthDOD: depthDOD,
                salinityDOD: salinityDOD,
                tempDOD: tempDOD,
                tdsDOD: tdsDOD,
                tssDOD: tssDOD,
                dissolvedoxygenDOD: dissolvedoxygenDOD,
            }
            data.push(response);
        }
        return data;
    }

    async getDepthData(area){

    }

    async getPondAlertStatus(area){
        let data = [];
        if (!area) return [];
        const ponds = await prisma.Pond.findMany({
            where:{
                area_uuid: area,
            }
        })
        for (const item of ponds){
            const { ctx } = this;
            const response_shape = await ctx.service.water.getPondObjects(item);
            let alert = await prisma.Alert.findMany({
                where: {
                    pond_id: item.id,
                }
            })
            //latest_alerts
            const maxDate = new Date(
                Math.max(
                  ...alert.map(element => {
                    return new Date(element.creation);
                  }),
                ),
            );
            const latest_alert = await prisma.Alert.findMany({
                where:{
                    creation: maxDate,
                },
            })
            let status = 1
            let response_latest_alert = []
            for (const item of latest_alert){
                const type2 = categories.find(e => e.label === item.type);
                const threshold = await prisma.Threshold.findFirst({
                    where:{
                        id: item.threshold_id,
                    }
                })
                let alertDetails = {
                    creation: item.creation.valueOf(),
                    id: item.name_id,
                    metric: item.type,
                    sensor: item.sensor_uuid,
                    unit: item.unit,
                    value: item.value,
                    metricID: type2.uuid,
                };
                if (threshold.max) alertDetails[type2.uuid + 'AlertMax'] = threshold.max;
                if (threshold.min) alertDetails[type2.uuid + 'AlertMin'] = threshold.min;
                response_latest_alert.push(alertDetails);
                if (item.level > status){
                    status = item.level;
                }
            }
            let response = {
                shape: response_shape,
                uuid: item.uuid,
                id: item.name_id,
                name: item.name,
                alerts: latest_alert.length,
                alertDetails: response_latest_alert,
                status: status
            }
            const onlineTime = new Date().valueOf() - onlineTimeLimit;
            const sensors = await prisma.Sensor.findMany({
                where:{
                    pond_id: item.id,
                }
            })
            for (const item of sensors){
                response.active = item.update.valueOf() >= onlineTime;
                response.valid = item.update.valueOf() > item.creation.valueOf();
            }
            data.push(response);
        }
        return data;
    }

    async getPondInfoById(pond){
        if (!pond) return [];
        const ponds = await prisma.Pond.findUnique({
            where:{
                uuid: pond
            }
        })
        const area = await prisma.Area.findFirst({
            where:{
                uuid: pond.area_uuid,
            }
        })
        const waterLevel = await prisma.WaterLevel.findMany({
            where:{
                pond_id: ponds.id
            },
            select:{
                type: true,
                value: true,
            }
        })
        const sensors = await prisma.Sensor.findMany({
            where:{
                pond_id: ponds.id,
            }
        })
        const { ctx } = this;
        const response_shape = await ctx.service.water.getPondObjects(ponds);
        let response = {
            shape: response_shape,
            uuid: pond.uuid,
            id: pond.name_id,
            name: pond.name,
            aid: pond.area_uuid,
            area: area.name,
            waterLevel: waterLevel,
            seaOffset: sensors.map(e => e.seaOffset),
        }
        return response;
    }

    async getPoints(pond){
        const ponds = await prisma.Pond.findUnique({
            where:{
                uuid: pond,
            }
        })
        const points = await prisma.Features.findMany({
            where: {
                point_id: ponds.points_id,
            },
            select:{
                name: true,
                value: true,
                uuid: true,
                coords: true,
            }
        })
        return points
    }

    async getAllByTimeRange(range, pondUUID, types){
        const {ctx, app} = this;
        if (!range || !range.start || !range.end || !range.granularity) return;
        if (!types || !types.length) types = categories.concat(airCategories).map(e => e.uuid);

        const start = range.start;
        const granularity = range.granilarity
        const end = range.end > new Date().valueOf() ? new Date().valueOf() : range.end;

        const pond = await prisma.Pond.findUnique({
            where:{
                uuid: pondUUID,
            }
        })

        const sensors = await prisma.Sensor.findFirst({
            where:{
                pond_id: pond.id,
            }
        })
        const thresholds = await prisma.SensorThreshold.findFirst({
            where: {
                id: sensors.threshold_id
            }
        })
        const units = await prisma.Unit.findFirst({
            where:{
                id: sensors.unit_id,
            }
        })
        const waterRecords = await ctx.service.water.getWaterRecordsByTimeAndSensor(start, end, pond.sensors_uuid, granularity === 'hourly');
        const airRecords = await ctx.service.water.getAirRecordByTimeAndSensor(start, end, pond.sensors_uuid);
        const aggregated = {};
        const average = arr => arr.reduce((p, c) => p + c, 0) / arr.length;

        let timeInterval = 1000 * 60 * 60;
        if (granularity === 'daily'){
            timeInterval = timeInterval * 24;
        }else if (granularity === 'weekly'){
            timeInterval = timeInterval * 24 * 7;
        }else if (granularity === 'monthly'){
            timeInterval = timeInterval * 24 * 7 * 30;
        }

        const xLabel = [];
        for (let i = start; i <= end; i = i + timeInterval) xLabel.push(i);

        for (const record of waterRecords){
            record.sensor = record.sensor_uuid.replace('water_', '');
            record.creation = parseInt(record.update_time);
            const day = (Math.floor((record.creation - start) / timeInterval)).toString();

            if (!aggregated[day]){
                aggregated[day] = {
                    airtemperature: [], pressure: [], humidity: [], rain: [], depth: [], salinity: [], ph: [], tds: [], tss: [], turbidity: [], conductivity: [], temp: [], orp: [], dissolvedoxygen: [],
                  };
            }
            aggregated[day].pond = pond.name;
            aggregated[day].pondID = pond.name_id;
            aggregated[day].pondUUID = pond.uuid;
            aggregated[day].day = day;
            aggregated[day].interval = start + timeInterval * parseInt(day);
            aggregated[day].date = record.creation;
            aggregated[day].ph.push(record.ph);
            aggregated[day].depth.push(record.depth);
            aggregated[day].salinity.push(record.salinity);
            aggregated[day].tds.push(record.tds);
            aggregated[day].tss.push(record.tss);
            aggregated[day].turbidity.push(record.turbidity);
            aggregated[day].conductivity.push(record.conductivity);
            aggregated[day].orp.push(record.orp);
            aggregated[day].temp.push(record.temp);
            aggregated[day].dissolvedoxygen.push(record.dissolved_oxygen);
        }

        const aggregated2 = {};
        for (const record of airRecords){
            record.sensor = record.sensor_uuid.replace('air_', '');
            record.creation = parseInt(record.update_time);
            const day = (Math.floor((record.creation - start) / timeInterval)).toString();
            if (!aggregated2[day]) {
                aggregated2[day] = {
                  airtemperature: [], pressure: [], humidity: [], rain: [],
                };
              }
            aggregated2[day].day = day;
            aggregated2[day].interval = start + timeInterval * parseInt(day);
            aggregated2[day].date = record.creation;
            aggregated2[day].airtemperature.push(record.temp);
            aggregated2[day].pressure.push(record.pressure);
            aggregated2[day].humidity.push(record.humidity);
            aggregated2[day].rain.push(record.rain);
        }
        const result = Object.values(aggregated);
        const result2 = Object.values(aggregated2);
        const valuesObj = { airtemperature: [], pressure: [], humidity: [], rain: [], depth: [], salinity: [], ph: [], tds: [], tss: [], turbidity: [], conductivity: [], temp: [], orp: [], dissolvedoxygen: [] };

        for (const item of result) {
            valuesObj.temp[parseInt(item.day)] = (average(item.temp)).toFixed(2);
            valuesObj.ph[parseInt(item.day)] = (average(item.ph)).toFixed(2);
            valuesObj.tss[parseInt(item.day)] = (average(item.tss)).toFixed(2);
            valuesObj.tds[parseInt(item.day)] = (average(item.tds)).toFixed(2);
            valuesObj.depth[parseInt(item.day)] = (average(item.depth)).toFixed(2);
            valuesObj.salinity[parseInt(item.day)] = (average(item.salinity)).toFixed(2);
            valuesObj.conductivity[parseInt(item.day)] = (average(item.conductivity)).toFixed(1);
            valuesObj.turbidity[parseInt(item.day)] = (average(item.turbidity)).toFixed(2);
            valuesObj.orp[parseInt(item.day)] = (average(item.orp)).toFixed(1);
            valuesObj.dissolvedoxygen[parseInt(item.day)] = (average(item.dissolvedoxygen)).toFixed(2);
        }

        for (const item of result2) {
            valuesObj.rain[parseInt(item.day)] = (average(item.rain)).toFixed(1);
            valuesObj.pressure[parseInt(item.day)] = (average(item.pressure)).toFixed(1);
            valuesObj.humidity[parseInt(item.day)] = (average(item.humidity)).toFixed(1);
            valuesObj.airtemperature[parseInt(item.day)] = (average(item.airtemperature)).toFixed(1);
        }

        const valuesArr = [];
        for (const type of types) valuesArr.push(valuesObj[type]);
        return { x: xLabel, y: valuesArr, values: valuesObj, thresholds: thresholds, units: units };
    }

    async getPondWeather(pondUUID){
        const {ctx, app} = this;
        const result = { temperature: '', humidity: '', pressure: '', rainfall: '' };
        if (!pondUUID) return result;
  
        const sensor = await prisma.WeatherSensor.findFirst({
            where:{
                pond_uuid: pondUUID
            }
        })
        const end = new Date().valueOf();
        const start = end - 1000 * 60 * 60 * 1;
        const device_id = 'air_' + sensor.uuid;
        const records = await ctx.service.water.getAirRecordByTimeAndID(start, end, device_id);
        let latest = records && records.length ? records[0] : {};
        for (const record of records) {
          if (record.update_time > latest.update_time) latest = record;
        }
  
        result.temperature = latest.temp ? latest.temp.toFixed(1).toString() + ' °C' : '';
        result.humidity = latest.humidity ? latest.humidity.toFixed(1).toString() + ' % RH' : '';
        result.pressure = latest.pressure ? latest.pressure.toFixed(1).toString() + ' hPa' : '';
        result.rainfall = latest.rain === 0 || latest.rain ? latest.rain.toFixed(1).toString() + ' mm' : '0 mm';
        if (!result.pressure) result.rainfall = '';
        return result;
    }
}
module.exports = SWP;