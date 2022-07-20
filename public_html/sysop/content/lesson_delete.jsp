<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//기본키
int id = m.ri("id");
int cid = m.ri("cid");
if(id == 0) { m.jsError("기본키는 반드시 지정해야 합니다."); return; }

//객체
LessonDao lesson = new LessonDao();

//정보-강의
DataSet info = lesson.find("id = " + id + " AND course_id = " + cid + " AND status != -1 ");
if(!info.next()) { m.jsError("해당 강의정보가 없습니다."); return; }

//삭제
lesson.item("status", -1);
if(!lesson.update("id = " + id +  " AND course_id = " + cid + " AND status != -1 ")) {
    m.jsError("삭제하는 중 오류가 발생했습니다.");
    return;
}

DataSet list = lesson.find("course_id = " + cid + " AND status = 1 ORDER BY sort ASC ");

int sort = 1;
while(list.next()) {
    lesson.execute("UPDATE " + lesson.table + " SET sort = " + sort + " WHERE id = " + list.i("id") );
    sort++;
}

m.jsAlert("성공적으로 삭제했습니다.");
m.js("try { parent.opener.location.href = parent.opener.location.href; } catch(e) { } window.close();");
return;

%>