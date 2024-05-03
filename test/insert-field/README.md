# Insert field Kamelet action test

This test verifies the Kamelet action defined in [insert-field-action.kamelet.yaml](../../insert-field-action.kamelet.yaml)

## Objectives

The test verifies the insert field Kamelet action by creating a Pipe that uses the action. 
In the following the test provides a proper input to the binding and verifies the expected outcome on a Http service endpoint. 

### Test Kamelet action

The test performs the following high level steps:

*Preparation*
- Create and start Http test service as a sink for the Pipe
- Expose the service on a given target port

*Scenario* 
- Configure and create the Pipe that uses the action (timer-source to uri)
- Wait for the Camel K integration to start
- Verify that the binding has performed the Kamelet action as expected by verifying the Http service sink request data

*Cleanup*
- Delete the Pipe
- Delete the test Http service

## Installation

The test assumes that you have access to a Kubernetes cluster and that the Camel K operator as well as the YAKS operator is installed
and running.

You can review the installation steps for the operators in the documentation:

- [Install Camel K operator](https://camel.apache.org/camel-k/latest/installation/installation.html)
- [Install YAKS operator](https://github.com/citrusframework/yaks#installation)

## Preparations

If for any reason this script execution does not work for your OS or environment you may need to run this step manually on your cluster and
remove the prepare script from the [yaks-config.yaml](yaks-config.yaml).

Now you should be ready to run the test!

## Run the test

```shell script
$ yaks run test/insert-field-action
```

You will be provided with the test log output and the test results.
