#!/bin/bash

set -e

# https://www.elastic.co/guide/en/kibana/current/tutorial-load-dataset.html

curl -XDELETE 'elasticsearch-master:9200/bank/account'
curl -XDELETE 'elasticsearch-master:9200/shakespeare'
curl -XDELETE 'elasticsearch-master:9200/logstash-2015.05.18'
curl -XDELETE 'elasticsearch-master:9200/logstash-2015.05.19'
curl -XDELETE 'elasticsearch-master:9200/logstash-2015.05.20'

curl -XPUT 'elasticsearch-master:9200/shakespeare?pretty' -H 'Content-Type: application/json' -d'
{
 "mappings" : {
  "_default_" : {
   "properties" : {
    "speaker" : {"type": "keyword" },
    "play_name" : {"type": "keyword" },
    "line_id" : { "type" : "integer" },
    "speech_number" : { "type" : "integer" }
   }
  }
 }
}
'

curl -XPUT 'elasticsearch-master:9200/logstash-2015.05.18?pretty' -H 'Content-Type: application/json' -d'
{
  "mappings": {
    "log": {
      "properties": {
        "geo": {
          "properties": {
            "coordinates": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
'
curl -XPUT 'elasticsearch-master:9200/logstash-2015.05.19?pretty' -H 'Content-Type: application/json' -d'
{
  "mappings": {
    "log": {
      "properties": {
        "geo": {
          "properties": {
            "coordinates": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
'
curl -XPUT 'elasticsearch-master:9200/logstash-2015.05.20?pretty' -H 'Content-Type: application/json' -d'
{
  "mappings": {
    "log": {
      "properties": {
        "geo": {
          "properties": {
            "coordinates": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
'


curl -H 'Content-Type: application/x-ndjson' -XPOST 'elasticsearch-master:9200/bank/account/_bulk?pretty' --data-binary @/raw/accounts.json
curl -H 'Content-Type: application/x-ndjson' -XPOST 'elasticsearch-master:9200/shakespeare/_bulk?pretty' --data-binary @/raw/shakespeare.json
curl -H 'Content-Type: application/x-ndjson' -XPOST 'elasticsearch-master:9200/_bulk?pretty' --data-binary @/raw/logs.jsonl
