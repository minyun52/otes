<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//객체
CourseDao course = new CourseDao();
CourseUserDao courseUser = new CourseUserDao();
UserDao user = new UserDao();

//폼체크
f.addElement("s_keyword", null, null);
f.addElement("s_listnum", null, null);
f.addElement("s_field", null, null);
f.addElement("s_recomm", null, null);

//목록
ListManager lm = new ListManager();
lm.setRequest(request);
lm.setListNum("excel".equals(m.rs("mode")) ? 1000 : f.getInt("s_listnum", 20));
lm.setTable(course.table + " a");
lm.setFields(
	"a.* "
	+ ", ( "
		+ "SELECT COUNT(*) FROM " + courseUser.table + " cu "
		+ " INNER JOIN " + user.table + " u ON cu.user_id = u.id " + " AND u.status != -1 "
		+ " WHERE a.id = cu.course_id AND cu.status != -1 "
	+ " ) "
	+ "user_cnt " + ""
);
lm.addWhere("a.status != -1");
lm.addSearch("a.recomm_yn", f.get("s_recomm"));
if(!"".equals(f.get("s_field"))) lm.addSearch(f.get("s_field"), f.get("s_keyword"), "LIKE");
else if("".equals(f.get("s_field")) && !"".equals(f.get("s_keyword"))) lm.addSearch("a.course_nm, a.id", f.get("s_keyword"), "LIKE");
lm.setOrderBy(!"".equals(m.rs("ord")) ? m.rs("ord") : "a.id DESC");

//포맷팅
DataSet list = lm.getDataSet();
if(!list.next()) { m.log("course_list", "course not found"); }

//엑셀
if("excel".equals(m.rs("mode"))) {

	String[] cols = { "__ord=>No", "course_nm=>과정명", "lesson_day=>수강일수", "limit_progress=>출석(진도) 수료기준", "recomm_yn=>추천여부"};

    ExcelWriter ex = new ExcelWriter(response, "과정관리(" + m.time("yyyy-MM-dd") + ").xls");
    ex.setData(list, cols);
    ex.write();
    return;
}

//출력
p.setLayout(ch);
p.setBody("course.course_list");
p.setVar("p_title", "과정관리");
p.setVar("query", m.qs());
p.setVar("list_query", m.qs("id"));
p.setVar("form_script", f.getScript());

p.setLoop("list", list);
p.setVar("list_total", lm.getTotalString());
p.setVar("pagebar", lm.getPaging());

p.display();

%>