var mysql = require('mysql');
var connection = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

//connection.connect();

module.exports.hello = async event => {
  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: 'Go Serverless v1.0! Your function executed successfully!',
        input: event,
      },
      null,
      2
    ),
  };
};

module.exports.hello_db = (event, context, callback) => {
  // allows for using callbacks as finish/error-handlers
  context.callbackWaitsForEmptyEventLoop = false;

  const create_table = "CREATE TABLE IF NOT EXISTS messages (text VARCHAR(64) NOT NULL)";
  const insert_object = "INSERT INTO messages (text) VALUES ('Hello, World')";
  const count_objects = "SELECT count(*) as rows_in_messages_table FROM messages";
  connection.query(create_table, function (err, result) {
    if (err) throw err;
    console.log("Table exists");
    connection.query(insert_object, function (err, result) {
      if (err) throw err;
      console.log("Inserted message");
      connection.query(count_objects, function (err, result) {
        if (err) throw err;
        var response = {
          statusCode: 200,
          body: JSON.stringify(result, null, 2),
        };
        console.log(`Response from count query:`, result);
        callback(null, response);
      });
    });
  });
};
