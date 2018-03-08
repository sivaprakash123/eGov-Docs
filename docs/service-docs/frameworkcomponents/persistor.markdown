---
layout: post
date:   2018-02-02 14:00:04 +0530
categories: persister
---
<b>Persister service</b>

The eGov Persistor Service allows third party developers to persist data against a backend data store through a set of configurations defined at an individual business module level. Any data persistence errors or exceptions are logged on the Error Queue (a Kafka queue) to enable Application Monitoring at the platform level. Individual business modules can also subscribe to these errors to perform business module specific error handling.<br>
{: .text-justify}
<b>Architecture</b>
![mdms architecture](/app/docs/images/persister.png){:class="img-responsive"}

Persistor service listens to the configured Kafka topics, processes the records against the business module specific yaml configuration, and persists data against a configured data store. Each new business application would need an accompanying persistor yml file. The location of the yml file is configured in the application.properties of the persistor service with the key egov.persist.yml.repo.path. Egov.persist.yml.repo.path will have comma separated raw urls of yml config files for all modules. It is recommended that the yml configuration file  be placed under individual module code base under a  persister folder.
{: .text-justify}
<b>Configurations</b><br>
Each module specific yaml configuration needs to be of the following format.<br>


<pre>
serviceMaps:
 serviceName: [SERVICE_NAME]
 mappings:
 - version: 1.0
   name: [MODULE_NAME]
   description: [DESCRIPTION]
   fromTopic: [TOPIC_NAME]
   isTransaction: [true/false]
   queryMaps:
    - query: [QUERY]
      basePath: [BASE_PATH_OF_MESSAGE]
      jsonMaps:

       - jsonPath: [PATH_TO_MAP_QUERY_PARAM_1]

       - jsonPath: [PATH_TO_MAP_QUERY_PARAM_2]

       - jsonPath: [PATH_TO_MAP_QUERY_PARAM_3]
</pre>
{: .text-justify}
Where
<li>[SERVICE_NAME] is the name of the service</li>
<li>[MODULE_NAME] is to be replaced with the module name</li>
<li>[DESCRIPTION] is a short description of what the query does</li>
<li>[TOPIC_NAME] is the name of the topic to listen to</li>
<li>[QUERY] is the query to be configured along with the query parameters</li>
<li>[BASE_PATH_OF_MESSAGE] is the base path to use for the json paths</li>
<li>[PATH_TO_MAP_QUERY_PARAM_1],[PATH_TO_MAP_QUERY_PARAM_2],
[PATH_TO_MAP_QUERY_PARAM_3] are the fully qualified json paths</li>
{: .text-justify}

Example:
<pre>
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

  <b>Usage</b><br>     
      Persister works on an asynchronous mode, that allows individual applications to write the object to be persisted in the Kafka queue under a topic name that is configured in the business module specific yaml configuration. The steps for using Persistor are mentioned below:

      Business Application Responsibility

      <li>Business Application performs the required business validations and process</li>
      <li>Creates the model object to be persisted</li>
      <li>Pushes the model object to the Kafka queue with the topic name configured in the Persistor YML configuration under the key fromTopic</li>

      Persistor Responsibility

      <li>Persistor service listens to the Kafka queue for objects published under the topic configured in the Persistor YML configuration under the key fromTopic</li>
      <li>Persistor picks up the object and uses the yaml configuration to persist the data</li>

     Configuration for a new module.

     Configuring a new module to be used by Persistor involves the following

    <li>Append the module config file to the Persistor Application.Properties</li>
    <li> Write the module config file as explained in the Configuration section</li>
    <li>Restart the Persistor service to reload the configurations</li>



Check out the [Jekyll docs][jekyll-docs] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll’s GitHub repo][jekyll-gh]. If you have questions, you can ask them on [Jekyll Talk][jekyll-talk].

[jekyll-docs]: http://jekyllrb.com/docs/home
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-talk]: https://talk.jekyllrb.com/
