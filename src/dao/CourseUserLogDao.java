package dao;

import malgnsoft.db.*;
import malgnsoft.util.*;
import java.util.*;

public class CourseUserLogDao extends DataObject{

    public CourseUserLogDao() {
        this.table = "LM_COURSE_USER_LOG";
    }

    public String getDeviceType(String agent) {
        return "PC";
    }
}