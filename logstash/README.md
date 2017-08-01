# Logstash with Filebeat

An example for Logstash with Filebeat

  - Build & Install Logstash & Filebeat
  - Run log parsing example

Usage

  - Build & Run the docker image of Logstash & Filebeat:
    ```sh
    ./script/run-server.sh
    ```
    It will attach to the logstash process since the output of logstash is configured to standard output
  - Run the example:
    ```sh
    ./script/run-example.sh
    ```
    It will (re)read the log file using Filebeat and you can find the result from the logstash output
