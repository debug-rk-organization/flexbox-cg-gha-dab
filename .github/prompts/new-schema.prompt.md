---
mode: 'agent'
tools: ['githubRepo', 'codebase']
description: 'Add a new schema to the project'
---
Your goal is to generate the ddl sql, python, configuration, and workflow tasks needed to populate a new schema.

Ask for the schema name if not provided.
The name should start with "bronze_", "silver_" or "gold_".
Ask if I want to include the processing for the new schema in an existing workflow or create a new one.

Requirements for the schema:
* Create a new folder with the same name as the schema under the main project folder.
* Create a subdirectory etl within this folder.
* Add the configuration entries for the schema name.

* Add a simple etl.py file to the etl folder that ingests data into the schema using any mechanism my instructions provide.  If i don't provide instructions, assume I want to read the data from a file.
* Invoke the etl.py file from whatever workflow I specify.  Don't forget to include an entry point to the project.scripts section of pyproject.toml
