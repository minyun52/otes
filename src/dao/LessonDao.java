package dao;

import malgnsoft.db.*;
import malgnsoft.util.*;
import java.util.*;

public class LessonDao extends DataObject{

    public String[] completeYn = {"Y=>완료", "N=>미완료"};

    public LessonDao() {
        this.table = "LM_LESSON";
    }

    public int getMaxSort(int cid) {
        return 1 + this.findCount(" course_id = " + cid + " AND status != -1");
    }


}