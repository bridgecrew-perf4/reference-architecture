#!/bin/bash

export DB_HOST=localhost DB_USER=example DB_PASSWORD=example DB_NAME=example

node -e 'require("./index.js").hello_db({}, {}, () => { console.log("callback done"); process.exit(1) })'
