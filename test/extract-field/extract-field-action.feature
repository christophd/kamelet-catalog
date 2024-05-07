Feature: Extract field Kamelet action

  Background:
    Given HTTP server timeout is 15000 ms
    Given HTTP server "test-service"
    Given variable field = "subject"

  Scenario: Create Http server
    Given create Kubernetes service test-service with target port 8080
    Given purge endpoint test-service

  Scenario: Create Pipe
    Given variable input is
    """
    { "id": "citrus:randomUUID()", "${field}": "Camel K rocks!" }
    """
    When load Pipe extract-field-action-pipe.yaml
    Then Camel K integration extract-field-action-pipe should be running
    And Camel K integration extract-field-action-pipe should print Routes startup

  Scenario: Verify output message sent
    Given expect HTTP request body: "Camel K rocks!"
    When receive POST /result
    Then send HTTP 200 OK

  Scenario: Remove resources
    Given delete Pipe extract-field-action-pipe
    And delete Kubernetes service test-service
