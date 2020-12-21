const AWS = require('aws-sdk');

let dynamo_options = {}

if(process.env.IS_OFFLINE === "true") {
  dynamo_options.region = "localhost"
  dynamo_options.endpoint = "http://localhost:8000"
  dynamo_options.accessKeyId = 'DEFAULT_ACCESS_KEY'  // needed if you don't have aws credentials at all in env
  dynamo_options.secretAccessKey = 'DEFAULT_SECRET' // needed if you don't have aws credentials at all in env
}

const dynamo = new AWS.DynamoDB.DocumentClient(dynamo_options);

const serverless = require('serverless-http');
const express = require('express')
const app = express()

// Get table name from env var
const HITS_TABLE = process.env.TABLE_NAME

// Simple hello world

/* 
 * Bad Counter Middleware
 * Tracks hits for a single instantiation of lambda.  Bad times.
 */
let badcounter = 0
app.use('/bad-hits', function (req, res, next){
  badcounter = badcounter + 1
  console.log(`Hits: ${badcounter}`)
  next()
})

// Respond to GET requests on /bad-hits
app.get('/bad-hits', function (req, res) {
  // Bad Counter Responder
  res.send(`Hello! I'm bad at counting, but I think I've had ${badcounter} hits!`)
})

/*
 * Good Counter Middleware [runs on every request, but doesn't send response]
 *   Persistently tracks IP specific hits using dynamodb and path
 */
app.use(function (req, res, next){
  // Get IP Address
  const ip = (req.headers['x-forwarded-for'] || req.connection.remoteAddress || '').split(',')[0].trim();

  // Save IP Address in request (for accessing it post-middleware)
  req.parsed_ip = ip

  // Craft DynamoDB Update
  const params = {
    TableName: HITS_TABLE,
    AttributeUpdates: {
      "hits": {
        Value: 1,
        Action: "ADD"
      }
    },
    Key: {"ip": ip, "path": req.path}
  }
  console.log("Updating dynamo with: ",JSON.stringify(params, null, 2))
  dynamo.update(params, next)
})

/*
 * Hit Fetcher Middleware [runs on every request, but doesn't send response]
 *   Fetch hits from DynamoDB By IP Address and path
 */
app.use(function (req, res, next){
  // Craft DynamoDB Get
  const params = {
    TableName: HITS_TABLE,
    Key: {"ip": req.parsed_ip, "path": req.path}
  }
  console.log("Updating dynamo with: ",JSON.stringify(params, null, 2))
  dynamo.get(params, function(err, data) {
    if (err) {
      console.log("ERROR: Failed to fetch hits", JSON.stringify(err, null, 2));
      req.hits = "Unknown :("
      next()
    } else {
      console.log("Fetched hits: ", JSON.stringify(data, null, 2));
      // Write hits into request for later use
      req.hits = data.Item.hits
      next()
    }
  });
})

// GET for any path not yet routed to print IP, path, and hits
app.get('*', function (req, res) {
  res.send(`Welcome to Zombocom, ${req.parsed_ip}! You've been to path [${req.path}] [${req.hits}] times.`)
})

// serverless(app) will help format responses for API Gateway
module.exports.handler = serverless(app);
