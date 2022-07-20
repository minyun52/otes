<%@ page contentType="text/html; charset=utf-8" %><%@ include file="../init.jsp" %><%

UserLoginDao userLogin = new UserLoginDao();

userLogin.item("user_id", userId);
userLogin.item("user_type", "F");
userLogin.item("login_type", "O");
userLogin.item("ip_addr", m.getRemoteAddr());
userLogin.item("device", userLogin.getDeviceType(request.getHeader("user-agent")));
userLogin.item("log_date", sysToday);
userLogin.item("reg_date", sysNow);

if(!userLogin.insert()) {}

auth.delete();

m.redirect("../main/index.jsp");

%>