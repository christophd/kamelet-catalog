import software.amazon.awssdk.auth.credentials.AwsBasicCredentials
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.kinesis.KinesisClient

KinesisClient kinesisClient = KinesisClient
        .builder()
        .endpointOverride(URI.create("${YAKS_TESTCONTAINERS_LOCALSTACK_KINESIS_LOCAL_URL}"))
        .credentialsProvider(StaticCredentialsProvider.create(
                AwsBasicCredentials.create(
                        "${YAKS_TESTCONTAINERS_LOCALSTACK_ACCESS_KEY}",
                        "${YAKS_TESTCONTAINERS_LOCALSTACK_SECRET_KEY}")
        ))
        .region(Region.of("${YAKS_TESTCONTAINERS_LOCALSTACK_REGION}"))
        .build()

kinesisClient.createStream(s -> s.streamName("${aws.kinesis.streamName}").shardCount(1))

return kinesisClient
