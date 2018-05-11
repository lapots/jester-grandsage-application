const NamingService = require('./NamingService');

const responseHeaders = {
    'Content-Type':'application/json',
    'Access-Control-Allow-Origin' : '*',
    'Access-Control-Allow-Credentials' : true
};

const responses = {
    success: (data={}, code=200) => {
        return {
            'statusCode': code,
            'headers': responseHeaders,
            'body': JSON.stringify(data),
            'isBase64Encoded': false
        }
    },
    error: (error) => {
        return {
            'statusCode': error.code || 500,
            'headers': responseHeaders,
            'body': JSON.stringify(error),
            'isBase64Encoded': false
        }
    }
};

module.exports = {
    generateName: (event, context, callback) => {
        context.callbackWaitsForEmptyEventLoop = false;
        const namingService = new NamingService();
        namingService.generateName()
            .then(name => {
                callback(null, responses.success(name))
            })
            .catch(error => {
                callback(null, responses.error(error))
            })
    }
};
