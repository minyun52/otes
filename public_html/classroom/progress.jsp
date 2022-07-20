<%@ page contentType="text/html; charset=utf-8" %><%@ include file="../init.jsp" %><%

if(userId == 0) return;

int cuid = m.ri("cuid");
int lid = m.ri("lid");
int studyTime = m.ri("study_time");
int lastTime = m.ri("last_time");

//기본키
if(cuid == 0 || lid == 0 || lastTime <= 0 || studyTime <= 0) return;
if(studyTime > 30) studyTime = 30; //비정상적인 누적학습시간 조정

//객체
CourseProgressDao courseProgress = new CourseProgressDao();
CourseUserDao courseUser = new CourseUserDao();

courseProgress.setStudyTime(studyTime);
courseProgress.setLastTime(lastTime);
int ret = courseProgress.updateProgress(cuid, lid);

m.log("progress", "userId=" + userId + ", cuid=" + cuid + ", lid=" + lid + ", studyTime=" + studyTime + ", lastTime=" + lastTime + ", ret=" + ret);

//수강생 정보 업데이트
if(ret == 2) { //2=진도 인정시간보다 많이 봄
    courseUser.setProgressRatio(cuid); //수강생 진도율 업데이트
}

out.print(ret);
%>