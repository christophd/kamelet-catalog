import software.amazon.awssdk.auth.credentials.AwsBasicCredentials
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.dynamodb.DynamoDbClient
import software.amazon.awssdk.services.dynamodb.model.AttributeDefinition
import software.amazon.awssdk.services.dynamodb.model.KeySchemaElement
import software.amazon.awssdk.services.dynamodb.model.KeyType
import software.amazon.awssdk.services.dynamodb.model.ProvisionedThroughput
import software.amazon.awssdk.services.dynamodb.model.ScalarAttributeType
import software.amazon.awssdk.services.dynamodb.model.StreamSpecification
import software.amazon.awssdk.services.dynamodb.model.StreamViewType

DynamoDbClient amazonDDBClient = DynamoDbClient
        .builder()
        .endpointOverride(URI.create("${YAKS_TESTCONTAINERS_LOCALSTACK_DYNAMODB_LOCAL_URL}"))
        .credentialsProvider(StaticCredentialsProvider.create(
                AwsBasicCredentials.create(
                        "${YAKS_TESTCONTAINERS_LOCALSTACK_ACCESS_KEY}",
                        "${YAKS_TESTCONTAINERS_LOCALSTACK_SECRET_KEY}")
        ))
        .region(Region.of("${YAKS_TESTCONTAINERS_LOCALSTACK_REGION}"))
        .build()

amazonDDBClient.createTable(b -> {
        b.tableName("${aws.ddb.tableName}")
        b.keySchema(
                KeySchemaElement.builder().attributeName("id").keyType(KeyType.HASH).build(),
        )
        b.attributeDefinitions(
                AttributeDefinition.builder().attributeName("id").attributeType(ScalarAttributeType.N).build(),
        )

        if (${aws.ddb.streams}) {
            b.streamSpecification(StreamSpecification.builder()
                .streamEnabled(true)
                .streamViewType(StreamViewType.NEW_AND_OLD_IMAGES).build())
        }

        b.provisionedThroughput(
                ProvisionedThroughput.builder()
                        .readCapacityUnits(1L)
                        .writeCapacityUnits(1L).build())
})

return amazonDDBClient
