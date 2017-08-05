#!/bin/bash

set -e

kubectl exec cassandra-0 -- /script/test-cassandra.py --create
kubectl exec cassandra-0 -- /script/test-cassandra.py --verify
kubectl exec cassandra-1 -- /script/test-cassandra.py --verify
kubectl exec cassandra-2 -- /script/test-cassandra.py --verify
kubectl exec cassandra-0 -- /script/test-cassandra.py --delete
