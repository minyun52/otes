<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//기본키
int cid = m.ri("cid");
if(cid == 0) { m.jsError("기본키는 반드시 지정해야 합니다."); return; }

//객체
UserDao user = new UserDao();
CourseDao course = new CourseDao();
CourseUserDao courseUser = new CourseUserDao();

//정보
DataSet cinfo = course.find("id = " + cid + " AND status != -1");
if(!cinfo.next()) { m.jsError("해당 정보가 없습니다."); return; }

//처리 - 선택 수료 판정
if("complete_y".equals(m.rs("mode"))) {
    String idx = m.rs("idx");
    if("".equals(idx)) { m.jsAlert("기본키는 반드시 지정해야 합니다."); return; }

    DataSet culist = courseUser.find("status = 1 AND id IN ( " + idx + " )");
    while(culist.next()) courseUser.completeUser(culist.i("id"));
    
    m.jsAlert(m.nf(culist.size()) + "명이 수료처리 되었습니다.");
    m.jsReplace("complete_user.jsp?cid=" + cid, "parent");
    return;

//전체 수료 판정
} else if("all_complete_y".equals(m.rs("mode"))) {
    DataSet culist = courseUser.find("status = 1 AND course_id = " + cid );
    while(culist.next()) courseUser.completeUser(culist.i("id"));

    m.jsAlert(m.nf(culist.size()) + "명이 수료처리 되었습니다.");
    m.jsReplace("complete_user.jsp?cid=" + cid, "parent");
    return;

// 선택 판정 취소
} else if("complete_n".equals(m.rs("mode"))) {

    String idx = m.rs("idx");
    if ("".equals(idx)) { m.jsAlert("기본키는 반드시 지정해야 합니다."); return; }

    int cuCnt = courseUser.findCount("status = 1 AND id IN ( " + idx + ")");
    courseUser.item("complete_status", "I");
    courseUser.item("complete_date", "");
    courseUser.item("complete_no", "");
    courseUser.item("reg_date", m.time("yyyyMMddHHmmss"));
    if (!courseUser.update("status = 1 AND id IN (" + idx + ")")) { m.jsAlert("수료를 취소하는 중 오류가 발생했습니다."); return; }

    //이동
    m.jsAlert(m.nf(cuCnt) + "명이 수료취소 되었습니다.");
    m.jsReplace("complete_user.jsp?cid=" + cid, "parent");
    return;

// 전체 판정 취소
} else if("all_complete_n".equals(m.rs("mode"))) {

    int cuCnt = courseUser.findCount("status = 1 AND course_id = " + cid );
    courseUser.item("complete_status", "I");
    courseUser.item("complete_date", "");
    courseUser.item("complete_no", "");
    courseUser.item("reg_date", m.time("yyyyMMddHHmmss"));
    if (!courseUser.update("status = 1 AND course_id = " + cid)) { m.jsAlert("수료를 취소하는 중 오류가 발생했습니다."); return; }

    //이동
    m.jsAlert(m.nf(cuCnt) + "명이 수료취소 되었습니다.");
    m.jsReplace("complete_user.jsp?cid=" + cid, "parent");
    return;
}

//폼체크
f.addElement("s_complete", null, null);
f.addElement("s_field", null, null);
f.addElement("s_listnum", null, null);
f.addElement("s_keyword", null, null);

//목록
ListManager lm = new ListManager();
lm.setRequest(request);
lm.setListNum("excel".equals(m.rs("mode")) ? 10000 : f.getInt("s_listnum", 20));
lm.setTable(
    courseUser.table + " a "
    + " INNER JOIN " + user.table + " u ON a.user_id = u.id  AND u.status != -1 "
);
lm.setFields("a.*, u.user_nm, u.login_id");
lm.addWhere("a.status != -1");
lm.addWhere("a.course_id = " + cid + "");
lm.addSearch("a.complete_status", f.get("s_complete"));
if(!"".equals(f.get("s_field"))) lm.addSearch(f.get("s_field"), f.get("s_keyword"), "LIKE");
else if("".equals(f.get("s_field")) && !"".equals(f.get("s_keyword"))) {
    lm.addSearch("u.login_id, u.user_nm", f.get("s_keyword"), "LIKE");
}
lm.setOrderBy(!"".equals(m.rs("ord")) ? m.rs("ord") : "a.id DESC");

//포맷팅
DataSet list = lm.getDataSet();
while(list.next()) {
	list.put("progress_ratio_conv", m.nf(list.d("progress_ratio"), 0));
	list.put("start_date_conv", m.time("yyyy.MM.dd", list.s("start_date")));
    list.put("end_date_conv", m.time("yyyy.MM.dd", list.s("end_date")));
    list.put("complete_date_conv", m.time("yyyy.MM.dd", list.s("complete_date")));
    list.put("complete_conv", m.getItem(list.s("complete_status"), courseUser.completeStatusList));     
}

//엑셀
if("excel".equals(m.rs("mode2"))) {
    String[] cols = {"__ord=>No","user_nm=>이름", "login_id=>아이디", "start_date_conv=>수강시작일", "end_date_conv=>수강마감일", "progress_ratio_conv=>진도(100%기준)","complete_conv=>수료여부", "complete_date_conv=>수료판정일", "complete_no=>수료번호"};

    ExcelWriter ex = new ExcelWriter(response, "과정수료관리 (" + m.time("yyyy-MM-dd") + ").xls");
    ex.setData(list, cols);
    ex.write();
    return;
}

//출력
p.setLayout(ch);
p.setBody("complete.complete_user");
p.setVar("p_title","수료관리");
p.setVar("query", m.qs());
p.setVar("form_script", f.getScript());

p.setLoop("list", list);
p.setVar("list_total", lm.getTotalString());
p.setVar("pagebar", lm.getPaging());

p.setVar("tab_complete", "current");
p.display();

%>