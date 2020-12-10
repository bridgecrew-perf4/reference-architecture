const mysql = require('mysql');
const db_config = {
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT || 3306,
}
const connection = mysql.createConnection(db_config);

const waitPort = require('wait-port');
const express = require('express')
const app = express()

// Get table name from env var or default it to "hits"
const HITS_TABLE = process.env.TABLE_NAME || "hits"

const NODEJS_PORT = process.env.NODEJS_PORT || 8000

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
 *   Persistently tracks IP specific hits using mysql and path
 */
app.use(function (req, res, next){
  // Get IP Address
  const ip = (req.headers['x-forwarded-for'] || req.connection.remoteAddress || '').split(',')[0].trim();

  // Save IP Address in request (for accessing it post-middleware)
  req.parsed_ip = ip

  // Update DB with hits
  connection.query(`SELECT * FROM ${HITS_TABLE} WHERE ip = '${ip}' AND path = '${req.path}'`, function(err, results, fields){
    if (err) throw err;
    if (results.length > 0) {
      req.hits = results[0].hits + 1;
      connection.query(`UPDATE ${HITS_TABLE} SET hits = hits + 1 WHERE ip = '${ip}' AND path = '${req.path}'`, next);
    } else {
      // No hits so far, so create a new record
      req.hits = 1;
      connection.query(`INSERT INTO ${HITS_TABLE} (ip, path, hits) VALUES ('${ip}', '${req.path}', 1)`, next);
    }
  });
})

// GET for any path not yet routed to print IP, path, and hits
app.get('*', function (req, res) {
  res.send(`Welcome to Zombocom, ${req.parsed_ip}! You've been to path [${req.path}] [${req.hits}] times.`)
})

// Wait for DB

waitPort({host: db_config.host, port: db_config.port}).then((open) => {

  // Set up DB
  const create_table = `CREATE TABLE IF NOT EXISTS ${HITS_TABLE} (ip VARCHAR(64) NOT NULL, path VARCHAR(64) NOT NULL, hits INT NOT NULL)`;
  connection.query(create_table, function (err, result) {
    if (err) throw err;
    console.log("Table created");

    // Start app
    app.listen(NODEJS_PORT, () => {
      console.log(`Example app listening at http://localhost:${NODEJS_PORT}`)
    })
  });
});
