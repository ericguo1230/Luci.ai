const {PrismaClient, Prisma} = require('@prisma/client')
const MongoClient = require('mongodb').MongoClient;

var mongo = undefined;
const prisma = new PrismaClient();

async function update_sensor(){
    //relationships: pond_id
    const items = await prisma.Sensor.findMany();
    for (const item in items){
        const element = items[item];
        const id = await prisma.Pond.findUnique({
            where: {
                uuid: element.pond_uuid,
            },
            select: {id: true}
        })
        await prisma.Sensor.update({
            where: {
                uuid: element.uuid,
            },
            data: {
                pond_id: id.id
            }
        })
    }
    return 'done'
}

async function update_environmentanalysis(){
    //relationships: pond_id, sensor_id
    const items = await prisma.EnvironmentAnalysis.findMany();
    for (const item in items){
        const element = items[item];
        const id = await prisma.Pond.findUnique({
            where: {
                uuid: element.pond_uuid,
            },
            select: {id: true}
        })
        const sensor_id = await prisma.Sensor.findUnique({
            where: {
                uuid: element.sensor_uuid,
            },
            select: {id: true}
        })
        await prisma.EnvironmentAnalysis.update({
            where: {
                uuid: element.uuid,
            },
            data: {
                pond_id: id.id,
                sensor_id: sensor_id.id
            }
        })
    }
}

async function update_fsms(){
    //relationships: pond_id
    const items = await prisma.FSM.findMany();
    for (const item in items){
        const element = items[item];
        const id = await prisma.Pond.findUnique({
            where: {
                uuid: element.pond_uuid,
            },
            select: {id: true}
        })
        await prisma.FSM.update({
            where: {
                uuid: element.uuid,
            },
            data: {
                pond_id: id.id
            }
        })
    }
}

async function update_users(){
    //relationships: aid
    const items = await prisma.User.findMany();
    for (const item in items){
        const element = items[item];
        for (const j in element.aid_uuid){
            const i = element.aid_uuid[j];
            console.log(i);
            const id = await prisma.Area.findUnique({
                where: {
                    uuid: i,
                },
                select: {id: true}
            })
            await prisma.UsersInArea.create({
                data: {
                    area_id: id.id,
                    user_id: element.id
                }
            })
        }
    }
}

async function update_alerts(){
    //relationships: ponds, sensors
    const items = await prisma.Alert.findMany();
    for (const item in items){
        const element = items[item];
        const id = await prisma.Pond.findUnique({
            where: {
                uuid: element.pond_uuid,
            },
            select: {id: true}
        })
        const sensor_id = await prisma.Sensor.findUnique({
            where: {
                uuid: element.sensor_uuid,
            },
            select: {id: true}
        })
        await prisma.Alert.update({
            where: {
                uuid: element.uuid,
            },
            data: {
                pond_id: id.id,
                sensor_id: sensor_id.id
            }
        })
    }
}

async function update_ponds(){
    //relationships: area
    const items = await prisma.Pond.findMany();
    for (const item in items){
        const element = items[item];
        const id = await prisma.Area.findUnique({
            where: {
                uuid: element.area_uuid,
            },
            select: {id: true}
        })
        await prisma.Pond.update({
            where: {
                uuid: element.uuid,
            },
            data: {
                area_id: id.id
            }
        })   
    }
}

async function update_sensor_pond(){
    const items = await prisma.Sensor.findMany({});
    for (const item in items){
        const element = items[item];
        const pond = await prisma.Pond.findUnique({
            where: {
                uuid: element.pond_uuid,
            }
        })
        await prisma.Sensor.update({
            where: {
                id: element.id,
            },
            data: {
                pond_id: pond.id
            }
        })
    }
}

async function update_sensor(){
    const items = await prisma.Sensor.findMany({
        where:{
            sensor_uuid:{
                contains: "water"
            },
        }
    })
    for (const item in items){
        const element = items[item];
        const id = await prisma.Sensor.findUnique({
            where: {
                uuid: element.sensor_uuid.slice(6)
            },
            select: {id: true}
        })
        if (id != null){
            await prisma.Record.update({
                where: {
                    id: element.id
                },
                data:{
                    sensor_id: id.id
                }
            })
        }
    }
}

async function update_sensor_threshold(){
    await prisma.SensorThreshold.updateMany({
        data: {
            conductivity_alert_max: 3000,
        }
    })
}

// update_sensor_threshold();

const url = 'mongodb://thermal:raptors%402019Luci@138.197.144.159:27017/';

async function connect(url){
    mongo = await MongoClient.connect(url);
    if (mongo){
      return mongo.db("sensor");
    }
    return null;
}

async function update_sensor_record(db){
    const items = await db.collection('swpsensors').find({}, { projection: { _id: 0}}).toArray();
    for (const item in items){
        const element = items[item];
        const change = await prisma.Sensor.findUnique({
            where:{
                uuid: element.uuid,
            }
        })
        if (element.values){
            const record = await prisma.Record.update({
                where:{
                    id: change.values_id,
                },
                data:{
                    bgm: element.values.bgm,
                    phmv: element.values.phmv
                },
            })
            if (element.values.bgm){
                console.log(element.values);
            }
        }
    }
    return 'done'
}

async function mongoupdate(){
    const db = await connect(url);
    await update_sensor_record(db);
    mongo.close();
}

// mongoupdate();

async function main(){
    // await update_sensor();
    // await update_environmentanalysis();
    // await update_fsms();
    // await update_users();
    // await update_alerts();
    // await update_ponds();
    await update_sensor_pond();
    // await update_alerts2();
}
  
// main();

async function update_sensors(){
    const items = await prisma.Record.findMany({
        where: {
            sensor_uuid:{
                contains: "water"
            },
            sensor_id: null
        }
    });
    for (const item in items){
        const element = items[item];
        const sensor = await prisma.Sensor.findUnique({
            where:{uuid: element.sensor_uuid.slice(6)},
        })
        if (sensor){
            await prisma.Record.update({
                where: {id: element.id},
                data: {
                    sensor_id: sensor.id,
                }
            })
        }
    }
    return 'done';
}

async function update_sensors_air(){
    const items = await prisma.AirRecords.findMany({})
    for (const item of items){
        const sensor = await prisma.Sensor.findUnique({
            where:{uuid: item.sensor_uuid.replace('air_','')},
        })
        if (sensor){
            await prisma.AirRecords.update({
                where: {id: item.id},
                data:{
                    sensor_id: sensor.id,
                }
            })
        }
    }
}

update_sensors_air();
// update_sensors();