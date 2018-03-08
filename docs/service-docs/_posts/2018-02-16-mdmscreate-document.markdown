---
layout: post
date:   2018-02-02 14:00:04 +0530
categories: mdms-create
---
<b>Master data management system Create(MDMS-Create)</b><br>
MDMS is a comprehensive method of enabling an enterprise to link all of its critical data to one place, called a master data, that provides a common point of reference. Master data is common data which will be added or modified once in a while in the system. To reduce the effort of creating API’s for master data maintenance for individual modules, MDMS Create Service is been introduced. MDMS-Create provides common API’s for maintenance of all modules master data.
{: .text-justify}

<h3><b>Data considered as master data</b></h3>

Master data is the consistent and uniform set of identifiers and extended attributes that describes the core entities of the enterprise. The data which is consistent, non transactional and will be added or modified once in a while are considered to be a master data.
{: .text-justify}
Example : Department.

Departments in an organization remains same throughout and added or modified rarely.
<pre>
{
  "tenantId": "default",
  "moduleName": "common-masters",
  "Department": [
    {
      "id": "1",
      "name": "ADMINISTRATION",
      "code": "ADM",
      "active": "true",
      "tenantId": "default"
    },{
      "active": "true",
      "tenantId": "default"
      "id": "2",
      "name": "ACCOUNTS",
      "code": "ACC",

    },{
      "id": "5",
      "name": "ENGINEERING",
      "code": "ENG",
      "active": "true",
      "tenantId": "default"
    },
    {
      "id": "7",
      "name": "TOWN PLANNING",
      "code": "TP",
      "active": "true",
      "tenantId": "default"
    }
}
</pre>

Architecture of MDMS
![mdms architecture](/app/docs/images/mdms arch.png){:class="img-responsive"}


<b>Organization of MDMS Data:</b><br>
MDMS stores master data in json file. The folder structure of a GIT is as follows :
Repository where Master data is stored is egov-mdms-data.
Under egov-mdms-data repository, there is a data folder.
Under data folder, there will be a folder with state level tenant name ex:  "mh", where Maharastra specific statewide master data will be published.
Under state level tenant folder, there will be "tenant" folders where ulb specific master data will be checked in. for example "mh.roha"
Each module will have one folder for statewide and ulb wide master data. The folder name should be same as module name.
Under the modules, individual master data is stored in individual json file. The file name should be same as master name.
{: .text-justify}
Note- Be very sure of what we are keeping as master data. No transaction data should be added here.

<b>API’s available in MDMS are as follows:</b><br>

<li>MDMS create/update</li>
<a href="#" class="btn btn--primary">http://egov-micro-dev.egovernments.org/egov-mdms-create/v1/_create</a><br>
<a href="#" class="btn btn--primary">http://egov-micro-dev.egovernments.org/egov-mdms-create/v1/_update</a>

Payload for both create and update should have Requestinfo and MasterMetaData, under which tenantId, moduleName and masterName and masterData should be present.

Format of request:
<pre>
{
“RequestInfo”: {}
"MasterMetaData": {
    "masterData": List of master data,
    "tenantId": "Tenant id",
    "moduleName": "Module name",
    "masterName": "Master name"
  }
}
</pre>
for more information, have a look on swagger. <a href="#" class="btn btn--primary">https://raw.githubusercontent.com/egovernments/egov-services/master/docs/mdms/contract/mdms-create-v1-0-0.yml
Example :
<pre>
{
  "MasterMetaData": {
    "masterData": [
      {
        "tenantId": "default",
        "id": "14",
        "name": "Water Ways",
        "code": "014"
      }
    ],
    "tenantId": "default",
    "moduleName": "ASSET",
    "masterName": "AssetCategory"
  },
  "RequestInfo": {
    "apiId": "org.egov.pt",
    "ver": "1.0",
    "ts": 1513338399194,
    "action": "asd",
    "did": "4354648646",
    "key": "xyz",
    "msgId": "654654",
    "requesterId": "61",
    "authToken": "6bcde78c-2ef8-453c-a2ac-16c44fded416"
  }
}
</pre>
Example:

Note: For MDMS create or update unique or primary key constraints needs to be configured in master-config.json in MDMS create service resources folder.
<pre>
{
  "ASSET": {
    "AssetCategory": {
      "masterName": "AssetCategory",
      "moduleDefinition": null,
      "isStateLevel": true,
      "uniqueKeys": [
        "$.id",
        "$.tenantId"
      ]
    }
  }
}
</pre>

When we hit create request, the mdms-create service will go through master-config.json, validates the request against the configuration. If validation holds good then it will insert a requested record in the specified master file. If the Master file does not exist and corresponding configuration is present in master-config file, then it will create the file with the requested data. The application will give the exception, if there is no master configuration in master-config.json file related to requested master, even if the master file exists in the repository.<br>
For update, the data is updated on the bases of configurations (unique key/primary key constraints) in <b>master-config.json</b>.<br>
If we modify the master-config.json file or any other config file, then respective services must build and deployed for reflecting modifications.<br>
When we build and deploy the service, the application will loads up all our configurations from config files in a map. Whenever the application needs configs, it will get it done from the map.
{: .text-justify}


<li>MDMS Search:</li>
<a href="#" class="btn btn--primary">http://egov-micro-dev.egovernments.org/egov-mdms-service/v1/_search</a><br>
MDMS search API provides to get the data from the master data. It also provides an attribute called filter, where in we can provide filter expressions. Based on filter expression, search API will filter the data and provide the response. Example:
[?(@.id==1||@.id==2)] This expression will filter the master data by id equals to 1 or 2.
[?( @.id == 10 && @.tenantId =='default')] This expression will filter the master data by id equals to 10 and tenantId=default.<br>
For more information on filter expression please go through <a href="http://goessner.net/articles/JsonPath/" class="btn btn--primary">http://goessner.net/articles/JsonPath/</a><br>
The Request body must contain requestInfo and masterDataCriteria, where in we need to mention tenantId and moduleDetails. moduleDetails must contain moduleName and masterDetails. Master Details must contain name and filter.
For more information, have a look on swagger.{: .text-justify}
<a href="https://raw.githubusercontent.com/egovernments/egov-services/master/docs/mdms/contract/v1-0-0.yml" class="btn btn--primary">https://raw.githubusercontent.com/egovernments/egov-services/master/docs/mdms/contract/v1-0-0.yml</a><br>
Example :
<pre>
{
"RequestInfo":{
    "action":"action",
    "did":"did",
    "msgId": "msgId",
    "requesterId":"reuesterId",
    "authToken":"296e6d21-66f9-45c8-a24f-f51d65243ebd",
    "apiId": "123456789",
    "ver": "159",
    "ts": null,
    "key": "key",
    "tenantId": "default"
  },
"MdmsCriteria": {
    "tenantId": "default",

    "moduleDetails": [
      {
        "moduleName": "works",
        "masterDetails": [
          {
            "name": "WorksStatus",
            "filter": null
          }
        ]
      }
    ]
  }
}


Response will be in the form of :
{
  "ResponseInfo": null,
  "MdmsRes": {
    "moduleName": {
      "masterName": [
        {
          "masterData": "Master data"
        }
      ]
    }
  }
}

</pre>

<li>MDMS get:</li>
If we have filter [?(@.id==1||@.id==2)], filter value should be url-encoded. The URL finally looks like : <a>http://localhost:8093/egov-mdms-service/v1/_get?moduleName=SWM&masterName=<br>CollectionPoint&tenantId=mh&filter=%5B%3F%28%40.id%3D%3D1%7C%7C%40.id%3D%3D2%29%5D</a>

MDMS get is same as MDMS search. Only the difference is, instead of sending the required master data details in body, we will send in the form of query parameter.

Configurations to get MDMS enabled
	By default the master file location is set to the path mentioned in Organization of MDMS Data section in mdms repository. If we want to modify it, then we need to change the configuration in application.properties file with key as egov.mdms.conf.path. Only if we modify in master-config.json, the build and deploy is required.


<b>Getting a new Master Data enabled for MDMS</b>

To enable new module in mdms, we need to commit the folder manually in the repository in the specified location with name same as module name and configure masters config details in master-config file and create masters using create API.
Example:
Let us create a master data for new module, Asset. We need to create the folder with name Asset(Module name), in mh folder(tenant folder) in cloned location of egov-mdms-data repository in our system. We need to add master data configurations in master-config.json file. After adding configuration, the mdms create service needs to  build and deploy via  jenkins. After deploying the service, hit create api with master data details. Otherwise, we can add data manually in local pulled file and commit it to git, and call reload api to refresh the data map in mdms service(cached data).
{: .text-justify}



Check out the [Jekyll docs][jekyll-docs] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll’s GitHub repo][jekyll-gh]. If you have questions, you can ask them on [Jekyll Talk][jekyll-talk].

[jekyll-docs]: http://jekyllrb.com/docs/home
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-talk]: https://talk.jekyllrb.com/
