<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//제한
if(userId != 0) {
   m.jsAlert("로그인한 회원은 회원가입을 진행할 수 없습니다.");
   m.jsReplace("../main/index.jsp");
   return;
}

//폼체크
f.addElement("agree_yn1", null, "hname:'이용약관', required:'Y'");
f.addElement("agree_yn2", null, "hname:'개인정보 수집 및 이용', required:'Y'");
f.addElement("agree_yn3", null, "hname:'개인정보 제3자 제공, required:'Y'");

//동의
if(m.isPost() && f.validate()) {

   String key = m.getUniqId();
   String ek = m.encrypt(key + "_AGREE");

   //이동
   m.jsReplace("../member/join.jsp?ek=" + ek + "&k=" + key, "parent");
   return;
}

//출력
p.setLayout(ch);
p.setBody("member.agreement");
p.setVar("form_script", f.getScript());
p.display();

%>