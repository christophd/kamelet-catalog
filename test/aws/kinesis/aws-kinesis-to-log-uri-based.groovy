// camel-k: language=groovy

def parameters = 'stream=${aws.kinesis.streamName}&' +
                    'overrideEndpoint=true&' +
                    'uriEndpointOverride=${YAKS_TESTCONTAINERS_LOCALSTACK_KINESIS_URL}&' +
                    'accessKey=${YAKS_TESTCONTAINERS_LOCALSTACK_ACCESS_KEY}&' +
                    'secretKey=${YAKS_TESTCONTAINERS_LOCALSTACK_SECRET_KEY}&'+
                    'region=${YAKS_TESTCONTAINERS_LOCALSTACK_REGION}'

from("kamelet:aws-kinesis-source?$parameters")
    .to("log:info")
