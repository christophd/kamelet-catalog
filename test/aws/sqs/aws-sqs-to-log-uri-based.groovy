// camel-k: language=groovy

def parameters = 'queueNameOrArn=${aws.sqs.queueName}&' +
                    'overrideEndpoint=true&' +
                    'uriEndpointOverride=${YAKS_TESTCONTAINERS_LOCALSTACK_SQS_URL}&' +
                    'accessKey=${YAKS_TESTCONTAINERS_LOCALSTACK_ACCESS_KEY}&' +
                    'secretKey=${YAKS_TESTCONTAINERS_LOCALSTACK_SECRET_KEY}&'+
                    'region=${YAKS_TESTCONTAINERS_LOCALSTACK_REGION}&'+
                    'deleteAfterRead=true'

from("kamelet:aws-sqs-source?$parameters")
  .to("log:info")
