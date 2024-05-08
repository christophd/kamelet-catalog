Feature: AWS Kinesis - Sink

  Background:
    Given variables
      | timer.source.period      | 10000 |
      | aws.kinesis.streamName   | mystream |
      | aws.kinesis.partitionKey | partition-1 |
      | aws.kinesis.message      | Camel rocks! |
      | aws.kinesis.json.data    | { "message":"${aws.kinesis.message}" } |

  Scenario: Create infrastructure
    # Start LocalStack container
    Given Enable service KINESIS
    Given start LocalStack container

  Scenario: Verify Kinesis events
    # Create AWS-KINESIS client
    Given load to Camel registry amazonKinesisClient.groovy
    # Create binding
    When load Pipe aws-kinesis-sink-pipe.yaml
    And Pipe aws-kinesis-sink-pipe is available
    And Camel K integration aws-kinesis-sink-pipe is running
    And Camel K integration aws-kinesis-sink-pipe should print Installed features
    # Create vent listener
    Given Camel route eventListener.groovy
    """
    from("aws2-kinesis://${aws.kinesis.streamName}?amazonKinesisClient=#amazonKinesisClient")
       .convertBodyTo(String.class)
       .to("seda:result")
    """
    # Verify event
    Given Camel exchange message header CamelAwsKinesisPartitionKey="${aws.kinesis.partitionKey}"
    Then receive Camel exchange from("seda:result") with body: ${aws.kinesis.json.data}

  Scenario: Remove resources
    # Remove Camel K binding
    Given delete Pipe aws-kinesis-sink-pipe
    # Stop event listener
    Given stop Camel route kinesisEventListener
    # Stop LocalStack container
    Given stop LocalStack container
