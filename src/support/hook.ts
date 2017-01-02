import * as webdriverio from 'webdriverio';
import * as cucumber from 'cucumber';

let client: WebdriverIO.Client<void> = null;

let initClient = function(callback: cucumber.CallbackStepDefinition) {
  let options: WebdriverIO.RemoteOptions = {
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
}

module.exports = function() {
  let hook = <cucumber.Hooks>this;

  hook.registerHandler('BeforeFeatures', (features: any, callback: cucumber.CallbackStepDefinition) => {
    initClient(callback);
  });

  hook.Before(function(scenarioResult, callback: Function) {
    this.client = client;
    callback();
  });

  hook.registerHandler('AfterFeatures', (features, callback: cucumber.CallbackStepDefinition) => {
    client.end().call(callback);
  });
}