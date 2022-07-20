<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//기본키
int cid = m.ri("cid");
if(cid == 0) { m.jsError("기본키는 반드시 지정해야 합니다."); return; }

//객체
CourseDao course = new CourseDao();
LessonDao lesson = new LessonDao();


//정보-과정
DataSet cinfo = course.find("id = " + cid + " AND status != -1");
if(!cinfo.next()) { m.jsError("해당 정보가 없습니다."); return; }


//삭제
if("del".equals(m.rs("mode"))) {

    if("".equals(f.get("idx"))) { m.jsError("기본키는 반드시 지정해야 합니다."); return; }

    lesson.item("status", -1);
    if(!lesson.update("id IN (" + f.get("idx") + ")")) { m.jsAlert("삭제하는 중 오류가 발생했습니다."); return; }

    DataSet list = lesson.find("course_id = " + cid + " AND status = 1 ORDER BY sort ASC ");
    
    int sort = 1;
    while(list.next()) {
        lesson.execute("UPDATE " + lesson.table + " SET sort = " + sort + " WHERE id = " + list.i("id") );
        sort++;
    }
    //이동
    m.jsAlert("삭제 완료되었습니다.");
    m.jsReplace("course_lesson.jsp?" + m.qs("mode, idx"));
    return;
}

//수정
if(m.isPost() && f.validate()) {

    //차시 sort 수정
    if(f.getArr("lesson_id") != null) {
        int sort = 1;

        for(int i = 0; i < f.getArr("lesson_id").length; i++) {
            lesson.item("sort", sort++);
            if(!lesson.update("id = " + f.getArr("lesson_id")[i])) { }
        }
    }

    //이동
    m.jsAlert("수정되었습니다.");
    m.jsReplace("course_lesson.jsp?" + m.qs(), "parent");
    return;
}

DataSet list = lesson.find("course_id = " + cid + " AND status != -1 ORDER BY sort ASC ");
if(!list.next()) { m.log("course_lesson", "lesson not found"); }


//출력
p.setLayout(ch);
p.setBody("course.course_lesson");
p.setVar("p_title", "강의목차");
p.setVar("query", m.qs());
p.setVar("list_query", m.qs("cid"));
p.setVar("form_script", f.getScript());

p.setLoop("list", list);
p.setVar("list_total", list.size());
p.setVar("course", cinfo);
p.setVar("tab_lesson", "current");

p.display();

%>