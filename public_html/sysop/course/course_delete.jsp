<%@ page contentType="text/html; charset=utf-8" %> <%@ include file="init.jsp" %><%

//기본키
int id = m.ri("id");
if(id == 0) { m.jsError("기본키는 반드시 있어야 합니다."); return; }

//객체
CourseDao course = new CourseDao();
CourseUserDao courseUser = new CourseUserDao();
LessonDao lesson = new LessonDao();

//정보
DataSet info = course.find("id = " + id + " AND status != -1");
if(!info.next()) { m.jsError("해당 정보가 없습니다."); return; }

//제한-수강생
if(0 < courseUser.findCount("course_id = " + id + " AND status != -1 " )) {
    m.jsError("해당 과정에 [수강생]이 존재하여 과정을 삭제할 수 없습니다.\\n[수강생] 먼저 삭제 해주시길 바랍니다.");
    return;
}
//제한-강의
if(0 < lesson.findCount("course_id = " + id + " AND status ! = -1 " )) {
    m.jsError("해당 과정에 [강의정보]가 포함되어 있어 과정을 삭제할 수 없습니다.\\n[강의] 먼저 삭제 해주시길 바랍니다.");
    return;
}

//삭제
course.item("course_file", "");
course.item("status", -1);
if(!course.update("id = " + id + "")) { m.jsError("삭제하는 중 오류가 발생했습니다."); return; }

//삭제-파일
if(!"".equals(info.s("course_file"))) m.delFileRoot(m.getUploadPath(info.s("course_file")));

m.jsReplace("course_list.jsp?" + m.qs("id"));

%>