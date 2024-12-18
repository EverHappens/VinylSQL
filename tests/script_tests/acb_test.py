import os
import pytest
from tests import execute_sql_to_df
from tests import read_sql

@pytest.fixture()
def select_script():
    path = os.getenv("SCRIPT_PATH")
    return read_sql(path)


@pytest.fixture()
def select_df(select_script, sqlalchemy_conn):
    return execute_sql_to_df(
        conn=sqlalchemy_conn,
        sql=select_script
    )


def test(select_df):
    assert select_df['avg'].iloc[0] == 1.7500000000000000
