#NoEnv
#NoTrayIcon
FileEncoding, UTF-8
#Include, %A_ScriptDir%\func_01.ahk

DataPath = %A_ScriptDir%\data
Global _module := "Tiep nhan"
Global _function := ""
Global _TestCaseName := ""

;Data
;GUI setting
TCF_T := "Chỉnh sửa"
AH_height := 620
AH_width := 1000
LV_width := AH_width - 40

Gui, Main:Default
Gui Main:Color, CCCCF0
Gui, Main:Font, S13 normal,

Menu, FileMenu, Add, Exit, MainExit
Menu, InfoMenu, Add, Ver, InfoVer
Menu, MyMenuBar, Add, &File, :FileMenu
Menu, MyMenuBar, Add, &Help, :InfoMenu

Gui, Main:Menu, MyMenuBar
Gui, Main:Add, DropDownList, x120 y20 +0x200 w150 -theme vDDLModule gDDLModule, Tiếp nhận||Khám bệnh|Dược
Gui, Main:Add, DropDownList, x400 y20 +0x200 w540 -theme vddlFunc gDDLFunC,
Gui, Main:Add, Pic, x950 y20 w28 h28 glistTC, %A_ScriptDir%\ico\document.png

Gui, Main:Font, s13 bold
Gui, Main:Add, Text, x20 y20 +0x200 h28 cNavy, Module:
Gui, Main:Add, Text, x300 y20 +0x200 h28 cNavy, Function:
Gui, Main:Add, Groupbox, x20 y60 w965 h260 cNavy, Test case
Gui, Main:Add, Groupbox, x20 y330 w965 h250 cNavy, Test step

Gui, Main:Font, S10 bold
Gui, Main: Add, Text, x25 y80 w25 h30 cGray +Center +0x200, X
Gui, Main: Add, Text, x50 y80 w50 h30 cGray +Center +0x200, ID
Gui, Main: Add, Text, x80 y80 w350 h30 cGray +Center +0x200, TestCase Name
Gui, Main: Add, Text, x440 y80 w350 h30 cGray +Center +0x200, Precondition
Gui, Main: Add, Text, x920 y80 w50 h30 cGray +Center +0x200, Auto?

Gui, Main:Font, S11 normal
Gui, Main:Add, ListView, x22 y110 w960 h207 hWndhLVItems +LV0x4000 +Grid +Checked AltSubmit -Hdr vlvTestCase glvTestCase ,X|STT|Test Name|Preconditon|Auto
DllCall("UxTheme.dll\SetWindowTheme", "Ptr", hLVItems, "WStr", "Explorer", "Ptr", 0)
    LV_ModifyCol(1, "25")
    LV_ModifyCol(2, "50 Center")
    LV_ModifyCol(3, "450")
    LV_ModifyCol(4, "370")
    LV_ModifyCol(5, "60 Center")

Gui, Main:Font, bold
Gui, Main: Add, Text, x21 y350 w48 h30 cGray +Center +0x200, ID
;Gui Add, Text, x68 y305 w2 h23 +0x1 +0x10
Gui, Main: Add, Text, x70 y350 w420 h30 cGray +Center +0x200, Step
Gui, Main: Add, Text, x490 y350 w200 h30 cGray +Center +0x200, Behaviour expect
Gui, Main: Add, Text, x690 y350 w200 h30 cGray +Center +0x200, Behaviour actual
Gui, Main: Add, Text, x890 y350 w80 h30 cGray +Center +0x200, Status
Gui, Main:Font, cBlack normal
Gui, Main:Add, ListView, x22 y377 w%LV_width% h200 hWndhLVItems +LV0x4000 +Grid AltSubmit -Hdr -Theme vlvTestStep glvTestStep ,STT|Step|Behaviour expect|Behaviour actual|Status
DllCall("UxTheme.dll\SetWindowTheme", "Ptr", hLVItems, "WStr", "Explorer", "Ptr", 0)
    LV_ModifyCol(1, "50 Center")
    LV_ModifyCol(2, 420)
    LV_ModifyCol(3, 200)
    LV_ModifyCol(4, 200)
    LV_ModifyCol(5, 80)

Gui, Main:Show, w%AH_width% h600, Testcase
Gui, Main:Submit, Nohide

_init()
 Gui, Main:Submit, NoHide
_function := bodau(DDLFunc)
init_TestCase()

Menu, Main:TestCaseMenu, Add, Thêm mới TestCase, AddTC
Menu, Main:TestCaseMenu, Add, Sửa TestCase, EditTC
Menu, Main:TestCaseMenu, Add, Xóa TestCase, DelTC
Menu, Main:TestCaseMenu, Add, Mở file, OpenFileTC

Menu, Main:TestStepMenuNull, Add, Thêm TestStep, AddTS

Menu, Main:TestStepMenu, Add, Thêm TestStep, AddTS
Menu, Main:TestStepMenu, Add, Chèn TestStep, InsertTS
Menu, Main:TestStepMenu, Add, Sửa TestStep, EditTS
Menu, Main:TestStepMenu, Add, Xóa TestStep, DelTS

Gui, TCF:Color, CCCCF0
Gui, TCF:Font, S11
Gui, TCF:Add, Text, x20 y20 cNavy, TestCase Name:
Gui, TCF:Add, Edit, x140 y20 w600 vTCFEdit gTCFEdit,
Gui, TCF:Add, Text, x20 y50 cNavy, Precondition:
Gui, TCF:Add, Edit, x140 y50 w600, 
Gui, TCF:Font, S10
Gui, TCF:Add, BUtton, x490 y80 w60 vbtnOK gbtnOK disabled, Ok
Gui, TCF:Add, BUtton, x560 y80 w60 gbtnCancel, Cancel

Gui, TSF:Color, CCCCF0
Gui, TSF:Font, s11
Gui, TSF:Font, bold c6666ff
Gui, TSF:Add, Text, x20 y20 cNavy, Thông tin Test Step

Gui, TSF:Add, Text, x20 y50 , ID:
Gui, TSF:Add, Text, x20 y80 TSName, Step Name:
Gui, TSF:Add, Text, x20 y110, Behaviour Expect:
Gui, TSF:Add, Text, x20 y140, Behaviour Actual:
Gui, TSF:Add, Text, x20 y170, Status:
Gui, TSF:Add, Button, x480 y200 w80 vTSOK gTSFOK, &OK
Gui, TSF:Add, Button, x570 y200 w80, Cancel
Gui, TSF:Font, Normal cBlack
Gui, TSF:Add, DropDownList, x160 y50 w70 vTSID -Theme,
Gui, TSF:Add, Edit, x160 y80 w500 vTSName gTSName -Theme,
Gui, TSF:Add, Edit, x160 y110 w500 vTSBeEx -Theme,
Gui, TSF:Add, Edit, x160 y140 w500 vTSBeAc -Theme,
Gui, TSF:Add, DropDownList, x160 y170 w70 vTSStatus -Theme, -||Pass|Fail|N/a

Gui, Info:Font, s12 bold
Gui, Info:Add, Text, x20 y20 cNavy, Thông tin phiên bản
Gui, Info:Font, s11 Normal
Gui, Info:Add, Text, x20 y50 w250 h440 -theme vinfodetail,

Return

MainGuiContextMenu:
    if (A_GuiControl = "lvTestCase")  
        Menu, Main:TestCaseMenu, Show, %A_GuiX%, %A_GuiY%
    Else If (A_GuiControl = "lvTestStep") {
        Gui, Main:ListView, lvTestStep
        If (LV_GetCount(["S"]) = 0)
            Menu, Main:TestStepMenuNULL, Show, %A_GuiX%, %A_GuiY%
        Else
            Menu, Main:TestStepMenu, Show, %A_GuiX%, %A_GuiY%
    } 
Return

MainExit:
MainGuiEscape:
MainGuiClose:
    ExitApp

TCFGuiClose:
btnCancel:
    Gui, Main:-Disabled
    Gui, TCF:Cancel
    Return

TSFGuiClose:
    Gui, Main:-Disabled
    Gui, TSF:Cancel
    Return

InfoVer:
    Gui, Info:Show, w300 h500, Info
    Xpath = %A_ScriptDir%\verinfo.txt
    IfNotExist, %Xpath%
    {
        Msgbox, 16, Thông báo, Lỗi không tìm thấy file info
        Return
    }
    FileRead, infovar, %Xpath%
    GuiControl, Info:, infodetail, %infovar%
    Return

CallTSF()
{
    Gui, TSF:Show,,Form
    GuiControl, TSF:Disable, TSOK
    Return
}
listTC:
    listTC_path = %A_ScriptDir%\data\%_module%\%_function%\_main.txt
    IfNotExist, %listTC_path%
    {
        Msgbox, 52, Thông báo, không tồn tại file`n Tạo file?
        IfMsgBox, Yes
            FileAppend,, %listTC_path%
        Else
            Return
    }
    Run, %listTC_path%
    Return


;XỬ TRÍ KHI NHẬP NỘI DỤNG TRONG FILED
TCFEdit:
    Gui, TCF:Submit, NoHide
    If (_ing = "Addtestcase" Or _ing = "AddTestStep" OR "InsertTestStep") {
        If (TCFEdit <> "")
            GuiControl, TCF:enable, btnOK 
        Else
            GuiControl, TCF:disable, btnOK 
    }
    Else If (_ing = "Edittestcase") {
        If (trim(TCFEdit) = TestCaseName Or TCFEdit = "")
            GuiControl, TCF:disable, btnOK 
        Else
            GuiControl, TCF:enable, btnOK 
    }
    Else If (_ing = "EditTestStep") {
        If (trim(TCFEdit) = TestStepName) Or (TCFEdit = "")
            GuiControl, TCF:disable, btnOK 
        Else
            GuiControl, TCF:enable, btnOK 
    }
    Return

DDLModule:
    Gui, Main:Submit, NoHide
    _Module := bodau(DDLModule)
    func := get_function()
    GuiControl, , DDLFunc,|%func% 
    GuiControl, choose, DDLFunc, 1
    Gui, Main:Submit, NoHide
    _function := bodau(DDLFunc)
    init_TestCase()
    Gui, Main:ListView, lvteststep
    LV_Delete()
    Return

;XỬ TRÍ KHI CHỌN VÀO DROPDOWNLIST FUNC
DDLFunC:
    Gui, Main:Submit, NoHide
    _function := bodau(DDLFunC)
    init_TestCase()
    Gui, Main:ListView, lvteststep
    LV_Delete()
    Return

;XỬ LÝ CÁC SỰ KIỆN RIGHT-CLICK

AddTC:
    Gui, Main:Submit, NoHide
    Gui, Main:+Disabled
    _ing := "AddTestCase"
    Gui, TCF:Show,,Thông tin TestCase
    GuiControl, TCF:, TCFEdit,
    Return

DelTC:
    If (MaxTS <> 0) {
        Msgbox, 16, Thông báo, TestCase có Step, không thể xóa!
    }
    Else {
        Msgbox, 52, Wait!, Xóa TestCase? `n%TestCaseName%
        IfMsgBox, Yes
        {
            Gui, Main:Default
            DelTestCase(TestCaseName)
            Msgbox, 32, Thông báo, Thành công
            init_TestCase()
        }
    } 
    Return


;XỬ LÝ KHI CLICK VÀO LISTVIEW TESTCASE
lvTestCase:
    Gui, Main:ListView, lvTestCase
    If (A_GuiEvent = "I") {
        if InStr(ErrorLevel, "C", true)
			Row%A_EventInfo% = 1
		else if InStr(ErrorLevel, "c", true)
			Row%A_EventInfo% = 0
    }
    ;Xử lý khi Click vào row
    If (A_GuiEvent = "Normal") {
        global X := A_EventInfo
        LV_GetText(TestCaseName, X, 3)
        _TestCaseName := Bodau(TestCaseName)
        init_TestStep()
    }
    if (A_GuiEvent = "RightClick") {
        X := A_EventInfo
        maxTC := LV_GetCount(["S"])
        LV_GetText(TestCaseName, X, 3)
        _TestCaseName := Bodau(TestCaseName)
        Gui, Main:ListView, lvTestStep
        maxTS := LV_GetCount(["S"])
    }
    Return

EditTC:
    Gui, Main:+Disabled
    _ing := "EditTestCase"
    
    Content := TestCaseName
    Gui, TCF:Show,,Thông tin TestCase
    GuiControl, TCF:, TCFEdit, %Content%
    GuiControl, TCF:Focus, TCFEdit
    Send ^{a}
    Return


OpenFileTC:
    xpath = %A_ScriptDir%\Data\%_module%\%_function%\%_TestCaseName%.txt
    IfNotExist, %xpath%
    {
        Msgbox, 52 , Thông báo, File không tồn tại!`nTạo file?
        IfMsgBox, Yes
            FileAppend,, %xpath%
        Else
            Return
    }
    run, %xpath%
    Return
btnOK:
    Gui, Main:Submit, Nohide
    Gui, TCF:Submit, NoHide
    Gui, Main:Default
    Gui, Main:ListView, lvTestCase
    If (CheckDup(TCFEdit)) {
        MSgbox, 16, Thông báo, Trùng TestCase
        Return
    }
    Switch _ing
    {
        Case "Addtestcase": ;Thêm Test name
            AddTestCase(TCFEdit)
            init_TestCase()
        Case "Edittestcase": ;Sửa test name
            EdiTestCase(TestcaseName, TCFEdit)
            init_TestCase()
    }
    Msgbox, 32, Thông báo, Thành công
    Gui, TCF:Cancel
    Gui, Main:-Disabled 
    WinActivate, Testcase
    Return

;/////////////////////////////////////////////////////////////////////////////////
;CÁC XỬ LÝ VỀ TESTCASE
;XỬ LÝ KHI CLICK VÀO LISTVIEW TEST STEP
lvTestStep:
    If (A_GuiEvent = "RightClick") {
        Y := A_EventInfo
        Gui, Main:ListView, lvTestStep
        maxTS := LV_GetCount(["S"])
        LV_GetText(TestStepID, Y, 1)
        LV_GetText(TestStepName, Y, 2)
        LV_GetText(TestStepEX, Y, 3)
        LV_GetText(TestStepAC, Y, 4)
        LV_GetText(TestStepSTATUS, Y, 5)
    }
    Return

AddTS:
    _ing := "AddTestStep"
    lineAdd := MaxTS + 1
    If (lineAdd < 10)
        lineAdd := "0" . lineAdd
    GuiControl, TSF:, TSID, |%lineAdd%
    GuiControl, TSF:Choose, TSID, 1
    GuiControl, TSF:disable, TSID
    GuiControl, TSF:, TSName,
    GuiControl, TSF:, TSBeEx,
    GuiControl, TSF:, TSBeAc,
    CallTSF()
    Return

InsertTS:
    _ing := "InsertTestStep"
    iString := "Chèn Test Step"
    CallTSF()
    GuiControl, TSF:, TSID, |%TestStepID%
    GuiControl, TSF:Choose, TSID, 1
    GuiControl, TSF:Disable, TSID
    Return

EditTS:
    Gui, Main:+Disabled
    _ing := "EditTestStep"
    IDList := ""
    loop, %maxTS%
    {
        If (A_Index < 10)
            IDList .= "0" . A_Index
        Else
            IDList .= A_Index
        If (A_Index <> maxTS)
            IDList .= "|"
    }
    GuiControl, TSF:, TSID, |%TestStepID%
    GuiControl, TSF:Choose, TSID, 1
    GuiControl, TSF:Disable, TSID

    GuiControl, TSF:, TSName, %TestStepName%
    GuiControl, TSF:, TSBeEx, %TestStepEX%
    GuiControl, TSF:, TSBeAc, %TestStepAC%
    ;GuiControl, TSF, TSStatus, %TestStepSTATUS%
    CallTSF()
    GuiControl, TSF:Enable, TSOK
    GuiControl, TSF:Focus, TSName
    Send ^{a}
    Return

DelTS:
    Msgbox, 52, Wait!, Xóa Test Step? `n%TestStepName%
        IfMsgBox, Yes
        {
            Gui, Main:Default
            DelTestStep(TestStepID)
            Msgbox, 32, Thông báo, Thành công
            init_TestStep()
        }
    Return
;Xử lý các button chỉnh sửa testcase

TSName:
    Gui, TSF:Submit, NoHide
    If (TSName = "")
        GuiControl, TSF:disable, TSOK
    Else
        GuiControl, TSF:Enable, TSOK
    Return

TSFOK:
    Gui, TSF:Submit, Nohide
    iSTr := TSName . "|" . TSBeEx . "|" . TSBeAc . "|" . TSStatus
    if (_ing = "AddTestStep") {
        AddTestStep(iSTr)
        Msgbox, 64, Thông báo, Thành công
    }
    Else if (_ing = "EditTestStep") {
        EditTestStep(TSID, iSTr)
        Msgbox, 64, Thông báo, Thành công
    }
    Else if (_ing = "InsertTestStep") {
        InsertTestStep(TSID, iSTr)
    }
        
    Gui, Main:Default
    init_TestStep()
    Return

_init()
{
    
    Gui, Main:Submit, Nohide
    func := get_function()
    GuiControl, , DDLFunc,|%func% 
    GuiControl, choose, DDLFunc, 1
   
    
    Return
}