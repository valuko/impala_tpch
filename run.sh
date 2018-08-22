#!/usr/bin/env bash

# set up configurations
source benchmark.conf;

if [ -e "$LOG_FILE" ]; then
	timestamp=`date "+%F-%R" --reference=$LOG_FILE`
	backupFile="$LOG_FILE.$timestamp"
	mv $LOG_FILE $LOG_DIR/$backupFile
fi

echo ""
echo "***********************************************"
echo "*          TPC-H benchmark on Impala          *"
echo "***********************************************"
echo "                                               " 
echo "See $LOG_FILE for more details of query errors."
echo ""

trial=0
while [ $trial -lt $NUM_OF_TRIALS ]; do
	trial=`expr $trial + 1`
	echo "Executing Trial #$trial of $NUM_OF_TRIALS trial(s)..."

	for query in ${TPCH_QUERIES_ALL[@]}; do
		echo "Running query: $query" | tee -a $LOG_FILE

		echo "Running Impala query: $query" >> $LOG_FILE
		$TIME_CMD $IMPALA_CMD --query_file=$BASE_DIR/tpch_queries/${query}.sql 2>&1 | tee -a $LOG_FILE | grep '^Time:'
                returncode=${PIPESTATUS[0]}
		if [ $returncode -ne 0 ]; then
			echo "ABOVE QUERY FAILED:$returncode"
		fi
		echo "" >> $LOG_FILE
		echo "Impala query: $query Done" >> $LOG_FILE
		echo "" >> $LOG_FILE

	done

done # TRIAL
echo "***********************************************"
echo ""
