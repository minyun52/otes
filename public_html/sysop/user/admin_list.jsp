<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//객체
UserDao user = new UserDao();

//폼체크
f.addElement("s_user_type", null, null);
f.addElement("s_status", null, null);
f.addElement("s_field", null, null);
f.addElement("s_keyword", null, null);
f.addElement("s_listnum", null, null);

//목록
ListManager lm = new ListManager();
lm.setRequest(request);
lm.setListNum(f.getInt("s_listnum", 20));
lm.setTable(user.table + " a");
lm.setFields("a.*");
lm.addWhere("a.status != -1");
lm.addWhere("a.user_type != 'U'");
lm.addSearch("a.user_type", f.get("s_user_type"));
lm.addSearch("a.status", f.get("s_status"));
if(!"".equals(f.get("s_field"))) lm.addSearch(f.get("s_field"), f.get("s_keyword"), "LIKE");
else lm.addSearch("a.login_id, a.user_nm", f.get("s_keyword"), "LIKE");
lm.setOrderBy(!"".equals(f.get("ord")) ? f.get("ord") : "a.id DESC");

//포맷팅
DataSet list = lm.getDataSet();
while(list.next()) {
    list.put("status_conv", m.getItem(list.i("status"), user.statusList));
    list.put("user_type_conv", m.getItem(list.s("user_type"), user.adminTypes));
}

//출력
p.setLayout(ch);
p.setBody("user.admin_list");
p.setVar("p_title", "관리자관리");
p.setVar("query", m.qs());
p.setVar("list_query", m.qs("id"));
p.setVar("form_script", f.getScript());

p.setLoop("list", list);
p.setVar("pagebar", lm.getPaging());
p.setVar("list_total", lm.getTotalString());

p.setLoop("admin_types", m.arr2loop(user.adminTypes));
p.setLoop("status_list", m.arr2loop(user.statusList));
p.display();

%>