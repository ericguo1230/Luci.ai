const MongoClient = require('mongodb').MongoClient;
const {PrismaClient, Prisma} = require('@prisma/client')

var mongo = undefined;
const prisma = new PrismaClient();
const url = 'mongodb://thermal:raptors%402019Luci@138.197.144.159:27017/';

async function connect(url){
  mongo = await MongoClient.connect(url);
  if (mongo){
    return mongo.db("sensor");
  }
  return null;
}

async function threshold_format(object){
  if (object === undefined){
    return undefined
  }else{
    const threshold = {
      orp_alert_max: object.orpAlertMax,
      orp_alert_min: object.orpAlertMin,
      ph_alert_max: object.phAlertMax,
      ph_alert_min: object.phAlertMin,
      conductivity_alert_max: object.conductivity,
      turbidity_alert_max: object.turbidityAlertMax,
      tds_alert_max: object.tdsAlertMax,
      do_above_20_alert_min: object.do_above20AlertMin,
      do_below_20_alert_min: object.do_below20AlertMin,
      salinity_alert_max: object.salinityAlertMax,
      outflow_1_alert_max: object.outflow1AlertMax,
      outflow_2_alert_max: object.outflow2AlertMax
    }
    await prisma.SensorThreshold.create({
      data: threshold,
    })
    const first_id = await prisma.SensorThreshold.findFirst({
      orderBy: {
        id: "desc"
      },
      select: {id: true,},
    })
    return first_id.id
  }
}

async function values_format(object){
  //reference to the sensor record table
  if (object == undefined){
    return undefined
  }else {
    const values = {
      uuid: undefined,
      depth: object.depth,
      ph: object.ph,
      orp: object.orp,
      dissolved_oxygen: object.dissolvedoxygen,
      conductivity: object.conductivity,
      tds: object.tds,
      turbidity: object.turbidity,
      tss: object.tss,
      temp: object.temp,
      salinity: object.salinity,
      voltage: object.voltage,
      cable: object.cable,
      hdop: object.hdop
    }
    await prisma.Record.create({
      data: values,
    })
    const first_id = await prisma.Record.findFirst({
      orderBy: {id: "desc"},
      select: {id: true,},
    })
    return first_id.id
  }
}

async function environment_status(object){
  if (object == undefined){
    return undefined
  }else{
    const status = {
      value: object.value,
      failed: object.failed,
      category: object.category,
      block_rate: object.block_rate,
      unit: object.unit
    }
    await prisma.EnvironmentStatus.create({
      data: status,
    })
    const first_id = await prisma.EnvironmentStatus.findFirst({
      orderBy: {
        id: "desc"
      },
      select: {id: true,},
    })
    return first_id.id
  }
}

async function units_format(object){
  if (object == undefined){
    return undefined
  }else{
    const unit = {
      ph: object.ph,
      conductivity: object.conductivity,
      tds: object.tds,
      orp: object.orp,
      dissolvedoxygen: object.dissolvedoxygen,
      turbidity: object.turbidity,
      salinity: object.salinity,
      temp: object.temp,
      depth: object.depth,
      tss: object.tss,
      airtemperature: object.airtemperature,
      pressure: object.pressure,
      humidity: object.humidity,
      rain: object.rain,
    }
    await prisma.Unit.create({
      data: unit,
    })
    const first_id = await prisma.Unit.findFirst({
      orderBy: {
        id: "desc"
      },
      select: {id: true,},
    })
    return first_id.id
  }
}

async function swpsensors(db){
  const items = await db.collection('swpsensors').find({}, { projection: { _id: 0}}).toArray();
  data = []
  for (const item in items){
    const element = items[item];
    const sensor = {
      uuid: element.uuid,
      pond_uuid: element.pond,
      pond_id: null,
      name: element.name,
      lat: element.lat,
      lng: element.lng,
      update: new Date(element.update || element.creation),
      values_id: await values_format(element.values),
      creation: new Date(element.creation),
      status: element.status,
      threshold_id: await threshold_format(element.threshold),
      unit_id: await units_format(element.units),
      seaOffset: element.seaOffset
    }
    data.push(sensor);
  };
  const sensor_data = await prisma.Sensor.createMany({
    data: data,
    skipDuplicates: true,
  })
  return sensor_data
}

async function environment(array){
  data = []
  for (const item in array){
    const element = array[item];
    const environment = {
      uuid: element.id,
      sensor_uuid: element.sensor,
      sensor_id: null,
      pond_uuid: element.pond,
      pond_id: null,
      timestamp: new Date(element.timestamp),
      depth_id: await environment_status(element.Depth),
      ph_id: await environment_status(element.PH),
      ec_id: await environment_status(element.EC),
      tds_id: await environment_status(element.TDS),
      orp_id: await environment_status(element.ORP),
      do_id: await environment_status(element.DO),
      turbidity_id: await environment_status(element.Turbidity),
      tss_id: await environment_status(element.TSS),
      rainfall_id: await environment_status(element.Rainfall),
      salinity_id: await environment_status(element.Salinity)
    }
    data.push(environment);
  }
  const result = await prisma.EnvironmentAnalysis.createMany({
    data: data,
    skipDuplicates: true,
  })
  return result
}

async function swpenvironmentanalysis(db){
  const page_size = 1000
  data = []
  for (let page = 0; page < 7; page ++){
    var items = await db.collection('swpoldanalyses')
    .find({}).skip(page * page_size).limit(page_size)
    .toArray();
    data.concat(await environment(items));
  }
  return data
}

async function machine_format(object){
  if (object == undefined){
    return undefined
  }
  const machine = {
    value: object.value,
    transition: object.transition
  }
  await prisma.Machine.create({
    data: machine,
  })
  const first_id = await prisma.Machine.findFirst({
    orderBy: {id: "desc"},
    select: {id: true,},
  })
  return first_id.id
}

async function swpfsms(db){
  data = []
  const items = await db.collection('swpfsms').find({}, { projection: { _id: 0}}).toArray();
  for (const item in items){
    const element = items[item];
    const fsm = {
      uuid: element.uuid,
      pond_uuid: element.pond,
      pond_id: null,
      ph_machine_id: await machine_format(element.PH_machine),
      ec_machine_id: await machine_format(element.EC_machine),
      tds_machine_id: await machine_format(element.TDS_machine),
      orp_machine_id: await machine_format(element.ORP_machine),
      do_machine_id: await machine_format(element.DO_machine),
      turbidity_machine_id: await machine_format(element.Turbidity_machine),
      salinity_machine_id: await machine_format(element.Salinity_machine),
    }
    data.push(fsm);
  }
  const result = await prisma.FSM.createMany({
    data: data,
    skipDuplicates: true,
  })
  return result
}

async function swpmodelmappings(db){
  data = []
  const items = await db.collection('swpmodelmappings').find({}, { projection: { _id: 0}}).toArray();
  for (const item in items){
    const element = items[item];
    const model = {
      uuid: element.uuid,
      model: element.model,
      sensor: element.sensor,
      air: element.air,
      pond: element.pond
    }
    data.push(model);
  }
  const result = await prisma.modelMapping.createMany({
    data: data,
    skipDuplicates: true,
  })
  return result
}

async function format_threshold(object){
  if (object == undefined){
    return undefined
  }
  const bound = {
    min: object.min,
    max: object.max
  }
  await prisma.Threshold.create({
    data: bound,
  })
  const first_id = await prisma.Threshold.findFirst({
    orderBy: {
      id: "desc"
    },
    select: {id: true,},
  })
  return first_id.id
}

//format
async function alerts(array){
  data = []
  for (const item in array){
    const element = array[item];
    const alert = {
      uuid: element.uuid,
      history: element.history,
      sensor_uuid: element.sensor,
      sensor_id: null,
      pond_uuid: element.pond,
      pond_id: null,
      record_uuid: element.record,
      record_id: null,
      creation: new Date(element.creation),
      type: element.type,
      value: element.value,
      unit: element.unit,
      level: element.level,
      threshold_id: await format_threshold(element.threshold),
      status: element.status,
      email_notification: element.emailA,
      leading: element.leading,
    }
    data.push(alert);
  }
  const result = await prisma.Alert.createMany({
    data: data,
    skipDuplicates: true,
  })
  return result
}

async function swpalerts(db){
  const page_size = 1000
  data = []
  for (let page = 0; page < 8; page ++){
    var items = await db.collection('swpalerts')
    .find({}).skip(page * page_size).limit(page_size)
    .toArray();
    data.concat(await alerts(items));
  }
  return data
}

async function swpareas(db){
  data = []
  const items = await db.collection('swpareas').find({}, { projection: { _id: 0}}).toArray();
  for (const item in items){
    const element = items[item];
    const area = {
      uuid: element.uuid,
      users_uuid: element.users,
      ponds_uuid: element.ponds,
      name: element.name,
      creation: new Date(element.creation),
      active: element.active
    }
    data.push(area);
  }
  const createMany = await prisma.Area.createMany({
    data: data,
    skipDuplicates: true,
  })
  return createMany
}

async function property_format(object){
  if (object == undefined){
    return undefined
  }else{
    const property = {
      fid: object.fid,
      object_id: object.OBJECTID,
      name: object.Name,
      classifica: object.Classifica,
      shape_leng: object.Shape_Leng,
      shape_area: object.Shape_Area,
      shape__area: object.Shape__Area,
      shape__length: object.Shape__Length
    }
    //insert data
    await prisma.Properties.create({
      data: property,
    })
    //find data id
    const first_id = await prisma.Properties.findFirst({
      orderBy: {
        id: "desc"
      },
      select: {id: true,},
    })
    return first_id.id
  }
}

async function coords_three(array, id){
  const coords = {
    coord_id: id,
    coords: array,
  }
  await prisma.CoordThree.create({
    data: coords,
  })
  return coords
}

async function coords_two(array, id){
  const coords = {
    coord_id: id
  }
  await prisma.CoordTwo.create({
    data: coords,
  })
  const first_id = await prisma.CoordTwo.findFirst({
    orderBy: {id: "desc"},
    select: {id: true},
  })
  for (const item in array){
    await coords_three(array[item], first_id.id)
  }
  return 'done'
}

async function coords_one(array, id){
  const coord = {
    geometry_id: id,
  }
  await prisma.CoordOne.create({
    data: coord,
  })
  const first_id = await prisma.CoordOne.findFirst({
    orderBy: {id: "desc"},
    select: {id: true},
  })
  
  for (const item in array){
    await coords_two(array[item], first_id.id);
  }
  return 'done'
}

async function geometry_format(object){
  const geometry = {
    type: object.type,
  }
  await prisma.Geometry.create({
    data: geometry,
  })
  const first_id = await prisma.Geometry.findFirst({
    orderBy: {
      id: "desc"
    },
    select: {id: true,},
  })
  for (const item in object.coordinates){
    await coords_one(object.coordinates[item], first_id.id);
  }
  return first_id.id
}

async function shape_format(object){
  const shape = {
    type: object.type,
    property_id: await property_format(object.properties),
    geometry_id: await geometry_format(object.geometry)
  }
  await prisma.Shape.create({
    data: shape,
  })
  const first_id = await prisma.Shape.findFirst({
    orderBy: {id: "desc"},
    select: {id: true},
  })
  return first_id.id
}

async function points_format(array){
  //return id not actual object change for future
  await prisma.Points.create({
    data: {},
  });
  const id = await prisma.Points.findFirst({
    orderBy: {
      id: "desc"
    },
    select: {id: true,},
  })
  for (const item in array){
    const element = array[item];
    const point = {
      point_id: id.id,
      name: element.name,
      value: element.value,
      uuid: element.uuid,
      coords: element.coords
    }
    //push to features table
    await prisma.Features.create({
      data: point,
    })
  }
  return id.id
}

async function waterlevel_format(array, id){
  //return ids
  for (const item in array){
    const element = array[item];
    const waterlevel = {
      pond_id: id.id,
      type: element.type,
      value: element.value
    }
    await prisma.WaterLevel.create({
      data: waterlevel,
    })
  }
  return 'done'
}

async function swpponds(db){
  const items = await db.collection('swpponds').find({}, { projection: { _id: 0}}).toArray();
  for (const item in items){
    const element = items[item];
    if ((await prisma.Pond.count({where: {uuid: element.uuid}})) == 0){
      const pond = {
        uuid: element.uuid,
        name_id: element.id,
        name: element.name,
        shape_id: await shape_format(element.shape),
        sensors_uuid: element.sensors,
        area_uuid: element.aid,
        points_id: await points_format(element.points),
        active: element.active,
      }
      await prisma.Pond.create({
        data: pond,
      })
      const id = await prisma.Pond.findFirst({
        orderBy: {id: "desc"},
        select: {id: true}
      })
      await waterlevel_format(element.waterLevel, id);
    }
  }
  return 'done'
}

function null_check(element){
  return element != null
}

async function swpusers(db){
  data = []
  const items = await db.collection('swpusers').find({}, { projection: { _id: 0}}).toArray();
  for (const item in items){
    const element = items[item];
    const user = {
      uuid: element.uuid,
      username: element.username,
      display_name: element.displayName,
      aid_uuid: element.aid,
      status: element.status,
      creation: new Date(element.creation),
      recipient_uuid: await element.recipient.filter(null_check),
      password: element.password,
      role: await element.role.filter(null_check)
    }
    data.push(user);
  }
  const result = await prisma.User.createMany({
    data: data,
    skipDuplicates: true,
  })
  return result
}

async function weather_sensor(db){
  let data = []
  const items = await db.collection('weathersensors').find({}, { projection: { _id: 0}}).toArray();
  for (const item of items){
    const weather_sensor = {
      uuid: item.uuid,
      name: item.name,
      pond_uuid: item.pond,
      geo_id: await insert_geo(item.geo),
    }
    data.push(weather_sensor);
  }
  await prisma.WeatherSensor.createMany({
    data: data,
    skipDuplicates: true,
  })
  return 'done'
}

async function insert_geo(object){
  if (object === undefined){
    return null
  }
  const geo = {
    lat: object.lat,
    lng: object.lng,
  }
  const result = await prisma.Geo.create({
    data:geo
  })
  return result.id;
}

async function main(){
  const db = await connect(url);
  // await swpsensors(db);
  // await swpenvironmentanalysis(db);
  // await swpfsms(db);
  // await swpmodelmappings(db);
  await weather_sensor(db);
  const thermal = mongo.db("CloudDB_thermal");
  // await swpusers(thermal);
  // await swpalerts(thermal);
  // await swpareas(thermal);
  // await swpponds(thermal);
  mongo.close();
}

// main();

const { Client } = require('pg');
const Service = require('egg').service;
async function records(){
  const client = new Client({
    user: 'postgres',
    host: '138.197.144.159',
    database: 'swp',
    password: 'raptorsat2019luci',
    port: 5432
  });

  // var query = 'SELECT * FROM public.water_msg'

  // client.connect ((err, client, done) => {
  //   if (err) throw err;
  //   client.query(query, async (err, res) => {
  //     if (err) console.log(err.stack);
  //     else{
  //       await water_record(res.rows);
  //     }
  //     client.end()
  //   })
  // })
  
  //'SELECT * FROM public.air_msg ORDER BY id ASC LIMIT 100000'
  //'SELECT * FROM public.air_msg ORDER BY id ASC LIMIT 100000 OFFSET 100000 ROWS'
  //'SELECT * FROM public.air_msg ORDER BY id ASC LIMIT 100000 OFFSET 200000 ROWS'
  var query = 'SELECT * FROM public.air_msg ORDER BY id ASC LIMIT 100000'

  client.connect ((err, client, done) => {
    if (err) throw err;
    client.query(query, async (err, res) => {
      if (err) console.log(err.stack);
      else{
        await air_record(res.rows);
      }
      client.end()
    })
  })
}

async function air_record(array){
  let data = []
  for (const element of array){
    const record = {
      uuid: element.uuid,
      sensor_uuid: element.device_id,
      created_at: element.create_at,
      update_time: element.update_time,
      sunrise_time: element.sunrise_time,
      sunset_time: element.sunset_time,
      temp: element.temp,
      feels_like_temp: element.feels_like_temp,
      pressure: element.pressure,
      humidity: element.humidity,
      dew_point_atmos_temp: element.dew_point_atmos_temp,
      clouds: element.clouds,
      uvi: element.uvi,
      visibility: element.visibility,
      wind_speed: element.wind_speed,
      wind_gust: element.wind_gust,
      wind_deg: element.wind_deg,
      rain: element.rain,
      snow: element.snow
    }
    data.push(record);
  }
  await prisma.AirRecords.createMany({
    data: data,
    skipDuplicates: true,
  })
}

async function water_record(array){
  data = []
  const items = array
  for (const item in items){
    const element = items[item];
    const record = {
      uuid: element.uuid,
      sensor_uuid: element.device_id,
      depth: element.depth,
      ph: element.ph,
      orp: element.orp,
      dissolved_oxygen: element.dissolvedoxygen,
      conductivity: element.conductivity,
      tds: element.tds,
      turbidity: element.turbidity,
      tss: element.tss,
      temp: element.temp,
      salinity: element.salinity,
      voltage: element.voltage,
      cable: element.cable,
      hdop: element.hdo,
      hourly: element.hourly,
      creation: element.created_at,
      update_time: element.update_time,
      bgm: element.bgm,
      phmv: element.phmv,
    }
    data.push(record);
  }
  await prisma.Record.createMany({
    data: data,
    skipDuplicates: true,
  })
  return 'done'
}

records();

async function delete_sensor(){
  await prisma.Record.deleteMany({
    where:{
      sensor_uuid:{
        contains: "water"
      }
    }
  })
}

// delete_sensor();