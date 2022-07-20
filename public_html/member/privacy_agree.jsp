<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp"%><%

//기본키
int id = m.ri("id");
if(id == 0) { m.jsError("기본키는 반드시 지정해야 합니다."); return; }

//객체
UserDao user = new UserDao();

//제한
String ek = m.encrypt("PRIVACY_" + id + "_AGREE_" + m.time("yyyyMMdd"));
if(!ek.equals(m.rs("ek"))) { m.jsAlert("잘못된 접근입니다."); return; }

//정보
DataSet info = user.find("id = " + id + " AND status = 1");
if(!info.next()) { m.jsError("해당 회원 정보가 없습니다."); return; }

//폼체크
f.addElement("agree_yn1", null, "hname:'이용약관', required:'Y'");
f.addElement("agree_yn2", null, "hname:'개인정보 수집 및 이용', required:'Y'");
f.addElement("agree_yn3", null, "hname: '제3자 ', required:'Y'");

//처리
if(m.isPost() && f.validate()) {

    //수정- 이용약관
    user.item("agreement_yn", "Y");
    user.item("agreement_date", m.time("yyyyMMddHHmmss"));

    if(!user.update("id = " + id + "")) { m.jsError("수정하는 중 오류가 발생했습니다."); return; }
    m.jsAlert("처리가 완료되었습니다. 다시 로그인 해 주세요");
    m.jsReplace("/member/login.jsp", "parent");
    return;

}

//출력
p.setLayout(ch);
p.setBody("member.privacy_agree");
p.setVar("form_script", f.getScript());
p.display();

%>