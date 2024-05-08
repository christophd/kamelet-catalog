$(repeatOnError()
    .until('i > ${maxRetryAttempts}')
    .actions(new org.citrusframework.TestAction() {
        @Override
        void execute(org.citrusframework.context.TestContext context) {
            try {
                assert context.getVariable('aws.ddb.items').equals(amazonDDBClient.scan(b -> b.tableName(context.getVariable('aws.ddb.tableName')))?.items()?.toListString())
            } catch (AssertionError e) {
                throw new org.citrusframework.exceptions.CitrusRuntimeException("AWS DDB item verification failed", e)
            }
        }
    })
)
