<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//기본키
String userNm = m.rs("cunm");
String courseId = m.rs("cid");
String startDate = m.rs("start_date");
String endDate = m.rs("end_date");
if("".equals(userNm) && "".equals(courseId) && "".equals(startDate) && "".equals(endDate)) { m.jsErrClose("기본키는 반드시 지정해야 합니다."); return; }

//객체
CourseDao course = new CourseDao();

//포멧팅
startDate = m.time("yyyy년 MM월 dd일", startDate);
endDate = m.time("yyyy년 MM월 dd일", endDate);
String today = m.time("yyyy년 MM월 dd일", sysToday);

DataSet cinfo = course.find("id = " + courseId);
if(!cinfo.next()) { m.jsAlert("해당 정보가 없습니다."); return; }
String courseNm = cinfo.s("course_nm");

//출력
p.setLayout(null);
p.setBody("page.certificate");

p.setVar("user_nm", userNm);
p.setVar("course_nm", courseNm);
p.setVar("start_date", startDate);
p.setVar("end_date", endDate);
p.setVar("sys_today", today);
p.display();

%>