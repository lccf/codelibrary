import * as cucumber from 'cucumber';

function CustomWorld(callback: cucumber.CallbackStepDefinition) {

}

module.exports = function() {
    this.World = CustomWorld;
}