# Jira Kamelet test

This test verifies the Jira Kamelet source defined in [jira-source.kamelet.yaml](jira-source.kamelet.yaml)

## Objectives

The test verifies the Jira Kamelet by creating a Camel K integration that uses the Kamelet and listens for new 
Jira issue objects. 

In jira-source new issue event is passed to a logger-sink Kamelet by Pipe.

### Test Kamelet

The test performs the following high level steps:

*Preparation*
- Create a Jira API server that will simulate the Jira API (e.g. providing a new issue as a response)

*Scenario* 
- Create the Camel K integration that uses the Jira Kamelets
- Wait for the Camel K integration to start and listen for new issue events
- Simulate a new issue returned by the Jira API server
- Verify the issue was logged by Camel K integrations using the log-sink

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
$ yaks run jira-source.feature
```

You can increase number of attempts to run the test by adding: "-e YAKS_CAMELK_MAX_ATTEMPTS=1000"

You will be provided with the test log output and the test results.
