Feature: AWS Kinesis - Sink

  Background:
    Given variables
      | aws.kinesis.streamName   | mystream |
      | aws.kinesis.partitionKey | partition-1 |

  Scenario: Create infrastructure
    # Start LocalStack container
    Given Enable service KINESIS
    Given start LocalStack container

  Scenario: Verify Kinesis events
    # Create AWS-KINESIS client
    Given load to Camel registry amazonKinesisClient.groovy
    # Create binding
    When load Pipe aws-kinesis-source-pipe.yaml
    And Pipe aws-kinesis-source-pipe is available
    And Camel K integration aws-kinesis-source-pipe is running
    And Camel K integration aws-kinesis-source-pipe should print Installed features
    # Publish event
    Given variable aws.kinesis.streamData is "Camel rocks!"
    Given Camel exchange message header CamelAwsKinesisPartitionKey="${aws.kinesis.partitionKey}"
    Given send Camel exchange to("aws2-kinesis://${aws.kinesis.streamName}?amazonKinesisClient=#amazonKinesisClient") with body: ${aws.kinesis.streamData}
    # Verify event
    Then Camel K integration aws-kinesis-source-pipe should print ${aws.kinesis.streamData}

  Scenario: Remove resources
    # Remove Camel K binding
    Given delete Pipe aws-kinesis-source-pipe
    # Stop LocalStack container
    Given stop LocalStack container
