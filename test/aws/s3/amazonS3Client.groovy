import software.amazon.awssdk.auth.credentials.AwsBasicCredentials
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.s3.S3Client

S3Client s3 = S3Client
        .builder()
        .endpointOverride(URI.create("${YAKS_TESTCONTAINERS_LOCALSTACK_S3_LOCAL_URL}"))
        .credentialsProvider(StaticCredentialsProvider.create(
                AwsBasicCredentials.create(
                        "${YAKS_TESTCONTAINERS_LOCALSTACK_ACCESS_KEY}",
                        "${YAKS_TESTCONTAINERS_LOCALSTACK_SECRET_KEY}")
        ))
        .forcePathStyle(true)
        .region(Region.of("${YAKS_TESTCONTAINERS_LOCALSTACK_REGION}"))
        .build()

s3.createBucket(b -> b.bucket("${aws.s3.bucketNameOrArn}"))

return s3
