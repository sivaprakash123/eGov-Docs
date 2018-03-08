---
layout: post
title:  "Persister"
date:   2018-02-02 14:00:04 +0530
categories: persister
---
<b>Persister service</b>

The eGov Persistor Service allows third party developers to persist data against a backend data store through a set of configurations. Using the persistor service allows configuration of details like the data store to be configured and written on the persistor service without the need to make this change at the individual modules.<br>
The configurations of persistor allows for the following
<li>Mapping of the object attributes with the attributes of the persisted object.</li>
<li>Query configurations</li>
{: .text-justify}
<b>Architecture of Persister</b>
![mdms architecture](/app/docs/images/persister.png){:class="img-responsive"}


Persister service is a common component, which will pick the request from KAFKA queue based on configured topic names in yml configuration, process the request, prepares queries and run queries to persist the data. The yml configuration file path, which is configured in the persister application.properties file are loaded in the application cache memory at the time of deployment of the application.
{: .text-justify}
<b>Persister yml configurations structure</b>
<pre>
The eGov Indexer provides following configurations:
mappings: List of mappings between topic name and respective configurations.
fromTopic: The topic on which the input json will be received, This will be the parent topic for the list of persister configs.
queryMaps: It will have a list of queries and respective json mappings configurations.
query: query, which is to be executed to persist the data in database.
jsonMaps: It is a collection of json paths for mapping json data to query placeholder.
jsonPath: The json path to be configured to map data to the query placeholder.

serviceMaps:
 serviceName: User Service
 mappings:
 - version: 1.0
   name: Module name
   description: Description
   fromTopic: save-asset-maha (unique Topic)
   isTransaction: true
   queryMaps:
    - query: Insert/Update query (eg: INSERT INTO egasset_asset( id, name, code, departmentcode, assetcategory)VALUES (?, ?, ?, ?, ?);)

      basePath: Asset
      jsonMaps:
       - jsonPath: $.Asset.id
       - jsonPath: $.Asset.name
       - jsonPath: $.Asset.code
       - jsonPath: $.Asset.department.code
       - jsonPath: $.Asset.assetCategory.id
</pre>
For more information on json path refer http://goessner.net/articles/JsonPath/

<b>Artifacts</b><br>
The configurations for persister to persist the data is done through  yml configurations. Each new business application would need an accompanying persistor yml file. The location of the yml file is configured in the application.properties of the persistor service. It is recommended that the yml configuration file  be placed under individual module code base under a  persister folder.
The conventions to be followed for placing the yml configuration are
{: .text-justify}
<li>Create config folder in the application.</li>
<li>Create persister folder in config.</li>
<li>Create the yml file in persister and write the configurations as mentioned in Persister yml configurations structure section.</li><br>

<b>Configurations</b><br>
Add the module specific configuration location path in the application.properties of the Persistor Service [TODO -> Need to fix a process for making this change…..]
To make persister identify this config file, we should configure the raw url of the config yml file in persister service application.properties file, with key egov.persist.yml.repo.path. Egov.persist.yml.repo.path will have comma separated raw urls of yml config files.
{: .text-justify}
<b>Example:</b>
egov.persist.yml.repo.path=https://raw.githubusercontent.com/egovernments/egov-services/master/docs/persist-infra/configuration-yaml/swm-service-persist.yaml,<b>https://raw.githubusercontent.com/egovernments/egov-services/master/asset/config/persister/asset-services-maha.yml</b><br>
The highlighted path is an example of how configuration for a new module can be added
Create the module specific configuration file [Need instructions for creating the new configuration file

Note: After all configurations build and deploy both persister and respective integrated service through jenkins.




<b>Calling Persister</b><br/>
Persister works on an asynchronous mode, that allows individual applications to write the object to be persisted in the Kafka queue under a topic name that is configured in the application specific yaml configuration. The steps for using Persistor are mentioned below
{: .text-justify}
<h4>Business Application Responsibility</h4>
<li>Business Application performs the required business validations and process</li>
<li>Creates the model object to be persisted</li>
<li>Pushes the model object to the Kafka queue with the topic name configured in the Persistor YML configuration under the key [KEY_NAME]</li><br>
<h4>Persistor Responsibility</h4>
Persistor service is listening to the Kafka queue for objects published under the topic configured in the Persistor YML configuration under the key [KEY_NAME].
Persistor picks up the object and uses the following configurations to persist the data
{: .text-justify}
<li>Key 1 - > Used to pick up the query</li>
<li>Key 2 -> Used to map the business object to the data store object</li>
Calling persister is similar to handovering request from service to repository through KAFKA. When a create or update endpoint is called, the request is picked by the respective controller, from controller to the service. In service after business logic the request is sent in the queue, with some topic using kafkaTemplate.send() method. The same topic will be configured in persister yml configuration. The persister consumer will be listening for the specific topic. Once the topic is found, the persister will process the respective configurations(query and data binding is done based on json paths configured) corresponding to the sent topic and will be executed.
<br><b>Example:</b><br>
logAwareKafkaTemplate.send(“save-asset-maha”,”save-asset-maha-key”,assetRequest); -> posts the asset business object under the topic “save-asset-maha” with the key “save-asset-maha-key” [What is a key]


<b>Testing Persister</b>

Persister can be tested by initiating a create api from postman, with respective request, which is configured in persister for create. If validation and business logic executes successfully, the request is sent to kafka queue with unique topic name. After placing the request in to kafka queue, the api will give the response back with successful status and sequence generated ids or code(Unique key).
Initiate Search api with ids or codes as request params, which we got from create response. It should return the same json object as we got in create api response, which means persister is working fine.  
{: .text-justify}




Check out the [Jekyll docs][jekyll-docs] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll’s GitHub repo][jekyll-gh]. If you have questions, you can ask them on [Jekyll Talk][jekyll-talk].

[jekyll-docs]: http://jekyllrb.com/docs/home
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-talk]: https://talk.jekyllrb.com/
