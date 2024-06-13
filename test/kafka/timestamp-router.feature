Feature: Kafka Timestamp Router

  Background:
    Given variable user is ""
    Given variable password is ""
    Given variables
      | bootstrap.server.host     | my-cluster-kafka-bootstrap |
      | bootstrap.server.port     | 9092 |
      | securityProtocol          | PLAINTEXT |
      | topicName                 | my-topic |
      | timestamp                 | yaks:unixTimestamp()000 |
      | topic                     | ${topicName}_yaks:currentDate('YYYY-MM-dd') |
      | message                   | Camel K rocks! |
    Given Kafka topic: ${topic}
    Given Kafka topic partition: 0

  Scenario: Create Pipe
    Given Camel K resource polling configuration
      | maxAttempts          | 200   |
      | delayBetweenAttempts | 2000  |
    When load Pipe timestamp-router-pipe.yaml
    Then Camel K integration timestamp-router-pipe should be running
    Then Camel K integration timestamp-router-pipe should print Routes startup

  Scenario: Receive message on Kafka topic and verify sink output
    Given Kafka connection
      | url         | ${bootstrap.server.host}.${YAKS_NAMESPACE}:${bootstrap.server.port} |
    Given URL: yaks:resolveURL('timestamp-router-pipe',8080)
    Given HTTP request query parameter kafka.TOPIC="${topicName}"
    Given HTTP request query parameter kafka.TIMESTAMP="${timestamp}"
    Given HTTP request query parameter message="yaks:urlEncode(${message})"
    When send GET /messages
    And receive HTTP 200 OK
    Then receive Kafka message with body: ${message}

  Scenario: Remove resources
    Given delete Pipe timestamp-router-pipe
