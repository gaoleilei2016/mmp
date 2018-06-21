var socket;

function OutputLog(msg){	
	console.log(msg);
	
};

function DealJob(msg) {
	if (msg.indexOf("json:{")>=0)
	{
		msg = msg.substr(5,msg.length-5);
	}
	var idcard = JSON.parse(msg);
	if (typeof(idcard) == undefined || idcard.error != 0) {
		alert("Read IdCard error.");
	} else {
		//todo Job
		// console.log(idcard);
		// $('#photo').attr('src','data:image/bmp;base64,'+idcard.img);
		// 身份证信息调用成功之后，执行自己业务的方法
		apps.encounters_new.SetIdCardInfo(idcard);
	}
}

function connect(){

	var host = "ws://127.0.0.1:5689/test";
			
	try{
		socket = new WebSocket(host);
		OutputLog('Socket Status: '+socket.readyState);
		socket.onopen = function(){
			OutputLog('Socket Status: '+socket.readyState+' (open)');
			var pseudoName = Math.floor(Math.random()*10000);//$('#pseudo').val();
			socket.send('0'+pseudoName);
		}
		
		socket.onmessage = function(msg){
			console.log(msg);
			var str = "";
			str = msg.data;
			var id  = str.match(/\d+/)[0];
			var separator = str.indexOf("|");
			var jsonpos = str.indexOf("json:");
			var arg1 = "";
			var arg2 = "";
			if(separator != -1 && (jsonpos == -1 || separator < jsonpos))
			{
				arg1 = str.substr(id.length, separator-1);
				arg2 = str.substr(separator+1);
			}
			else
				arg1 = str.substr(id.length);				
			
			if(id == "0"){
				OutputLog('Server reply : '+arg1);	
			}
			if(id == "1"){
				if (arg1.indexOf("json:{")>=0)
				{
					DealJob(arg1.substr(5,arg1.length-5));
				} else {
					OutputLog('Server echo msg : '+arg1);	
				}						
			}
			if(id == "2"){
				OutputLog(arg1 + ' said : ' + arg2);	 						
			}
			if(id == "3"){
				OutputLog(arg1 + ' broadcasted : ' + arg2);	 						
			}
			if(id == "4"){
				OutputLog('Server streamed : '+arg1);	
			}
			if(id == "5"){
				OutputLog('Server push : '+arg1);
				DealJob(arg1);
			}


		}
		
		socket.onclose = function(){
			OutputLog('Socket Status: '+socket.readyState+' (Closed)');
		}			
			
	} catch(exception){
		OutputLog('Error'+exception);
	}
	
}