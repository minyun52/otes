package dao;

import malgnsoft.db.*;
import malgnsoft.util.*;
import java.util.*;

public class CourseUserDao extends DataObject{

    public String[] completeStatusList = {"I => 미판정", "N => 미수료", "Y => 수료"};

    public CourseUserDao() {
        this.table = "LM_COURSE_USER";
    }

    public boolean addUser(int userId, int courseId) { return addUser(userId, courseId, null); }

    public boolean addUser(int userId, int courseId, DataSet cinfo) {
        CourseDao course = new CourseDao();
        Malgn m = new Malgn();

        if(cinfo == null) {
            cinfo = new DataSet();
            cinfo = course.find("id = " + courseId + "");
            if(!cinfo.next()) { return false;}
            item("course_id", courseId);
        } else {
            item("course_id", cinfo.i("id"));
        }

        item("user_id", userId);
        item("start_date", m.time("yyyyMMdd")); //학습시작일
        item("end_date", (m.addDate("D", cinfo.i("lesson_day"), m.time("yyyyMMdd"), "yyyyMMdd"))); //학습종료일
        item("reg_date", m.time("yyyyMMddHHmmss"));
        return insert();
    }

    public int completeUser(int id) {
    	CourseDao course = new CourseDao();
    	Malgn m = new Malgn();
    	
    	DataSet info = query(
    		"SELECT a.*, c.limit_progress "
			+ " FROM " + this.table + " a "
			+ " INNER JOIN " + course.table + " c ON a.course_id = c.id "
			+ " WHERE a.id = " + id + " "   			
		);
    	if(!info.next()) return -1;
    	
    	if(info.d("limit_progress") > info.d("progress_ratio")) {
    		item("complete_status", "N");
    		item("complete_date", "");
            item("complete_no", "");
    	} else if(info.d("limit_progress") <= info.d("progress_ratio")) {
    		item("complete_status", "Y");
    		item("complete_date", m.time("yyyyMMdd"));
            item("complete_no", m.time("yyyy") + "-"+ id +"-" + info.i("course_id"));
        }
    	if(!update("id = " + id)) { return -1; }
    	return 1;    	
    }
    
    public boolean setProgressRatio(int id) { //진도율 계산
        DataSet info = find("id = " + id  + "");
        if(!info.next()) return false;

        int lessonCnt = new LessonDao().findCount("status = 1 AND course_id = " + info.i("course_id") + ""); //전체 차시
        int completedCnt = new CourseProgressDao().findCount("course_user_id = " + id + " AND complete_yn = 'Y' AND status = 1"); //수강생이 진도완료한 강의가 몇 개인지 셈

        this.item("progress_ratio", Math.min(100.00, Malgn.round(lessonCnt > 0 ? completedCnt * 100.00 / lessonCnt : 0.00, 2))); //강의가 있으면 ? 완료한강의수/전체강의수 : 0.00% , 소수점 지정하는 인자
        return this.update("id = " + id + "");
    }
}