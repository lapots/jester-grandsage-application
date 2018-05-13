const randomizer = require('./RdsService');

class NamingService {

    generateGreekAllianceName() {
        return randomizer('alliance');
    }
}

module.exports = NamingService;
