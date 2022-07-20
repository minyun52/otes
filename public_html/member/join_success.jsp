<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp"%><%
    
//제한
String ek = m.rs("ek");
String key = m.rs("k");
if(!ek.equals(m.encrypt(key + "_AGREE"))) {
    m.jsError("올바른 접근이 아닙니다.");
    return;
}

//출력
p.setLayout(ch);
p.setBody("member.join_success");
p.display();

%>