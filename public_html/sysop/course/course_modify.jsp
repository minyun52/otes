<%@ page contentType="text/html; charset=utf-8" %><%@ include file="init.jsp" %><%

//기본키
int id = m.ri("id");
if(id == 0) { m.jsError("기본키는 반드시 있어야 합니다."); return; }

//객체
CourseDao course = new CourseDao();

//변수
int recommMax = 8;

//정보
DataSet info = course.find("id = " + id + "");
if(!info.next()) { m.jsError("해당 정보가 없습니다."); return; }

//폼체크
info.put("course_file_conv", m.encode(info.s("course_file")));
info.put("course_file_url", m.getUploadUrl(info.s("course_file")));
info.put("course_file_ek", m.encrypt(info.s("course_file") + m.time("yyyyMMdd"))); //유효성 검사

//파일삭제

if("fdel".equals(m.rs("mode"))) {

    if(!"".equals(info.s("course_file"))) {
        course.item("course_file", "");
        if(course.update("id = " + id)) {
            m.delFileRoot(m.getUploadPath(info.s("course_file")));
        }
    }
    return;
}

//폼체크
f.addElement("course_nm", info.s("course_nm"), "hname:'과정명', required:'Y'");
f.addElement("course_file", null, "hname:'메인이미지', allow:'jpg|jpeg|gif|png'");
f.addElement("lesson_day", info.i("lesson_day"), "hname:'학습일수', option:'number', min:'1', required:'Y'");
f.addElement("description", info.s("description"), "hname:'과정 소개'");
f.addElement("start_date", info.s("start_date"), "hname:'학습시작일'");
f.addElement("end_date", info.s("end_date"), "hname:'학습종료일'");
f.addElement("recomm_yn", info.s("recomm_yn"), "hname:'추천과정'");
f.addElement("limit_progress", info.i("limit_progress"), "hname:'진도 수료기준', option:'number'");

//등록
if(m.isPost() && f.validate()) {

    if(!"Y".equals(info.s("recomm_yn")) && "Y".equals(f.get("recomm_yn")) && course.findCount("recomm_yn = 'Y' AND status != -1") >= recommMax) {
        m.jsAlert("추천과정은 최대 " + recommMax + "개까지만 등록할 수 있습니다.");
        return; // 현재 추천유무가 y 가 아니고 체크한 값이 y 이고 과정 테이블에서 추천과정이 8개 이상 이라면
    }
    course.item("course_nm", f.get("course_nm"));
    course.item("lesson_day", f.getInt("lesson_day"));
    course.item("recomm_yn", f.get("recomm_yn", "N"));
    course.item("description", f.get("description"));
    course.item("limit_progress", f.getInt("limit_progress"));
    course.item("reg_date", m.time("yyyyMMddHHmmss"));

    //학습일수
    if(f.getInt("lesson_day") < 1) { m.jsAlert("학습일수는 1일 이상 입력해주세요."); return; }

    //이미지 파일 유무 체크 후 기존에 있는거 삭제
    File f1 = f.saveFile("course_file");
    if(null != f1) {
        course.item("course_file", f.getFileName("course_file"));
        if(!"".equals(info.s("course_file")) && new File(m.getUploadPath(info.s("course_file"))).exists()) {
            m.delFileRoot(m.getUploadPath(info.s("course_file")));
        }
    }

    if(!course.update("id = " + id + "")) { m.jsAlert("수정하는 중 오류가 발생했습니다."); return; }

    //이동
    m.jsAlert("성공적으로 수정했습니다.");
    m.jsReplace("course_modify.jsp?" + m.qs());
    return;
}

//출력
p.setLayout(ch);
p.setBody("course.course_insert");
p.setVar("p_title", "과정 정보");
p.setVar("query", m.qs());
p.setVar("list_query", m.qs("id"));
p.setVar("form_script", f.getScript());

p.setVar(info);
p.setVar("modify", true);
p.setVar("tab_modify", "current");
p.setVar("cid", id);
p.display();

%>