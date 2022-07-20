<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//기본키
int cuid = m.ri("cuid");
if("".equals(cuid)) { m.jsErrClose("기본키는 반드시 지정해야 합니다."); return; }

//객체
CourseUserLogDao courseUserLog = new CourseUserLogDao();
LessonDao lesson = new LessonDao();

//목록
ListManager lm = new ListManager();
lm.setRequest(request);
lm.setListNum(15);
lm.setTable(
    courseUserLog.table + " a "
    + " LEFT JOIN " + lesson.table + " l ON a.lesson_id = l.id "
);
lm.setFields("a.*, l.lesson_nm ");
lm.addWhere("a.course_user_id = " + cuid + "");
lm.setOrderBy("a.reg_date DESC");

//포맷팅
DataSet list = lm.getDataSet();
while(list.next()) {
    list.put("progress_ratio", m.nf(list.d("progress_ratio"), 1));
    list.put("reg_date", m.time("yyyy.MM.dd HH:mm:ss", list.s("reg_date")));
}

//출력
p.setLayout("poplayer");
p.setBody("course.progress_log_list");
p.setVar("p_title", "진도로그");
p.setVar("query", m.qs());
p.setVar("list_query", m.qs("id"));
p.setVar("form_script", f.getScript());

p.setLoop("list", list);
p.setVar("pagebar", lm.getPaging());
p.setVar("list_total", lm.getTotalString());

p.display();

%>