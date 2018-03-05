---
layout: post
date:   2018-02-13 14:00:04 +0530
categories: report
---

<h2>Reports Service</h2>


The eGov Reporting Service provides a single common interface across modules to define report search and filter criteria and retrieve data. Reporting service configurations for each business module is configured in a module specific yaml configurations file. The reporting service allows transaction data stored in the data store to be combined with master data that is internally retrieved through the eGov MDMS service.<br>

<h3>Architecture</h3><br>
![mdms architecture](/images/report.png){:class="img-responsive"}

Report service processes the request against yaml configurations, prepares and executes queries and retrieves data in a json format. The yaml configuration locations for each business module are configured in the reportFileLocations.txt file stored in egov-services repository under egov-services/docs/reportinfra/report folder. Each business module reports are configured in separate yaml files. The reload API can be used to reload the configurations when a new module is configured or if configurations for a module are changed.

<b>Configuration</b><br>

<pre>
Each module configuration file is of the following format
- reportName: [NAME_OF_REPORT]
  summary: [REPORT_SUMMARY]
  version: [VERSION_INFO]
  moduleName: [MODULE_NAME]
  sourceColumns:
  - name: [COLUMN_NAME]
    label: [COLUMN_LABEL]
    type: [COLUMN_DATA_TYPE]
    source: [SOURCE]
    linkedReport:
      reportName: [NAME_OF_LINKED_REPORT]
      linkedColumn: [NAVIGATION_TO_LINKED_COLUMN]
  searchParams:
  - name: [SEARCH_CRITERIA_NAME]
    label: [SEARCH_CRITERIA_LABEL]
    type: [SEARCH_CRITERIA_DATA_TYPE]
    source: [SOURCE]
    isMandatory: [true/false]
    searchClause:[APPEND_SEARCH_CLAUSE]   
  query: [REPORT_QUERY]

</pre>

Where

<li>[NAME_OF_REPORT]: Name of the report</li>
<li>[REPORT_SUMMARY]: Summary message for the report(AssetReport)</li>
<li>[VERSION_INFO]: version of the report(optional)</li>
<li>[MODULE_NAME]: modulename of which the report belongs to (eg : asset)</li>
<li>sourceColumns: - (list of source columns fetched from the query.)</li>
<pre>
[COLUMN_NAME]: Column name fetched from the query
[COLUMN_LABEL]: Column label pointer that will be replaced using the localization service
[COLUMN_DATA_TYPE]: is an enumerated value for the column data type [string/number/epoch/etc]
[SOURCE]: source module
linkedReport if clicking on the column needs to support a drill down of the report
[NAME_OF_LINKED_REPORT]: Name of the report configuration that needs to be used for the drill down [The name would be another entry in the yaml file if the drill down is to another report in the same module
[NAVIGATION_TO_LINKED_COLUMN]:  
searchParams:(list of search parameters which is required for the report)
[SEARCH_CRITERIA_NAME]: Name of the search parameter
[SEARCH_CRITERIA_LABEL]: Search criteria label pointer that will be replaced using the localization service
[SEARCH_CRITERIA_DATA_TYPE]: is an enumerated value for the column data type [string/number/epoch/etc]
[SOURCE]: Source Module
isMandatory flag: true/false (specifies whether the search param is optional or not)
[APPEND_SEARCH_CLAUSE]: Search clause that needs to be appended to the Search query
</pre>
<li>[REPORT_QUERY]: Query string which needs to get execute to generate the report with the place holders for the search params.</li>

Example:

A sample module specific yaml configuration can be accessed at
[Report Configuration file](https://raw.githubusercontent.com/egovernments/egov-services/master/docs/citizen/reports/report.yml)


<b>Usage</b><br>
Once the reporting service is configured, the get calls  
The Swagger definition for Reporting Service is accessible at
[Report Framework contract](https://raw.githubusercontent.com/egovernments/egov-services/master/docs/reportinfra/contracts/reportinfra-1-0-0.yml).The following are the API’s available

<li>Get Report Metadata provides report meta data for a report name. Payload for get api should have Requestinfo, tenantId and reportName. </li>

Request Format:
<pre>
{
  "RequestInfo": {
    "apiId": "emp",
    "ver": "1.0",
    "ts": "10-03-2017 00:00:00",
    "action": "create",
    "did": "1",
    "key": "abcdkey",
    "msgId": "20170310130900",
    "requesterId": "rajesh",
    "authToken": "0348d66f-d818-47fc-933b-ba23079986b8"
  },
  "tenantId": "default",
  "reportName": "ImmovableAssetRegister"
}
</pre>

Response Format:

<pre>
{
  "requestInfo": {
    "apiId": "emp",
    "ver": "1.0",
    "ts": "Fri Mar 10 00:00:00 IST 2017",
    "resMsgId": "uief87324",
    "msgId": "20170310130900",
    "status": "200"
  },
  "tenantId": "default",
  "reportDetails": {
    "reportName": "AssetImmovableRegister",
    "serialNo": false,
    "sorting": true,
    "searchFilter": false,
    "viewPath": "assetImmovableReport",
    "selectiveDownload": true,
    "summary": "Immovable Asset Register Report",
    "reportHeader": [
      {
        "name": "name",
        "label": "reports.asset.name",
        "type": "string",
        "defaultValue": null,
        "isMandatory": false,
        "showColumn": true,
        "total": false,
        "rowTotal": null,
        "columnTotal": null
      },
      {
        "name": "code",
        "label": "reports.asset.code",
        "type": "string",
        "defaultValue": null,
        "isMandatory": false,
        "showColumn": true,
        "total": false,
        "rowTotal": null,
        "columnTotal": null
      },
      {
        "name": "dateofcreation",
        "label": "reports.asset.dateofcreation",
        "type": "epoch",
        "defaultValue": null,
        "isMandatory": false,
        "showColumn": true,
        "total": false,
        "rowTotal": null,
        "columnTotal": null
      }
    ],
    "searchParams": [
      {
        "name": "assetcategory",
        "label": "reports.asset.assetCategory",
        "type": "singlevaluelist",
        "defaultValue": {
          "1": "Building",
          "2": "Infrastructure assets",
          "3": "Plant and Machinery",
          "4": "Electrical Installations",
          "2010": "RI-Office"
        },
        "isMandatory": false,
        "showColumn": true,
        "total": false,
        "rowTotal": null,
        "columnTotal": null
      },
      {
        "name": "assetsubcategory",
        "label": "reports.asset.assetSubCategory",
        "type": "url",
        "defaultValue": <a>/egov-mdms-service/v1/_get?moduleName=ASSET&masterName=AssetCategory&tenantId=$tenantid&filter=%5B%3F(%20%40.parent%3D%3D{assetcategory})%5D|$.MdmsRes.ASSET.AssetCategory.*.id|$.MdmsRes.ASSET.AssetCategory.*.name</a>,
        "isMandatory": false,
        "showColumn": true,
        "total": false,
        "rowTotal": null,
        "columnTotal": null
      },
      {
        "name": "department",
        "label": "reports.asset.departmentCode",
        "type": "singlevaluelist",
        "defaultValue": {
          "ACC": "ACCOUNTS",
          "REV": "REVENUE",
          "UPA": "URBAN POVERTY ALLEVIATION",
          "EDU": "EDUCATION",
          "ADM": "ADMINISTRATION",
          "PHS": "PUBLIC HEALTH AND SANITATION",
          "TP": "TOWN PLANNING",
          "ENG": "ENGINEERING"
        },
        "isMandatory": false,
        "showColumn": true,
        "total": false,
        "rowTotal": null,
        "columnTotal": null
      },
      {
        "name": "code",
        "label": "reports.asset.code",
        "type": "string",
        "defaultValue": null,
        "isMandatory": false,
        "showColumn": true,
        "total": false,
        "rowTotal": null,
        "columnTotal": null
      }
    ]
  }
}
</pre>

Module Specific _get API to retrieve report results - These reports are at an individual module level that returns reporting data based on the report name and search criteria passed to the reports.The API URL is of the format /report/{module_name}/_get.  Payload for get api should have Requestinfo, tenantId, reportName and search params. This api will return the results based on report name and search params provided the API request..

Request Format:

<pre>
{
  "RequestInfo": {
    "apiId": "emp",
    "ver": "1.0",
    "ts": "10-03-2017 00:00:00",
    "action": "create",
    "did": "1",
    "key": "abcdkey",
    "msgId": "20170310130900",
    "requesterId": "rajesh",
    "authToken": "39b6d8aa-e312-441e-8162-7032ae1303e1"
  },
  "tenantId": "default",
  "reportName": "ImmovableAssetRegister",
  "searchParams": [
    {
      "name": "assetid",
      "input": [
        	"283”,
”300”,
”128"
      ]
    }
  ]
}
</pre>

Response Format:

<pre>
{
  "viewPath": "assetImmovableReport",
  "selectiveDownload": true,
  "reportHeader": [
    {
      "name": "id",
      "label": "reports.asset.id",
      "type": "number",
      "defaultValue": null,
      "isMandatory": false,
      "showColumn": true,
      "total": false,
      "rowTotal": null,
      "columnTotal": null
    },
    {
      "name": "quantity",
      "label": "reports.asset.quantity",
      "type": "number",
      "defaultValue": null,
      "isMandatory": false,
      "showColumn": true,
      "total": false,
      "rowTotal": null,
      "columnTotal": null
    },
    {
      "name": "plintharea",
      "label": "reports.asset.plintharea",
      "type": "number",
      "defaultValue": null,
      "isMandatory": false,
      "showColumn": true,
      "total": false,
      "rowTotal": null,
      "columnTotal": null
    },
    {
      "name": "cubiccontents",
      "label": "reports.asset.cubiccontents",
      "type": "string",
      "defaultValue": null,
      "isMandatory": false,
      "showColumn": true,
      "total": false,
      "rowTotal": null,
      "columnTotal": null
    },
    {
      "name": "landsurveyno",
      "label": "reports.asset.landsurveyno",
      "type": "string",
      "defaultValue": null,
      "isMandatory": false,
      "showColumn": true,
      "total": false,
      "rowTotal": null,
      "columnTotal": null
    }
  ],
  "ttl": null,
  "reportData": [
    [
      283,
      3,
      null,
      null,
      null
    ],
    [
      300,
      3,
      null,
      null,
      null
    ],
    [
      128,
      2,
      null,
      null,
      null
    ]
  ]
}
</pre>


<li>Reload API</li><br.>

Reload api is developed to avoid building the service and deploying on every change of yml configs. This api will refresh the cache and reloads all updated configs in app cache.

Request Format:
<pre>
{
"RequestInfo": {
"apiId" : "emp",
"ver" : "1.0",
"ts" : "10-03-2017 00:00:00",
"action" : "create",
"did" : "1",
"key" : "abcdkey",
"msgId" : "20170310130900",
"requesterId" : "rajesh",
"authToken" : "3081f773-159b-455b-b977-acfd6ed2c61b"
} ,
"tenantId" : "default",
}
</pre>

<b>Configuring Reporting Service for a new module</b><br>

For configuring a new module to use the reporting service,

Modify the reportFileLocations.txt file in the path egov-services/docs/reportinfra/report/ to add a new module specific entry for the new module.
Create a module specific yaml file in the specified path for the module using the configuration structure defined in the Configurations section. The eGov convention is to place the reports configuration under docs under the specific module folder with the name “reports.yaml”.
Refresh the report service cache either by calling the reload API or by refreshing the Report service.
