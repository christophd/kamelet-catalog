$(repeatOnError()
    .until('i > ${maxRetryAttempts}')
    .actions(new org.citrusframework.TestAction() {
        @Override
        void execute(org.citrusframework.context.TestContext context) {
            try {
                assert context.getVariable('aws.ddb.item').equals(amazonDDBClient.getItem(b -> b.tableName(context.getVariable('aws.ddb.tableName'))
                        .key(Collections.singletonMap("id", software.amazon.awssdk.services.dynamodb.model.AttributeValue.builder().n(context.getVariable('aws.ddb.item.id')).build())))?.item()?.toString())
            } catch (AssertionError e) {
                throw new org.citrusframework.exceptions.CitrusRuntimeException("AWS DDB item verification failed", e)
            }
        }
    })
)
