const NamingService = require('./NamingService');

const responses = {
    success: (data={}) => {
        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin" : "*",
                "Access-Control-Allow-Credentials" : true
            },
            "body": JSON.stringify(data)
        }
    },
    error: (error) => {
        return {
            "statusCode": error.code || 500,
            "headers": {
                "Access-Control-Allow-Origin" : "*",
                "Access-Control-Allow-Credentials" : true
            },
            "body": JSON.stringify(error)
        }
    }
};

module.exports = {
    generateName: (event, context, callback) => {
        context.callbackWaitsForEmptyEventLoop = false;
        const namingService = new NamingService();
        const generatedName = namingService.generateName();
        callback(null, responses.success(generatedName));
    }
};
