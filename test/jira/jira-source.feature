Feature: Jira Kamelet - Source

  Background:
    Given variables
      | jira.project.id    | 10001 |
      | jira.issue.id      | 10001 |
      | jira.issue.key     | CAMEL-1 |
      | jira.issue.summary | New bug, citrus:randomString(10) |
      | jira.username      | yaks   |
      | jira.password      | secr3t |
      | jira.jql           | assignee=yaks |
    Given HTTP server timeout is 120000 ms
    Given HTTP server "jira-service"

  Scenario: Create Infra
    Given create Kubernetes service jira-service
    Given create Kubernetes secret jira-credentials from file jira-credentials.properties

  Scenario: Verify Jira events
    # Create binding
    Given load Pipe jira-source-pipe.yaml
    # Verify latest issue request
    Given expect HTTP request header: Authorization="Basic citrus:encodeBase64(${jira.username}:${jira.password})"
    And expect HTTP request query parameter jql="yaks:urlEncode(${jira.jql})+ORDER+BY+key+desc"
    And expect HTTP request query parameter maxResults="1"
    When receive GET /rest/api/latest/search
    Then HTTP response header: Content-Type="application/json"
    And HTTP response body: yaks:readFile('jira-latest-issue.json')
    Then send HTTP 200 OK
    # Verify search request
    Given expect HTTP request header: Authorization="Basic citrus:encodeBase64(${jira.username}:${jira.password})"
    And expect HTTP request query parameter jql="yaks:urlEncode(${jira.jql})+ORDER+BY+key+desc"
    And expect HTTP request query parameter maxResults="50"
    And expect HTTP request query parameter expand="schema%2Cnames"
    When receive GET /rest/api/latest/search
    Then HTTP response header: Content-Type="application/json"
    And HTTP response body: yaks:readFile('jira-search-results.json')
    Then send HTTP 200 OK
    And Camel K integration jira-source-pipe should print ${jira.issue.summary}

  Scenario: Remove resources
    # Remove Camel K binding
    Given delete Pipe jira-source-pipe
    Given delete Kubernetes secret jira-credentials
    Given delete Kubernetes service jira-service
    And stop server component jira-service
