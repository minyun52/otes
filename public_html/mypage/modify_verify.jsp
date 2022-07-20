<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp"%><%
    
//폼체크
f.addElement("passwd", null, "hname:'비밀번호', required:'Y'");

//처리
if(m.isPost() && f.validate()) {

    String passwd = m.encrypt(f.get("passwd"), "SHA-256");

    if(!passwd.equals(uinfo.s("passwd"))) {
        m.jsAlert("비밀번호를 확인해주세요.");
        return;
    }

    //이동
    String key = m.getUniqId();
    String ek = m.encrypt(key + "_MODIFY");
    m.jsReplace("modify.jsp?ek=" + ek + "&k=" + key, "parent");
    return;
}

//출력
p.setLayout(ch);
p.setBody("mypage.modify_verify");
p.setVar("form_script", f.getScript());
p.display();

%>