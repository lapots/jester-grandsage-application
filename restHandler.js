const NamingService = require('./services/NamingService');

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
    generateAllianceName: (event, context, callback) => {
        context.callbackWaitsForEmptyEventLoop = false;
        const namingService = new NamingService();
        const generatedName = namingService.generateGreekAllianceName();
        callback(null, responses.success(generatedName));
    }
};
