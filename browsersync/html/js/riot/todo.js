riot.tag2('todo', '<h3>{opts.title}</h3> <ul> <li each="{item, i in items}">{item}</li> </ul> <form onsubmit="{add}"> <input> <button>Add #{items.length + 1}</button> </form>', 'todo h3,[riot-tag="todo"] h3 { font-size: 14px; }', '', function(opts) {
    this.items = []

    this.add = function(e) {
      var input = e.target[0]
      this.items.push(input.value)
      input.value = ''
    }.bind(this)
}, '{ }');
