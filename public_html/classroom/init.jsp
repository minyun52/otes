<%@ include file="/init.jsp"%><%

//로그인
if(0 == userId) { auth.loginForm(); return; }

//기본키
int cuid = m.ri("cuid");
if(cuid == 0) { m.jsError("기본키는 반드시 지정해야 합니다."); return; }

//객체
UserDao user = new UserDao();
CourseDao course = new CourseDao();
CourseUserDao courseUser = new CourseUserDao();

//정보- 수강생
DataSet cuinfo = courseUser.query(
    "SELECT a.*, c.course_nm, c.course_file, u.id user_id, u.user_nm "
    + " FROM " + courseUser.table + " a "
    + " INNER JOIN " + course.table + " c ON a.course_id = c.id "
    + " INNER JOIN " + user.table + " u ON a.user_id = u.id"
    + " WHERE a.id = " + cuid + " AND a.user_id = '" + userId + "' AND a.status = 1"
);
if(!cuinfo.next()) { m.jsError("해당 수강 정보가 없습니다."); return; }

//포멧팅
cuinfo.put("start_date_conv", m.time("yyyy.MM.dd", cuinfo.s("start_date")));
cuinfo.put("end_date_conv", m.time("yyyy.MM.dd", cuinfo.s("end_date")));
cuinfo.put("progress_ratio", m.nf(cuinfo.d("progress_ratio"), 1));

//변수
String courseId = cuinfo.s("course_id");

//채널
String ch = "classroom";
%>