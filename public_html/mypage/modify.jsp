<%@ page contentType="text/html; charset=utf-8" %><%@ page import="java.util.regex.Pattern" %><%@ include file="init.jsp"%><%
    
//암호키
String ek = m.rs("ek");
String key = m.rs("k");
if(!ek.equals(m.encrypt(key+"_MODIFY"))) { m.jsReplace("modify_verify.jsp"); return; }

String[] uemail = m.split("@", uinfo.s("email"), 2);
String[] mobile = m.split("-", uinfo.s("mobile"), 3);

//폼체크
f.addElement("user_nm", uinfo.s("user_nm"), "hname:'이름', required:'Y'");
f.addElement("email1", uemail[0], "hname:'이메일', required:'Y'");
f.addElement("email2", uemail[1], "hname:'이메일', required:'Y'");
f.addElement("mobile1", mobile[0], "hname:'휴대전화번호', required:'Y'");
f.addElement("mobile2", mobile[1], "hname:'휴대전화번호', required:'Y'");
f.addElement("mobile3", mobile[2], "hname:'휴대전화번호', required:'Y'");
f.addElement("email_yn", uinfo.s("email_yn"), "hname:'이메일수신동의'");
f.addElement("sms_yn", uinfo.s("sms_yn"), "hname:'SMS수신동의'");

//수정
if(m.isPost() && f.validate()) {

    //변수
    String email = f.glue("@", "email1, email2").toLowerCase();
    String emailYn = f.get("email_yn");
    String smsYn = f.get("sms_yn");

    if("@".equals(email)) email = "";

    //이메일변경
    if(!email.equals(userEmail)) {
        if(!"".equals(email) && !user.isMail(email)) {
            m.jsAlert("이메일이 형식에 맞지 않습니다.");
            return;
        }
        user.item("email", email);
    }

    //휴대전화번호 변경
    String patternMobile = "(\\d{3})(\\d{3,4})(\\d{4})";
    String newMobile = "";
    if(!"".equals(f.get("mobile2")) || !"".equals(f.get("mobile3"))) {
        newMobile = f.get("mobile1") + f.get("mobile2") + f.get("mobile3");
        if(!Pattern.matches(patternMobile, newMobile)) {
            m.jsAlert("휴대전화번호를 확인해주세요.");
            m.js("parent.resetPassword();");
            return;
        }
        newMobile = newMobile.replaceAll(patternMobile, "$1-$2-$3");
    } else {
        newMobile = f.get("mobile1");
    }

    user.item("mobile", newMobile);

    if(!uinfo.s("email_yn").equals(f.get("email_yn"))) {
        user.item("email_date", sysToday);
    }
    if(!uinfo.s("sms_yn").equals(f.get("sms_yn"))) {
        user.item("sms_date", sysToday);
    }
    user.item("email_yn", emailYn);
    user.item("sms_yn", smsYn);

    if(!uinfo.s("user_nm").equals(f.get("user_nm"))) {
        user.item("user_nm", f.get("user_nm"));
    }

    if(!user.update("id = " + userId + "")) {
        m.jsAlert("회원정보 수정 중 오류가 발생했습니다" + user.errMsg);
        return;
    }

    auth.put("USERNAME", f.get("user_nm"));
    auth.save();

    m.jsAlert("성공적으로 회원정보를 수정했습니다.");
    m.jsReplace("modify.jsp?ek=" + ek + "&k=" + key, "parent");
    return;
}

//출력
p.setLayout(ch);
p.setBody("mypage.modify");
p.setVar("form_script", f.getScript()); //폼 스크립트
p.setVar(uinfo);
p.display();

%>