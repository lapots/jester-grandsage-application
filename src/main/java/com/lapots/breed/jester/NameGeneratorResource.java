package com.lapots.breed.jester;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

/**
 * Resource for name generation.
 */
@Path("/names")
public class NameGeneratorResource {
    private static final Logger LOGGER = LoggerFactory.getLogger(NameGeneratorResource.class);

    /**
     * Generates alliance name.
     * @return alliance name
     */
    @Path("/alliance")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String generateAllianceName() {
        LOGGER.info("Generating alliance name.");
        return "sample-alliance-name";
    }

}
