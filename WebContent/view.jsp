<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%
    	String loginid = session.getId();
    	System.out.println(loginid);
    %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
</head>
<body>
    <!-- 로그인한 상태일 경우와 비로그인 상태일 경우의 chat_id설정 -->
	<% if (loginid != null) { %>
        <input type="hidden" value='<%=loginid %>' id='chat_id' />
	<% } else { %>
        <input type="hidden" value='<%=session.getId().substring(0, 6)%>'
            id='chat_id' />
	<% } %>
    <!--     채팅창 -->
    <div id="_chatbox" style="display: none">
        <fieldset>
            <div id="messageWindow"></div>
            <br /> 
                <input id="inputMessage" type="text"/>
            <input type="submit" value="send" onclick="send()" />
        </fieldset>
    </div>
    <img class="chat" width="300" height="300" src="https://www.trazi.hr/wp-content/uploads/2017/02/chat-1.png" />
</body>
<!-- 말풍선아이콘 클릭시 채팅창 열고 닫기 -->
<script>
var chatOn = "https://www.trazi.hr/wp-content/uploads/2017/02/chat-1.png";
var chatHide = "https://cdn0.iconfinder.com/data/icons/basic-ui-elements-colored/700/010_x-3-512.png";
    $(".chat").on({
        "click" : function() {
            if ($(this).attr("src") == chatOn) {
                $(".chat").attr("src", chatHide);
                $("#_chatbox").css("display", "block");
            } else if ($(this).attr("src") == chatHide) {
                $(".chat").attr("src", chatOn);
                $("#_chatbox").css("display", "none");
            }
        }
    });
</script>
<script type="text/javascript">
    var textarea = document.getElementById("messageWindow");
    var host = location.host;
    var path = '/' + location.pathname.split('/')[1];
    var wsUrl = 'ws://' + host + path + '/chat';
    
    var webSocket = new WebSocket(wsUrl);
    var inputMessage = document.getElementById('inputMessage');
    webSocket.onerror = function(event) {
        onError(event)
    };
    webSocket.onopen = function(event) {
        onOpen(event)
    };
    webSocket.onmessage = function(event) {
        onMessage(event)
    };
    function onMessage(event) {
        var message = event.data.split("|");
        var sender = message[0];
        var content = message[1];
        if (content == "") {
            
        } else {
        	//  /ID 를 입력하면 귀속말 가능
            if (content.match("/")) {
                if (content.match(("/" + $("#chat_id").val()))) {
                    var temp = content.replace("/" + $("#chat_id").val(), "(귓속말) :").split(":");
                    if (temp[1].trim() == "") {
                    } else {
                        $("#messageWindow").html($("#messageWindow").html() + "<p class='whisper'>"
                            + sender + content.replace("/" + $("#chat_id").val(), "(귓속말) :") + "</p>");
                    }
                } else {
                }
            } else {
                if (content.match("!")) {
                    $("#messageWindow").html($("#messageWindow").html()
                        + "<p class='chat_content'><b class='impress'>" + sender + " : " + content + "</b></p>");
                } else {
                    $("#messageWindow").html($("#messageWindow").html()
                        + "<p class='chat_content'>" + sender + " : " + content + "</p>");
                }
            }
        }
    }
    function onOpen(event) {
        $("#messageWindow").html("<p class='chat_content'>채팅에 참여하였습니다.</p>");
    }
    function onError(event) {
        alert(event.data);
    }
    function send() {
        if (inputMessage.value == "") {
        } else {
            $("#messageWindow").html($("#messageWindow").html()
                + "<p class='chat_content'>나 : " + inputMessage.value + "</p>");
        }
        webSocket.send($("#chat_id").val() + "|" + inputMessage.value);
        inputMessage.value = "";
    }


    // 모든 브라우저 호환
	$("#inputMessage").keyup(function(e) {
		var code = e.which;
		if (code == 13)
			e.preventDefault();
		if (code == 13) {
			send();
		}
	});

	//     엔터키를 통해 send함
	function enterkey() {
		if (window.event.keyCode == 13) {
			send();
		}
	}
	//     채팅이 많아져 스크롤바가 넘어가더라도 자동적으로 스크롤바가 내려가게함
	window.setInterval(function() {
		var elem = document.getElementById('messageWindow');
		elem.scrollTop = elem.scrollHeight;
	}, 0);
</script>

</html>