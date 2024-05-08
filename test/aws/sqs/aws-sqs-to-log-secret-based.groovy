// camel-k: language=groovy

from("kamelet:aws-sqs-source/aws-sqs-credentials")
  .to("log:info")
