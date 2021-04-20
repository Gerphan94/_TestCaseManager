#NoEnv
#NoTrayIcon
FileEncoding, UTF-8
#Include, %A_ScriptDir%\func_01.ahk

DataPath = %A_ScriptDir%\data

;Data
;GUI setting
MiniF_T := "Chỉnh sửa"
AH_height := 620
AH_width := 600
LV_width := AH_width - 40

_Check = 0

Global module := "Tiếp nhận"
Global chucnang := "Nhập thông tin BN"

Gui, Main:Default
Gui, Main:Font, S20 bold
Gui, Main:Add,Text, x20 y20 cNavy, TESTCASE
Gui, Main:Font, S11 normal

Gui, Main:Add, Text, x20 y60 +0x200 h28, Module:
Gui, Main:Add, DropDownList, x70 y60 +0x200 w120 vDDLModule gDDLModule, Tiếp nhận||Khám bệnh|Dược
Gui, Main:Add, Text, x220 y60 +0x200 h28, Func:
Gui, Main:Add, DropDownList, x270 y60 +0x200 w310 vDDLFunC gDDLFunC, Nhập thông tin BN||Thẻ BHYT
Gui, Main:Font, s13 bold
Gui, Main:Add, Text, x20 y90 cNavy, Test name:
Gui, Main:Add, Text, x20 y270 cNavy, Test Step:

Gui, Main:Font, S10 normal
Gui, Main:Add, Text, x20 y465 w560 h2 +0x10
Gui, Main:Add, GroupBox, x20 y470 w560 h85
;Gui, Main:Add, Pic, x23 y480 w553 h71, %A_ScriptDir%\img\whitebg.jpg
Gui, Main:Font, S10
Gui, Main:Add, ListView, x20 y110 w560 h150 hWndhLVItems1 +LV0x4000 +Grid +Checked AltSubmit +NoSortHdr vMyListV gMyListV ,X|STT|Test Name|Status
DllCall("UxTheme.dll\SetWindowTheme", "Ptr", hLVItems1, "WStr", "Explorer", "Ptr", 0)
    LV_ModifyCol(1, "25")
    LV_ModifyCol(2, "50 Center")
    LV_ModifyCol(3, "400")
    LV_ModifyCol(4, 60)
  
Gui, Main:Add, ListView, x20 y290 w%LV_width% h190 hWndhLVItems2 +LV0x4000 +Grid  AltSubmit +NoSortHdr vMyListV2 gMyListV2 ,Step|Tên
DllCall("UxTheme.dll\SetWindowTheme", "Ptr", hLVItems2, "WStr", "Explorer", "Ptr", 0)

    LV_ModifyCol(1, "50 Center")
    LV_ModifyCol(2, 420)
 
;button_showhide("hide")

Gui, Main:Show, w600 h510, Testcase

Menu, Main:TestCaseMenu, Add, Thêm mới TestCase, AddTC
Menu, Main:TestCaseMenu, Add, Sửa TestCase, EditTC
Menu, Main:TestCaseMenu, Add, Xóa TestCase, DelTC
Menu, Main:TestCaseMenu, Add, Mở file, OpenFileTC

Menu, Main:TestStepMenuNull, Add, Thêm TestStep, AddTS

Menu, Main:TestStepMenu, Add, Thêm TestStep, AddTS
Menu, Main:TestStepMenu, Add, Chèn TestStep, InsertTS
Menu, Main:TestStepMenu, Add, Sửa TestStep, EditTS
Menu, Main:TestStepMenu, Add, Xóa TestStep, DelTS

Gui, miniF:Font, S11
Gui, miniF:Add, Text, x20 y20 w400 vminiFText, 
Gui, miniF:Add, Edit, x20 y50 w600 vminiFEdit gMiniFEdit,
Gui, miniF:Font, S10
Gui, miniF:Add, BUtton, x490 y80 w60 vbtnOK gbtnOK disabled, Ok
Gui, miniF:Add, BUtton, x560 y80 w60 gbtnCancel, Cancel
init_TestCase()
Return

MainGuiContextMenu:
    if (A_GuiControl = "MyListV")  
        Menu, Main:TestCaseMenu, Show, %A_GuiX%, %A_GuiY%
    Else If (A_GuiControl = "MyListV2") {
        Gui, Main:ListView, myListV2
        If (LV_GetCount(["S"]) = 0)
            Menu, Main:TestStepMenuNULL, Show, %A_GuiX%, %A_GuiY%
        Else
            Menu, Main:TestStepMenu, Show, %A_GuiX%, %A_GuiY%
    } 
Return

MiniFGuiClose:
btnCancel:
    Gui, Main:-Disabled
    Gui, MiniF:Cancel
    Return

;XỬ TRÍ KHI NHẬP NỘI DỤNG TRONG FILED
MiniFEdit:
    Gui, miniF:Submit, NoHide
    If (_ing = "Addtestcase" Or _ing = "AddTestStep" OR "InsertTestStep") {
        If (miniFEdit <> "")
            GuiControl, miniF:enable, btnOK 
        Else
            GuiControl, miniF:disable, btnOK 
    }
    Else If (_ing = "Edittestcase") {
        If (trim(miniFEdit) = TestCaseName Or miniFEdit = "")
            GuiControl, miniF:disable, btnOK 
        Else
            GuiControl, miniF:enable, btnOK 
    }
    Else If (_ing = "EditTestStep") {
        If (trim(miniFEdit) = TestStepName) Or (miniFEdit = "")
            GuiControl, miniF:disable, btnOK 
        Else
            GuiControl, miniF:enable, btnOK 
    }
    Return
;XỬ LÝ KHI NHẤN BUTTON OK
btnOK:
    Gui, Main:Submit, Nohide
    Gui, miniF:Submit, NoHide
    Gui, Main:Default
    Gui, Main:ListView, myListV
    Switch _ing
    {
        Case "Addtestcase": ;Thêm Test name
            AddTestCase(chucnang, miniFEdit)
            init_TestCase()
        Case "Edittestcase": ;Sửa test name
            str := DDLFunC . "|" .  miniFEdit
            func_Edit(testcase_xpath, TestCaseid, str)
            
        Case "AddTestStep":
            AddTestStep(module, chucnang, TestCasename, miniFEdit)
            ;init_TestStep(testcaseid, teststep_xpath)
        Case "EditTestStep":
            Edit_TestStep(chucnang, TestCaseName, Y, miniFEdit)
            init_TestStep(module, chucnang, TestCasename)
        Case "InsertTestStep":
            InsertTestStep(Chucnang, TestCasename, miniFEdit)
    }
    Msgbox, 32, Thông báo, Thành công
    Gui, miniF:Cancel
    Gui, Main:-Disabled 
    WinActivate, Testcase
    Return

DDLModule:
    Gui, Main:Submit, NoHide
    Module := DDLModule
    IChucnang := initChucnang()
    GuiControl, , DDLFunc,|%IChucnang% 
    GuiControl, choose, DDLFunc, 1
    Gui, Main:Submit, NoHide
    Chucnang := DDLFunc
    init_TestCase()
    Return

;XỬ TRÍ KHI CHỌN VÀO DROPDOWNLIST FUNC
DDLFunC:
    Gui, Main:Submit, NoHide
    chucnang := DDLFunC
    init_TestCase()
    Return

OpenFileTC:
    iname := bodau(TestcaseName)
    xpath = %DataPath%\%chucnang%\%iname%.txt
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

AddTC:
AddTS:
    Gui, Main:Submit, NoHide
    Gui, Main:+Disabled
    If (A_ThisLabel = "AddTC") {
        _ing := "AddTestCase"
        iString := "Thêm mới Test Case"
    }
    Else {
        _ing := "AddTestStep"
        iString := "Thêm mới Test Step"
    }
    Gui, miniF:Show,,Form Nhập
    GuiControl, miniF:, miniFText, %iString%
    GuiControl, miniF:, miniFEdit,
    Return

EditTC:
EditTS:
    Gui, Main:+Disabled
    If (A_ThisLabel = "EditTC") {
        _ing := "EditTestCase"
        iString := "Sửa Test Case"
        Content := TestCaseName
    }
    Else {
        _ing := "EditTestStep"
        iString := "Sửa Test Step"
        Content := TestStepName
    }
    Gui, miniF:Show,,Form Nhập
    GuiControl, miniF:, miniFText, %iString%
    GuiControl, miniF:, miniFEdit, %Content%
    GuiControl, miniF:Focus, miniFEdit
    Send ^{a}
    Return

DelTC:
DelTS:
    If (A_ThisLabel = "DelTC") {
        Gui, Main:ListView, myListV
        If (checkExistString(TestCaseid, teststep_xpath))
            msgbox, 16, Oop!, Test Case có step, không thể xóa.
        Else {
            Msgbox, 52, Wait!, Xóa TestCase? `n%TestCaseName%
            IfMsgBox, Yes
            {
                Gui, Main:Default
                ;Gui, Main:Submit, Nohide
                func_Del(testcase_xpath, TestCaseid)
                Msgbox, 32, Thông báo, Thành công
            }
        } 
    }
    Else {
        Msgbox, 52, Wait!, Xóa Test Step? `n%TestStepName%
        IfMsgBox, Yes
        {
            Gui, Main:Default
            Del_TestStep(chucnang, TestCaseName, Y)
            Msgbox, 32, Thông báo, Thành công
            init_TestStep(module, chucnang, TestCaseName)
        }
    }
    Return

InsertTS:
    _ing := "InsertTestStep"
    iString := "Chèn Test Step"
    Gui, miniF:Show,,Form Nhập
    GuiControl, miniF:, miniFText, %iString%
    GuiControl, miniF:, miniFEdit,
    Return

;XỬ LÝ KHI CLICK VÀO LISTVIEW TESTCASE
MyListV:
    Gui, Main:ListView, myListV
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
        init_TestStep(module, chucnang, TestCaseName)
    }
    if (A_GuiEvent = "RightClick") {
        X := A_EventInfo
        maxTC := LV_GetCount(["S"])
        LV_GetText(TestCaseName, X, 3)
    }
    Return
;XỬ LÝ KHI CLICK VÀO LISTVIEW TEST STEP
MyListV2:
    If (A_GuiEvent = "RightClick") {
        Y := A_EventInfo
        Gui, Main:ListView, myListV2
        LV_GetText(TestStepName, Y, 2)
    }
    Return

;Xử lý các button chỉnh sửa testcase
btnAdd:
    Gui, Main:+Disabled
    GuiControl, miniF:, 2EditField,
    GuiControl, miniF:Focus, 2EditField
    If (radio1) {
        _ing := "addtestcase"
        GuiControl, miniF:, 2EditField,
        Gui, Main:ListView, myListV
        LV_GetText(var, LV_GetCount(["S"]), 2)
        GuiControl, miniF:, 2text, Thêm mới test name
        Gui, miniF:Show,, %MiniF_T%
    }

    Else if (radio2) {
        _ing := "addTeststep"
        Gui, Main:ListView, myList2
        If (TestCaseSTT <> 0) {
            If (TestStepSTT <> 0) {
                iStep := TestStepSTT
                lineAdd := TestStepid
            }
            Else {
                iStep := TestStepCount + 1
                lineAdd := 
            }
        }
        GuiControl, miniF:, 2text, Thêm mới Test Step %iStep%
        Gui, miniF:Show,, %MiniF_T%
    }
   
    Return

btnEdit:
    Gui, Main:+Disabled
    If (Radio1) {
        _ing := "Edittestcase"
        GuiControl, miniF:, 2EditField, %TestCaseName%
    }
    Else if (radio2) {
        _ing := "EditTestStep"
        GuiControl, miniF:, 2EditField, %TestStepName%
    }
    Gui, miniF:-SysMenu
    Gui, miniF:Show,, %MiniF_T%
    GuiControl, miniF:Focus, 2EditField
    Send ^{a}
    Return

editCtr:
    Return


