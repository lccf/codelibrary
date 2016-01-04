var WSH = new ActiveXObject('WScript.Shell');
var paths = {
  'RUBY_HOME': 'D:\\ruby\\Ruby200-x64',
  'DEVKIT_HOME': 'D:\\ruby\\devkit',
  'PYTHON_HOME': 'D:\\python\\Python27-x64',
  'NODE_HOME': 'D:\\node',
  'GIT_HOME': 'D:\\Program Files\\git',
  'NODE_PATH': '%NODE_HOME%\\node_modules',
  'PATH': '%RUBY_HOME%\\bin;%PYTHON_HOME%;%PYTHON_HOME%\\Scripts;%NODE_HOME%;%GIT_HOME%\\cmd;%DEVKIT_HOME%\\bin'
}
for (var key in paths) {
  // 设置系统环境变量
  // WSH.Environment('system').Item(key)=paths[key]
  WSH.Environment('user').Item(key)=paths[key]
}
WScript.Echo('set success!')
