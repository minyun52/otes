<%@ page contentType="text/html; charset=utf-8" %><%@ include file="../init.jsp" %><%

//기본키
String file = m.decode(m.rs("file")); // 인코드된 파일을 복호화 해서 사용할 수 있게 한다.
String path = m.getUploadPath(file); //getuploadpath  메소드를 이용해서 파일 경로를 받아온다
if("".equals(file)) { m.jsError("기본키는 반드시 지정해야 합니다."); return; }

//제한
String ek = m.rs("ek");
if("".equals(ek) || !m.encrypt(file + m.time("yyyyMMdd")).equals(ek)) { m.jsError("잘못된 접근입니다."); return; }

//다운로드
File f1 = new File(path);
if(f1.exists()) {
    m.download(path, file);
} else { m.jsError("파일이 존재하지 않습니다."); return; }

%>