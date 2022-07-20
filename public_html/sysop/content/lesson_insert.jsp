<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//기본키
int cid = m.ri("cid");
if(cid == 0) { m.jsError("기본키는 반드시 지정해야 합니다."); return; }

//객체
LessonDao lesson = new LessonDao();

//폼체크
f.addElement("lesson_nm", null, "hname:'강의명', required:'Y'");
f.addElement("lesson_url", null, "hname:'강의url', required:'Y'");
f.addElement("lesson_url_mobile", null, "hname:'강의모바일url'");
f.addElement("total_time", null, "hname:'학습시간', option:'number'");
f.addElement("complete_time", null , "hname:'인정시간', option:'number'");
f.addElement("description", null, "hname:'강의설명'");


//등록
if(m.isPost() && f.validate()) {

    int maxSort = lesson.getMaxSort(cid);

    lesson.item("course_id", cid);
    lesson.item("lesson_nm", f.get("lesson_nm"));
    lesson.item("lesson_type", "mp4");
    lesson.item("lesson_url", f.get("lesson_url"));
    lesson.item("lesson_url_mobile", f.get("lesson_url_mobile"));
    lesson.item("total_time", f.getInt("total_time"));
    lesson.item("complete_time", f.getInt("complete_time"));
    lesson.item("description", f.get("description"));
    lesson.item("reg_date", m.time("yyyyMMddHHmmss"));
    lesson.item("sort", maxSort);

    if(!lesson.insert()) { m.jsAlert("등록하는 중 오류가 발생했습니다."); return; }

    m.jsAlert("성공적으로 등록했습니다.");
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

p.display();

%>