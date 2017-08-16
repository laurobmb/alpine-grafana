#!/bin/bash
set -ex

version=$(git describe --always --tags|sed 's/^v//')

docker run -d -p 3000:3000 orangesys/alpine-grafana:${version}
sleep 3
docker ps
curl -X GET 'http://127.0.0.1:3000/api/health'

curl -s 'http://admin:admin@127.0.0.1:3000/api/datasources' \
    -X POST \
    -H 'Content-Type: application/json;charset=UTF-8' \
    --data-binary '{
	"name":"localinflux",
	"type":"influxdb",
	"url":"http://influxsrv:8086",
	"access":"proxy",
	"isDefault":true,
	"database":"telegraf",
	"user":"root",
	"password":"root"}'|grep -q "Datasource added"
