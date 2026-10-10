## Python

* We use uv for managing our Python dependencies, not pip, so when talking about python packages, always give me instructions and code samples that use uv.

* We use normal python for production code, so when talking about production code, always give me instructions and code samples that use normal Python following best practices like PEP 8 guidelines and meaningful variable names.

* When adding a python module to a workflow, don't forget to add an entry to the project.scripts section of pyproject.toml

* We write our tests using pytest, so when talking about testing, always give me instructions and code samples that use pytest.

* We pass params to our python scripts using argparse.  Always give me instructions and code samples that use argparse for passing parameters to Python scripts.  Don't forget to map the parameters to input values in the databricks workflow yaml.

* We don't use databricks widgets, so when talking about user input in Databricks notebooks, always use argparse instead of widgets.

* to get a spark context we use get_spark() in common.py.

* to get dbutils we use get_dbutils() in common.py.

* We sometimes use jupyter notebooks for exploratory data analysis, so when talking about notebooks place these notebooks in the scratch folder.

* When adding test data for integration tests, place it in the fixtures folder.

* When writing integration tests, use the pytest.mark.integration marker.

* When writing integration tests that need spark, use fixtures that are provided in test/integration/conftest.py

* When writing unit tests, use the pytest.mark.unit marker.

* We use ruff for python formatting, so when talking about formatting, always give me instructions and code samples that use ruff.

* Always include a python boilerplate at the bottom of python files in etl folders so they can be run & debugged as scripts easily.

* We store common functions that can be used across python files in flexbox_cg_gha_dab/common.py.

* to get a logger we use get_logger() in common.py.

## Databricks/Spark
* Include the spark_env_vars PIP_EXTRA_INDEX_URL and ENVIRONMENT in all cluster configurations in databricks yaml.  Use the values that already exist in the provided yaml files.

*  When managing schema, use merge schema and schema evolution, so when talking about schema management or ddl give me examples and instructions that use merge schema and schema evolution.

* we typically use pyspark for data processing, so when talking about data processing, always give me instructions and code samples that use PySpark.

* When dealing with sql, default to databricks compatible sql unless I say otherwise.

* We store our secrets in databricks secret scopes, so when talking about secrets management, always give me instructions and code samples that use Databricks secrets.

## Orchestration

* We handle orchestration using databricks workflows.  When talking about orchestration, always give me instructions and code samples that use Databricks workflows.

* If we need to do the same operation on multiple tables, use the for-each task in the databricks workflow yaml.

* We manage our databricks workflows using YAML files in the resources folder.

* We deploy our databricks workflows using databricks asset bundles.  When talking about deployment, always give me instructions and code samples that use Databricks asset bundles.

* We prefer to trigger our workflows from file arrival or table triggers, but fall back to cron scheduling if necassary.


## Configuration

* We use the P&G databricks configuration library pg-de-cf-databricks-configuration to manage our databricks configurations, so when talking about databricks configurations, always give me instructions and code samples that use the pg-de-cf-databricks-configuration library.

* We use separate environment configuration yaml files to store values depending on the deployment environment.

* We keep our configuration files in the flexbox_cg_gha_dab/config folder.

* To get a configuration dict, use Configuration.load_for_default_environment(__file__, dbutils).

* Our configuration library resolves secrets in the yaml files in the format secrets/<secret-scope-name>/<secret name>

* We store our configuration in yaml files named for each environment, so when talking about configuration management, always give me instructions and code samples that use YAML files.

* Always store infrastructure specific values such as database names, table names, schema names, api urls, and other related configurations in the environment specific configuration file.


## Documentation

* We store our documentation in the doc in markdown format.

* We document our workflows using mermaid diagrams and descriptions in doc/technical.md.

* We document key contacts, azure resources used, scheduled maintenance, and common issues in doc/operations.md.

* When making changes to a workflow, always update the documentation in doc/technical.md and doc/operations.md.


## P&G and Core Data Lake (CDL) specifics.

* P&G Jfrog hosts our python packages and it is located at this URL: https://png.jfrog.io/.  Include this url any time you need me to provide a P&G python package.

## infrastructure
* When creating a completely new cluster configuration, always default to node_type_id "Standard_F4" and match the databricks runtime to the other workflows in this project.

* Determine which node_type I am currently using by looking at the node_type_id field in the yaml files in the resources folder.

* If I ask to change the node type in my cluster configurations, "scale up", or "scale down", please recommend options to me from table below.
  When giving me node type options always reference them with the node_type field.
  When giving me node type options, always provide cost, number of cores, memory, and disk space.
  When giving me node type options, Never recommend node types that have gpu_count greater than 0 unless I specifically ask for a GPU node type.
  When giving me node type options, Always recommend the lowest dbu_cost node_type that matches my criteria.
  When giving me node type options, If I ask to scale up or down, assume I want to use the same node_family as I am already using unless I say otherwise.
  When giving me node type options, Do not recommend a node_type with a resource_disk_size_in_mb greater than 0 unless I specify that I want a resource disk.
  When giving me node type options, If I don't provide enough details, give preference to F and D node_family with 0 gpu_count and 0 resource_disk_size_in_mb.
  When giving me node type options, Only recommend the latest node_version available for a selected node_size.

| node_type                | node_family | node_series | node_size    | node_version | dbu_cost | number_of_cores | memory_in_mb | resource_disk_size_in_mb | gpu_count |
| ------------------------ | ----------- | ----------- | ------------ | ------------ | -------- | --------------- | ------------ | ------------------------ | --------- |
| Standard_NC96ads_A100_v4 | NC          | NCads_A     | NC96ads_A100 | 4            | 8.81     | 96              | 901120       | 262144                   | 4         |
| Standard_NC64as_T4_v3    | NC          | NCas_T      | NC64as_T4    | 3            | 2.611    | 64              | 450560       | 2883584                  | 4         |
| Standard_NC24s_v3        | NC          | NCs         | NC24s        | 3            | 7.34     | 24              | 458752       | 3018752                  | 4         |
| Standard_NV72ads_A10_v5  | NV          | NVads_A     | NV72ads_A10  | 5            | 3.912    | 72              | 901120       | 2949120                  | 2         |
| Standard_NC48ads_A100_v4 | NC          | NCads_A     | NC48ads_A100 | 4            | 4.408    | 48              | 450560       | 131072                   | 2         |
| Standard_NC12s_v3        | NC          | NCs         | NC12s        | 3            | 3.67     | 12              | 229376       | 1509376                  | 2         |
| Standard_NC40ads_H100_v5 | NC          | NCads_H     | NC40ads_H100 | 5            | 4.188    | 40              | 327680       | 131072                   | 1         |
| Standard_NV36ads_A10_v5  | NV          | NVads_A     | NV36ads_A10  | 5            | 1.92     | 36              | 450560       | 1474560                  | 1         |
| Standard_NC24ads_A100_v4 | NC          | NCads_A     | NC24ads_A100 | 4            | 2.204    | 24              | 225280       | 65536                    | 1         |
| Standard_NC16as_T4_v3    | NC          | NCas_T      | NC16as_T4    | 3            | 0.722    | 16              | 112640       | 360448                   | 1         |
| Standard_NC8as_T4_v3     | NC          | NCas_T      | NC8as_T4     | 3            | 0.4512   | 8               | 57344        | 360448                   | 1         |
| Standard_NC6s_v3         | NC          | NCs         | NC6s         | 3            | 1.84     | 6               | 114688       | 753664                   | 1         |
| Standard_NC4as_T4_v3     | NC          | NCas_T      | NC4as_T4     | 3            | 0.3156   | 4               | 28672        | 180224                   | 1         |
| Standard_E96ads_v5       | E           | Eads        | E96ads       | 5            | 3.773    | 96              | 688128       | 3686400                  | 0         |
| Standard_E96ds_v5        | E           | Eds         | E96ds        | 5            | 4.147    | 96              | 688128       | 3686400                  | 0         |
| Standard_E96a_v4         | E           | Ea          | E96a         | 4            | 3.629    | 96              | 688128       | 2457600                  | 0         |
| Standard_E96as_v4        | E           | Eas         | E96as        | 4            | 3.629    | 96              | 688128       | 1376256                  | 0         |
| Standard_E96as_v5        | E           | Eas         | E96as        | 5            | 3.254    | 96              | 688128       | 0                        | 0         |
| Standard_E96s_v5         | E           | Es          | E96s         | 5            | 3.629    | 96              | 688128       | 0                        | 0         |
| Standard_D96ads_v5       | D           | Dads        | D96ads       | 5            | 2.966    | 96              | 393216       | 3686400                  | 0         |
| Standard_D96ds_v5        | D           | Dds         | D96ds        | 5            | 3.254    | 96              | 393216       | 3686400                  | 0         |
| Standard_D96a_v4         | D           | Da          | D96a         | 4            | 2.765    | 96              | 393216       | 2457600                  | 0         |
| Standard_D96as_v4        | D           | Das         | D96as        | 4            | 2.765    | 96              | 393216       | 786432                   | 0         |
| Standard_D96as_v5        | D           | Das         | D96as        | 5            | 2.477    | 96              | 393216       | 0                        | 0         |
| Standard_D96s_v5         | D           | Ds          | D96s         | 5            | 2.765    | 96              | 393216       | 0                        | 0         |
| Standard_L80as_v3        | L           | Las         | L80as        | 3            | 3.744    | 80              | 655360       | 819200                   | 0         |
| Standard_L80s_v2         | L           | Ls          | L80s         | 2            | 3.744    | 80              | 655360       | 819200                   | 0         |
| Standard_E80ids_v4       | E           | Eids        | E80ids       | 4            | 3.456    | 80              | 516096       | 2457600                  | 0         |
| Standard_F72s_v2         | F           | Fs          | F72s         | 2            | 1.82     | 72              | 147456       | 589824                   | 0         |
| Standard_E64ads_v5       | E           | Eads        | E64ads       | 5            | 2.515    | 64              | 524288       | 2457600                  | 0         |
| Standard_E64ds_v5        | E           | Eds         | E64ds        | 5            | 2.765    | 64              | 524288       | 2457600                  | 0         |
| Standard_E64a_v4         | E           | Ea          | E64a         | 4            | 2.419    | 64              | 524288       | 1638400                  | 0         |
| Standard_E64as_v4        | E           | Eas         | E64as        | 4            | 2.419    | 64              | 524288       | 884736                   | 0         |
| Standard_L64as_v3        | L           | Las         | L64as        | 3            | 2.995    | 64              | 524288       | 655360                   | 0         |
| Standard_L64s_v2         | L           | Ls          | L64s         | 2            | 2.995    | 64              | 524288       | 655360                   | 0         |
| Standard_L64s_v3         | L           | Ls          | L64s         | 3            | 3.35     | 64              | 524288       | 655360                   | 0         |
| Standard_E64as_v5        | E           | Eas         | E64as        | 5            | 2.17     | 64              | 524288       | 0                        | 0         |
| Standard_E64s_v5         | E           | Es          | E64s         | 5            | 2.419    | 64              | 524288       | 0                        | 0         |
| Standard_E64d_v4         | E           | Ed          | E64d         | 4            | 2.765    | 64              | 516096       | 2457600                  | 0         |
| Standard_E64ds_v4        | E           | Eds         | E64ds        | 4            | 2.765    | 64              | 516096       | 2457600                  | 0         |
| Standard_E64_v3          | E           | E           | E64          | 3            | 2.177    | 64              | 442368       | 1638400                  | 0         |
| Standard_E64s_v3         | E           | Es          | E64s         | 3            | 2.177    | 64              | 442368       | 884736                   | 0         |
| Standard_D64ads_v5       | D           | Dads        | D64ads       | 5            | 1.978    | 64              | 262144       | 2457600                  | 0         |
| Standard_D64d_v4         | D           | Dd          | D64d         | 4            | 2.17     | 64              | 262144       | 2457600                  | 0         |
| Standard_D64ds_v4        | D           | Dds         | D64ds        | 4            | 2.17     | 64              | 262144       | 2457600                  | 0         |
| Standard_D64ds_v5        | D           | Dds         | D64ds        | 5            | 2.17     | 64              | 262144       | 2457600                  | 0         |
| Standard_D64_v3          | D           | D           | D64          | 3            | 1.843    | 64              | 262144       | 1638400                  | 0         |
| Standard_D64a_v4         | D           | Da          | D64a         | 4            | 1.843    | 64              | 262144       | 1638400                  | 0         |
| Standard_D64as_v4        | D           | Das         | D64as        | 4            | 1.843    | 64              | 262144       | 524288                   | 0         |
| Standard_D64s_v3         | D           | Ds          | D64s         | 3            | 1.843    | 64              | 262144       | 524288                   | 0         |
| Standard_D64as_v5        | D           | Das         | D64as        | 5            | 1.651    | 64              | 262144       | 0                        | 0         |
| Standard_F64s_v2         | F           | Fs          | F64s         | 2            | 1.62     | 64              | 131072       | 524288                   | 0         |
| Standard_E48ads_v5       | E           | Eads        | E48ads       | 5            | 1.886    | 48              | 393216       | 1843200                  | 0         |
| Standard_E48d_v4         | E           | Ed          | E48d         | 4            | 2.074    | 48              | 393216       | 1843200                  | 0         |
| Standard_E48ds_v4        | E           | Eds         | E48ds        | 4            | 2.074    | 48              | 393216       | 1843200                  | 0         |
| Standard_E48ds_v5        | E           | Eds         | E48ds        | 5            | 2.074    | 48              | 393216       | 1843200                  | 0         |
| Standard_E48a_v4         | E           | Ea          | E48a         | 4            | 1.814    | 48              | 393216       | 1228800                  | 0         |
| Standard_E48as_v4        | E           | Eas         | E48as        | 4            | 1.814    | 48              | 393216       | 786432                   | 0         |
| Standard_L48as_v3        | L           | Las         | L48as        | 3            | 2.246    | 48              | 393216       | 491520                   | 0         |
| Standard_L48s_v3         | L           | Ls          | L48s         | 3            | 2.513    | 48              | 393216       | 491520                   | 0         |
| Standard_E48as_v5        | E           | Eas         | E48as        | 5            | 1.627    | 48              | 393216       | 0                        | 0         |
| Standard_D48ads_v5       | D           | Dads        | D48ads       | 5            | 1.483    | 48              | 196608       | 1843200                  | 0         |
| Standard_D48ds_v5        | D           | Dds         | D48ds        | 5            | 1.627    | 48              | 196608       | 1843200                  | 0         |
| Standard_D48a_v4         | D           | Da          | D48a         | 4            | 1.382    | 48              | 196608       | 1228800                  | 0         |
| Standard_D48as_v4        | D           | Das         | D48as        | 4            | 1.382    | 48              | 196608       | 393216                   | 0         |
| Standard_D48as_v5        | D           | Das         | D48as        | 5            | 1.238    | 48              | 196608       | 0                        | 0         |
| Standard_D48s_v5         | D           | Ds          | D48s         | 5            | 1.382    | 48              | 196608       | 0                        | 0         |
| Standard_L32s            | L           | Ls          | L32s         | null         | 1.648    | 32              | 262144       | 5765120                  | 0         |
| Standard_E32ads_v5       | E           | Eads        | E32ads       | 5            | 1.258    | 32              | 262144       | 1228800                  | 0         |
| Standard_E32d_v4         | E           | Ed          | E32d         | 4            | 1.382    | 32              | 262144       | 1228800                  | 0         |
| Standard_E32ds_v4        | E           | Eds         | E32ds        | 4            | 1.382    | 32              | 262144       | 1228800                  | 0         |
| Standard_E32ds_v5        | E           | Eds         | E32ds        | 5            | 1.382    | 32              | 262144       | 1228800                  | 0         |
| Standard_E32_v3          | E           | E           | E32          | 3            | 1.277    | 32              | 262144       | 819200                   | 0         |
| Standard_E32a_v4         | E           | Ea          | E32a         | 4            | 1.21     | 32              | 262144       | 819200                   | 0         |
| Standard_E32as_v4        | E           | Eas         | E32as        | 4            | 1.21     | 32              | 262144       | 524288                   | 0         |
| Standard_E32s_v3         | E           | Es          | E32s         | 3            | 1.277    | 32              | 262144       | 524288                   | 0         |
| Standard_L32as_v3        | L           | Las         | L32as        | 3            | 1.498    | 32              | 262144       | 327680                   | 0         |
| Standard_L32s_v2         | L           | Ls          | L32s         | 2            | 1.498    | 32              | 262144       | 327680                   | 0         |
| Standard_L32s_v3         | L           | Ls          | L32s         | 3            | 1.675    | 32              | 262144       | 327680                   | 0         |
| Standard_E32as_v5        | E           | Eas         | E32as        | 5            | 1.085    | 32              | 262144       | 0                        | 0         |
| Standard_E32s_v4         | E           | Es          | E32s         | 4            | 1.21     | 32              | 262144       | 0                        | 0         |
| Standard_E32s_v5         | E           | Es          | E32s         | 5            | 1.21     | 32              | 262144       | 0                        | 0         |
| Standard_D32ads_v5       | D           | Dads        | D32ads       | 5            | 0.989    | 32              | 131072       | 1228800                  | 0         |
| Standard_D32d_v4         | D           | Dd          | D32d         | 4            | 1.085    | 32              | 131072       | 1228800                  | 0         |
| Standard_D32ds_v4        | D           | Dds         | D32ds        | 4            | 1.085    | 32              | 131072       | 1228800                  | 0         |
| Standard_D32ds_v5        | D           | Dds         | D32ds        | 5            | 1.085    | 32              | 131072       | 1228800                  | 0         |
| Standard_D32_v3          | D           | D           | D32          | 3            | 0.922    | 32              | 131072       | 819200                   | 0         |
| Standard_D32a_v4         | D           | Da          | D32a         | 4            | 0.922    | 32              | 131072       | 819200                   | 0         |
| Standard_D32as_v4        | D           | Das         | D32as        | 4            | 0.922    | 32              | 131072       | 262144                   | 0         |
| Standard_D32s_v3         | D           | Ds          | D32s         | 3            | 0.922    | 32              | 131072       | 262144                   | 0         |
| Standard_D32as_v5        | D           | Das         | D32as        | 5            | 0.826    | 32              | 131072       | 0                        | 0         |
| Standard_D32pds_v6       | D           | Dpds        | D32pds       | 6            | 0.881    | 32              | 131072       | 0                        | 0         |
| Standard_D32s_v4         | D           | Ds          | D32s         | 4            | 0.922    | 32              | 131072       | 0                        | 0         |
| Standard_D32s_v5         | D           | Ds          | D32s         | 5            | 0.922    | 32              | 131072       | 0                        | 0         |
| Standard_F32s_v2         | F           | Fs          | F32s         | 2            | 0.812    | 32              | 65536        | 262144                   | 0         |
| Standard_E20ads_v5       | E           | Eads        | E20ads       | 5            | 0.786    | 20              | 163840       | 768000                   | 0         |
| Standard_E20d_v4         | E           | Ed          | E20d         | 4            | 0.864    | 20              | 163840       | 768000                   | 0         |
| Standard_E20ds_v4        | E           | Eds         | E20ds        | 4            | 0.864    | 20              | 163840       | 768000                   | 0         |
| Standard_E20ds_v5        | E           | Eds         | E20ds        | 5            | 0.864    | 20              | 163840       | 768000                   | 0         |
| Standard_E20a_v4         | E           | Ea          | E20a         | 4            | 0.756    | 20              | 163840       | 512000                   | 0         |
| Standard_E20as_v4        | E           | Eas         | E20as        | 4            | 0.756    | 20              | 163840       | 327680                   | 0         |
| Standard_E20as_v5        | E           | Eas         | E20as        | 5            | 0.678    | 20              | 163840       | 0                        | 0         |
| Standard_E20s_v4         | E           | Es          | E20s         | 4            | 0.756    | 20              | 163840       | 0                        | 0         |
| Standard_E20s_v5         | E           | Es          | E20s         | 5            | 0.756    | 20              | 163840       | 0                        | 0         |
| Standard_D15_v2          | D           | D           | D15          | 2            | 0.897    | 20              | 143360       | 1024000                  | 0         |
| Standard_DS15_v2         | DS          | DS          | DS15         | 2            | 0.897    | 20              | 143360       | 286720                   | 0         |
| Standard_L16s            | L           | Ls          | L16s         | null         | 0.824    | 16              | 131072       | 2874368                  | 0         |
| Standard_E16ads_v5       | E           | Eads        | E16ads       | 5            | 0.629    | 16              | 131072       | 614400                   | 0         |
| Standard_E16d_v4         | E           | Ed          | E16d         | 4            | 0.691    | 16              | 131072       | 614400                   | 0         |
| Standard_E16ds_v4        | E           | Eds         | E16ds        | 4            | 0.691    | 16              | 131072       | 614400                   | 0         |
| Standard_E16ds_v5        | E           | Eds         | E16ds        | 5            | 0.6912   | 16              | 131072       | 614400                   | 0         |
| Standard_E16_v3          | E           | E           | E16          | 3            | 0.638    | 16              | 131072       | 409600                   | 0         |
| Standard_E16a_v4         | E           | Ea          | E16a         | 4            | 0.605    | 16              | 131072       | 409600                   | 0         |
| Standard_E16as_v4        | E           | Eas         | E16as        | 4            | 0.605    | 16              | 131072       | 262144                   | 0         |
| Standard_E16s_v3         | E           | Es          | E16s         | 3            | 0.638    | 16              | 131072       | 262144                   | 0         |
| Standard_L16as_v3        | L           | Las         | L16as        | 3            | 0.749    | 16              | 131072       | 163840                   | 0         |
| Standard_L16s_v2         | L           | Ls          | L16s         | 2            | 0.749    | 16              | 131072       | 163840                   | 0         |
| Standard_L16s_v3         | L           | Ls          | L16s         | 3            | 0.838    | 16              | 131072       | 163840                   | 0         |
| Standard_E16as_v5        | E           | Eas         | E16as        | 5            | 0.5424   | 16              | 131072       | 0                        | 0         |
| Standard_E16pds_v6       | E           | Epds        | E16pds       | 6            | 0.5616   | 16              | 131072       | 0                        | 0         |
| Standard_E16s_v4         | E           | Es          | E16s         | 4            | 0.605    | 16              | 131072       | 0                        | 0         |
| Standard_E16s_v5         | E           | Es          | E16s         | 5            | 0.6048   | 16              | 131072       | 0                        | 0         |
| Standard_D14_v2          | D           | D           | D14          | 2            | 0.718    | 16              | 114688       | 819200                   | 0         |
| Standard_DS14_v2         | DS          | DS          | DS14         | 2            | 0.718    | 16              | 114688       | 229376                   | 0         |
| Standard_D16ads_v5       | D           | Dads        | D16ads       | 5            | 0.4944   | 16              | 65536        | 614400                   | 0         |
| Standard_D16d_v4         | D           | Dd          | D16d         | 4            | 0.5424   | 16              | 65536        | 614400                   | 0         |
| Standard_D16ds_v4        | D           | Dds         | D16ds        | 4            | 0.5424   | 16              | 65536        | 614400                   | 0         |
| Standard_D16ds_v5        | D           | Dds         | D16ds        | 5            | 0.5424   | 16              | 65536        | 614400                   | 0         |
| Standard_D16_v3          | D           | D           | D16          | 3            | 0.461    | 16              | 65536        | 409600                   | 0         |
| Standard_D16a_v4         | D           | Da          | D16a         | 4            | 0.461    | 16              | 65536        | 409600                   | 0         |
| Standard_D16as_v4        | D           | Das         | D16as        | 4            | 0.461    | 16              | 65536        | 131072                   | 0         |
| Standard_D16s_v3         | D           | Ds          | D16s         | 3            | 0.461    | 16              | 65536        | 131072                   | 0         |
| Standard_D16as_v5        | D           | Das         | D16as        | 5            | 0.4128   | 16              | 65536        | 0                        | 0         |
| Standard_D16pds_v6       | D           | Dpds        | D16pds       | 6            | 0.4404   | 16              | 65536        | 0                        | 0         |
| Standard_D16ps_v6        | D           | Dps         | D16ps        | 6            | 0.3372   | 16              | 65536        | 0                        | 0         |
| Standard_D16s_v4         | D           | Ds          | D16s         | 4            | 0.4608   | 16              | 65536        | 0                        | 0         |
| Standard_D16s_v5         | D           | Ds          | D16s         | 5            | 0.4608   | 16              | 65536        | 0                        | 0         |
| Standard_D5_v2           | D           | D           | D5           | 2            | 0.55     | 16              | 57344        | 819200                   | 0         |
| Standard_DS5_v2          | DS          | DS          | DS5          | 2            | 0.55     | 16              | 57344        | 114688                   | 0         |
| Standard_F16             | F           | F           | F16          | null         | 0.478    | 16              | 32768        | 262144                   | 0         |
| Standard_F16s_v2         | F           | Fs          | F16s         | 2            | 0.406    | 16              | 32768        | 131072                   | 0         |
| Standard_F16s            | F           | Fs          | F16s         | null         | 0.478    | 16              | 32768        | 65536                    | 0         |
| Standard_D16pls_v6       | D           | Dpls        | D16pls       | 6            | 0.2976   | 16              | 32768        | 0                        | 0         |
| Standard_L8s             | L           | Ls          | L8s          | null         | 0.412    | 8               | 65536        | 1421312                  | 0         |
| Standard_E8ads_v5        | E           | Eads        | E8ads        | 5            | 0.3144   | 8               | 65536        | 307200                   | 0         |
| Standard_E8d_v4          | E           | Ed          | E8d          | 4            | 0.3456   | 8               | 65536        | 307200                   | 0         |
| Standard_E8ds_v4         | E           | Eds         | E8ds         | 4            | 0.3456   | 8               | 65536        | 307200                   | 0         |
| Standard_E8ds_v5         | E           | Eds         | E8ds         | 5            | 0.3456   | 8               | 65536        | 307200                   | 0         |
| Standard_E8_v3           | E           | E           | E8           | 3            | 0.319    | 8               | 65536        | 204800                   | 0         |
| Standard_E8a_v4          | E           | Ea          | E8a          | 4            | 0.302    | 8               | 65536        | 204800                   | 0         |
| Standard_E8as_v4         | E           | Eas         | E8as         | 4            | 0.302    | 8               | 65536        | 131072                   | 0         |
| Standard_E8s_v3          | E           | Es          | E8s          | 3            | 0.319    | 8               | 65536        | 131072                   | 0         |
| Standard_L8as_v3         | L           | Las         | L8as         | 3            | 0.3744   | 8               | 65536        | 81920                    | 0         |
| Standard_L8s_v2          | L           | Ls          | L8s          | 2            | 0.374    | 8               | 65536        | 81920                    | 0         |
| Standard_L8s_v3          | L           | Ls          | L8s          | 3            | 0.4188   | 8               | 65536        | 81920                    | 0         |
| Standard_E8as_v5         | E           | Eas         | E8as         | 5            | 0.2712   | 8               | 65536        | 0                        | 0         |
| Standard_E8pds_v6        | E           | Epds        | E8pds        | 6            | 0.2808   | 8               | 65536        | 0                        | 0         |
| Standard_E8ps_v6         | E           | Eps         | E8ps         | 6            | 0.2214   | 8               | 65536        | 0                        | 0         |
| Standard_E8s_v4          | E           | Es          | E8s          | 4            | 0.3024   | 8               | 65536        | 0                        | 0         |
| Standard_E8s_v5          | E           | Es          | E8s          | 5            | 0.3024   | 8               | 65536        | 0                        | 0         |
| Standard_D13_v2          | D           | D           | D13          | 2            | 0.359    | 8               | 57344        | 409600                   | 0         |
| Standard_DS13_v2         | DS          | DS          | DS13         | 2            | 0.359    | 8               | 57344        | 114688                   | 0         |
| Standard_D8ads_v5        | D           | Dads        | D8ads        | 5            | 0.2472   | 8               | 32768        | 307200                   | 0         |
| Standard_D8d_v4          | D           | Dd          | D8d          | 4            | 0.2712   | 8               | 32768        | 307200                   | 0         |
| Standard_D8ds_v4         | D           | Dds         | D8ds         | 4            | 0.2712   | 8               | 32768        | 307200                   | 0         |
| Standard_D8ds_v5         | D           | Dds         | D8ds         | 5            | 0.2712   | 8               | 32768        | 307200                   | 0         |
| Standard_D8_v3           | D           | D           | D8           | 3            | 0.23     | 8               | 32768        | 204800                   | 0         |
| Standard_D8a_v4          | D           | Da          | D8a          | 4            | 0.23     | 8               | 32768        | 204800                   | 0         |
| Standard_D8as_v4         | D           | Das         | D8as         | 4            | 0.23     | 8               | 32768        | 65536                    | 0         |
| Standard_D8s_v3          | D           | Ds          | D8s          | 3            | 0.23     | 8               | 32768        | 65536                    | 0         |
| Standard_D8as_v5         | D           | Das         | D8as         | 5            | 0.2064   | 8               | 32768        | 0                        | 0         |
| Standard_D8pds_v6        | D           | Dpds        | D8pds        | 6            | 0.2202   | 8               | 32768        | 0                        | 0         |
| Standard_D8s_v4          | D           | Ds          | D8s          | 4            | 0.2304   | 8               | 32768        | 0                        | 0         |
| Standard_D8s_v5          | D           | Ds          | D8s          | 5            | 0.2304   | 8               | 32768        | 0                        | 0         |
| Standard_D4_v2           | D           | D           | D4           | 2            | 0.275    | 8               | 28672        | 409600                   | 0         |
| Standard_DS4_v2          | DS          | DS          | DS4          | 2            | 0.275    | 8               | 28672        | 57344                    | 0         |
| Standard_F8              | F           | F           | F8           | null         | 0.239    | 8               | 16384        | 131072                   | 0         |
| Standard_F8s_v2          | F           | Fs          | F8s          | 2            | 0.203    | 8               | 16384        | 65536                    | 0         |
| Standard_F8s             | F           | Fs          | F8s          | null         | 0.239    | 8               | 16384        | 32768                    | 0         |
| Standard_D8plds_v6       | D           | Dplds       | D8plds       | 6            | 0.1872   | 8               | 16384        | 0                        | 0         |
| Standard_L4s             | L           | Ls          | L4s          | null         | 0.206    | 4               | 32768        | 694272                   | 0         |
| Standard_E4ads_v5        | E           | Eads        | E4ads        | 5            | 0.1572   | 4               | 32768        | 153600                   | 0         |
| Standard_E4d_v4          | E           | Ed          | E4d          | 4            | 0.1728   | 4               | 32768        | 153600                   | 0         |
| Standard_E4ds_v4         | E           | Eds         | E4ds         | 4            | 0.1728   | 4               | 32768        | 153600                   | 0         |
| Standard_E4ds_v5         | E           | Eds         | E4ds         | 5            | 0.1728   | 4               | 32768        | 153600                   | 0         |
| Standard_E4a_v4          | E           | Ea          | E4a          | 4            | 0.151    | 4               | 32768        | 102400                   | 0         |
| Standard_E4as_v4         | E           | Eas         | E4as         | 4            | 0.151    | 4               | 32768        | 65536                    | 0         |
| Standard_E4as_v5         | E           | Eas         | E4as         | 5            | 0.1356   | 4               | 32768        | 0                        | 0         |
| Standard_E4pds_v6        | E           | Epds        | E4pds        | 6            | 0.1404   | 4               | 32768        | 0                        | 0         |
| Standard_E4ps_v6         | E           | Eps         | E4ps         | 6            | 0.1104   | 4               | 32768        | 0                        | 0         |
| Standard_E4s_v4          | E           | Es          | E4s          | 4            | 0.1512   | 4               | 32768        | 0                        | 0         |
| Standard_E4s_v5          | E           | Es          | E4s          | 5            | 0.1512   | 4               | 32768        | 0                        | 0         |
| Standard_D12_v2          | D           | D           | D12          | 2            | 0.179    | 4               | 28672        | 204800                   | 0         |
| Standard_DS12_v2         | DS          | DS          | DS12         | 2            | 0.179    | 4               | 28672        | 57344                    | 0         |
| Standard_D4ads_v5        | D           | Dads        | D4ads        | 5            | 0.1236   | 4               | 16384        | 153600                   | 0         |
| Standard_D4d_v4          | D           | Dd          | D4d          | 4            | 0.1356   | 4               | 16384        | 153600                   | 0         |
| Standard_D4ds_v4         | D           | Dds         | D4ds         | 4            | 0.1356   | 4               | 16384        | 153600                   | 0         |
| Standard_D4ds_v5         | D           | Dds         | D4ds         | 5            | 0.1356   | 4               | 16384        | 153600                   | 0         |
| Standard_D4a_v4          | D           | Da          | D4a          | 4            | 0.1152   | 4               | 16384        | 102400                   | 0         |
| Standard_D4s_v3          | D           | Ds          | D4s          | 3            | 0.115    | 4               | 16384        | 32768                    | 0         |
| Standard_D4as_v5         | D           | Das         | D4as         | 5            | 0.1032   | 4               | 16384        | 0                        | 0         |
| Standard_D4pds_v6        | D           | Dpds        | D4pds        | 6            | 0.1104   | 4               | 16384        | 0                        | 0         |
| Standard_D4s_v4          | D           | Ds          | D4s          | 4            | 0.1152   | 4               | 16384        | 0                        | 0         |
| Standard_D4s_v5          | D           | Ds          | D4s          | 5            | 0.1152   | 4               | 16384        | 0                        | 0         |
| Standard_D3_v2           | D           | D           | D3           | 2            | 0.137    | 4               | 14336        | 204800                   | 0         |
| Standard_DS3_v2          | DS          | DS          | DS3          | 2            | 0.137    | 4               | 14336        | 28672                    | 0         |
| Standard_F4              | F           | F           | F4           | null         | 0.119    | 4               | 8192         | 65536                    | 0         |
| Standard_F4s_v2          | F           | Fs          | F4s          | 2            | 0.1014   | 4               | 8192         | 32768                    | 0         |
| Standard_F4s             | F           | Fs          | F4s          | null         | 0.119    | 4               | 8192         | 16384                    | 0         |
| Standard_D4plds_v6       | D           | Dplds       | D4plds       | 6            | 0.0936   | 4               | 8192         | 0                        | 0         |
| Standard_D4pls_v6        | D           | Dpls        | D4pls        | 6            | 0.0744   | 4               | 8192         | 0                        | 0         |
