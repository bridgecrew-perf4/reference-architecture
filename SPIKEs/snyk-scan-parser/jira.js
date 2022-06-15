var JiraApi = require('jira-client');
var jira = new JiraApi({
  protocol: 'https',
  host: process.env.JIRA_HOST,
  username: process.env.JIRA_EMAIL,
  password: process.env.JIRA_TOKEN,
  apiVersion: '2',
  strictSSL: true
});

const FIELDS = ['priority','status','issuetype','project','summary','customfield_10008'];

// return an issue by the :id attribute
jira.findIssue(56967, null, FIELDS.join(',')) // issueNumber, expand, fields, properties, fieldsByKeys
  .then(function(issue) {
    console.log('-------------------------------------------------------');
    console.log(issue.id);
    console.log(issue.key);
    console.log(issue.fields.summary);
    console.log(issue.fields.priority.name);
    console.log(issue.fields.status.name);
    console.log(issue.fields.issuetype.name);
  })
  .catch(function(err) {
    console.error(err);
  });

// finds an issue by :key attr
jira.findIssue("IA-2512", null, FIELDS.join(',')) // issueNumber, expand, fields, properties, fieldsByKeys
  .then(function(issue) {
    console.log('-------------------------------------------------------');
    console.log(issue.id);
    console.log(issue.key);
    console.log(issue.fields.summary);
    console.log(issue.fields.priority.name);
    console.log(issue.fields.status.name);
    console.log(issue.fields.issuetype.name);
  })
  .catch(function(err) {
    console.error(err);
  });

// finds issue(s) by :project and a free-text search on :summary
jira.searchJira("project = \"IA\" AND summary ~ \"Remove Algo-VPN\"", {startAt:0, maxResults:1, fields:FIELDS}) //startAt, maxResults, fields, expand
  .then(function(data){
    data.issues.forEach(function(issue) {
    console.log('-------------------------------------------------------');
      console.log(issue.id);
      console.log(issue.key);
      console.log(issue.fields.summary);
      console.log(issue.fields.priority.name);
      console.log(issue.fields.status.name);
      console.log(issue.fields.issuetype.name);
    });
  })
  .catch(function(error){
    console.log(error)
  });



// Example Response

//{
//  statuscategorychangedate: '2022-06-14T16:01:09.681-0400',
//  customfield_10070: null,
//  customfield_10071: null,
//  customfield_10072: '0.0',
//  customfield_10073: null,
//  customfield_10074: null,
//  customfield_10075: null,
//  customfield_10076: null,
//  customfield_10077: null,
//  customfield_10110: null,
//  fixVersions: [],
//  customfield_10111: null,
//  customfield_10078: null,
//  customfield_10112: null,
//  resolution: null,
//  customfield_10113: null,
//  customfield_10114: null,
//  customfield_10104: null,
//  customfield_10105: null,
//  customfield_10106: null,
//  customfield_10107: null,
//  customfield_10108: null,
//  customfield_10109: null,
//  lastViewed: '2022-06-14T16:02:36.360-0400',
//  customfield_10062: null,
//  customfield_10063: null,
//  customfield_10064: null,
//  customfield_10065: null,
//  customfield_10066: null,
//  customfield_10100: null,
//  customfield_10067: null,
//  priority: {
//    self: 'https://jira.atlassian.com/rest/api/2/priority/3',
//    iconUrl: 'https://jira.atlassian.com/images/icons/priorities/medium.svg',
//    name: 'Medium',
//    id: '3'
//  },
//  customfield_10101: null,
//  customfield_10068: null,
//  customfield_10069: null,
//  customfield_10102: null,
//  customfield_10103: null,
//  labels: [],
//  aggregatetimeoriginalestimate: null,
//  timeestimate: null,
//  versions: [],
//  issuelinks: [],
//  assignee: null,
//  status: {
//    self: 'https://jira.atlassian.com/rest/api/2/status/10009',
//    description: '',
//    iconUrl: 'https://jira.atlassian.com/',
//    name: 'To Do',
//    id: '10009',
//    statusCategory: {
//      self: 'https://jira.atlassian.com/rest/api/2/statuscategory/2',
//      id: 2,
//      key: 'new',
//      colorName: 'blue-gray',
//      name: 'To Do'
//    }
//  },
//  components: [],
//  customfield_10170: null,
//  customfield_10050: null,
//  customfield_10172: null,
//  customfield_10051: null,
//  customfield_10173: null,
//  customfield_10055: 1,
//  customfield_10049: null,
//  aggregatetimeestimate: null,
//  creator: {
//    self: 'https://jira.atlassian.com/rest/api/2/user?accountId=AAAAAAAAAAAAAAAAAAAAAAAA',
//    accountId: 'AAAAAAAAAAAAAAAAAAAAAAAA',
//    emailAddress: 'jdough@aol.com',
//    avatarUrls: {
//      '48x48': 'https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/AAAAAAAAAAAAAAAAAAAAAAAA/BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB/48',
//      '24x24': 'https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/AAAAAAAAAAAAAAAAAAAAAAAA/BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB/24',
//      '16x16': 'https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/AAAAAAAAAAAAAAAAAAAAAAAA/BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB/16',
//      '32x32': 'https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/AAAAAAAAAAAAAAAAAAAAAAAA/BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB/32'
//    },
//    displayName: 'John Dough',
//    active: true,
//    timeZone: 'America/New_York',
//    accountType: 'atlassian'
//  },
//  subtasks: [],
//  customfield_10161: null,
//  customfield_10162: null,
//  customfield_10163: null,
//  reporter: {
//    self: 'https://jira.atlassian.com/rest/api/2/user?accountId=AAAAAAAAAAAAAAAAAAAAAAAA',
//    accountId: 'AAAAAAAAAAAAAAAAAAAAAAAA',
//    emailAddress: 'jdough@aol.com',
//    avatarUrls: {
//      '48x48': 'https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/AAAAAAAAAAAAAAAAAAAAAAAA/BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB/48',
//      '24x24': 'https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/AAAAAAAAAAAAAAAAAAAAAAAA/BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB/24',
//      '16x16': 'https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/AAAAAAAAAAAAAAAAAAAAAAAA/BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB/16',
//      '32x32': 'https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/AAAAAAAAAAAAAAAAAAAAAAAA/BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB/32'
//    },
//    displayName: 'John Dough',
//    active: true,
//    timeZone: 'America/New_York',
//    accountType: 'atlassian'
//  },
//  customfield_10164: null,
//  customfield_10165: null,
//  aggregateprogress: { progress: 0, total: 0 },
//  customfield_10166: null,
//  customfield_10167: null,
//  customfield_10168: null,
//  customfield_10048: null,
//  customfield_10169: null,
//  customfield_10159: null,
//  progress: { progress: 0, total: 0 },
//  votes: {
//    self: 'https://jira.atlassian.com/rest/api/2/issue/IA-2515/votes',
//    votes: 0,
//    hasVoted: false
//  },
//  issuetype: {
//    self: 'https://jira.atlassian.com/rest/api/2/issuetype/10004',
//    id: '10004',
//    description: 'A task that needs to be done.',
//    iconUrl: 'https://jira.atlassian.com/rest/api/2/universal_avatar/view/type/issuetype/avatar/10489?size=medium',
//    name: 'Task',
//    subtask: false,
//    avatarId: 10489,
//    hierarchyLevel: 0
//  },
//  timespent: null,
//  customfield_10150: null,
//  customfield_10030: [],
//  customfield_10151: null,
//  project: {
//    self: 'https://jira.atlassian.com/rest/api/2/project/10027',
//    id: '10027',
//    key: 'IA',
//    name: 'Infrastructure Automation',
//    projectTypeKey: 'software',
//    simplified: false,
//    avatarUrls: {
//      '48x48': 'https://jira.atlassian.com/rest/api/2/universal_avatar/view/type/project/avatar/10210',
//      '24x24': 'https://jira.atlassian.com/rest/api/2/universal_avatar/view/type/project/avatar/10210?size=small',
//      '16x16': 'https://jira.atlassian.com/rest/api/2/universal_avatar/view/type/project/avatar/10210?size=xsmall',
//      '32x32': 'https://jira.atlassian.com/rest/api/2/universal_avatar/view/type/project/avatar/10210?size=medium'
//    }
//  },
//  customfield_10031: null,
//  customfield_10153: null,
//  customfield_10032: null,
//  customfield_10033: null,
//  customfield_10154: null,
//  customfield_10155: null,
//  aggregatetimespent: null,
//  customfield_10156: null,
//  customfield_10157: null,
//  customfield_10158: null,
//  customfield_10029: null,
//  resolutiondate: null,
//  workratio: -1,
//  watches: {
//    self: 'https://jira.atlassian.com/rest/api/2/issue/IA-2515/watchers',
//    watchCount: 1,
//    isWatching: true
//  },
//  created: '2022-06-14T16:01:09.223-0400',
//  customfield_10137: [],
//  customfield_10138: null,
//  customfield_10139: null,
//  updated: '2022-06-14T16:02:49.992-0400',
//  customfield_10090: null,
//  customfield_10095: null,
//  timeoriginalestimate: null,
//  customfield_10096: null,
//  description: 'Revisit legacy cert application infrastructure to be able to support the team in sprint 100. \n' +
//    '\n' +
//    '*Assumptions*\n' +
//    '\n' +
//    "* We don't remember what was done as its been 6+ months\n" +
//    '\n' +
//    '*AC*\n' +
//    '\n' +
//    '* Revisit docker setup\n' +
//    '* Revisit Infrastructure configuration\n' +
//    '* Revisit VPN connection',
//  customfield_10097: null,
//  customfield_10010: null,
//  customfield_10131: null,
//  customfield_10098: null,
//  customfield_10011: null,
//  customfield_10099: null,
//  customfield_10132: {
//    self: 'https://jira.atlassian.com/rest/api/2/customFieldOption/10186',
//    value: 'S',
//    id: '10186'
//  },
//  customfield_10133: null,
//  customfield_10134: null,
//  customfield_10135: null,
//  customfield_10136: null,
//  customfield_10006: null,
//  customfield_10127: null,
//  security: null,
//  customfield_10128: null,
//  customfield_10007: {
//    hasEpicLinkFieldDependency: false,
//    showField: false,
//    nonEditableReason: {
//      reason: 'PLUGIN_LICENSE_ERROR',
//      message: 'The Parent Link is only available to Jira Premium users.'
//    }
//  },
//  customfield_10008: [
//    {
//      id: 574,
//      name: 'IA S99: 6/15/22-6/28/23',
//      state: 'future',
//      boardId: 22,
//      goal: '',
//      startDate: '2022-06-15T13:51:00.000Z',
//      endDate: '2022-06-28T13:51:00.000Z'
//    }
//  ],
//  customfield_10129: {
//    self: 'https://jira.atlassian.com/rest/api/2/customFieldOption/10177',
//    value: 'Unsure',
//    id: '10177'
//  },
//  customfield_10009: '1|i00efz:',
//  summary: 'Revisit cert-legacy infrastructure',
//  customfield_10085: null,
//  customfield_10086: null,
//  customfield_10087: null,
//  customfield_10120: null,
//  customfield_10000: '{}',
//  customfield_10122: null,
//  customfield_10001: null,
//  customfield_10002: null,
//  customfield_10123: null,
//  customfield_10124: null,
//  customfield_10115: null,
//  customfield_10116: null,
//  customfield_10117: null,
//  environment: null,
//  customfield_10118: null,
//  customfield_10119: null,
//  duedate: null
//}
