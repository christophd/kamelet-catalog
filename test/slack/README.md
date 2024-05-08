# Slack Kamelet test

This test verifies the Slack Kamelets defined in [slack-source.kamelet.yaml](slack-source.kamelet.yaml)

## Objectives

The test verifies the Slack Kamelets by creating a Camel K integration that uses the Kamelet to listen for messages on a
Slack channel using the Slack bot API.

### Test Kamelet source

The test performs the following high level steps:

*Preparation*
- Create a Slack API server that will simulate the Slack API 

*Scenario* 
- Create the Camel K integration that uses the Slack Kamelets
- Wait for the Camel K integration to start and listen for Slack messages
- Create a new message on the Slack channel
- Verify that the integration has received the message event

*Cleanup*
- Delete the Camel K integration

## Installation

The test assumes that you have access to a Kubernetes cluster and that the Camel K operator as well as the YAKS operator is installed
and running.

You can review the installation steps for the operators in the documentation:

- [Install Camel K operator](https://camel.apache.org/camel-k/latest/installation/installation.html)
- [Install YAKS operator](https://github.com/citrusframework/yaks#installation)

## Run the test

```shell script
$ yaks test slack-uri-pipe.feature
```

You will be provided with the test log output and the test results.
