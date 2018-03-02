---
type: landing
directory: usecase
description: usecase
keywords: usecase
published: true
allowSearch: true
categories : pgr
layout : post
---

<b>PGR (Public Grievance Redressal)</b><br>

The PGR Business application are a set of API’s written using the Open311 API standards to meet the needs of a citizen to raise public grievance(s). The API’s for the module allows the module to be used for other “Grievance Redressal” scenarios in the health, sanitation and similar areas of governance.
{: .text-justify}


<b>Setting up a new Tenant<b><br>

<li>Setup a new tenant using the tenant/_create API</li>
<li>Parameters required for the tenant are</li>
{: .text-justify}
     Tenant Code
     Tenant Name
     Tenant Description
     Cities for the tenant
     ImageId, LogoId
     Domain URL
     Contact Numbers

<b>Configuring Grievance types and SLA’s</b><br>
Grievance Types and its SLA’s can be loaded using the Data Uploader interface.
Adding Employees.

Employees can be added using the /employee/_create API.
