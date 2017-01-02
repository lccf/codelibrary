"use strict";
const webdriverio = require("webdriverio");
let client = null;
let initClient = function (callback) {
    let options = {
        desiredCapabilities: {
            browserName: 'chrome'
        },
        logLevel: 'silent',
        baseUrl: 'http://localhost:3000'
    };
    client = webdriverio
        .remote(options)
        .init()
        .setViewportSize({ width: 800, height: 768 }, true)
        .getViewportSize().then(size => console.log(size))
        .call(callback);
};
module.exports = function () {
    let hook = this;
    hook.registerHandler('BeforeFeatures', (features, callback) => {
        initClient(callback);
    });
    hook.Before(function (scenarioResult, callback) {
        this.client = client;
        callback();
    });
    hook.registerHandler('AfterFeatures', (features, callback) => {
        client.end().call(callback);
    });
};
//# sourceMappingURL=hook.js.map