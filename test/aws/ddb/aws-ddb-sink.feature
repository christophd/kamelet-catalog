Feature: AWS DDB Sink

  Background:
    Given variables
      | timer.source.period  | 10000 |
      | aws.ddb.streams      | false |
      | aws.ddb.tableName    | movies |

  Scenario: Create infrastructure
    # Start LocalStack container
    Given Enable service DYNAMODB
    Given start LocalStack container
    Then verify actions waitForLocalStack.groovy

  Scenario: Verify AWS-DDB Kamelet sink
    Given variables
      | maxRetryAttempts   | 20 |
      | aws.ddb.items      | [] |
    # Create AWS-DDB client
    Given load to Camel registry amazonDDBClient.groovy
    # Verify empty items on AWS-DDB
    Then apply actions verifyItems.groovy

    # DeleteItem
    Given variables
      | aws.ddb.operation  | DeleteItem |
      | aws.ddb.item.id    | yaks:randomNumber(4) |
      | aws.ddb.item.year  | 1985 |
      | aws.ddb.item.title | Back to the future |
      | aws.ddb.json.data  | {"id": ${aws.ddb.item.id}} |
    Given run script putItem.groovy
    Given variables
      | maxRetryAttempts | 20 |
      | aws.ddb.items    | [[year:AttributeValue(N=${aws.ddb.item.year}), id:AttributeValue(N=${aws.ddb.item.id}), title:AttributeValue(S=${aws.ddb.item.title})]] |
    # Create item on AWS-DDB
    Then apply actions verifyItems.groovy
    # Create binding
    When load Pipe aws-ddb-sink-pipe.yaml
    And Pipe aws-ddb-sink-pipe is available
    And Camel K integration aws-ddb-sink-pipe is running
    And Camel K integration aws-ddb-sink-pipe should print Installed features
    # Verify Kamelet sink
    Given variables
      | maxRetryAttempts | 20 |
      | aws.ddb.items    | [] |
    Then apply actions verifyItems.groovy
    # Remove Camel K resources
    Given delete Pipe aws-ddb-sink-pipe

    # PutItem
    Given variables
      | aws.ddb.operation  | PutItem |
      | aws.ddb.item.id    | yaks:randomNumber(4) |
      | aws.ddb.item.year  | 1977 |
      | aws.ddb.item.title | Star Wars IV |
      | aws.ddb.json.data  | { "id":${aws.ddb.item.id}, "year":${aws.ddb.item.year}, "title":"${aws.ddb.item.title}" } |
    When load Pipe aws-ddb-sink-pipe.yaml
    And Pipe aws-ddb-sink-pipe is available
    And Camel K integration aws-ddb-sink-pipe is running
    And Camel K integration aws-ddb-sink-pipe should print Installed features
    # Verify Kamelet sink
    Given variables
      | aws.ddb.item | [year:AttributeValue(N=${aws.ddb.item.year}), id:AttributeValue(N=${aws.ddb.item.id}), title:AttributeValue(S=${aws.ddb.item.title})] |
    Then apply actions getItem.groovy
    # Remove Camel K binding
    Given delete Pipe aws-ddb-sink-pipe

    # UpdateItem
    Given variables
      | aws.ddb.operation      | UpdateItem |
      | aws.ddb.item.id        | yaks:randomNumber(4) |
      | aws.ddb.item.year      | 1933 |
      | aws.ddb.item.title     | King Kong |
      | aws.ddb.item.title.new | King Kong - Historical |
      | aws.ddb.item.directors | ["Merian C. Cooper", "Ernest B. Schoedsack"] |
      | aws.ddb.json.data      | { "key": {"id": ${aws.ddb.item.id}}, "item": {"title": "${aws.ddb.item.title.new}", "year": ${aws.ddb.item.year}, "directors": ${aws.ddb.item.directors}} } |
    Given run script putItem.groovy
    Given variables
      | aws.ddb.item | [year:AttributeValue(N=${aws.ddb.item.year}), id:AttributeValue(N=${aws.ddb.item.id}), title:AttributeValue(S=${aws.ddb.item.title})] |
    Then apply actions getItem.groovy
    # Create binding
    When load Pipe aws-ddb-sink-pipe.yaml
    And Pipe aws-ddb-sink-pipe is available
    And Camel K integration aws-ddb-sink-pipe is running
    And Camel K integration aws-ddb-sink-pipe should print Installed features
    # Verify Kamelet sink
    Given variables
      | maxRetryAttempts       | 200 |
      | aws.ddb.item.directors | [Ernest B. Schoedsack, Merian C. Cooper] |
      | aws.ddb.item           | [year:AttributeValue(N=${aws.ddb.item.year}), directors:AttributeValue(SS=${aws.ddb.item.directors}), id:AttributeValue(N=${aws.ddb.item.id}), title:AttributeValue(S=${aws.ddb.item.title.new})] |
    Then apply actions getItem.groovy
    # Remove Camel K resources
    Given delete Pipe aws-ddb-sink-pipe

  Scenario: Remove resources
    # Stop LocalStack container
    Given stop LocalStack container
