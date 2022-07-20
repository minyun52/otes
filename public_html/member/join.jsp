<%@ page contentType="text/html; charset=utf-8" %><%@ page import="java.util.regex.Pattern" %><%@ include file="init.jsp" %><%

//객체
UserDao user = new UserDao();

//제한 - 동의페이지에서 넘어온 것
String ek = m.rs("ek");
String key = m.rs("k");
if(!ek.equals(m.encrypt(key + "_AGREE"))) {
    m.jsError("올바른 접근이 아닙니다.");
    return;
}

//폼체크
f.addElement("login_id", null, "hname:'로그인아이디', required:'Y', pattern:'^[a-zA-Z]{1}[a-zA-Z0-9]{1,19}$' ");
f.addElement("passwd", null, "hname: '비밀번호', required:'Y', minbyte:'8' ,match:'passwd2'");
f.addElement("passwd2", null, "hname: '비밀번호', required:'Y'");
f.addElement("user_nm", null, "hname: '이름', required:'Y'");
f.addElement("email1", null, "hname: '이메일', required:'Y'");
f.addElement("email2", null, "hname: '이메일', required:'Y'");
f.addElement("mobile1", null, "hname:'휴대전화번호', required:'Y'");
f.addElement("mobile2", null, "hname:'휴대전화번호', required:'Y', option:'number'");
f.addElement("mobile3", null, "hname:'휴대전화번호', required:'Y', option:'number'");
f.addElement("email_yn", null, "hname: '이메일수신동의', required: 'Y'");
f.addElement("sms_yn", null, "hname: 'SMS수신동의', required: 'Y'");
f.addElement("status", 1, "hname: '상태'");

//등록
if(m.isPost() && f.validate()) {

    //제한 - 비밀번호 형식
    if(!f.get("passwd").matches("^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[\\W_]).{8,}$")) {
        m.jsAlert("비밀번호가 형식에 맞지 않습니다");
        return;
    }

    //제한 - 이메일 형식
    String email = f.glue("@", "email1, email2").toLowerCase();
    if(!"@".equals(email)) {
        if(!user.isMail(email)) {
            m.jsAlert("이메일이 형식에 맞지 않습니다.");
            return;
        }
    }

    //제한 - 휴대전화번호 형식
    String patternMobile = "(\\d{3})(\\d{3,4})(\\d{4})";
    String mobile = "";
    if(!"".equals(f.get("mobile2")) || !"".equals(f.get("mobile3"))) {
        mobile = f.get("mobile1") + f.get("mobile2") + f.get("mobile3");
        if(!Pattern.matches(patternMobile, mobile)) {
            m.jsAlert("휴대전화번호를 확인해주세요");
            m.js("parent.resetPassword();");
            return;
        }
        mobile = mobile.replaceAll(patternMobile, "$1-$2-$3");
    } else {
        mobile = f.get("mobile1");
    }

    //제한 - 아이디 중복
    if(0 != user.findCount("login_id = '" + f.get("login_id") + "' ")) {
        m.jsAlert("사용할 수 없는 아이디입니다.\\n아이디를 확인해 주세요.");
        m.js("parent.resetPassword();");
        return;
    }

    String passwd = f.get("passwd");
    passwd = m.encrypt(passwd, "SHA-256"); //암호화

    user.item("user_type", "U");
    user.item("login_id", f.get("login_id"));
    user.item("passwd", passwd);
    user.item("user_nm", f.get("user_nm"));
    user.item("email", email);
    user.item("mobile", mobile);
    user.item("email_yn", f.get("email_yn", "N"));
    user.item("email_date", sysToday);
    user.item("sms_yn", f.get("sms_yn", "N"));
    user.item("sms_date", sysToday);
    user.item("agreement_yn", "Y");
    user.item("agreement_date", sysNow);
    user.item("conn_date", sysNow);
    user.item("reg_date", sysNow);
    user.item("status", "1");

    if(!user.insert()) {
        m.jsAlert("회원가입을 하는 중 오류가 발생했습니다.");
    } else {
        m.jsAlert("회원 가입을 성공적으로 완료했습니다.");
        m.jsReplace("join_success.jsp?ek=" + ek + "&k=" + key, "parent"); //등록 후 보여줄 페이지
    }
    return;
}

//출력
p.setLayout(ch);
p.setBody("member.join");
p.setVar("form_script", f.getScript());
p.display();

%>