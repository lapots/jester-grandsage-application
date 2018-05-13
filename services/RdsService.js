const pg = require('pg');
const connStr = `postgres://${process.env.RDS_LOGIN}:${process.env.RDS_PASSWORD}@${process.env.RDS_HOST}:${process.env.RDS_PORT}/${process.env.RDS_DB}`;
const client = new pg.Client(connStr);

function generateRandom(generator) {
    let pool = new pg.Pool();
    console.log('created pool');
    pool.connect(connStr, function(err, client, done) {
       if (err) {
           console.error(err);
           return '';
       }

       client.query('select generator.generateName($1)', [generator], function(err, result) {
           done();
           if (err) {
               console.error(err);
               return ''
           }

           console.log(result);
           return result;
       })
    });

    pool.end();
}

module.exports = generateRandom;
