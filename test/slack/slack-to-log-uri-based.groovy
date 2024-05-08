// camel-k: language=groovy

def parameters = 'serverUrl=yaks:resolveURL(slack-service)&channel=${slack.channel}&token=${slack.token}'

from("kamelet:slack-source?$parameters")
    .to('log:info')
