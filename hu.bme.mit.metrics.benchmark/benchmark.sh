#!/bin/bash

for i in 1 2 3 4 5; do
	for j in 1 2 3 4 5; do
		java -jar target/hu.bme.mit.metrics.benchmark-0.0.1-SNAPSHOT.jar ~/git/trainbenchmark/models/railway-repair-32-inferred.ttl $i $j
	done
done

