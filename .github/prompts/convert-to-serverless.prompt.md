---
mode: 'agent'
tools: ['githubRepo', 'codebase']
description: 'Update/convert/migrate an existing databricks asset bundle/workflow/project to use serverless compute'
---

## Update your Libraries

- Update pyproject.toml, if it exists, to include the following dependencies
```toml
[project]
requires-python = ">=3.12,<3.13"
dependencies = [
    "pg-de-cf-databricks-configuration>=1.1,<1.2",
    "pg-de-cf-databricks-migration==0.25.0",
    "databricks-connect>=16.4,<16.5",
]

[[tool.uv.index]]
name = "pg_jfrog"
url = "https://png.jfrog.io/artifactory/api/pypi/pgg-python/simple"
explicit = true

[tool.uv.sources]
pg-de-cf-databricks-configuration = { index = "pg_jfrog" }
pg-de-cf-databricks-migration = { index = "pg_jfrog" }
```

## Update your development environment

- (vscode workflow only) Update your local development environment to python 3.12.  If you are using the provided devcontainer, you may use the [latest template](https://github.com/procter-gamble/de-cf-databricks-template/blob/94edc26b1bdbcf8209c9ddcbeedb7f3ddc46f534/.devcontainer/devcontainer.json#L20) as a reference.

## Update your CI/CD

Github Actions CI/CD Only (.github/workflows exists)
- Update all references to `python-version` to reference `3.12`
- Remove all references to environment variable `DATABRICKS_CLUSTER_ID`, replace with `DATABRICKS_SERVERLESS_COMPUTE_ID: auto`

Azure Devops CI/CD Only (.azurepipelines exists)
- Update all references to `default_python_version` to reference `3.12`
- Remove all references to environment variable `DATABRICKS_CLUSTER_ID`, replace with `DATABRICKS_SERVERLESS_COMPUTE_ID: auto`

## Update your databricks asset bundle yaml

- Remove `job_clusters` sections from databricks.yaml, resources/*.yaml
- Add `environments` section (note only include whl OR requirements.txt depending on which workflow you use)  Note that peformance_target is under the job, element, _not_ the environments or environment.
```yaml
environments:
    - environment_key: serverless_environment
        spec:
        environment_version: "4"
            dependencies:
        #vscode workflow
            - ../dist/<your project name>-*-py3-none-any.whl
performance_target: STANDARD
```
- For each task with a `job_cluster_key` reference, remove `job_cluster_key` and replace with `environment_key: serverless_environment`
- Remove any `libraries` references from tasks.
    - (vscode workflow only) ensure any library references are added to the pyproject.toml dependencies
- (Recommended but not required) Pass environment as a param
    - (vscode-python workflow, python tasks)
```yaml
named_parameters:
    environment: "${bundle.target}"
```
    - (ui-notebook workflow, notebook tasks)
```yaml
parameters:
    - name: ENVIRONMENT
        default: '${bundle.target}'
```

## (Optional) Update your configuration library references

`load_for_default_environment` is still supported, but is not the recommended approach for environment selection.  See [configuration library](https://github.com/procter-gamble/de-cf-databricks-configuration) to understand the changes to default environment detection that were mandated by the introduction of serverless compute.

- (vscode workflow, python tasks only)
    Replace references to `Configuration.load_for_default_environment`.
    Instead, explicitly pass the environment from a task paramater
```python
import argparse
parser = argparse.ArgumentParser()
parser.add_argument('--environment', type=str, required=True, help='The execution environment')
args = parser.parse_args()
config = Configuration.load_for_environment(args.environment, __file__, dbutils)
```

## Test & Deploy

Test, build, and deploy your job.  Ensure it runs successfully.  Deploy via CI/CD as you would normally.
