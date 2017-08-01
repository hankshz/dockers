set -e

wget -nc -O raw/logstash-5.5.1.tar.gz https://artifacts.elastic.co/downloads/logstash/logstash-5.5.1.tar.gz | true
wget -nc -O raw/filebeat-5.5.1-amd64.deb https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.5.1-amd64.deb | true

docker build -t logstash .
docker rm -f logstash | true
docker run -it --name=logstash logstash
