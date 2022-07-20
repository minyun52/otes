<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//객체
UserDao user = new UserDao();

//변수
boolean isAdmin = "ADMIN".equals(m.rs("mode"));

//폼체크
f.addElement("login_id", null, "hname:'로그인아이디', required:'Y'");
f.addElement("passwd", null, "hname: '비밀번호', required:'Y', minbyte:'8'");
f.addElement("passwd2", null, "hanme: '비밀번호확인', required:'Y'");
f.addElement("user_nm", null, "hname: '이름', required: 'Y'");
f.addElement("email1", null, "hname: '이메일', required:'Y', option:'email', glue:'email2', delim:'@'");
f.addElement("email2", null, "hname: '이메일', required:'Y'");
f.addElement("mobile1", null, "hname:'휴대전화번호', required:'Y', option:'number', minbyte:'3'");
f.addElement("mobile2", null, "hname:'휴대전화번호', required:'Y', option:'number', minbyte:'3'");
f.addElement("mobile3", null, "hname:'휴대전화번호', required:'Y', option:'number', minbyte:'4'");

//제한 - 로그인아이디 중복 알림
if("VERIFY".equals(m.rs("mode"))) {
    String value = m.rs("v");
    if("".equals(value)) {
        return;
    }
    if (0 < user.findCount("login_id = '" + value.toLowerCase() + "'")) {
        out.print("<span class='bad'>이미 사용중인 아이디입니다.</span>");
    } else {
        out.print("<span class='good'>사용할 수 있는 아이디입니다.</span>");
    }
    return;
}

//등록
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

    //제한 - 비밀번호
    if(!f.get("passwd").matches("^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[\\W_]).{8,}$")) {
        m.jsAlert("비밀번호는 영문, 숫자, 특수문자 조합 8자 이상 입력하세요.");
        return;
    }
    //제한 - 비밀번호 일치
    if(!f.get("passwd").equals(f.get("passwd2"))) {
        m.jsAlert("두 비밀번호가 일치하지 않습니다.");
        return;
    }

    String mobile = f.glue("-", "mobile1, mobile2, mobile3");
    String email = f.glue("@", "email1, email2").toLowerCase();
    if("--".equals(mobile)) mobile = "";
    if("@".equals(email)) email = "";

    user.item("user_type", f.get("user_type"));
    user.item("login_id", f.get("login_id"));
    user.item("passwd", m.encrypt(f.get("passwd"), "SHA-256"));
    user.item("user_nm", f.get("user_nm"));
    user.item("email", email);
    user.item("mobile", mobile);
    user.item("reg_date", m.time("yyyyMMddHHmmss"));
    user.item("status", f.getInt("status"));

    if (!user.insert()) { m.jsAlert("등록하는중 오류가 발생했습니다."); return; }

    //이동
    m.jsAlert("등록이 완료되었습니다.");
    if(isAdmin) {
        m.jsReplace("admin_list.jsp", "parent");
        return;
    } else {
        m.jsReplace("user_list.jsp", "parent");
        return;
    }

}

//출력
p.setLayout(ch);
p.setBody("user.user_insert");
p.setVar("p_title", "회원관리");
p.setVar("ADMIN_BLOCK", isAdmin);
p.setVar("SUPERADMIN_BLOCK", isSuperAdmin);
p.setVar("form_script", f.getScript());

p.setLoop("status_list", m.arr2loop(user.statusList));
p.display();

%>