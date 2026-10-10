---
mode: 'agent'
tools: ['githubRepo', 'codebase']
description: 'Add a new API data source to the project'
---
Your goal is to create a pyspark custom data source which can be used to stream data from the source API into a streaming data frame and then write it to a delta table.

Ask for the name of the API or openapi url if not provided.
Create configuration items in our configuration yaml that contains the url.
Create configuration items in our configuration yaml that reference databricks secret scope locations where the api credentials will be stored.
Ask if I want to process the data as streaming or batch.

Requirements for the data source:
* Attempt to locate an existing REST client in PyPI that can be used to connect to the API.  If one exists, use it.
* Create a new folder with the same name as the data source under the main project folder.
* Implement the pyspark custom data source in the new folder.
* Create a python file in the etl folder that uses the custom data source to read data from the API and write it to a delta table.
