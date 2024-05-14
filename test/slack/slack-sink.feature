Feature: Slack Kamelet - Sink

  Background:
    Given variables
      | timer.source.period | 10000 |
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
    Given load Pipe slack-sink-pipe.yaml
    And Pipe slack-sink-pipe is available
    # Verify authentication test
    Given expect HTTP request header: Content-Type="application/json; charset=UTF-8"
    Then expect HTTP request body
    """
    {
        "channel": "${slack.channel}",
        "text": "${slack.message}",
    }
    """
    When receive POST /
    Then send HTTP 200 OK
    # Verify event
    And Camel K integration slack-sink-pipe should print ${slack.message}

  Scenario: Remove resources
    # Remove Camel K binding
    Given delete Pipe slack-sink-pipe
    Given delete Kubernetes service slack-service
    And stop server component slack-service
