<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//기본키
int id = m.ri("id");
int cid = m.ri("cid");
if(id == 0) { m.jsError("기본키는 반드시 지정해야 합니다."); return; }

//객체
LessonDao lesson = new LessonDao();

//정보
DataSet info = lesson.find("id = " + id + " AND course_id = " + cid + " AND status != -1 ");
if(!info.next()) { m.jsErrClose("해당 강의 정보가 없습니다."); return; }

//폼체크
f.addElement("lesson_nm", info.s("lesson_nm"), "hname:'강의명', required:'Y'");
f.addElement("total_time", info.i("total_time"), "hname:'학습시간', option:'number'");
f.addElement("complete_time", info.i("complete_time"), "hname:'인정시간', option:'number'");
f.addElement("lesson_url", null, "hname:'강의url', required:'Y'");
f.addElement("lesson_url_mobile", info.s("lesson_url_mobile"), "hname:'모바일강의url'");
f.addElement("description", info.s("description"), "hname:'강의 소개'");

//수정
if(m.isPost() && f.validate()) {

    lesson.item("lesson_nm", f.get("lesson_nm"));
    lesson.item("lesson_url", f.get("lesson_url"));
    lesson.item("lesson_url_mobile", f.get("lesson_url_mobile"));
    lesson.item("total_time", f.getInt("total_time"));
    lesson.item("complete_time", f.getInt("complete_time"));
    lesson.item("description", f.get("description"));

    if(!lesson.update("id = " + info.i("id"))) {
        m.jsAlert("수정하는 중 오류가 발생했습니다.");
        return;
    }
    
    m.jsAlert("성공적으로 수정했습니다.");
    m.js("try { parent.opener.location.href = parent.opener.location.href; } catch(e) { } window.close();");
    return;
}


//출력
p.setLayout("pop");
p.setVar("p_title", "온라인강의관리");
p.setBody("content.lesson_insert");
p.setVar("query", m.qs());
p.setVar("list_query", m.qs("id"));
p.setVar("form_script", f.getScript());
p.setVar("modify", true);
p.setVar(info);
p.display();

%>