---
layout: post
date:   2018-02-02 14:00:04 +0530
categories: mdms
---
<b>Master Data Management System(MDMS)</b><br>
MDMS (Master Data Management Service) is used to manage versioned reference data across the platform. Master data sets are synchronized copies of core business entities used across an organization, and subjected to governance policies, along with their associated metadata, attributes, definitions, roles, connections and taxonomies.

The MDMS Service currently supports Create / Update and Search functions on master data. Configurations are specified in YAML/JSON. The service caches data for faster access and performance. To reduce the server round-trips involved in retrieving multiple master data for a workflow, a single API can be configured to return multiple master objects which can then be parsed using JSON expressions.
{: .text-justify}

<b>Archictecture</b><br>

![mdms architecture](/images/mdms arch.png){:class="img-responsive"}


<b>Configuration</b><br>
{: .text-justify}

The Service configurations are stored in the file “master-config.json” configured in the application.properties of the MDMS Service. Each new module to be configured requires an entry in the “master-config.json” file along with the list of masters in the following format
{: .text-justify}

<pre>
"[MODULE_NAME]": {
    "[MASTER_DATA_1]": {
      "masterName": "[NAME_OF_MASTER]",
      "isStateLevel": [true/false],
      "uniqueKeys": [
        "[KEY_1]",”[KEY_2]"
      ]
    }
  }
</pre>
where the highlighted parameters needs to be replaced as applicable

For example, the following is the configuration for the ASSET module

<pre>
"ASSET": {
    "AssetCategory": {
      "masterName": "AssetCategory",
      "moduleDefinition": null,
      "isStateLevel": true,
      "uniqueKeys": [
        "$.id",
        "$.tenantId"
      ]
    },
    "LayerType": {
      "masterName": "LayerType",
      "moduleDefinition": "null",
      "isStateLevel": true,
      "uniqueKeys": [
        "$.name",
        "$.tenantId"
      ]
    },
    "Assetconfiguration": {
      "masterName": "Assetconfiguration",
      "moduleDefinition": "null",
      "isStateLevel": true,
      "uniqueKeys": [
        "$.keyname",
        "$.tenantId"
      ]
    },
    "ModeOfAcquisition": {
      "masterName": "ModeOfAcquisition",
      "moduleDefinition": "null",
      "isStateLevel": true,
      "uniqueKeys": [
        "$.code",
        "$.tenantId"
      ]
    }
  },

</pre>
{: .text-justify}

<b>Usage</b><br>

MDMS is setup as a microservice that exposes the create, update and search API’s to consume the service. The Swagger definition for MDMS is accessible at <a href="#" class="btn btn--primary">https://raw.githubusercontent.com/egovernments/egov-services/master/docs/mdms/contract/mdms-create-v1-0-0.yml</a><br>

Create/Update APIs

Payload for both create and update should have Requestinfo and MasterMetaData, under which tenantId, moduleName and masterName and masterData should be present.

Request Format:

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
{: .text-justify}
For update, the data is updated on the bases of configurations (unique key/primary key constraints) in master-config.json.
If we modify the master-config.json file or any other config file, then respective services must build and deployed for reflecting modifications.
When we build and deploy the service, the application will loads up all our configurations from config files in a map. Whenever the application needs configs, it will get it done from the map.
{: .text-justify}
Search API to search for MDMS Data:<br>
<a href="#"
class="btn--primary">http://egov-micro-dev.egovernments.org/egov-mdms-service/v1/_search</a><br>
The Search API allows filtering of content based on an attribute called filter, that supports JSON filter expressions. Based on filter expression, search API will filter the data and provide the response. Example:
[?(@.id==1||@.id==2)] This expression will filter the master data by where the attribute id  equals 1 or 2.
[?( @.id == 10 && @.tenantId =='default')] This expression will filter the master data by id equals to 10 and tenantId=default.
The Request body must contain RequestInfo and MdmsCriteria, containing the tenantId and moduleDetails. moduleDetails must contain moduleName and masterDetails. Master Details must contain name and filter.<br>
{: .text-justify}
Request Format:
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
</pre>
Response Format:
<pre>
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
{: .text-justify}

<b>Configuring master data for a new Module</b><br>
To enable master data for a new application using MDMS under a tenant, a new folder corresponding to the module name needs to be created under the corresponding tenant. Further entries for the new module and all the masters in the module needs to be made in the master-config file as specified in the Configuration section. After the configuration is completed, the Create and Update APIs can be used to load the Master Data.



Check out the [Jekyll docs][jekyll-docs] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll’s GitHub repo][jekyll-gh]. If you have questions, you can ask them on [Jekyll Talk][jekyll-talk].

[jekyll-docs]: http://jekyllrb.com/docs/home
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-talk]: https://talk.jekyllrb.com/
