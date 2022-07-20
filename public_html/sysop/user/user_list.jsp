<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//객체
UserDao user = new UserDao();
CourseUserDao courseUser = new CourseUserDao();

//폼체크
f.addElement("s_user_type", null, null);
f.addElement("s_status", null, null);
f.addElement("s_field", null, null);
f.addElement("s_keyword", null, null);
f.addElement("s_listnum", null, null);

//목록
ListManager lm = new ListManager();
lm.setRequest(request);
lm.setListNum("excel".equals(m.rs("mode")) ? 1000 : f.getInt("s_listnum", 20));
lm.setTable(user.table + " a ");
lm.setFields(
    "a.* "
    + ", (SELECT COUNT(*) FROM "
    + courseUser.table
    + " WHERE user_id = a.id AND status != -1) course_cnt "
);
lm.addWhere("a.status != -1");
lm.addSearch("a.user_type", f.get("s_user_type"));
lm.addSearch("a.status", f.get("s_status"));
if(!"".equals(f.get("s_field"))) lm.addSearch(f.get("s_field"), f.get("s_keyword"), "LIKE");
else lm.addSearch("a.login_id, a.user_nm", f.get("s_keyword"), "LIKE");
lm.setOrderBy(!"".equals(m.rs("ord")) ? m.rs("ord") : "a.id DESC");

//포맷팅
DataSet list = lm.getDataSet();

while(list.next()) {
    list.put("conn_date_conv", m.time("yyyy.MM.dd HH:mm", list.s("conn_date")));
    list.put("reg_date_conv", m.time("yyyy.MM.dd", list.s("reg_date")));
    list.put("status_conv", m.getItem(list.i("status"), user.statusList));
    list.put("user_type_conv", m.getItem(list.s("user_type"), user.types));
}

//엑셀
if("excel".equals(m.rs("mode"))) {
    String[] cols = {"__ord=>No", "user_type_conv=>구분", "user_nm=>이름", "login_id=>로그인아이디", "mobile=>휴대전화번호", "email=>이메일", "course_cnt=>수강건수", "conn_date_conv=>최근접속일", "reg_date_conv=>가입일", "status_conv=>상태"};

    ExcelWriter ex = new ExcelWriter(response, "회원관리(" + m.time("yyyy-MM-dd") + ").xls");
    ex.setData(list, cols);
    ex.write();
    return;
}

//출력
p.setLayout(ch);
p.setBody("user.user_list");
p.setVar("p_title", "회원관리");
p.setVar("query", m.qs());
p.setVar("list_query", m.qs("id"));
p.setVar("form_script", f.getScript());

p.setLoop("list", list);
p.setVar("pagebar", lm.getPaging());
p.setVar("list_total", lm.getTotalString());

p.setLoop("types", m.arr2loop(user.types));
p.setLoop("status_list", m.arr2loop(user.statusList));
p.display();

%>