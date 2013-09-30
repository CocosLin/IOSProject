var gapp_server = "http://gapp.gitom.com";
var gapp_server_getUserInfo = gapp_server+"/api/getUserinfo.json?act=cas";
var uc_regedit = "http://uc.gitom.com/Register";



function loadUserInfo(callBack,time){
	if(!time){time=5;}
	time--;
	if(time<=0){
		$.showToast({msg:"用户信息加载失败"})
		window.myjs.runOnAndroidJavaScript("CASLOGIN_SUCCESS_1")
		return;
	}
	$.ajax({
		crossDomain:true,
		type: 'GET', /*定义发送数据的方式*/
		cache : false, /*是否用缓存*/
		//url: 'http://login.gitom.com/login?service='+encodeURI(gapp_server_getUserInfo),
		url:gapp_server_getUserInfo,
		jsonpCallback:"loadUserInfoCallback",
		data:{},/*要发往服务器的数据值对*/
		dataType: 'jsonp',
		error:function(){
			loadUserInfo(callBack,time);
		},
           success: function(data) {
           alert(JSON.stringify(data));
			console.log(JSON.stringify(data))
           
           //var data = JSON.stringify(data);
           
           
           
			if(data.name){
           //alert(1111)
				user_info = data;
//           bridge.send(user_info, function(responseData) {
//                       
//                       })
           //alert(2222)
			}else{
           
				user_info = {name:"guest"}
			}
			user_info.orderData="";
			if(!user_info.nick_name){
				user_info.nick_name = user_info.name;
			}
			$.putAccountIntoApp(user_info)
			
			if(callBack)callBack(data);
		}
	})
}
