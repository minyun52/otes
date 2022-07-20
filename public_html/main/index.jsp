<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//객체
CourseDao course = new CourseDao();
//목록
DataSet list = course.find(" status = '1' AND recomm_yn = 'Y' ");

//포맷팅
while(list.next()) {
    //메인이미지
    list.put("course_file_url", "/html/images/common/noimage_course.gif");
    if(!"".equals(list.s("course_file"))) {
        list.put("course_file_url", m.getUploadUrl(list.s("course_file")));
    }
}

//출력
p.setLayout(ch);
p.setBody("main.index");
p.setVar("form_script", f.getScript());
p.setLoop("list", list);
p.display();

%>