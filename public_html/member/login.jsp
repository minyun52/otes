<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//로그인
if(userId != 0) {
    m.redirect("../mypage/modify_verify.jsp");
    return;
}

//객체
UserDao user = new UserDao();
UserLoginDao userLogin = new UserLoginDao();

//폼체크
f.addElement("id", null, "hname:'아이디', required:'Y'");
f.addElement("passwd", null, "hname:'비밀번호', required:'Y'");

if(m.isPost() && f.validate()) {
    String id = f.get("id");
    String passwd = m.encrypt(f.get("passwd"), "SHA-256");
    DataSet info = user.find("login_id = ? AND status IN (1, -1)", new Object[] {id}, 1);

    //존재하지 않는 아이디
    if(!info.next()) {
        m.jsAlert("아이디/비밀번호를 확인하세요.\\n로그인 5회 오류 시 로그인이 제한됩니다.");
        return;
    }

    //정지회원
    if(0 == info.i("status")) {
        m.jsAlert("로그인 할 수 없습니다.\\n관리자에게 문의해 주시기 바랍니다.\\nadmin@enter.com");
        return;
    }

    //제한-비밀번호오류
    if(!passwd.equals(info.s("passwd"))) {
        int totalFailCnt = info.i("fail_cnt") + 1;
        user.item("fail_cnt", totalFailCnt);
        if(5 == totalFailCnt) {
            user.item("status", 0);
        }
        user.update("id = " + info.i("id"));
        m.jsAlert("아이디/비밀번호를 확인하세요.\\n로그인 5회 오류 시 로그인이 제한됩니다.");
        return;
    }

    //개인정보활용에 동의하지 않은 경우
    if(!"Y".equals(info.s("agreement_yn")) && !"S".equals(info.s("user_type"))) {
        String ek = m.encrypt("PRIVACY_" + info.s("id") + "_AGREE_" + sysToday);
        m.jsAlert("동의하지 않은 약관이 존재합니다.\\n약관에 동의해야 서비스를 이용할 수 있습니다\\n확인 버튼을 누르면 이용약관 페이지로 이동합니다.");
        m.jsReplace("privacy_agree.jsp?id=" + info.s("id") + "&ek=" + ek , "parent");
        return;
    }

    //로그 남기기
    userLogin.item("user_id", info.i("id"));
    userLogin.item("user_type", "F"); //F:사용자단 B:관리자단
    userLogin.item("login_type", "I"); //I:로그인 O:로그아웃
    userLogin.item("ip_addr", m.getRemoteAddr());
    userLogin.item("device", userLogin.getDeviceType(request.getHeader("user-agent")));
    userLogin.item("log_date", sysToday);
    userLogin.item("reg_date", sysNow);

    //로그
    if(!userLogin.insert()) { m.log("login", "로그인 기록 등록 오류 - USER_ID = " + info.i("id") + ""); }

    auth.put("USERID", info.i("id"));
    auth.put("LOGINID", info.s("login_id"));
    auth.put("USERNAME", info.s("user_nm"));
    auth.put("EMAIL", info.s("email"));
    auth.put("TYPE", info.s("user_type"));
    auth.save();

    if(-1 == user.execute("UPDATE " + user.table + " SET fail_cnt = 0, conn_date = " + sysNow + " WHERE id = " + info.i("id"))) {
        m.log("login", "로그인 성공 업데이트 오류 - USER_ID = " + info.i("id") + "");
    }

    //이동
    m.jsReplace("../main/index.jsp", "parent");
    return;
}

//출력
p.setLayout(ch);
p.setBody("member.login");
p.setVar("form_script", f.getScript());
p.display();

%>

