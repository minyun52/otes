/*
 * JSP generated by Resin-3.1.15 (built Mon, 13 Oct 2014 06:45:33 PDT)
 */

package _jsp._member;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.util.regex.Pattern;
import java.util.*;
import java.io.*;
import dao.*;
import malgnsoft.db.*;
import malgnsoft.util.*;

public class _join__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;
  
  public void
  _jspService(javax.servlet.http.HttpServletRequest request,
              javax.servlet.http.HttpServletResponse response)
    throws java.io.IOException, javax.servlet.ServletException
  {
    javax.servlet.http.HttpSession session = request.getSession(true);
    com.caucho.server.webapp.WebApp _jsp_application = _caucho_getApplication();
    javax.servlet.ServletContext application = _jsp_application;
    com.caucho.jsp.PageContextImpl pageContext = _jsp_application.getJspApplicationContext().allocatePageContext(this, _jsp_application, request, response, null, session, 8192, true, false);
    javax.servlet.jsp.PageContext _jsp_parentContext = pageContext;
    javax.servlet.jsp.JspWriter out = pageContext.getOut();
    final javax.el.ELContext _jsp_env = pageContext.getELContext();
    javax.servlet.ServletConfig config = getServletConfig();
    javax.servlet.Servlet page = this;
    response.setContentType("text/html; charset=utf-8");
    request.setCharacterEncoding("UTF-8");
    try {
      

//\uac1d\uccb4
Malgn m = new Malgn(request, response, out);

Form f = new Form("form1");
try { f.setRequest(request); }
catch(Exception ex) { out.print("Overflow file size. - " + ex.getMessage()); return; }

Page p = new Page();
p.setRequest(request);
p.setPageContext(pageContext);
p.setWriter(out);

//\ubcc0\uc218
int userId = 0;
String loginId = "";
String userName = "";
String userEmail = "";
String userType = "";
String sysToday = m.time("yyyyMMdd");
String sysNow = m.time("yyyyMMddHHmmss");
boolean loginBlock = false;

//\ub85c\uadf8\uc778 \uc5ec\ubd80 \uccb4\ud06c
Auth auth = new Auth(request, response);
auth.loginURL = "/member/login.jsp";
auth.keyName = "ENTER2022";

if(auth.isValid()) {
    userId = auth.getInt("USERID");
    loginId = auth.getString("LOGINID");
    userName = auth.getString("USERNAME");
    userEmail = auth.getString("EMAIL");
    userType = auth.getString("TYPE");
    loginBlock = true;
}

p.setVar("login_block", loginBlock);
p.setVar("SYS_TITLE", "<ENTER \"_\"> \uc624\ud508 \ub354 \uc774\ub7ec\ub2dd\uc0ac\uc774\ud2b8!");
p.setVar("SYS_LOGINID", loginId);
p.setVar("SYS_USERNAME", userName);
p.setVar("SYS_USEREMAIL", userEmail);
p.setVar("SYS_USERKIND", userType);
p.setVar("SYS_TODAY", sysToday);
p.setVar("SYS_NOW", sysNow);

      

String ch = "member";


      

//\uac1d\uccb4
UserDao user = new UserDao();

//\uc81c\ud55c - \ub3d9\uc758\ud398\uc774\uc9c0\uc5d0\uc11c \ub118\uc5b4\uc628 \uac83
String ek = m.rs("ek");
String key = m.rs("k");
if(!ek.equals(m.encrypt(key + "_AGREE"))) {
    m.jsError("\uc62c\ubc14\ub978 \uc811\uadfc\uc774 \uc544\ub2d9\ub2c8\ub2e4.");
    return;
}

//\ud3fc\uccb4\ud06c
f.addElement("login_id", null, "hname:'\ub85c\uadf8\uc778\uc544\uc774\ub514', required:'Y', pattern:'^[a-zA-Z]{1}[a-zA-Z0-9]{1,19}$' ");
f.addElement("passwd", null, "hname: '\ube44\ubc00\ubc88\ud638', required:'Y', minbyte:'8' ,match:'passwd2'");
f.addElement("passwd2", null, "hname: '\ube44\ubc00\ubc88\ud638', required:'Y'");
f.addElement("user_nm", null, "hname: '\uc774\ub984', required:'Y'");
f.addElement("email1", null, "hname: '\uc774\uba54\uc77c', required:'Y'");
f.addElement("email2", null, "hname: '\uc774\uba54\uc77c', required:'Y'");
f.addElement("mobile1", null, "hname:'\ud734\ub300\uc804\ud654\ubc88\ud638', required:'Y'");
f.addElement("mobile2", null, "hname:'\ud734\ub300\uc804\ud654\ubc88\ud638', required:'Y', option:'number'");
f.addElement("mobile3", null, "hname:'\ud734\ub300\uc804\ud654\ubc88\ud638', required:'Y', option:'number'");
f.addElement("email_yn", null, "hname: '\uc774\uba54\uc77c\uc218\uc2e0\ub3d9\uc758', required: 'Y'");
f.addElement("sms_yn", null, "hname: 'SMS\uc218\uc2e0\ub3d9\uc758', required: 'Y'");
f.addElement("status", 1, "hname: '\uc0c1\ud0dc'");

//\ub4f1\ub85d
if(m.isPost() && f.validate()) {

    //\uc81c\ud55c - \ube44\ubc00\ubc88\ud638 \ud615\uc2dd
    if(!f.get("passwd").matches("^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[\\W_]).{8,}$")) {
        m.jsAlert("\ube44\ubc00\ubc88\ud638\uac00 \ud615\uc2dd\uc5d0 \ub9de\uc9c0 \uc54a\uc2b5\ub2c8\ub2e4");
        return;
    }

    //\uc81c\ud55c - \uc774\uba54\uc77c \ud615\uc2dd
    String email = f.glue("@", "email1, email2").toLowerCase();
    if(!"@".equals(email)) {
        if(!user.isMail(email)) {
            m.jsAlert("\uc774\uba54\uc77c\uc774 \ud615\uc2dd\uc5d0 \ub9de\uc9c0 \uc54a\uc2b5\ub2c8\ub2e4.");
            return;
        }
    }

    //\uc81c\ud55c - \ud734\ub300\uc804\ud654\ubc88\ud638 \ud615\uc2dd
    String patternMobile = "(\\d{3})(\\d{3,4})(\\d{4})";
    String mobile = "";
    if(!"".equals(f.get("mobile2")) || !"".equals(f.get("mobile3"))) {
        mobile = f.get("mobile1") + f.get("mobile2") + f.get("mobile3");
        if(!Pattern.matches(patternMobile, mobile)) {
            m.jsAlert("\ud734\ub300\uc804\ud654\ubc88\ud638\ub97c \ud655\uc778\ud574\uc8fc\uc138\uc694");
            m.js("parent.resetPassword();");
            return;
        }
        mobile = mobile.replaceAll(patternMobile, "$1-$2-$3");
    } else {
        mobile = f.get("mobile1");
    }

    //\uc81c\ud55c - \uc544\uc774\ub514 \uc911\ubcf5
    if(0 != user.findCount("login_id = '" + f.get("login_id") + "' ")) {
        m.jsAlert("\uc0ac\uc6a9\ud560 \uc218 \uc5c6\ub294 \uc544\uc774\ub514\uc785\ub2c8\ub2e4.\\n\uc544\uc774\ub514\ub97c \ud655\uc778\ud574 \uc8fc\uc138\uc694.");
        m.js("parent.resetPassword();");
        return;
    }

    String passwd = f.get("passwd");
    passwd = m.encrypt(passwd, "SHA-256"); //\uc554\ud638\ud654

    user.item("user_type", "U");
    user.item("login_id", f.get("login_id"));
    user.item("passwd", passwd);
    user.item("user_nm", f.get("user_nm"));
    user.item("email", email);
    user.item("mobile", mobile);
    user.item("email_yn", f.get("email_yn", "N"));
    user.item("email_date", sysToday);
    user.item("sms_yn", f.get("sms_yn", "N"));
    user.item("sms_date", sysToday);
    user.item("agreement_yn", "Y");
    user.item("agreement_date", sysNow);
    user.item("conn_date", sysNow);
    user.item("reg_date", sysNow);
    user.item("status", "1");

    if(!user.insert()) {
        m.jsAlert("\ud68c\uc6d0\uac00\uc785\uc744 \ud558\ub294 \uc911 \uc624\ub958\uac00 \ubc1c\uc0dd\ud588\uc2b5\ub2c8\ub2e4.");
    } else {
        m.jsAlert("\ud68c\uc6d0 \uac00\uc785\uc744 \uc131\uacf5\uc801\uc73c\ub85c \uc644\ub8cc\ud588\uc2b5\ub2c8\ub2e4.");
        m.jsReplace("join_success.jsp?ek=" + ek + "&k=" + key, "parent"); //\ub4f1\ub85d \ud6c4 \ubcf4\uc5ec\uc904 \ud398\uc774\uc9c0
    }
    return;
}

//\ucd9c\ub825
p.setLayout(ch);
p.setBody("member.join");
p.setVar("form_script", f.getScript());
p.display();


    } catch (java.lang.Throwable _jsp_e) {
      pageContext.handlePageException(_jsp_e);
    } finally {
      _jsp_application.getJspApplicationContext().freePageContext(pageContext);
    }
  }

  private java.util.ArrayList _caucho_depends = new java.util.ArrayList();

  public java.util.ArrayList _caucho_getDependList()
  {
    return _caucho_depends;
  }

  public void _caucho_addDepend(com.caucho.vfs.PersistentDependency depend)
  {
    super._caucho_addDepend(depend);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  public boolean _caucho_isModified()
  {
    if (_caucho_isDead)
      return true;
    if (com.caucho.server.util.CauchoSystem.getVersionId() != 6749855747778707107L)
      return true;
    for (int i = _caucho_depends.size() - 1; i >= 0; i--) {
      com.caucho.vfs.Dependency depend;
      depend = (com.caucho.vfs.Dependency) _caucho_depends.get(i);
      if (depend.isModified())
        return true;
    }
    return false;
  }

  public long _caucho_lastModified()
  {
    return 0;
  }

  public java.util.HashMap<String,java.lang.reflect.Method> _caucho_getFunctionMap()
  {
    return _jsp_functionMap;
  }

  public void init(ServletConfig config)
    throws ServletException
  {
    com.caucho.server.webapp.WebApp webApp
      = (com.caucho.server.webapp.WebApp) config.getServletContext();
    super.init(config);
    com.caucho.jsp.TaglibManager manager = webApp.getJspApplicationContext().getTaglibManager();
    com.caucho.jsp.PageContextImpl pageContext = new com.caucho.jsp.PageContextImpl(webApp, this);
  }

  public void destroy()
  {
      _caucho_isDead = true;
      super.destroy();
  }

  public void init(com.caucho.vfs.Path appDir)
    throws javax.servlet.ServletException
  {
    com.caucho.vfs.Path resinHome = com.caucho.server.util.CauchoSystem.getResinHome();
    com.caucho.vfs.MergePath mergePath = new com.caucho.vfs.MergePath();
    mergePath.addMergePath(appDir);
    mergePath.addMergePath(resinHome);
    com.caucho.loader.DynamicClassLoader loader;
    loader = (com.caucho.loader.DynamicClassLoader) getClass().getClassLoader();
    String resourcePath = loader.getResourcePathSpecificFirst();
    mergePath.addClassPath(resourcePath);
    com.caucho.vfs.Depend depend;
    depend = new com.caucho.vfs.Depend(appDir.lookup("member/join.jsp"), 1191258477673611855L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("member/init.jsp"), 8543850891864551039L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("init.jsp"), -2671751158375180785L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }
}