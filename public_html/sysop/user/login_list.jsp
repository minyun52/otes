<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//객체
UserLoginDao userLogin = new UserLoginDao();
UserDao user = new UserDao();
MCal mcal = new MCal(10);

//날짜
String today = m.time("yyyyMMdd");
DataSet dinfo = new DataSet();

dinfo.addRow();
dinfo.put("today", m.time("yyyy-MM-dd", today));
dinfo.put("sw", m.time("yyyy-MM-dd", mcal.getWeekFirstDate(today)));
dinfo.put("ew", m.time("yyyy-MM-dd", mcal.getWeekLastDate(today)));
dinfo.put("sm", m.time("yyyy-MM-01", today));
dinfo.put("em", m.time("yyyy-MM-dd", mcal.getMonthLastDate(today)));

//폼입력
String sdate = m.rs("s_sdate");
String edate = m.rs("s_edate");

//폼체크
f.addElement("s_sdate", null, null);
f.addElement("s_edate", null, null);
f.addElement("s_user_type", null, null);
f.addElement("s_login_type", null, null);
f.addElement("s_field", null, null);
f.addElement("s_keyword", null, null);
f.addElement("s_listnum", null, null);

//목록
ListManager lm = new ListManager();
lm.setRequest(request);
lm.setListNum("excel".equals(m.rs("mode")) ? 10000 : f.getInt("s_listnum", 20));
lm.setTable(
    userLogin.table + " a "
    + " LEFT JOIN " + user.table + " u ON a.user_id = u.id "
);
lm.setFields("a.*, u.user_nm, u.login_id");
if(!"".equals(sdate)) lm.addWhere("a.log_date >= '" + m.time("yyyyMMdd", sdate) + "'");
if(!"".equals(edate)) lm.addWhere("a.log_date <= '" + m.time("yyyyMMdd", edate) + "'");
lm.addSearch("a.user_type", f.get("s_user_type"));
lm.addSearch("a.login_type", f.get("s_login_type"));
if(!"".equals(f.get("s_field"))) lm.addSearch(f.get("s_field"), f.get("s_keyword"), "LIKE");
else if("".equals(f.get("s_field")) && !"".equals(f.get("s_keyword"))) lm.addSearch("u.user_nm, u.login_id, a.device, a.ip_addr", f.get("s_keyword"), "LIKE");
lm.setOrderBy(!"".equals(m.rs("ord")) ? m.rs("ord") : "a.id DESC");

//포맷팅
DataSet list = lm.getDataSet();
while(list.next()) {
    list.put("user_type_conv", m.getItem(list.s("user_type"), userLogin.userTypeList));
    list.put("login_type_conv", m.getItem(list.s("login_type"), userLogin.loginTypeList));
    list.put("reg_date_conv", m.time("yyyy.MM.dd HH:mm:ss", list.s("reg_date")));
}

//엑셀
if("excel".equals(m.rs("mode"))) {
    String[] cols = {"__ord=>No", "user_nm=>이름", "login_id=>로그인아이디", "user_type_conv=>구분", "login_type_conv=>유형", "device=>기기", "ip_addr=>IP주소", "reg_date_conv=>등록일"};

    ExcelWriter ex = new ExcelWriter(response, "접속이력(" + m.time("yyyy-MM-dd") + ").xls");
    ex.setData(list, cols);
    ex.write();
    return;
}

//출력
p.setLayout(ch);
p.setBody("user.login_list");
p.setVar("p_title", "접속이력");
p.setVar("query", m.qs());
p.setVar("list_query", m.qs("id"));
p.setVar("form_script", f.getScript());

p.setLoop("list", list);
p.setVar("pagebar", lm.getPaging());
p.setVar("list_total", lm.getTotalString());

p.setVar("date", dinfo);
p.setLoop("user_type_list", m.arr2loop(userLogin.userTypeList));
p.setLoop("login_type_list", m.arr2loop(userLogin.loginTypeList));
p.display();

%>