package dao;

import malgnsoft.db.*;
import malgnsoft.util.*;
import java.util.*;

public class CourseDao extends DataObject{

    public CourseDao() {
        this.table = "LM_COURSE";
    }

    public DataSet getCourseList() {
        return this.query(
                " SELECT a.id, a.course_nm "
                + " FROM " + this.table + " a "
                + " WHERE a.status != -1 "
                + " ORDER BY a.course_nm ASC, a.reg_date DESC "
        );
    }

}