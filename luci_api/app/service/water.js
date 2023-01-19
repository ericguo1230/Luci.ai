'use strict';

const Service = require('egg').Service;
const { Client } = require('pg');
const {PrismaClient, Prisma} = require('@prisma/client')
const prisma = new PrismaClient();

class Water extends Service {
    async getWaterRecordsByTimeRange(start, end) {
      const client = new Client({
        user: 'postgres',
        host: 'localhost',
        database: 'luci',
        password: 'password',
        port: 5432
      });
      const query = 'SELECT * FROM public."Record" WHERE update_time BETWEEN $1 AND $2';
      const params = [ start, end ];
      client.connect();
    
      let msg = [];
      const res = await client.query(query, params);
      msg = res.rows;
      client.end();
      return msg;
    
    }

  async getPondObjects(item) {
    const shape = await prisma.Shape.findFirst({
      where: {
        id: item.shape_id
      }
    })
    const property = await prisma.Properties.findFirst({
      where: {
        id: shape.property_id,
      }
    })
    const geometry = await prisma.Geometry.findFirst({
      where: {
        id: shape.geometry_id,
      }
    })
    const coordinates = await prisma.CoordOne.findMany({
      where: {
        geometry_id: geometry.id,
      }
    })
    const coordinates_two = await prisma.CoordTwo.findMany({
      where: {
        coord_id: coordinates.id,
      }
    })
    let response_coordinates = [];
    for (const item of coordinates_two) {
      let data = []
      const coordinates_three = await prisma.CoordThree.findMany({
        where: {
          coord_id: item.id,
        }
      })
      for (const item of coordinates_three) {
        data.push(item.coords);
      }
      response_coordinates.push(data);
    }
    let response_geometry = {
      type: geometry.type,
      coordinates: response_coordinates,
    }
    let response_shape = {
      type: shape.type,
      properties: property,
      geometry: response_geometry,
    }
    return response_shape;
  }

  async getWaterRecordsByTimeAndSensor(start, end, sensor, hourly){
    const params = [ start, end ];
    const client = new Client({
      user: 'postgres',
      host: 'localhost',
      database: 'luci',
      password: 'password',
      port: 5432
    });
    client.connect();
    let query = 'SELECT * FROM public."Record" WHERE update_time BETWEEN $1 AND $2';

    if (hourly) {
      query += 'AND hourly=$3';
      params.push(hourly);
    }

    if (sensor.length) {
      query += ' AND sensor_uuid IN (';
      for (const i of sensor) {
        query += "'water_" + i + "', ";
      }
      query = query.slice(0, query.length - 2) + ');';
    }

    let msg = []
    const res = await client.query(query, params);
    msg = res.rows;
    client.end();
    return msg;
  }

  async getAirRecordByTimeAndSensor(start, end, sensor) {
    const params = [ start, end ];
    const client = new Client({
      user: 'postgres',
      host: 'localhost',
      database: 'luci',
      password: 'password',
      port: 5432
    });
    client.connect();
    let query = 'SELECT * FROM public."AirRecords" WHERE update_time BETWEEN $1 AND $2';

    if (sensor.length) {
      query += ' AND sensor_uuid IN (';
      for (const i of sensor) {
        query += "'air_" + i + "', ";
      }
      query = query.slice(0, query.length - 2) + ');';
    }

    let msg = []
    const res = await client.query(query, params);
    msg = res.rows;
    client.end();
    return msg;

  }
  async getAirRecordByTimeAndID(start, end, id) {
    const params = [ start, end, id ];
    const client = new Client({
      user: 'postgres',
      host: 'localhost',
      database: 'luci',
      password: 'password',
      port: 5432
    });
    client.connect();
    const query = 'SELECT * FROM public."AirRecords" WHERE sensor_uuid= $3 AND update_time BETWEEN $1 AND $2';

    let msg = []
    const res = await client.query(query, params);
    msg = res.rows;
    client.end();
    return msg;

  }
}
module.exports = Water;