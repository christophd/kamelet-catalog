Feature: Insert field Kamelet action

  Background:
    Given HTTP server timeout is 5000 ms
    Given HTTP server "test-service"
    Given variables
      | field | subject |
      | value | Camel K rocks! |

  Scenario: Create Http server
    Given create Kubernetes service test-service with target port 8080
    Given purge endpoint test-service

  Scenario: Create Pipe
    Given variable input is
    """
    { "id": "citrus:randomUUID()" }
    """
    When load Pipe insert-field-action-pipe.yaml
    Then Camel K integration insert-field-action-pipe should be running
    And Camel K integration insert-field-action-pipe should print Routes startup

  Scenario: Verify output message sent
    Given expect HTTP request body
    """
    { "id": "@ignore@", "${field}": "${value}" }
    """
    And expect HTTP request header: Content-Type="application/json;charset=UTF-8"
    When receive POST /result
    Then send HTTP 200 OK

  Scenario: Remove resources
    Given delete Pipe insert-field-action-pipe
    And delete Kubernetes service test-service
