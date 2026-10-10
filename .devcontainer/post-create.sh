#!/bin/bash

if [ "$CODESPACES" = "true" ]; then
    echo "Codespaces detected, configuring uv with JFrog credentials"
    uv auth login https://png.jfrog.io --username ${JFROG_USER} --password ${JFROG_TOKEN}
    uv sync
else
    echo -e "Configure uv with P&G JFrog credentials (if not mounted from host):"
    echo -e '    \033[32muv auth login https://png.jfrog.io\033[0m'
    echo -e "Install dependencies with:"
    echo -e '    \033[32muv sync\033[0m'
fi

echo -e 'Install git pre-commit with:'
echo -e '    \033[32muv run pre-commit install\033[0m'
echo -e 'Authenticate to Databricks with:'
echo -e '    \033[32maz login\033[0m'
echo -e '    or'
echo -e '    \033[32mdatabricks configure\033[0m'
echo -e 'Set Databricks Compute:'
echo -e '    \033[32mexport DATABRICKS_SERVERLESS_COMPUTE_ID=auto\033[0m'
echo -e '    or'
echo -e '    \033[32mexport DATABRICKS_CLUSTER_ID=xxxxxxxxxx\033[0m'
echo -e '    or use the vscode extension'
echo -e 'Add devagent skills:'
echo -e '    Install DevAgent Locally:'
echo -e '    \033[32muv pip install devagent@git+https://github.com/procter-gamble/custom-agents.git\033[0m'
echo -e '    Initialize DevAgent:'
echo -e '    \033[32muv run devagent init --frameworks cdl-cli,databricks-configuration,databricks-schema-migration\033[0m'
