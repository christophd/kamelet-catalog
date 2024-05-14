Feature: AWS DDB Source

  Background:
    Given variables
      | maxRetryAttempts     | 20 |
      | timer.source.period  | 10000 |
      | aws.ddb.streams      | true |
      | aws.ddb.tableName    | movies |
      | aws.ddb.item.id      | 1 |
      | aws.ddb.item.year    | 1977 |
      | aws.ddb.item.title   | Star Wars IV |

  Scenario: Create infrastructure
    # Start LocalStack container
    Given Enable service DYNAMODB
    Given start LocalStack container
    Then verify actions waitForLocalStack.groovy

  Scenario: Verify AWS-DDB Kamelet source binding
    # Create AWS-DDB client
    Given load to Camel registry amazonDDBClient.groovy
    # Create binding
    When load Pipe aws-ddb-source-pipe.yaml
    And Pipe aws-ddb-source-pipe is available
    And Camel K integration aws-ddb-source-pipe is running
    And Camel K integration aws-ddb-source-pipe should print Installed features
    # Create item on AWS-DDB
    Given run script putItem.groovy
    # Verify event
    And Camel K integration aws-ddb-source-pipe should print Star Wars IV

  Scenario: Remove resources
    # Remove Camel K binding
    Given delete Pipe aws-ddb-source-pipe
    # Stop LocalStack container
    Given stop LocalStack container
