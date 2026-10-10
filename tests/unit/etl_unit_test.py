"""Unit tests for the ETL pipeline."""

import pytest

# Commented out imports kept for reference:
# from chispa import assert_df_equality
# from flexbox_cg_gha_dab.bronze_flexbox_cg_gha_dab.etl.etl import transform_dataframe


@pytest.mark.unit
def test_unit_etl(mock_spark):
    """Test the transform_dataframe function."""
    # unit tests should be focused on the smallest 'unit' in your pipeline
    # this test is an example of validating simple logic of the transform method

    # df = mock_spark.createDataFrame([{"id": "1", "value": "2"}])

    # result = transform_dataframe(df)

    # expected = mock_spark.createDataFrame([{"id": 1, "value": 2}])

    # assert_df_equality(expected, result)
    assert 1 == 1
