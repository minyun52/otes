<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//폼체크
f.addElement("passwd_old", null, "hname:'기존 비밀번호', required:'Y'"); //기존 비번
f.addElement("passwd", null, "hname:'신규 비밀번호', required:'Y',minbyte:'8' "); //새 비번
f.addElement("passwd2", null, "hname:'신규 비밀번호', required:'Y'"); //새 비번 확인

//수정
if(m.isPost() && f.validate()) {

    //변수
    String passwdOld = m.encrypt(f.get("passwd_old"), "SHA-256"); //기존 비밀번호 암호화
    String passwd = m.encrypt(f.get("passwd"), "SHA-256"); //새 비밀번호 암호화
    String passwd2 = m.encrypt(f.get("passwd2"), "SHA-256"); //새 비밀번호 확인 암호화

    //제한 - 비밀번호 형식
    if(!f.get("passwd").matches("^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[\\W_]).{8,}$")) {
        m.jsAlert("비밀번호가 형식에 맞지 않습니다");
        return;
    }

    //제한 - 기존 비밀번호 확인
    if (!passwdOld.equals(uinfo.s("passwd"))) {
        m.jsAlert("비밀번호를 확인해 주세요.");
        m.js("parent.resetPassword();");
        return;
    }

    //제한 - 새 비번 != 새 비번 확인
    if (!passwd.equals(passwd2)) {
        m.jsAlert("비밀번호를 확인해 주세요.");
        m.js("parent.resetPassword();");
        return;
    }

    //암호화한 새 비밀번호
    user.item("passwd", passwd);

    if (!user.update("id = " + userId + "")) {
        m.jsAlert("비밀번호를 변경하는 중 오류가 발생했습니다.");
        m.js("parent.resetPassword();");
        return;
    }
    m.jsAlert("비밀번호가 변경되었습니다");
    m.js("parent.resetPassword();");
    return;
}

//출력
p.setLayout(ch);
p.setBody("member.join");
p.setBody("mypage.modify_passwd");
p.setVar("form_script", f.getScript());
p.display();

%>