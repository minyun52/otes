<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//기본키
int uid = m.ri("uid");
if("".equals(uid)) { m.jsErrClose("기본키는 반드시 지정해야 합니다."); return; }
int cuid = m.ri("cuid");
if(cuid == 0) { m.jsError("기본키는 반드시 지정해야 합니다."); return; }

//객체
UserDao user = new UserDao();
CourseDao course = new CourseDao();
CourseUserDao courseUser = new CourseUserDao();
CourseProgressDao courseProgress = new CourseProgressDao();
LessonDao lesson = new LessonDao();

//정보-수강생
DataSet cuinfo = courseUser.query(
    "SELECT a.* "
    + ", u.user_nm, u.login_id "
    + " FROM " + courseUser.table + " a "
    + " INNER JOIN " + user.table + " u ON a.user_id = u.id AND u.status != -1 "
    + " WHERE a.id = " + cuid + " AND a.user_id = " + uid + " "
);
if(!cuinfo.next()) { m.jsError("해당 수강생 정보가 없습니다."); return; }

int courseId = cuinfo.i("course_id");

//정보-과정
DataSet cinfo = course.find("id = " + courseId + " AND status != -1");
if(!cinfo.next()) { m.jsAlert("해당 과정 정보가 없습니다."); return; }

DataSet lessons = lesson.query(
    "SELECT a.*"
    + ", p.course_user_id, p.complete_yn, IFNULL(NULLIF(p.study_time, ''), 0) study_time, IFNULL(NULLIF(p.max_time, ''), 0) max_time, p.complete_date"
    + " FROM " + lesson.table + " a "
    + " LEFT JOIN " + courseProgress.table + " p ON "
    + " p.course_user_id = " + cuid + " AND p.lesson_id = a.id "
    + " WHERE a.status = 1 AND a.course_id = " + courseId
    + " ORDER BY a.sort ASC "
);

//포맷팅
cuinfo.put("complete_conv", !"I".equals(cuinfo.s("complete_status")) ? ("Y".equals(cuinfo.s("complete_status")) ? "수료" : "미수료") : "미판정");
cuinfo.put("start_date", m.time("yyyy-MM-dd", cuinfo.s("start_date")));
cuinfo.put("end_date", m.time("yyyy-MM-dd", cuinfo.s("end_date")));

while(lessons.next()) {
    lessons.put("complete_yn_conv", m.getItem(lessons.s("complete_yn"), lesson.completeYn));
    lessons.put("complete_date_conv", m.time("yyyy-MM-dd", lessons.s("complete_date")));
}

//출력
p.setLayout("poplayer");
p.setBody("course.course_user_view");
p.setVar("p_title", "수강정보");
p.setVar("query",m.qs());
p.setVar("list_query",m.qs("cuid"));

p.setVar("cuinfo", cuinfo);
p.setLoop("lessons", lessons);
p.setVar("course", cinfo);

p.display();

%>