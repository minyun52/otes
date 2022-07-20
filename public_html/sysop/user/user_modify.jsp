<%@ page contentType="text/html; charset=utf-8"%><%@ include file="init.jsp" %><%

//기본키
int id = m.ri("id");
if(id == 0) { m.jsError("기본키는 반드시 지정해야 합니다."); return; }

//객체
UserDao user = new UserDao();

//변수
boolean isAdmin = "ADMIN".equals(m.rs("mode"));

//정보
DataSet info = user.find("id = " + id + " AND status != -1");
if(!info.next()) { m.jsError("해당 정보가 없습니다."); }

//폼체크
f.addElement("login_id", info.s("login_id"), "hname:'로그인아이디'");
f.addElement("user_nm", info.s("user_nm"), "hname: '이름', required:'Y'");
f.addElement("email1", m.split("@", info.s("email"), 2)[0], "hname: '이메일', required:'Y', option: 'email', glue:'email2', delim:'@'");
f.addElement("email2", m.split("@", info.s("email"), 2)[1], "hname: '이메일', required:'Y'");
f.addElement("mobile1", m.split("-", info.s("mobile"), 3)[0], "hname:'휴대전화번호', required:'Y', option: 'number', minbyte: '3'");
f.addElement("mobile2", m.split("-", info.s("mobile"), 3)[1], "hname:'휴대전화번호', required:'Y', option: 'number', minbyte: '3'");
f.addElement("mobile3", m.split("-", info.s("mobile"), 3)[2], "hname:'휴대전화번호', required:'Y', option: 'number', minbyte: '4'");
f.addElement("status", info.s("status"), "hname: '상태', required:'Y'");
f.addElement("user_type", info.s("user_type"), "hname: '회원구분', required:'Y'");

//비밀번호 초기화
if("RESETPW".equals(m.rs("mode"))) {

    String newPasswd = m.getUniqId();
    String subject = "[오픈 더 이러닝 사이트] 임시 비밀번호 안내메일";
    String msg = " 임시비밀번호 : <span style=\"color:red; font-size:20px;\">" + newPasswd + "</span> 입니다.<br> 로그인 후 새로운 비밀번호로 변경해주세요.";

    //갱신
    user.item("fail_cnt", 0);
    user.item("passwd", m.encrypt(newPasswd, "SHA-256"));
    if(!user.update("id = " + id)) { m.jsAlert("갱신하는 중 오류가 발생했습니다."); return;}

    //발송
    m.mail(info.s("email"), subject, msg);
    m.jsAlert("임시비밀번호가 등록된 메일주소로 발송되었습니다.");
    return;
}

//수정
if(m.isPost() && f.validate()) {

    String mobile = f.glue("-", "mobile1, mobile2, mobile3");
    String email = f.glue("@", "email1, email2").toLowerCase();
    if("--".equals(mobile)) mobile = "";
    if("@".equals(email)) email = "";

    user.item("user_type", f.get("user_type"));
    user.item("user_nm", f.get("user_nm"));
    user.item("email", email);
    user.item("mobile", mobile);
    user.item("status", f.getInt("status"));

    if(!user.update("id = " + id + "")) { m.jsAlert("수정하는 중 오류가 발생했습니다."); return;}

    //이동
    m.jsAlert("수정이 완료되었습니다.");
    if(isAdmin) {
        m.jsReplace("admin_list.jsp?" + m.qs(), "parent");
        return;
    } else {
        m.jsReplace("user_list.jsp?" + m.qs(), "parent");
        return;
    }
}

//출력
p.setLayout(ch);
p.setBody("user.user_insert");
p.setVar("p_title", "회원관리");
p.setVar("query", m.qs());
p.setVar("list_query", m.qs("id"));
p.setVar("form_script", f.getScript());

p.setVar(info);
p.setVar("modify", true);
p.setVar("USER_BLOCK", "U".equals(info.s("user_type")));
p.setVar("ADMIN_BLOCK", isAdmin);
p.setVar("SUPERADMIN_BLOCK", isSuperAdmin);
p.setLoop("status_list", m.arr2loop(user.statusList));
p.display();

%>