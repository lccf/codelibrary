(function() {
  var list;

  list = "<% if (data.list && data.list.length) { %>\n  <ul>\n  <% _.each(data.list, function(item, key) { %>\n    <li>\n    <a href=\"<%=item.url%>\"><%=item.text%></a>\n    </li>\n  <% } %>\n  </ul>\n<% } %>\n";

  ndoo.service('template').set('list', list);

}).call(this);
