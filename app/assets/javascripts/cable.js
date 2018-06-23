// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `rails generate channel` command.
//
//= require action_cable
//= require_self

(function() {
  this.App || (this.App = {});
  var data = JSON.parse($.ajax({url:"/wechat/websocket.json",async:false}).responseText);
  console.log(data,'-----------');
  var url = 'ws://'+data.host+'/cable?uid='+data.uid;
  App.cable = ActionCable.createConsumer(url);

}).call(this);
