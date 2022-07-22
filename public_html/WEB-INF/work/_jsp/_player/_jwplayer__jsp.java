/*
 * JSP generated by Resin-3.1.15 (built Mon, 13 Oct 2014 06:45:33 PDT)
 */

package _jsp._player;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.util.*;
import java.io.*;
import dao.*;
import malgnsoft.db.*;
import malgnsoft.util.*;

public class _jwplayer__jsp extends com.caucho.jsp.JavaPage
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

      

//\uae30\ubcf8\ud0a4
int lid = m.ri("lid");
int cuid = m.ri("cuid");
String ek = m.rs("ek");

//\uc81c\ud55c
if(lid == 0) { m.jsErrClose("\uae30\ubcf8\ud0a4\ub294 \ubc18\ub4dc\uc2dc \uc9c0\uc815\ud574\uc57c \ud569\ub2c8\ub2e4."); return; }
if(cuid > 0 && userId == 0) { m.jsErrClose("\ub85c\uadf8\uc778\uc774 \ud544\uc694\ud55c \uc11c\ube44\uc2a4\uc785\ub2c8\ub2e4."); return; }
if(!ek.equals(m.encrypt(lid + "|" + cuid + "|" + sysToday))) { m.jsErrClose("\uc62c\ubc14\ub978 \uc811\uadfc\uc774 \uc544\ub2d9\ub2c8\ub2e4."); return; }

//\uac1d\uccb4
LessonDao lesson = new LessonDao();
CourseDao course = new CourseDao();
CourseProgressDao courseProgress = new CourseProgressDao();

//\ubaa9\ub85d
DataSet info = lesson.query(
	"SELECT a.*, b.course_file, p.max_time, p.last_time, p.complete_yn "
	+ " FROM " + lesson.table + " a "
	+ " INNER JOIN " + course.table + " b ON a.course_id = b.id"
	+ " LEFT JOIN " + courseProgress.table + " p ON p.course_user_id = " + cuid + " AND p.lesson_id = a.id "
	+ " WHERE a.status = 1 AND a.id = " + lid
);
if(!info.next()) { m.jsErrClose("\ud574\ub2f9 \uac15\uc758\uac00 \uc5c6\uc2b5\ub2c8\ub2e4."); return; }

info.put("lesson_nm_conv", m.cutString(info.s("lesson_nm"), 40));

//\ucd9c\ub825
p.setLayout(null);
p.setBody("player.jwplayer");
p.setVar("file_type", "mp4");
p.setVar("image_url", info.s("course_file"));
p.setVar("lesson_url", info.s("lesson_url"));
p.setVar("last_time", info.i("last_time"));
p.setVar("start_pos", info.i("last_time"));
p.setVar("max_time", info.i("max_time"));
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("player/jwplayer.jsp"), 2536725554282177696L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("init.jsp"), -2671751158375180785L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }
}