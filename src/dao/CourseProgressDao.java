package dao;

import malgnsoft.db.*;
import malgnsoft.util.*;

public class CourseProgressDao extends DataObject {
    private int studyTime = 0;
    private int totalPlayTime = 0;
    private int lastTime = 0;

    public CourseProgressDao() {
        this.table = "LM_COURSE_PROGRESS";
    }

    public void setStudyTime(int time) {
        if(time > 0) this.studyTime = time;
    }

    public void setTotalPlayTime(int time) {
        if(time > 0) this.totalPlayTime = time;
    }

    public void setLastTime(int time) {
        if(time > 0) this.lastTime = time;
    }

    public void initProgress(int cuid, int lid) {
        this.item("course_user_id", cuid);
        this.item("lesson_id", lid);
        this.item("study_time", studyTime);
        this.item("last_time", lastTime);
        this.item("max_time", 0);
        this.item("complete_yn", "N");
        this.item("complete_date", "");
        this.item("reg_date", Malgn.time("yyyyMMddHHmmss"));
        this.item("status", 1);
    }

    public int updateProgress(int cuid, int lid) {

        CourseDao course = new CourseDao();
        CourseUserDao courseUser = new CourseUserDao();
        LessonDao lesson = new LessonDao();

        //수강생정보
        DataSet cuinfo = courseUser.query(
                " SELECT a.course_id, a.user_id, a.end_date "
                + " FROM " + courseUser.table + " a "
                + " INNER JOIN " + course.table + " c ON a.course_id = c.id "
                + " WHERE a.id = " + cuid + " AND a.status = 1 "
        );
        if(!cuinfo.next()) return -1;

        //제한-학습종료일 경우 진도율을 저장하지 않음
        if(0 < Malgn.diffDate("D", cuinfo.s("end_date"), Malgn.time("yyyyMMdd"))) return -2;

        //정보-강의
        DataSet linfo = lesson.query(
                "SELECT a.total_time, a.complete_time "
                + " FROM " + lesson.table + " a "
                + " WHERE a.id = " + lid + " AND a.status = 1 "
        );
        if(!linfo.next()) return -3;
        linfo.put("total_time", linfo.i("total_time") * 60);
        linfo.put("complete_time", linfo.i("complete_time") * 60);

        //진도저장
        int maxTime = 0;
        String completeYN = "N"; //최근 진도 완료
        String preCompleteYN = "N"; //마지막 진도 완료 여부

        //정보-진도
        boolean exists = false; //진도 이력 여부
        DataSet cpinfo = this.find("course_user_id = " + cuid + " AND lesson_id = " + lid + " AND status = 1", "study_time, max_time, last_time, complete_yn, reg_date");
        if(cpinfo.next()) {
            exists = true;
            preCompleteYN = cpinfo.s("complete_yn");
            maxTime = lastTime > cpinfo.i("max_time") ? lastTime : cpinfo.i("max_time"); //현재 마지막위치와 이전최대위치를 비교해서 큰값을 maxtime으로 저장
            //일반
            studyTime = cpinfo.i("study_time") + studyTime; //누적시간 = 지난번 학습시간 + 학습시간
        }

        //진도율 계산
        double ratio = 100.0;

        // MP4
        int ratioTime = Math.min(studyTime, maxTime); //누적학습시간, 최대위치 중 작은 값을 진도율을 산정
        if(ratioTime < linfo.i("complete_time")) { //완료가 아님(ratioTime 이 강의 인정시간보다 작으면)
            ratio = Math.min(100.0, (ratioTime / linfo.d("total_time")) * 100); //진도율 산정
        }

        if(ratio >= 100.0) completeYN = "Y"; //진도의 완료여부를 Y로

        // DB 등록 또는 수정
        this.item("study_time", studyTime);
        this.item("last_time", lastTime);
        this.item("max_time", maxTime);
        this.item("status", 1);

        if("N".equals(preCompleteYN) && "Y".equals(completeYN)) { //마지막 진도완료여부가 N -> 현재 Y 바뀔 때 : 현재 강의를 인정시간보다 더 본 경우
            this.item("complete_yn", "Y");
            this.item("complete_date", Malgn.time("yyyyMMdd"));
        }
        if(exists) { //진도이력이 있으면 update
            if(!this.update("course_user_id = " + cuid + " AND lesson_id = " + lid)) return -4;
        } else { //없으면 insert
            this.initProgress(cuid, lid);
            if(!this.insert()) return -5;
        }

        return "N".equals(preCompleteYN) && "Y".equals(completeYN) ? 2 : 1; //2 : 강의를 인정시간만큼 봄 , 1: 안 봄 
    }

    public boolean completeProgress(int cuid, int lid) {
        //객체
        CourseUserDao courseUser = new CourseUserDao();

        DataSet cuinfo = courseUser.find("id = " + cuid + "");
        if(!cuinfo.next()) return false;

        DataSet linfo = new LessonDao().find("id = " + lid + "");
        if(!linfo.next()) return false;

        DataSet cpinfo = this.find("course_user_id = " + cuid + " AND lesson_id = " + lid + "");
        boolean exists = cpinfo.next();

        this.item("lesson_id", lid);
        this.item("course_user_id", cuid);
        this.item("complete_yn", "Y");
        if("".equals(cpinfo.s("complete_date"))) this.item("complete_date", Malgn.time("yyyyMMdd"));

        if(exists) {
            if(!this.update("course_user_id = " + cuid + " AND lesson_id = " + lid + "")) return false;
        } else {
            this.item("reg_date", Malgn.time("yyyyMMddHHmmss"));
            if(!this.insert()) return false;
        }

        courseUser.setProgressRatio(cuid);

        return true;
    }


}
