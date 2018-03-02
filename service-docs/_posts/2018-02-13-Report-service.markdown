---
layout: post
title:  "Report service"
date:   2018-02-13 14:00:04 +0530
categories: report
---

<h2>Reports Service</h2>

The eGov Reporting Service is a common service running independently, which has provision to generate client defined or required reports for all modules in common, with a single configurable .yml file for each module respectively.
The service allows to retrieve the data from data store through a set of configurations. This service loads the report configuration from a yaml file at the run time and provides the report details from data store.
{: .text-justify}
Report service provides following functionalities
<li>Provides metadata about the report.</li>
<li>Provides the data for the report.</li>
<li>Reload the configuration at runtime</li>
<br>
<h3>Architecture of Report service</h3>
![mdms architecture](/images/report.png){:class="img-responsive"}

Report service is a common component, which will process the request against yml configurations, prepares queries and get data from database and gives back in response. The yml configuration file path, which are configured in the reportFileLocations.txt file are loaded in the application cache memory at the time of deployment of the application or on calling reload api.
{: .text-justify}

Yml configuration structure
<pre>
<b>reportName:</b> Name of the report
<b>summary:</b> Summary message for the report(AssetReport)
<b>version:</b> version of the report(optional)
<b>moduleName:</b> modulename of which the report belongs to (eg : asset)
<b>sourceColumns:</b> - (list of source columns fetched from the query.)
<b>name:</b> receiptNo (column name)
<b>label:</b> reports.citizen.receiptno (label which will get displayed in the report)
<b>type:</b> string (type of the column)
<b>source:</b> citizen (source module)
<b>searchParams:</b>(list of search parameters which is required for the report)
<b>name:</b> consumerno (name of the search param)
<b>label:</b> reports.citizen.consumerno (label which will be used for displaying the search param. It has to be created in common.js Front end team will update this information)
<b>type:</b> string (type of the search param)
<b>source:</b> (source module)
<b>isMandatory:</b> false (specifies whether the search param is optional or not)
<b>searchClause:</b> and consumerNo = $consumerno (Search clause will get appended to the query based on the ismandatory flag. if it is false and the search param is having that parameter then it will get appended otherwise it will not get appended)
<b>query:</b> (query string which needs to get execute to generate the report with the place holders for the search params. refer sample config for clarifications)
<b>groupby:</b> group by clause if needed(group by fieldname)
<b>orderby:</b> order by clause if needed(order by fieldname asc)
</pre>
<b>Example:<b>
<pre>
- reportName: CitizenService
  summary: Citizen Services Report
  version: 1.0.0
  moduleName: citizen
  sourceColumns:
  - name: receiptNo
    label: reports.citizen.receiptno
    type: string
    source: citizen
  - name: receiptDate
    label: reports.citizen.receiptdate
    type: number
    source: citizen
  - name: totalAmount
    label: reports.citizen.totalamount
    type: number
    source: citizen
  - name: payeeName
    label: reports.citizen.payeename
    type: number
    source: citizen
  - name: consumerAddress
    label: reports.citizen.consumeraddress
    type: number
    source: citizen
  - name: print
    label: reports.citizen.print
    type: number
    source: citizen
    linkedReport:
      reportName: ReceiptDetail
      linkedColumn: _url?/pgr/viewGrievance/:srn
  searchParams:
  - name: consumerno
    label: reports.citizen.consumerno
    type: string
    source: citizen
    isMandatory: false
    searchClause: and consumerNo = $consumerno
  - name: receiptno
    label: reports.citizen.receiptno
    type: string
    source: citizen
    isMandatory: false
    searchClause: and receiptno = $receiptno
  query: select receiptNo,receiptDate,totalAmount,payeeName,consumerAddress,'print' as print from egcl_legacy_receipt_header where tenantid = $tenantid
</pre>

<b>Configurations</b>

Standard convention of placing the yml configuration file is, under docs individual module folder will be there. Under module folder create folder with name report. Place the yml configuration file under report folder.
Add the module specific configuration location path in <b>reportFileLocations.txt</b>, which is in egov-services/docs/reportinfra/report/ path. The Report service will pull all configurations from git, which are specified in the path, and store in cache on loading the service.
{: .text-justify}
Note: After adding or modifying configs build and deploying the report service is must. OR call reload api.<br>
<b>Example:</b><br>
Let us create a configurations for module asset. Create a folder with name report under respective module folder(Asset), which will be under docs. Create yml file in report folder. Configure according to the structure as mentioned above in yml configuration section. Configure the yml file path in <b>reportFileLocations.txt</b>, which is in <b>egov-services/docs/ reportinfra/report/</b> path. Initiate report service reload api, so that it will refresh the app cache with updated conf.
{: .text-justify}
<b>API Details:</b><br>
<li>Get Report Metadata:</li>

/report/asset/metadata/_get

Payload for get api should have Requestinfo, tenantId and reportName. This api will provide the details of the specified report.

Request json fromat:
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
Response json format: <br>The response json will be consist of Report details, which will be consisting list of report Header(Column headers) and list of searchParams.
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
        "defaultValue": "/egov-mdms-service/v1/_get?moduleName=ASSET&masterName=AssetCategory&tenantId=$tenantid&filter=%5B%3F(%20%40.parent%3D%3D{assetcategory})%5D|$.MdmsRes.ASSET.AssetCategory.*.id|$.MdmsRes.ASSET.AssetCategory.*.name",
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

<li>/report/asset/_get</li>

Payload for get api should have Requestinfo, tenantId, reportName and search params. This api will provide the report data of respective report name based on search params provided in searchParams tag .
Sample Request:
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
Response json format: <br>Response json will consist of list of report headers, which are column headers and list of report data, which will be list of list. The report data will be consist of list of records to be displayed in report with respect to headers.
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

<li> /report/_reload</li>

Reload api is developed to avoid building the service and deploying on every change of yml configs. This api will refresh the cache and reloads all updated configs in app cache.
Sample Request:
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
    "authToken": "3081f773-159b-455b-b977-acfd6ed2c61b"
  },
  "tenantId": "default"
}
</pre>
	For more information refer the report service design in :https://raw.githubusercontent.com/egovernments/egov-services/master/docs/reportinfra/contracts/reportinfra-1-0-0.yml




<b>Testing Report service</b>

Report service can be tested by initiating a create api of respective module from postman. If validation and business logic executes successfully, the request is sent to kafka queue with unique topic name. After placing the request in to kafka queue, the api will give the response back with successful status and sequence generated ids or code(Unique key with client specified  standard format).
Initiate /report/{asset}/_get api with ids or codes as search params, which we got from create response. It should return the data as we got in create api response, which means Report service is working fine.  
{: .text-justify}
