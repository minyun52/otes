<%@ page contentType="applictaion/json; charset=utf-8" %><%@ page import="org.json.JSONObject"%><%@ include file="../init.jsp"%><%

//JSON
JSONObject result = new JSONObject();
result.put("rst_code", "1");

//기본키
int id = m.ri("id");
if(id == 0) {
    result.put("rst_code", "3");
    result.put("rst_message", "기본키는 반드시 지정해야 합니다.");
    out.print(result);
    return;
}


//객체
CourseDao course = new CourseDao();

//변수
int recommMax = 8;

//폼입력
String recommYn = !"".equals(f.get("recomm_yn")) ? f.get("recomm_yn") : "N";

//JSON-초기값
result.put("id", id);
result.put("recomm_yn", recommYn);

//제한
if("Y".equals(recommYn) && course.findCount("recomm_yn = 'Y' AND status != -1") >= recommMax){
    result.put("rst_code", "2"); 
    result.put("rst_message", " 추천여부는 최대 8개까지만 등록할 수 있습니다.");
    out.print(result);
    return;
}

//수정
course.item("recomm_yn", recommYn);
if(!course.update("id = " + id + "")) {
    result.put("rst_code", "4");
    result.put("rst_message", "수정하는 중 오류가 발생했습니다.");
    out.print(result);
    return;
}

//성공
result.put("rst_message", "추천여부 변경에 성공했습니다.");
out.print(result);

%>