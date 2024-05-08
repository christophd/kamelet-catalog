Feature: AWS Kinesis Kamelet

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
    Given Camel K integration property file aws-kinesis-credentials.properties
    And create Camel K integration aws-kinesis-to-log-prop-based.groovy
    """
    from("kamelet:aws-kinesis-source/aws-kinesis-credentials")
      .to("log:info")
    """
    Then Camel K integration aws-kinesis-to-log-prop-based should be running
    # Verify Kamelet source
    Given variable aws.kinesis.streamData is "Camel rocks!"
    Given Camel exchange message header CamelAwsKinesisPartitionKey="${aws.kinesis.partitionKey}"
    Given send Camel exchange to("aws2-kinesis://${aws.kinesis.streamName}?amazonKinesisClient=#amazonKinesisClient") with body: ${aws.kinesis.streamData}
    # Verify event
    Then Camel K integration aws-kinesis-to-log-prop-based should print ${aws.kinesis.streamData}

  Scenario: Remove resources
    # Remove Camel K resources
    Given delete Camel K integration aws-kinesis-to-log-prop-based
    # Stop LocalStack container
    Given stop LocalStack container
