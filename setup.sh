#!/usr/bin/env bash

source benchmark.conf;

$IMPALA_SHELL --query_file=$BASE_DIR/setup/create_database.sql 2>&1