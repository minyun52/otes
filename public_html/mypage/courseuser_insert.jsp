<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//제한
int courseId = m.ri("courseId");
if (courseId == 0 ) { m.jsError("기본키는 반드시 지정해야합니다."); return; }

//객체
CourseDao course = new CourseDao(); //과정
CourseUserDao courseUser = new CourseUserDao(); //수강생
LessonDao lesson = new LessonDao(); //강의
CourseProgressDao courseProgress = new CourseProgressDao(); //진도


//변수
int applyStatus = 0;

//과정 정보(과정 아이디, 과정상태)
DataSet courseInfo = course.find("id = " + courseId + " AND status = 1 ");
//if(!courseInfo.next()) { m.jsError("해당 정보가 없습니다."); return; };

//수강 신청 이력: 수강신청 되어있는지, 안되어있는지. courseuser-학습종료일(수강생-아이디, 회원아이디, 과정아이디, 학습시작일, 학습종료일 / 회원아이디&&과정아이디 )
DataSet courseInsertInfo = courseUser.find(" user_id = " + userId + " AND course_id = " + courseId + " AND status = 1 ", "*" , " end_date DESC ", 1);

if(courseInsertInfo.next()) {};

//0보다 크면 -> 재수강 가능
//0보다 작으면 -> 수강 불가
applyStatus = m.diffDate("D", courseInsertInfo.s("end_date"), sysToday);

//강의
//DataSet lessonList = lesson.query(
//    " SELECT a.id, a.course_id "
//    + " FROM " + lesson.table + " a "
//    + " JOIN " + course.table + " b "
//    + " ON a.course_id = b.id "
//    + " WHERE b.id = " + courseId + " AND a.status = 1 "
//);
//while(!lessonList.next()) { m.jsError("레슨 해당 정보가 없습니다."); return; };


//수강신청
if(m.isPost()) {

    //수강 종료일이 현재시간을 기준으로
    if(applyStatus < 0 ) { //수강신청이 되어있는지 확인
        if(m.diffDate("D", courseInsertInfo.s("start_date"), sysToday) < 0 ) { // 미래 수강예정
            m.jsAlert("선택하신 과정은 수강신청 할 수 없습니다. " + courseInfo.s("course_nm") + "은 수강 예정인 과정입니다.");
            return;
        }
        m.jsAlert("선택하신 과정은 수강신청 할 수 없습니다. " + courseInfo.s("course_nm") + "은 현재 수강중인 과정입니다.");
        return;//과정상세창
    }

    //입과처리
    if(!courseUser.addUser(userId, courseId)) { m.jsError("등록하는 중 오류가 발생했습니다."); return; }
    
    m.jsReplace("course_list.jsp", "parent");
    return;
}

%>