# Data type transformation

This test verifies the data type transformations

## Objectives

The test verifies the proper transformations based on data types e.g. `http:application-cloudevents`.

### YAKS Test

The test performs the following high level steps:

*Avro data type feature*
- Create test data based on the User.avsc Avro schema
- Load and run the `avro-to-log` Pipe
- Load and run the `json-to-avro` Pipe
- Verify that the bindings do interact with each other and the proper test data is logged in the binding output

## Installation

The test assumes that you have [JBang](https://www.jbang.dev/) installed and the YAKS CLI setup locally.

You can review the installation steps for the tooling in the documentation:

- [JBang](https://www.jbang.dev/documentation/guide/latest/installation.html)
- [Install YAKS CLI](https://github.com/citrusframework/yaks#installation)

## Run the tests with JBang

To run tests with URI based configuration: 

```shell script
$ yaks run --local test/avro-data-type/avro-serdes-action.feature
```

You will be provided with the test log output and the test results.
