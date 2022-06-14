var JiraApi = require('jira-client');
var jira = new JiraApi({
  protocol: 'https',
  host: 'us-sba.atlassian.net',
  username: 'john.dough@aol.com',
  password: 'AAAAAAAAAAAAAAAAAAAAAAAA',
  apiVersion: '2',
  strictSSL: true
});

//jira.findIssue("IA-2404")
//  .then(function(issue) {
//    console.log(JSON.stringify(issue.fields, null, indent=2));
//    //console.log('Status: ' + issue.fields.status.name);
//  })
//  .catch(function(err) {
//    console.error(err);
//  });

jira.searchJira("summary LIKE 'SNYK'")
  .then(function(data){
    console.log(JSON.stringify(data));
  })
  .catch(function(error){
    console.log(error)
  });


//const fileSystem = require("fs");
//var contentsRaw = fileSystem.readFileSync("snyk-scan.json", "utf-8");
//var contentsJson = JSON.parse(contentsRaw);
//
//var isOk = contentsJson.ok;
//console.log(`Status: ${isOk}`);
//
//var vulnerabilities = contentsJson.vulnerabilities;
//console.log(`Found ${vulnerabilities.length} vulnerabilities`);
//vulnerabilities.forEach((element) => {
//  console.log("");
//  console.log(`ID:    ${element.id}`);
//  console.log(`Title: ${element.title}`);
//  console.log("");
//});
