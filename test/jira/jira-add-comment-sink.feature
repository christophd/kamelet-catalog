Feature: Jira Kamelet - Sink

  Background:
    Given variables
      | timer.source.period | 10000 |
      | jira.project.key    | CAMEL |
      | jira.project.id     | 10001 |
      | jira.issue.id       | 10001 |
      | jira.issue.key      | CAMEL-10001 |
      | jira.issue.summary  | New bug, citrus:randomString(10) |
      | jira.issue.assignee | Superman |
      | jira.issue.type     | Bug |
      | jira.issue.description | Sample bug |
      | jira.issue.comment  | New comment, citrus:randomString(10) |
      | jira.issue.comment.id | 10001 |
      | jira.username       | yaks   |
      | jira.password       | secr3t |
    Given HTTP server timeout is 120000 ms
    Given HTTP server "jira-service"

  Scenario: Create Http server
    Given create Kubernetes service jira-service

  Scenario: Verify Jira events
    # Create binding
    Given load Pipe jira-add-comment-sink-pipe.yaml
    # Verify get issue request
    Given expect HTTP request header: Authorization="Basic citrus:encodeBase64(${jira.username}:${jira.password})"
    When receive GET /rest/api/latest/issue/${jira.issue.key}
    Then HTTP response header: Content-Type="application/json"
    And HTTP response body: yaks:readFile('jira-get-issue-response.json')
    Then send HTTP 200 OK
    # Verify add comment request
    Given expect HTTP request header: Authorization="Basic citrus:encodeBase64(${jira.username}:${jira.password})"
    When receive GET /rest/api/latest/serverInfo
    Then HTTP response body: yaks:readFile('jira-server-info.json')
    Then send HTTP 200 OK
    # Verify add comment request
    Given expect HTTP request header: Authorization="Basic citrus:encodeBase64(${jira.username}:${jira.password})"
    Then expect HTTP request body
    """
    {
        "body": "${jira.issue.comment}"
    }
    """
    When receive POST /rest/api/latest/issue/${jira.issue.key}/comment
    Then HTTP response body: yaks:readFile('jira-add-comment-response.json')
    Then send HTTP 200 OK
    # Verify event
    And Camel K integration jira-add-comment-sink-pipe should print ${jira.issue.comment}

  Scenario: Remove resources
    # Remove Camel K binding
    Given delete Pipe jira-add-comment-sink-pipe
    Given delete Kubernetes service jira-service
    And stop server component jira-service
