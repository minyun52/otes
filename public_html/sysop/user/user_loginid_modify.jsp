<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//기본키
String uid = m.rs("uid");
if("".equals(uid)) { m.jsErrClose("기본키는 반드시 지정해야 합니다."); return; }

//객체
UserDao user = new UserDao();

//정보
DataSet info = user.find("id = " + uid + " AND status != -1");
if(!info.next()) { m.jsAlert("해당 회원정보가 없습니다."); return;
}

//폼체크
f.addElement("login_id", null, "hname:'로그인아이디', required:'Y'");

//제한 - 로그인아이디
if("VERIFY".equals(m.rs("mode"))) {
    String value = m.rs("v");
    if("".equals(value)) return;
    if (0 < user.findCount("login_id = '" + value.toLowerCase() + "'")) {
        out.print("<span class='bad'>이미 사용중인 로그인아이디입니다. 다시 입력해주세요.</span>");
    } else {
        out.print("<span class='good'>사용할 수 있는 로그인아이디입니다.</span>");
    }
    return;
}

//수정
if(m.isPost() && f.validate()) {

    //제한 - 로그인아이디 중복여부
    if(0 < user.findCount("login_id = '" + f.get("login_id").toLowerCase() + "'")) {
        m.jsAlert("이미 사용 중인 아이디입니다.");
        return;
    }

    //제한 - 로그인아이디 형식
    if(!f.get("login_id").matches("^[a-zA-Z]{1}[a-zA-Z0-9]{1,19}$")) {
        m.jsAlert("영문으로 시작하는 2-20자 영문, 숫자 조합을 입력하세요.");
        return;
    }

    user.item("login_id", f.get("login_id"));
    if(!user.update("id = " + uid)) { m.jsAlert("수정하는 중 오류가 발생했습니다."); return; }

    //이동
    m.jsReplace("user_modify.jsp?id=" + uid, "parent.parent");
    m.js("parent.CloseLayer()");
    return;

}

//출력
p.setLayout("poplayer");
p.setBody("user.user_loginid_modify");
p.setVar("p_title", "아이디 수정");
p.setVar("query", m.qs());
p.setVar("list_query", m.qs("id"));
p.setVar("form_script", f.getScript());

p.setVar(info);

p.display();

%>