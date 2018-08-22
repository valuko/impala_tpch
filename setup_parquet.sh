#!/usr/bin/env bash

source benchmark.conf;

$IMPALA_SHELL --query_file=$BASE_DIR/setup/create_text_tables.sql 2>&1
$IMPALA_SHELL --query_file=$BASE_DIR/setup/create_parquet_tables.sql 2>&1