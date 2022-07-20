<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//객체
LessonDao lesson = new LessonDao(); //강의
CourseProgressDao courseProgress = new CourseProgressDao(); //진도

//정보 - 과정 + 강의 + 진도
DataSet list = lesson.query(
    " SELECT a.id, a.sort, a.lesson_nm, a.total_time, c.max_time, c.study_time, c.complete_yn "
    + " FROM " + lesson.table + " a "
    + " INNER JOIN " + course.table + " b ON a.course_id = b.id AND b.status = 1 "
    + " LEFT JOIN " + courseProgress.table + " c ON a.id = c.lesson_id " +  " AND c.course_user_id = " + cuid + ""
    + " WHERE a.course_id = " + courseId +" AND a.status = 1 "
    + " ORDER BY a.sort ASC "
);

//포멧팅
while(list.next()) {
    list.put("total_time_conv", list.s("total_time") + "분");
    list.put("study_time_conv", !"".equals(list.s("study_time")) || list.s("study_time") != null ? (list.i("study_time") / 60) + "분" : "0분");
}

//출력
p.setLayout(ch);
p.setBody("classroom.index");
p.setVar("cuinfo", cuinfo); // 학습기간, 진도율, 과정이름
p.setLoop("list", list); //차시, 학습여부, 강의명, 학습시간(진도-누적학습시간/강의-학습시간)
p.display();

%>