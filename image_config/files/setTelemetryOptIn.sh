#!/bin/sh

telemetry='{"type": "config","config":{"telemetry:optIn": true}}' 

body='{"settings" : {"number_of_shards" : 1,"index.mapper.dynamic": false},"mappings" : {"doc": {"properties": {"type": {"type": "keyword"},"updated_at": {"type": "date"},"config": {"properties": {"buildNum": {"type": "keyword"}}},"index-pattern": {"properties": {"fieldFormatMap": {"type": "text"},"fields": {"type": "text"},"intervalName": {"type": "keyword"},"notExpandable": {"type": "boolean" },"sourceFilters": {"type": "text"},"timeFieldName": {"type": "keyword"},"title": {"type": "text"}}},"visualization": {"properties": {"description": {"type": "text"},"kibanaSavedObjectMeta": {"properties": {"searchSourceJSON": { "type": "text"}}},"savedSearchId": {"type": "keyword"},"title": {"type": "text"},"uiStateJSON": {"type": "text"}, "version": { "type": "integer" },"visState": {"type": "text"} } }, "search": {"properties": { "columns": {"type": "keyword"},"description": {"type": "text"}, "hits": {"type": "integer" },"kibanaSavedObjectMeta": {"properties": { "searchSourceJSON": { "type": "text" }}},"sort": {"type": "keyword"},"title": {"type": "text"},"version": { "type": "integer"}}},"dashboard": {"properties": {"description": {"type": "text"},"hits": {"type": "integer"},"kibanaSavedObjectMeta": {"properties": {"searchSourceJSON": {"type": "text"}}},"optionsJSON": {"type": "text"},"panelsJSON": {"type": "text"},"refreshInterval": {"properties": {"display": {"type": "keyword"}, "pause": {"type": "boolean"},"section": {"type": "integer"},"value": {"type": "integer"}}},"timeFrom": { "type": "keyword"},"timeRestore": { "type": "boolean"},"timeTo": {"type": "keyword"},"title": {"type": "text"},"uiStateJSON": {"type": "text"}, "version": {"type": "integer"}}},"url": {"properties": { "accessCount": {"type": "long"}, "accessDate": {"type": "date"},"createDate": {"type": "date"},"url": {"type": "text","fields": { "keyword": {"type": "keyword","ignore_above": 2048}}}}}, "server": {"properties": {"uuid": {"type": "keyword"}}},"timelion-sheet": {"properties": { "description": {"type": "text"},"hits": {"type": "integer"},"kibanaSavedObjectMeta": {"properties": { "searchSourceJSON": {"type": "text"}}},"timelion_chart_height": {"type": "integer"},"timelion_columns": {"type": "integer"}, "timelion_interval": {"type": "keyword"},"timelion_other_interval": { "type": "keyword"},"timelion_rows": {"type": "integer"},"timelion_sheet": {"type": "text"},"title": {"type": "text"},"version": {"type": "integer"}}},"graph-workspace": {"properties": {"description": {"type": "text"},"kibanaSavedObjectMeta": {"properties": {"searchSourceJSON": {"type": "text"}}},"numLinks": {"type": "integer"}, "numVertices": {"type": "integer"},"title": {"type": "text"}, "version": { "type": "integer"},"wsState": {"type": "text"}}}}}}}'



#get the kibana version

kibana_ver=`curl localhost:5601/api/status | awk '{print $0}'| awk -F 'number' '{print $2}' |awk -F ':"' '{print $2}'|awk -F '"' '{print $1}'`

echo "$kibana_ver"



curl -H 'Content-Type: application/json' -XPUT "http://localhost:9200/.kibana" -d "$body"
curl -H 'Content-Type: application/json' -XPOST "http://localhost:9200/.kibana/doc/config:$kibana_ver" -d "$telemetry"

