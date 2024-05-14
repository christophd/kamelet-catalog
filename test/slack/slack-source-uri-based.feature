Feature: Slack Kamelet - URI based configuration

  Background:
    Given variables
      | slack.channel | announcements |
      | slack.message | Camel rocks! |
      | slack.user.id | W12345678    |
      | slack.team.id | T12345678    |
    Given HTTP server timeout is 120000 ms
    Given HTTP server "slack-service"

  Scenario: Create Http server
    Given create Kubernetes service slack-service

  Scenario: Verify Slack events
    Given variables
      | slack.token   | xoxb-yaks:randomNumber(10)-yaks:randomNumber(13)-yaks:randomString(34) |
    # Create binding
    Given load Camel K integration slack-to-log-uri-based.groovy
    # Verify authentication test
    Given expect HTTP request header: Authorization="Bearer ${slack.token}"
    Given expect HTTP request header: Content-Type="application/x-www-form-urlencoded"
    When receive POST /api/auth.test
    Then HTTP response body: yaks:readFile('slack-auth-test.json')
    Then send HTTP 200 OK
    # Verify conversations list
    Given expect HTTP request header: Authorization="Bearer ${slack.token}"
    When receive POST /api/conversations.list
    Then HTTP response body: yaks:readFile('slack-conversations-list.json')
    Then send HTTP 200 OK
    # Verify conversations history
    Given expect HTTP request header: Authorization="Bearer ${slack.token}"
    When receive POST /api/conversations.history
    Then HTTP response body: yaks:readFile('slack-conversations-history.json')
    Then send HTTP 200 OK
    # Verify event
    And Camel K integration slack-to-log-uri-based should print ${slack.message}

  Scenario: Remove resources
    # Remove Camel K binding
    Given delete Camel K integration slack-to-log-uri-based
    Given delete Kubernetes service slack-service
