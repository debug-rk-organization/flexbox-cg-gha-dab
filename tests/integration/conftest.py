"""Common fixtures for integration tests."""

import pytest
from databricks.connect import DatabricksSession
from databricks.sdk.core import Config
from pg_composite_pipelines_configuration.configuration import Configuration
from pyspark.dbutils import DBUtils


@pytest.fixture(scope="session", autouse=True)
def config():
    """Provide test configuration."""
    spark_config = Config(profile="DEFAULT")
    spark = DatabricksSession.builder.sdkConfig(spark_config).getOrCreate()
    dbutils = DBUtils(spark)
    config = Configuration.load_for_environment("test", __file__, dbutils)
    yield config


@pytest.fixture(scope="session", autouse=True)
def spark():
    """Provide a Spark session."""
    spark_config = Config(profile="DEFAULT")
    spark = DatabricksSession.builder.sdkConfig(spark_config).getOrCreate()
    yield spark


@pytest.fixture(scope="session", autouse=True)
def dbutils(spark):
    """Provide a DBUtils instance."""
    # you may want to just use a magicmock, dbutils.fs especially doesn't realy work locally
    yield DBUtils(spark)
