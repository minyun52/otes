<%@ page contentType="text/html; charset=utf-8" %> <%@ include file="init.jsp" %><%

//객체
CourseDao course = new CourseDao();

//폼체크
f.addElement("course_nm", null, "hname:'과정명', required:'Y'");
f.addElement("course_file", null, "hname:'메인이미지', allow:'jpg|jpeg|gif|png', required:'Y'");
f.addElement("lesson_day", 30, "hname:'학습일수', option:'number', required:'Y'");
f.addElement("description", null, "hname:'과정목록 소개문구'");

//등록
if(m.isPost() && f.validate()) {

    course.item("course_nm", f.get("course_nm"));
    course.item("lesson_day", f.getInt("lesson_day"));
    course.item("description", f.get("description"));
    course.item("reg_date", m.time("yyyyMMddHHmmss"));

    //학습일수
    if(f.getInt("lesson_day") < 1) { m.jsAlert("학습일수는 1일 이상 입력해주세요."); return; }

    //이미지 파일 유무 체크
    File f1 = f.saveFile("course_file"); // 파일
    if(null != f1) {
        course.item("course_file", f.getFileName("course_file"));
    }

    if(!course.insert()) { m.jsAlert("등록하는 중 오류가 발생했습니다."); return; }

    //이동
    m.jsAlert("성공적으로 등록했습니다.");
    m.jsReplace("course_list.jsp", "parent");
    return;
}

//출력
p.setLayout(ch);
p.setBody("course.course_insert");
p.setVar("p_title", "과정등록");
p.setVar("query", m.qs());
p.setVar("list_query", m.qs("id"));
p.setVar("form_script", f.getScript());
p.display();

%>