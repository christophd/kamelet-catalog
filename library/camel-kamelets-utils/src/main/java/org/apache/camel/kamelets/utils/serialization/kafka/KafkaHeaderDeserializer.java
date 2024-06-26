/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.camel.kamelets.utils.serialization.kafka;

import java.nio.charset.StandardCharsets;
import java.util.Map;

import org.apache.camel.Exchange;
import org.apache.camel.Processor;
import org.apache.camel.TypeConverter;
import org.apache.camel.support.SimpleTypeConverter;

/**
 * Header deserializer used in Kafka source Kamelet. Automatically converts all message headers to String.
 * Uses given type converter implementation set on the Camel context to convert values. If no type converter is set
 * the deserializer uses its own fallback conversion implementation.
 */
public class KafkaHeaderDeserializer implements Processor {

    @Override
    public void process(Exchange exchange) throws Exception {
        Map<String, Object> headers = exchange.getMessage().getHeaders();

        TypeConverter typeConverter = exchange.getContext().getTypeConverter();
        if (typeConverter == null) {
            typeConverter = new SimpleTypeConverter(true, this::convert);
        }

        for (Map.Entry<String, Object> header : headers.entrySet()) {
            header.setValue(typeConverter.convertTo(String.class, header.getValue()));
        }
    }

    /**
     * Fallback conversion strategy supporting null values, String and byte[]. Converts headers to respective
     * String representation or null.
     * @param type target type, always String in this case.
     * @param exchange the exchange containing all headers to convert.
     * @param value the current value to convert.
     * @return String representation of given value or null if value itself is null.
     */
    private Object convert(Class<?> type, Exchange exchange, Object value) {
        if (value == null) {
            return null;
        }

        if (value instanceof String) {
            return value;
        }

        if (value instanceof byte[]) {
            return new String((byte[]) value, StandardCharsets.UTF_8);
        }

        return value.toString();
    }
}
