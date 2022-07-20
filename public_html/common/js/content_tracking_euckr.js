if(window.addEventListener) window.addEventListener("load", fn_InitPage, false);
else if(window.attachEvent) window.attachEvent("onload", fn_InitPage);

if(window.addEventListener) window.addEventListener("unload", fn_FinishPage, false);
else if(window.attachEvent) window.attachEvent("onunload", fn_FinishPage);

//if(window.addEventListener) window.addEventListener("beforeunload", fn_FinishPage, false);
//else if(window.attachEvent) window.attachEvent("onbeforeunload", fn_FinishPage);

var hrefArray = location.href.split('/');
//���� ������ ��

var arr = hrefArray[(hrefArray.length - 1)].split(".");
var thisPage = arr[0];
var thisExt = arr[arr.length - 1];

//����üũ����
var isProgress = top._isProgress;

//������ ���۽� ȣ��
function fn_InitPage() {
	if (!isProgress) { return; }
	if(top._setPage(thisPage)) {
		try	{
			//�̾��
			var sp = top.setStartPage();
			if(sp && confirm('������ �н��� �������� �̵��Ͻðڽ��ϱ�?')) {
				location.href = sp + "." + thisExt;
				return;
			}
		}
		catch (e) {}
	}
}

//������ ����� ȣ��
function fn_FinishPage() {
	if (!isProgress) {return;}
	top._setPageComplete(thisPage);
}