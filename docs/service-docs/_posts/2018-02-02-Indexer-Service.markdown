---
layout: post
title:  "Indexer service"
date:   2018-02-01 14:00:04 +0530
categories: indexer

---

<b>Indexer</b>

The eGov Indexer allows third party developers to index data through a set of configurations. The service allows configuration of details like the data to be configured and written on the indexer service without the need to create indexer components for individual modules. The service is designed to perform all the indexing tasks of the egov platform. The service reads records posted on specific kafka topics and picks the corresponding index configuration from the yaml file provided by the respective module.
{: .text-justify}
The configurations of indexer allows for the following
Multiple indexes of a record posted on a single topic.
Provision for custom index id.
Performs both bulk and non-bulk indexing.
Supports custom json indexing with field mappings, Enrichment of the input object on the queue.
Performs Elastic Search down handling.
{: .text-justify}
<b>Architecture of Indexer</b>
![mdms architecture](/app/docs/images/Indexer arch.png){:class="img-responsive"}


Indexer service is a common component, which will pick the request from KAFKA queue based on configured topic names in yml configuration, and process the request against yml configurations, if the uriMapping is configured, then the indexer calls the specified api with configured details. Once the indexer receives the response, it will map the response data to json, which is specified in index mapping and index the json data. The Indexer service will pull all configurations from git, which are specified in the path, and store in cache on loading the service.
{: .text-justify}
<b>Indexer yml configuration structure</b>
<pre>
  <b>The eGov Indexer provides following configurations:</b><br>
<b> - mappings:</b> List of mappings between topic name and respective index configurations.<br>
<b> - topic:</b> The topic on which the input json will be received, This will be the parent topic for the list of index configs.<br>
<b> - indexes:</b> List of index configuration to be applied on the input json received on the parent topic.<br>
<b> - name:</b> name of the index.<br>
<b> - type:</b> document type.<br>
<b> - id:</b> Json path of the id to be used as index id while indexing. This takes comma separated Json paths to build custom index id. Values will be fetched from the json path and concatenated to form the indexId.<br>
<b> - isBulk:</b> boolean value to signify if the input is a json array or json object, true in the first case, false otherwise.<br> <b>Note:</b> if isBulk = true, indexer will accept only array of json objects as input.<br>
<b> - jsonPath:</b> Json Node path in case just a piece of the input json is to be indexed.<br>
<b> - customJsonMapping:</b> Set of mappings for building an entirely new json object to index onto ES.<br>
<b> - indexMapping:</b> Sample output json which will get indexed on to ES. This has to be provided by the respective module, if not provided, framework will fetch it from the ES. It is recommended to provide this.<br>
<b> - fieldMapping:</b> This is a list of mappings between fields of input and output json namely: inJsonPath and outJsonPath. It takes inJsonPath value from input json and puts it to outJsonPath field of output json.
<b> - uriMapping:</b> This takes uri, queryParam, pathParam and apiRequest as to first build the uri and hit the service to get the response and then takes a list of fieldMappings as above to map fields of the api response to the fields of output json.

 <b>Note:</b> "$" is to be specified as place holder in the uri path wherever the pathParam is to be substituted in order. queryParams should be comma separated.
</pre>
<b>Example:</b>
<pre>
ServiceMaps:
 serviceName: Water Charges (Module name)
 version: 1.0.0
 mappings:
  - topic: egov.wcms.newconnection-create (KAFKA topic)
    indexes:
    - name: watercharges	 (Indexer name)
      type: consumerdetails 	 (Indexer type)
      id: $.Connection.id,$.Connection.tenantId (The data is indexed based on this id. If it is not provided then the indexer will create one id and index the data)
      isBulk: false
      jsonPath: (If part of data is to be indexed then configure details below in custom json mapping)
      customJsonMapping:
        indexMapping: {"ConnectionIndex":{"ConnectionDetailsEs":{"id":13567,"connectionType":"PERMANENT","applicationType":"NEWCONNECTION","hscPipeSizeType":19.05,"pipesizeId":18,"executionDate":null,"supplyType":"SemiBulkType","noOfFlats":0,"supplyTypeId":11}}} 	(Sample Json, in which data is mapped from json paths configured below)
        fieldMapping:
        - inJsonPath: $.Connection.supplyType (Input json path)
          outJsonPath: $.ConnectionIndex.ConnectionDetailsEs.supplyType (data mapping from input json to sample json)
        - inJsonPath: $.Connection.hscPipeSizeType
          outJsonPath: $.ConnectionIndex.ConnectionDetailsEs.hscPipeSizeType
 uriMapping: (to be configured If the data which is to be indexed, is to get from any other api)
     - path: http://hr-employee:8080/hr-employee/employees/73/positions/_search (api from which data is to be fetched)
       queryParam: tenantId = $.Connection.tenantId (Comma separated query params)
       pathParam: $.Connection.id (comma separated path params)
       apiRequest: {"RequestInfo": {"apiId": "org.egov.pt","ver": "1.0","ts": 1502890899493,"action": "asd","did": "4354648646","key": "xyz","msgId": "654654", "requesterId": "61",
       "authToken": "750d4aa9-2436-4bc4-a8f4-3796e3bfd465","userInfo":{"id":73}}}(Sample api request body)
       uriResponseMapping:		(Response mapping)
       - inJsonPath: $.Position[0].id	(From path)
         outJsonPath: $.ConnectionIndex.ConnectionDetailsEs.hscPipeSizeType (To path)
       - inJsonPath: $.Position[0].deptdesig.designation.name
         outJsonPath: $.ConnectionIndex.ConnectionDetailsEs.connectionType
</pre>





<b>Configurations</b>

Add the module specific configuration location path in the application.properties of the Indexer Service. The Indexer service will pull all configurations from git, which are specified in the path, and store in cache on loading the service. So after all configurations build and deploy Indexer service through jenkins.
{: .text-justify}
<b>Example:</b>

egov.indexer.yml.repo.path=https://raw.githubusercontent.com/egovernments/egov-services/master/core/egov-indexer/src/main/resources/swm-service-indexer.yml,https://raw.githubusercontent.com/egovernments/egov-services/master/core/egov-indexer/src/main/resources/watercharges-indexer.yml
The highlighted path is an example of how configuration for a new module can be added

<b>Calling Indexer component</b>

Indexer service works on an asynchronous mode, that allows individual applications to write the object to be indexed in the Kafka queue under a topic name that is configured in the application specific yaml configuration. The steps for using Indexer are mentioned below
{: .text-justify}
Business Application Responsibility
Business Application performs the required business validations and process
Creates the model object to be indexed.
Pushes the model object to the Kafka queue with the topic name configured in the Indexer yml configuration under the key [KEY_NAME]

Indexer Responsibility
Indexer service will be listening to the Kafka queue for objects published under the topic configured in the indexer yml configuration under the key [KEY_NAME]
Indexer picks up the object and uses the following configurations to to process the data and index.
{: .text-justify}
As both Persister and Indexer services are maid to store the data, If there is a requirement to store the data both in database as well as in indexer. In that case we can configure the same topic in both services, so that both will be listening to the same topic, once they will find the topic, both services start doing their respective tasks.
{: .text-justify}
<b>Testing Indexer component</b>

Indexer can be tested by initiating a create api from postman, with respective request, which is configured in indexer for create. If validation and business logic executes successfully, the request is sent to kafka queue with unique topic name. After placing the request in to kafka queue, the api will give the response back with successful status and sequence generated ids or code(Unique key).
{: .text-justify}
