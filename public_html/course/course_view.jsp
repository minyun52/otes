<%@ page contentType="text/html; charset=utf-8"%><%@ include file="init.jsp"%><%

//기본키
int id = m.ri("id");
if (id == 0) { m.jsError("기본키는 반드시 지정해야합니다."); return; }

//객체
CourseDao course = new CourseDao(); //과정
CourseUserDao courseUser = new CourseUserDao(); //수강생
LessonDao lesson = new LessonDao(); //강의

//변수
int cuStatus = 0; //수강 신청 이력
int applyStatus = 0; //수강 여부
int applyAgainStatus = 0; //재수강 여부
int applyFutureStatus = 0;  //미래 수강예정 여부


//과정 정보
DataSet info = course.find(" id = " + id + " AND status = 1 ");

//강의
DataSet lessonList = lesson.find(" status = 1 AND course_id = " + id + " ORDER BY sort ASC ");

if(!info.next()) {
    m.jsError("해당 정보가 없습니다.");
    return;
}

//과정 포멧팅
//메인이미지
info.put("course_file_url", "/html/images/common/noimage_course.gif");
if(!"".equals(info.s("course_file"))) info.put("course_file_url", m.getUploadUrl(info.s("course_file")));

//수강 내역- 1.수강여부 확인
cuStatus = courseUser.findCount( " user_id = " + userId + " AND course_id = " + info.s("id") + " AND status = 1 ");

if (cuStatus > 0) { //수강 이력이 있음

    //수강생정보
    DataSet courseInsertInfo = courseUser.find( " user_id = " + userId + " AND course_id = " + info.s("id") , "*" , " end_date DESC ", 1);
    if (!courseInsertInfo.next()){};

    
    //2. 수강중 or 재수강
    //값 < 0 : 현재 수강중 -> 수강신청 x
    //값 < 0 : 미래 수강예정 -> 수강신청 x
    //값 > 0 : 과거에 수강 -> 재수강 가능

    applyStatus = m.diffDate("D", courseInsertInfo.s("end_date"), sysToday);//현재 수강중
    applyFutureStatus = m.diffDate("D", courseInsertInfo.s("start_date"), sysToday);//미래 수강예정
    applyAgainStatus = m.diffDate("D", courseInsertInfo.s("end_date"), sysToday); // 재수강 가능

}


//출력
p.setLayout(ch);
p.setBody("course.course_view");
p.setVar("form_script", f.getScript());

p.setVar(info);//과정
p.setLoop("lessonList", lessonList);//강의
p.setVar("lesson_cnt", lessonList.size());//차시

p.setVar("cu_status", cuStatus); //수강신청 이력
p.setVar("apply_status", applyStatus); //첫수강 여부
p.setVar("apply_again_status", applyAgainStatus); //재수강 여부
p.setVar("apply_future_status",applyFutureStatus);  //미래 수강 여부

p.display();

%>