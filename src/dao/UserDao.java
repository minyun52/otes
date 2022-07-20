package dao;

import malgnsoft.db.*;
import malgnsoft.util.*;
import java.util.*;
import java.util.regex.*;

public class UserDao extends DataObject {
    //added for github test
    //인텔리제이에서 push 테스트
    //min 브랜치 생성2
    public String[] types = {"U=>회원", "A=>운영자", "S=>최고관리자"};
    public String[] adminTypes = {"A=>운영자", "S=>최고관리자"};
    public String[] emailYn = {"Y=>동의", "N=>미동의"};
    public String[] smsYn = {"Y=>동의", "N=>미동의"};
    public String[] agreementYn = {"Y=>동의", "N=>미동의"};
    public String[] statusList = {"1=>정상", "0=>중지"};
    public String[] receiveYn = { "Y=>수신동의", "N=>수신거부" };

    public UserDao() {
        this.table = "TB_USER";
    }

    public boolean isMail(String value) {
        Pattern pattern = Pattern.compile("^[a-z0-9A-Z\\_\\.\\-]+@([a-z0-9A-Z\\.\\-]+)\\.([a-zA-Z]+)$");
        Matcher match = pattern.matcher(value);
        return match.find();
    }

}
