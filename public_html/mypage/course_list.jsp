<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//객체
CourseUserDao courseUser = new CourseUserDao();
CourseDao course = new CourseDao();

//수강중인 과정
DataSet list1 = courseUser.query(
    " SELECT a.id, c.course_type, c.course_nm, a.start_date, a.end_date, a.progress_ratio "
    + " FROM " + courseUser.table + " a "
    + " INNER JOIN " + course.table + " c ON a.course_id = c.id AND c.status = 1 "
    + " WHERE a.user_id = " + userId + " AND a.status = 1 AND end_date >= '" + sysToday + "' "
    + " ORDER BY a.reg_date DESC "
);

//수강중인 과정 포멧팅
while(list1.next()) {
    list1.put("progress_ratio", m.nf(list1.d("progress_ratio"), 1));
    list1.put("start_date_conv", m.time("yyyy.MM.dd", list1.s("start_date")));
    list1.put("end_date_conv", m.time("yyyy.MM.dd", list1.s("end_date")));

    int studyStatus = m.diffDate("D", list1.s("start_date"), sysToday);
    list1.put("study_status", m.diffDate("D", list1.s("start_date"), sysToday));
}

//종료된 과정
DataSet list2 = courseUser.query(
    " SELECT a.id, c.course_type, c.course_nm, c.id as course_id, a.start_date, a.end_date, a.progress_ratio, a.complete_status "
    + " FROM " + courseUser.table + " a "
    + " INNER JOIN " + course.table + " c ON a.course_id = c.id AND c.status = 1 "
    + " WHERE a.user_id = " + userId + " AND a.status = 1 AND end_date < '" + sysToday + "' "
    + " ORDER BY a.reg_date DESC "
);

//종료된 과정 포멧팅
while(list2.next()) {
    //변수
    String completeStatusConv = "";
    boolean completeStatus = false;

    list2.put("progress_ratio", m.nf(list2.d("progress_ratio"), 1));
    list2.put("start_date_conv", m.time("yyyy.MM.dd", list2.s("start_date")));
    list2.put("end_date_conv", m.time("yyyy.MM.dd", list2.s("end_date")));

    if("N".equals(list2.s("complete_status"))) {
        completeStatusConv = "미수료";
    } else if("Y".equals(list2.s("complete_status"))) {
        completeStatusConv = "수료";
        completeStatus = true;
    } else {
        completeStatusConv = "미처리";
    }
    list2.put("status_conv", completeStatusConv);
    list2.put("complete_status", completeStatus);
}

//출력
p.setLayout(ch);
p.setBody("mypage.course_list");
p.setLoop("list1", list1);//수강중인 과정
p.setLoop("list2", list2);//종료된 과정
p.setVar("id", userId);
//p.setVar("complete_status", completeStatus);
p.display();

%>