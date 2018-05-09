package com.lapots.breed.jester;

import com.amazonaws.serverless.proxy.jersey.JerseyLambdaContainerHandler;
import com.amazonaws.serverless.proxy.model.AwsProxyRequest;
import com.amazonaws.serverless.proxy.model.AwsProxyResponse;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import org.glassfish.jersey.server.ResourceConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Lambda function for name generation.
 */
public class JesterNameGenerationHandler implements RequestHandler<AwsProxyRequest, AwsProxyResponse> {
    private static final Logger LOGGER = LoggerFactory.getLogger(JesterNameGenerationHandler.class);

    private static final ResourceConfig JERSEY_APP = new ResourceConfig()
            .packages("com.lapots.breed.jester");
    private static final JerseyLambdaContainerHandler<AwsProxyRequest, AwsProxyResponse> HANDLER =
            JerseyLambdaContainerHandler.getAwsProxyHandler(JERSEY_APP);

    @Override
    public AwsProxyResponse handleRequest(AwsProxyRequest input, Context context) {
        LOGGER.debug("Processing request: [{}].", input);
        HANDLER.proxy(input, context);
        // TODO:implement existing name check
        return null;
    }
}
