<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp"%><%

//변수
boolean managementBlock = "management".equals(m.rs("mode2"));

//객체
UserDao user = new UserDao();
CourseDao course = new CourseDao();
CourseUserDao courseUser = new CourseUserDao();
CourseUserLogDao courseUserLog = new CourseUserLogDao();
CourseProgressDao courseProgress = new CourseProgressDao();

//정보
DataSet cinfo = new DataSet();
if(managementBlock) {
    cinfo = course.find("id = " + f.get("s_course_id")  + " AND status != -1");
    if(!cinfo.next()) { m.jsAlert("해당 과정정보가 없습니다."); return; }
}

//삭제
if("del".equals(m.rs("mode"))) {
    //기본키
    if("".equals(f.get("idx"))) { m.jsError("기본키는 반드시 지정해야 합니다."); return; }

    //제한
    if(0 < courseProgress.findCount("course_user_id IN (" + f.get("idx") + ")")) {
        m.jsError("강의에 대한 진도내역이 있습니다. 삭제할 수 없습니다."); return;
    }
    if(0 < courseUserLog.findCount("course_user_id IN (" + f.get("idx") + ")")) {
        m.jsError("학습내역이 있습니다. 삭제할 수 없습니다."); return;
    }

    courseUser.item("status", -1);
    if(!courseUser.update("id IN (" + f.get("idx") + ")" )) { m.jsAlert("삭제하는 중 오류가 발생했습니다."); return; }

    //이동
    m.jsAlert("삭제 완료됐습니다.");
    m.jsReplace("user_list.jsp?" + m.qs("mode, idx"));
    return;
}

//폼체크
f.addElement("s_course_id", null, null);
f.addElement("s_complete_status", null, null);
f.addElement("s_complete_sdate", null, null);
f.addElement("s_complete_edate", null, null);
f.addElement("s_status", null, null);
f.addElement("s_field", null, null);
f.addElement("s_keyword", null, null);
f.addElement("s_listnum", null, null);

//목록
ListManager lm = new ListManager();
lm.setRequest(request);
lm.setListNum("excel".equals(m.rs("mode")) ? 10000 : f.getInt("s_listnum", 20));
lm.setTable(
     courseUser.table + " a "
     + " INNER JOIN " + user.table + " u ON a.user_id = u.id " + " AND u.status != -1 "
     + " INNER JOIN " + course.table + " c ON a.course_id = c.id "
);
lm.setFields("a.*, u.user_nm, u.login_id, c.course_nm");
lm.addWhere("a.status != -1");
lm.addSearch("a.course_id", f.get("s_course_id"));
lm.addSearch("a.complete_status", f.get("s_complete_status"));
if(!"".equals(f.get("s_complete_sdate"))) lm.addWhere("a.complete_date >= '" + m.time("yyyyMMdd000000", f.get("s_complete_sdate")) + "'");
if(!"".equals(f.get("s_complete_edate"))) lm.addWhere("a.complete_date <= '" + m.time("yyyyMMdd235959", f.get("s_complete_edate")) + "'");
if(!"".equals(f.get("s_field"))) lm.addSearch(f.get("s_field"), f.get("s_keyword"), "LIKE");
else if("".equals(f.get("s_field")) && !"".equals(f.get("s_keyword"))) lm.addSearch("a.id, a.user_id, u.user_nm, u.login_id", f.get("s_keyword"), "LIKE");
lm.setOrderBy(!"".equals(m.rs("ord")) ? m.rs("ord") : "a.id DESC");

//포맷팅
DataSet list = lm.getDataSet();
while(list.next()){
    list.put("progress_ratio_conv", m.nf(list.d("progress_ratio"), 1));
    list.put("start_date_conv", m.time("yyyy.MM.dd", list.s("start_date")));
    list.put("end_date_conv", m.time("yyyy.MM.dd", list.s("end_date")));
    list.put("complete_date_conv", "".equals(list.s("complete_date")) ? "-" : m.time("yyyy.MM.dd", list.s("complete_date")));
    list.put("complete_status_conv", m.getItem(list.s("complete_status"), courseUser.completeStatusList)); 
}

//엑셀
if("excel".equals(m.rs("mode"))){
    ExcelWriter ex = new ExcelWriter(response, "수강생관리(" + m.time("yyyy-MM-dd") + ").xls");

    ex.setData(list, new String[] { "__ord=>No", "user_nm=>수강생명", "login_id=>로그인아이디", "course_nm=>과정명", "progress_ratio=>진도율", "start_date=>학습시작일", "end_date=>학습종료일", "complete_date=>수료일", "complete_status_conv=>수료여부" }, "수강생관리(" + m.time("yyyy-MM-dd") + ")");
    ex.write();
    return;
}

//출력
p.setLayout(ch);
p.setBody("course.user_list");
p.setVar("p_title", !managementBlock ? "통합수강생관리" : cinfo.s("course_nm"));
p.setVar("query", m.qs());
p.setVar("list_query", m.qs("id"));
p.setVar("form_script", f.getScript());

p.setLoop("list", list);
p.setVar("list_total", lm.getTotalString());
p.setVar("pagebar", lm.getPaging());

p.setVar("tab_user", "current");
p.setLoop("courses", course.getCourseList());
p.setVar("management_block", managementBlock);
p.display();

%>