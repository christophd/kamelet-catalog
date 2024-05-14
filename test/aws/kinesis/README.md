# AWS Kinesis Kamelet test

This test verifies the AWS Kinesis Kamelet source defined in [aws-kinesis-source.kamelet.yaml](aws-kinesis-source.kamelet.yaml)

## Objectives

The test verifies the AWS Kinesis Kamelet source by creating a Camel K integration that uses the Kamelet and listens for messages on the
AWS Kinesis data stream.

The test uses a [LocalStack Testcontainers](https://www.testcontainers.org/modules/localstack/) instance to start a local AWS SQS service for mocking reasons.
The Kamelet and the test interact with the local AWS SQS service for validation of functionality.

### Test Kamelet source

The test performs the following high level steps:

*Preparation*
- Start the AWS Kinesis service as LocalStack container
- Overwrite the Kamelet with the latest source
- Prepare the Camel AWS SQS client

*Scenario* 
- Create the Kamelet in the current namespace in the cluster
- Create the Camel K integration that uses the Kamelet source to consume from AWS Kinesis service
- Wait for the Camel K integration to start and listen for AWS Kinesis data stream
- Create a new message on the AWS Kinesis data stream
- Verify that the integration has received the message event

*Cleanup*
- Stop the LocalStack container
- Delete the Camel K integration
- Delete the secret from the current namespace

## Installation

The test assumes that you have access to a Kubernetes cluster and that the Camel K operator as well as the YAKS operator is installed
and running.

You can review the installation steps for the operators in the documentation:

- [Install Camel K operator](https://camel.apache.org/camel-k/latest/installation/installation.html)
- [Install YAKS operator](https://github.com/citrusframework/yaks#installation)

## Run the tests

To run the Kinesis source tests: 

```shell script
$ yaks run aws-kinesis-source.feature
```

To run the Kinesis sink tests:

```shell script
$ yaks run aws-kinesis-sink.feature
```

To run tests with URI based configuration: 

```shell script
$ yaks run aws-kinesis-source-uri-conf.feature
```

To run tests with property based configuration:

```shell script
$ yaks run aws-kinesis-source-property-conf.feature
```

To run tests with URI binding:

```shell script
$ yaks run aws-kinesis-uri-pipe.feature
```

You will be provided with the test log output and the test results.
