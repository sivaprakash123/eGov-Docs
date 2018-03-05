---
type: landing
directory: environmentsetup
keywords: 'Installation setup, pre requisite'
published: true
allowSearch: true
categories : prerequisite
layout : post
---

##**Prerequisites**##><br>

The following are the technologies that a developer needs to be familiar with:<br>
<li>Java</li>
<li>Spring Boot [Recommended reading:
Knowledge on asynchronous processing (The eGov platform uses Kafka for the Pub-Sub mechanism)
RDBMS to be able to build the schema for any new modules to be developed</li>
<li>JSON and JSON Paths</li>
<li>REST API and using Swagger to build and understand API contracts</li>
<li>Maven</li>
<li>Swagger to document the API definitions and documentation (see section below for further information on Swagger).</li>
{: .text-justify}
  <b>Hardware</b><br>
The hardware suggestions is given for the recommended configuration of deploying only the modules being developed in the local environment. For the purpose of development, it is recommended that only a maximum of 3 modules would be deployed locally and the rest would be referred to from the eGov dev environment
{: .text-justify}
<li>Memory - 8GB</li>
<li>Processor Speed - 2GHz</li>
<li>Disk Space - 250 GB</li>
{: .text-justify}
  <b>Software</b><br>
The following are required in the Dev environment for a developer to successfully deploy and configure the components required to develop against the eGov services
{: .text-justify}
<li>Java (Version 8, available for free download at

[Java8](https://java.com/en/download/) <br>
  </li>
<li>Spring Boot (This allows individual services to be run in the local environment)
Download the latest version from the URL
[Springboot](https://projects.spring.io/spring-boot/) <br> </li>
<li>Postgres (9.6+) - This would be used as the local DB instance to persist data for the modules that are being developed in your environment. Download the latest version (9.6 or higher) from the URL
[Postgresql](https://www.postgresql.org/download/) <br> </li>
<li>Minikube and Docker -> This is required if the individual services are being run as local docker instances in the development environment. The hypervisor and other dependencies of Minikube can be found in the installation instructions for minikube accessible at[kubernetes](https://kubernetes.io/docs/tasks/tools/install-minikube) <br>  
Docker can be downloaded from the URL
[Docker](https://www.docker.com/community-edition) <br> </li>
<li>Kafka to deploy local pub/sub services. Download Kafka from
[Kafka](https://kafka.apache.org/downloads) <br> </li>
<li>Postman as the REST client -> This is optional as you can use other tools of your choice to make REST api calls to your locally developed services</li>
