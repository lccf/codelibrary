"use strict";
const assert = require("cucumber-assert");
module.exports = function () {
    let step = this;
    let client;
    step.Given('我访问 {arg1:stringInDoubleQuotes}', function (pageUrl, callback) {
        client = this.client;
        client.url(pageUrl).call(callback);
    });
    step.Then('我输入 {arg1:stringInDoubleQuotes}', function (queryString, callback) {
        client = this.client;
        client.setValue('#sb_form_q', queryString).call(callback);
    });
    step.Then('我点击搜索', function (callback) {
        client = this.client;
        client.click('#sb_form_go').call(callback);
    });
    step.When('页面标题中应包含 {arg1:stringInDoubleQuotes}', function (title, callback) {
        client = this.client;
        client.waitForVisible('#b_results', 3000).then(() => {
            client.getTitle().then(pageTitle => {
                assert.notEqual(pageTitle.match(title), null, callback, `页面标题中不包含${title}`);
            });
        });
    });
};
//# sourceMappingURL=bing_search_steps.js.map