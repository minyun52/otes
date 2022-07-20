<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp"%><%

//객체
CourseDao course = new CourseDao();

//폼입력
String ord = m.rs("ord");

//변수
String defaultImage = "/common/images/default/noimage_course.gif";

//폼체크
f.addElement("s_keyword", null, null);
f.addElement("ord", null, null);

//목록
ListManager lm = new ListManager();
lm.setRequest(request);
lm.setListNum(12);
lm.setTable(course.table + " a ");
lm.setFields("a.id, a.course_type, a.course_nm, a.course_file, a.price, a.recomm_yn");
lm.addWhere("a.status = 1");
lm.addSearch("a.course_nm", f.get("s_keyword"), "LIKE");
lm.setOrderBy(!"".equals(ord) ? "a.course_nm " + ord : "a.course_nm DESC");

DataSet list = lm.getDataSet();
//포메팅
while(list.next()) {
    //메인이미지
//    list.put("course_file_url", list.s("course_file_url") != "" ? defaultImage : m.getUploadUrl(list.s("course_file")));

list.put("course_file_url", "/html/images/common/noimage_course.gif");
if(!"".equals(list.s("course_file"))) {
    list.put("course_file_url", m.getUploadUrl(list.s("course_file")));
    };
};

//출력
p.setLayout(ch);
p.setBody("course.course_list");
p.setVar("form_script", f.getScript());
p.setLoop("list", list);
p.setVar("pagebar", lm.getPaging());
p.display();

%>