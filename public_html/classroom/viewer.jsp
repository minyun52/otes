<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//기본키
int lid = m.ri("lid");
if(lid == 0) { m.jsErrClose("기본키는 반드시 지정해야합니다."); return; }

//객체
CourseProgressDao courseProgress = new CourseProgressDao();
LessonDao lesson = new LessonDao();
CourseUserLogDao courseUserLog = new CourseUserLogDao();

//제한-수강가능여부
if(0 < m.diffDate("D", cuinfo.s("end_date"), sysToday)) { m.jsErrClose("학습기간이 아닙니다."); return; }

//목록-강의
DataSet info = lesson.query(
    "SELECT a.*"
    + ", p.max_time, p.last_time, p.study_time, p.complete_yn, p.reg_date "
    + " FROM " + lesson.table + " a "
    + " LEFT JOIN " + courseProgress.table + " p ON p.course_user_id = " + cuid + " AND p.lesson_id = a.id "
    + " WHERE a.status = 1 "
    + " AND a.course_id = " + courseId + " "
    + " AND a.id = " + lid + " "
);
if(!info.next()) { m.jsErrClose("해당 강의 정보가 없습니다."); return; }

//제한
if(1 != info.i("status")) { m.jsErrClose("사용 중지된 강의입니다."); return; }

//포멧팅
info.put("study_time", 0 != info.i("study_time") ? info.i("study_time") : 0);
info.put("last_time", 0 != info.i("last_time") ? info.i("last_time") : 0);
info.put("max_time", 0 != info.i("max_time") ? info.i("max_time") : 0);
info.put("lesson_nm_conv", m.cutString(info.s("lesson_nm"), 40));
info.put("image_url", cuinfo.s("course_file"));

//강의의 인정시간이 0인 경우 곧바로 완료처리
if(info.i("complete_time") == 0 && !"Y".equals(info.s("complete_yn"))) {
    info.put("complete_yn", "Y");
    if(!courseProgress.completeProgress(cuid, lid)) { m.jsAlert("완료 처리 중 오류가 발생했습니다."); return; }
}

//로그
courseUserLog.item("course_user_id", cuinfo.i("id"));
courseUserLog.item("lesson_id", info.i("id"));
courseUserLog.item("ip_addr", request.getRemoteAddr()); //아이피주소
courseUserLog.item("device", courseUserLog.getDeviceType("PC")); //단말기
courseUserLog.item("log_type", "S"); //S: 시작, E:종료
courseUserLog.item("conn_date", m.time("yyyyMMdd")); //접속일
courseUserLog.item("reg_date", m.time("yyyyMMddHHmmss")); //등록일시

if(!courseUserLog.insert()) { m.log("viewer", "cuid=" + cuid + "lid=" + lid); }

//동영상경로보안
info.put("start_url_conv", "/player/viewer.jsp?lid=" + lid + "&cuid=" + cuid + "&ek=" + m.encrypt(lid + "|" + cuid + "|" + m.time("yyyyMMdd")));

//출력
p.setLayout(null);
p.setBody("classroom.viewer");
p.setVar("image_url", info.s("course_file"));
p.setVar("lesson_url", info.s("lesson_url"));
p.setVar("last_time", info.i("last_time"));
p.setVar("start_pos", info.i("last_time"));
p.setVar("max_time", info.i("max_time"));
p.setVar("file_type", "mp4");
p.setVar(info);
p.display();

%>