App.notice = App.cable.subscriptions.create("NoticeChannel",{
  
  connected: function(){
    console.log("connected")
  },
 
  disconnected: function(){},
 
  received: function(data){
    console.log("received")
  },
  say:function(data){
    this.perform("say",{message:data})
  }
})
$(function(){

  $("input#say").on("keydown",function(e){
    if (e.keyCode == 13) {
      value = $(this).val()
      console.log(value)
      App.notice.say(value)
      e.target.value = ""
      e.preventDefault()
    };
  })
})