<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//기본키
int courseId = m.ri("cid");
if(courseId == 0) { m.jsErrClose("기본키는 반드시 지정해야 합니다."); return; }

//변수
String uid = f.get("uid");

//객체
UserDao user = new UserDao();
CourseDao course = new CourseDao();
CourseUserDao courseUser = new CourseUserDao();

//폼체크
f.addElement("s_type", null, null);
f.addElement("s_listnum", null, null);

//정보
DataSet cinfo = course.find("id = " + courseId + " AND status != -1");
if(!cinfo.next()) { m.jsAlert("해당 과정정보가 없습니다."); return; }

//등록
if(m.isPost() && !"".equals(uid)) {
    //중복체크
    DataSet cuinfo = courseUser.find("status != -1 AND course_id = " + courseId + " AND user_id IN (" + uid + ") ");
    if(cuinfo.size() > 0) { m.jsError("이미 등록된 수강생입니다."); return;}

    String[] idx = uid.split("\\,");
    for(int i = 0; i < idx.length; i++) {
        courseUser.addUser(m.parseInt(idx[i]), 0, cinfo);
    }

    m.jsAlert("등록되었습니다.");
    m.js("try { parent.opener.location.href = parent.opener.location.href; } catch(e) { }");
    m.jsReplace("user_add.jsp?" + m.qs());
    return;
}

//제한 - 기등록 수강생 목록
DataSet culist = courseUser.find("course_id = " + courseId + " AND status != -1");
String cuidx = "";
while(culist.next()) {
    if("".equals(cuidx)) cuidx = culist.s("user_id");
    else cuidx = cuidx + ", " + culist.s("user_id") + "";
}

//목록
ListManager lm = new ListManager();
lm.setRequest(request);
lm.setListNum(f.getInt("s_listnum", 20));
lm.setTable(user.table + " a ");
lm.setFields("a.*");
lm.addWhere("a.status = 1");
lm.addWhere("a.id NOT IN (" + cuidx + ") ");
lm.addSearch("a.user_type", f.get("s_type"));
if(!"".equals(f.get("s_field"))) lm.addSearch(f.get("s_field"), f.get("s_keyword"), "LIKE");
else lm.addSearch("a.user_nm, a.login_id", f.get("s_keyword"), "LIKE");
lm.setOrderBy(!"".equals(m.rs("ord")) ? m.rs("ord") : "a.user_nm ASC");

DataSet list = lm.getDataSet();

//출력
p.setLayout("pop");
p.setBody("course.user_add");
p.setVar("p_title", "수강생등록");
p.setVar("form_script", f.getScript());

p.setLoop("list", list);
p.setVar("pagebar", lm.getPaging());
p.setVar("list_total", lm.getTotalString());

p.setLoop("type_list", m.arr2loop(user.types));
p.display();

%>