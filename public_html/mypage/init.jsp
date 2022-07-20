<%@ include file="/init.jsp" %><%

//로그인
if(0 == userId) { auth.loginForm(); return; }

//채널
String ch = "mypage";

//정보-회원
UserDao user = new UserDao();
DataSet uinfo = user.find("id = ? AND status = 1", new Object[] {userId});//수정
if(!uinfo.next()) { m.jsError("해당 회원 정보가 없습니다."); return; }

%>