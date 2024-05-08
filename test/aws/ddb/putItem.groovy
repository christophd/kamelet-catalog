import software.amazon.awssdk.services.dynamodb.model.AttributeValue
import software.amazon.awssdk.services.dynamodb.model.ReturnValue

Map<String, AttributeValue> item = new HashMap<>()
item.put("id", AttributeValue.builder().n("${aws.ddb.item.id}").build())
item.put("year", AttributeValue.builder().n("${aws.ddb.item.year}").build())
item.put("title", AttributeValue.builder().s("${aws.ddb.item.title}").build())

amazonDDBClient.putItem(b -> {
    b.tableName("${aws.ddb.tableName}")
    b.item(item)
    b.returnValues(ReturnValue.ALL_OLD)
})
