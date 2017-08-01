#!/usr/bin/env python3

from datetime import datetime
from elasticsearch import Elasticsearch

es = Elasticsearch([{'host':'elasticsearch-master'}])
es.ping()

NUM = 1000
repeat = 100
es.indices.delete(index='test', ignore=[400, 404])

for i in range(NUM):
    doc = {
        'name': 'user{}'.format(i),
        'content': 'test content{}'.format(i % repeat),
        'timestamp': datetime.now(),
    }
    res = es.index(index="test", doc_type="external", body=doc)

es.indices.refresh(index="test")

res = es.search(index="test", body={
    "query": {"match_all": {}},
    "sort": [
        { "timestamp": "desc" }
    ],
    "size": 1,
})
assert(res['hits']['hits'][0]['_source']['name']=='user{}'.format(NUM-1))

res = es.search(index="test", body={
    "query": {"match": {"content":"content0"}},
    "sort": [
        { "timestamp": "asc" }
    ],
})
assert(res['hits']['total']==(NUM//repeat))

res = es.search(index="test", body={
    "size": 0, # our focus here is the aggregation results—not document results.
    "aggregations": {
        "content": {
            "terms": {
                "field": "content.keyword",
                "size": repeat,
            }
        }
    },
})
assert(len(res['aggregations']['content']['buckets'])==repeat)

es.indices.delete(index='test', ignore=[400, 404])
