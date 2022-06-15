const fileSystem = require("fs");

var contentsRaw = fileSystem.readFileSync("scan.json", "utf-8");
var contentsJson = JSON.parse(contentsRaw);

var isOk = contentsJson.ok;
console.log(`Status: ${isOk}`);

var vulnerabilities = contentsJson.vulnerabilities;
console.log(`Found ${vulnerabilities.length} vulnerabilities`);
vulnerabilities.forEach((element) => {
  console.log("");
  console.log(`ID:    ${element.id}`);
  console.log(`Title: ${element.title}`);
  console.log("");
});

