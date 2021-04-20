#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#NoTrayIcon
FileEncoding, utf-8
;Test git on VSCode
;test2
func_Add(filepath, line, string1, String2)
{
	string := autoTrimString(string1) . "|" . autoTrimString(string2)
	Loop, Read, %filepath%, %A_ScriptDir%\tmp.txt
	{
		If (A_index = line)
			var := string "`n"A_LoopReadLine
		Else
			var := A_LoopReadLine
		If (var <>"")
			FileAppend, %var%`n
	}
	FileDelete,%filepath%
	FileMove, %A_ScriptDir%\tmp.txt, %filepath%
    Return
}
func_edit(filepath, line, string)
{
    Loop, Read, %filepath%, %A_ScriptDir%\tmp.txt
	{
		If (A_index = line)
			var := string
		Else
			var := A_LoopReadLine
		If (var <> "")
			FileAppend, %var%`n
	}
	FileDelete,%filepath%
	FileMove, %A_ScriptDir%\tmp.txt, %filepath%
    Return
}
func_Del(filepath, line)
{
	Loop, Read, %filepath%, %A_ScriptDir%\tmp.txt
	{
		If (A_index = line)
			var := ""
		Else
			var := A_LoopReadLine
		If (var <> "")
			FileAppend, %var%`n
	}
	FileDelete,%filepath%
	FileMove, %A_ScriptDir%\tmp.txt, %filepath%
    Return
}
checkExistString(string, xpath)
{
	Statu = 0
	Loop {
		If ErrorLevel
			Break
		FileReadLine, OutputVar, %xpath%, %A_Index%
		Loop, Parse, OutputVar, `|
		{
			If (A_index = 1)
				If (A_LoopField = String)
					Return True
		}
	}
	return False
}
;Khởi tao chức năng
initChucnang()
{
	iString := ""
	Module := Bodau(module)
	xpath = %A_ScriptDir%\data\%module%\_main.txt
	Loop,
	{
		
		FileReadLine, var, %xpath%, %A_Index%
		If ErrorLevel
			Break
		iString .= var . "|"
	}
	Return, iString
}
;Khởi tạo listview TestCase
init_TestCase()
{
	module := Bodau(module)
	chucnang := Bodau(chucnang)
	Path = %A_ScriptDir%\data\%module%\%chucnang%\_main.txt
	Gui, Main:ListView, MyListV
	LV_Delete()
    Loop
    {
        FileReadLine, var, %Path%, %A_Index%
        If ErrorLevel
            Break
		If (A_Index < 10)
			stt := "0" . A_Index
		Else
			stt := A_Index
        LV_Add("",Checked, stt, var)
    }
}
;Khởi tạo listview Test Step
init_TestStep(module, chucnang, TestCasename)
{
	module := Bodau(module)
	chucnang := Bodau(chucnang)
	TestCasename := Bodau(TestCasename)
	xpath = %A_ScriptDir%\data\%module%\%chucnang%\%TestCasename%.txt
	Gui, Main:ListView, myListV2
	LV_Delete()
	Loop, 
	{
		FileReadLine, var, %xpath%, %A_Index%
		If ErrorLevel
			Break
		If (A_Index < 10)
			stt := "0" . A_Index
		Else
			stt := A_Index
		LV_Add("", stt, var)
	}
}
;XỬ TRÍ TESTCASE
;Thêm mới một TestCase của một chức năng đang chọn
AddTestCase(chucnang, string)
{
	xpath = %A_ScriptDir%\data\%chucnang%\_main.txt
	FileAppend, %String%`n, %xpath%
}
EdiTestCase(chucnang, oldstring, newstring)
{

}

;XỬ LÝ TESTSTEP


AddTestStep(module, Chucnang, TestCasename, String)
{
	module := bodau(module)
	Chucnang := Bodau(Chucnang)
	TestCasename := Bodau(TestCasename)
	FileAppend, `n%String%, %A_ScriptDir%\data\%module%\%chucnang%\%TestCasename%.txt
}


InsertTestStep(Chucnang, TestCasename, String)
{
	Chucnang := Bodau(Chucnang)
	TestCasename := Bodau(TestCasename)
	xpath = %A_ScriptDir%\data\%chucnang%\%TestCasename%.txt
	Loop,
	{
		If (A_Index = Y)
			FileAppend, `n%String%`n, %A_ScriptDir%\data\%chucnang%\%TestCasename%.txt
		
	}
}
Edit_TestStep(chucnang, TestCaseName, TestStepline, String)
{
	iname := Bodau(TestCasename)
	xpath = %A_ScriptDir%\data\%chucnang%\%iname%.txt
	Loop, Read, %xpath%, %A_ScriptDir%\data\%chucnang%\tmp.txt
	{
		If (A_index = TestStepline)
			var := string	
		Else
			var := A_LoopReadLine
		If (var <> "")
			FileAppend, %var%`n
	}
	FileDelete, %xpath%
	FileMove, %A_ScriptDir%\data\%chucnang%\tmp.txt, %xpath%
    Return
}
Del_TestStep(chucnang, TestCaseName, TestStepline)
{
	iname := Bodau(TestCasename)
	xpath = %A_ScriptDir%\data\%chucnang%\%iname%.txt
	Loop, Read, %xpath%, %A_ScriptDir%\data\%chucnang%\tmp.txt
	{
		If (A_index = TestStepline)
			var := ""	
		Else
			var := A_LoopReadLine
		If (var <> "")
			FileAppend, %var%`n
	}
	FileDelete, %xpath%
	FileMove, %A_ScriptDir%\data\%chucnang%\tmp.txt, %xpath%
    Return
}


SortFile(xpath)
{
	FileRead, datalist, %xpath%
	Sort, datalist, Alpha
    FileDelete, %xpath%
	FileAppend, %datalist%, %xpath%
	Return
}
autoTrimString(string)
{
	newString := Trim(String)
	iString := ""
	Loop, Parse, newString, %A_Space%
	{
		If (A_LoopField <> "")
			iString .= A_LoopField . " "
	}
	return, % Trim(iString)
}

Bodau(myString)
{    
    N_String := ""    
    Loop, % StrLen(myString)    
    {        
        temp := SubStr(myString, A_Index, 1)        
        Switch Asc(temp)       
        {            
            Case 273:                
                N_String .= "d"            
            Case 272:                
                N_String .= "D"            
            Case 224, 225, 226, 227, 259, 7841, 7843, 7845, 7847, 7849, 7851, 7853, 7855, 7857, 7859, 7861, 7863:                
                N_String .= "a"            
            Case 192, 193, 194, 195, 258, 7840, 7842, 7844, 7846, 7848, 7850, 7852, 7854, 7856, 7858, 7860, 7862:                
                N_String .= "A"            
            Case 232, 233, 234, 7865, 7867, 7869, 7871, 7873, 7875, 7877, 7879:                
                N_String .= "e"            
            Case 200, 201, 202, 7864, 7866, 7868, 7870, 7872, 7874, 7876, 7878:                
                N_String .= "E"            
            Case 236, 237, 297, 7881, 7883:                
                N_String .= "i"            
            Case 204, 205, 296, 7880, 7882:                
                N_String .= "I"            
            Case 242, 243, 244, 245, 417, 7885, 7887, 7889, 7891, 7893, 7895, 7897, 7899, 7901, 7903, 7905, 7907:                  
                N_String .= "o"            
            Case 210, 211, 212, 213, 416, 7884, 7886, 7888, 7890, 7892, 7894, 7896, 7898, 7900, 7902, 7904, 7906:                
                N_String .= "O"            
            Case 249, 250, 361, 432, 7909, 7911, 7913, 7915, 7917, 7919, 7921:                
                N_String .= "u"            
            Case 217, 218, 360, 431, 7908, 7910, 7912, 7914, 7916, 7918, 7920:                
                N_String .= "U"            
            Case 253, 7923, 7925, 7927, 7929:                
                N_String .= "y"            
            Case 221, 7922, 7924, 7926, 7928:                
                N_String .= "Y"
            Case 32:
                N_String .= " "         
            Default:                
                N_String .= temp        
        }    
    }    
    Return %N_String%
}