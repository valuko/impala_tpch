# Impala TPC-H Benchmark suite
TPC-H Benchmark suite for Impala. 

## Setup tools
Use the TPC-H data generation tool in the `datagen_tool` directory to generate the data.
Upload the generated data files into the HDFS, preferably `/tpch` directory
Run `./setup.sh` to setup the database for the benchmark

## Usage
Run `./run.sh` to run the benchmark

## Other notes
Running `./run.sh` runs the benchmark for the TPC-H Textfile benchmark. To run with the parquet file benchmark, Do the following:
- Run `./setup_parquet.sh`
- Modify `run.sh`. Change the queries directory from `tpch_queries` to `tpch_parquet_tables`.
- Run `./run.sh`

`tpch_parquet_views` contains experimental usage of views for the benchmark but which caused out of memory errors when tested with parquet files

## Further Resources
Refer to Impala_tpch_README.md for more guide
