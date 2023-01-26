ParseAHK(Lines, Tree, DocComment := "") {
  ; internal vars
  local InCommentSection := False             ; true if within a comment section '/* ... */'
      , ContinuationBuffer := ""              ; buffer to collect continuation lines
      , ContinuationBufferLineNum := 0        ; buffer for first line number of continuation lines
      , InContinuationBlock2 := False         ; true if within a continuation block of method 2 '( ... )'
      , AllowComments := 0                    ; true if comments are allowed within a continuation block of method 2
      , Match3 := Match4 := Match7 := ""      ; variable names for subpatterns of options for continuation block of method 2

      , ClassLevel := 0                       ; current class level, 0 if none
      , tnClasses := []                       ; array of tree nodes of classes, index is class Level
      , BlockLevel := []                      ; number of open blocks '{ ... }' per class level, index is class Level

      , tnCurrentFuncDef := 0                 ; tree node of function while in definition, 0 if not
      , FuncBlockLevel := 0                   ; number of open blocks '{ ... }' in the current function definition

  ;dummy values for ftAHK
      , IM_FldClose := "image of a closed folder"
      , IM_File     := "image of a file"
      , IM_Obj      := "image of a box"
      , IM_Point    := "image of a grey dot"
      , IM_Funct    := "image of an pink arrow"
      , IM_Proc     := "image of an green arrow"
      , IM_Prop     := "image of an green arrow"
  ;create master nodes in TreeView od code explorer
      , tnClass     := AddBaseNode(Tree, "Classes"   , IM_FldClose)
      , tnFunc      := AddBaseNode(Tree, "Functions" , IM_FldClose)
      , tnLab       := AddBaseNode(Tree, "Labels"    , IM_FldClose)
      , tnDLL       := AddBaseNode(Tree, "DLL calls" , IM_FldClose)
      , tnNote      := AddBaseNode(Tree, "Notes"     , IM_FldClose)
      , tnHotkey    := AddBaseNode(Tree, "HotKeys"   , IM_FldClose)
      , tnHotString := AddBaseNode(Tree, "HotStrings", IM_FldClose)
      , tnInclude   := AddBaseNode(Tree, "Includes"  , IM_FldClose)
      , tnGlobals   := AddBaseNode(Tree, "GlobalVars", IM_FldClose)

  ;>>> define RegEx Needles
      , DocCommRE :="
              ( Join LTrim Comment       ; DocComment allows comments to show up in Code Explorer as Notes
                    iS)(*UCP)                  ;case insensitive (for the DocComment string), Study and Unicode (for \s and DocComment)
                    (^|.*\s);                  ;a ';' either at start of line or with some code and a whitespace infront, thus it is an AHK comment
                    \s*                        ;optional whitespace
                    \Q" DocComment "\E         ;the literal DocComment string
                    \s*                        ;optional whitespace
                    (.*)                       ;$2 the documentation string
              )"
      , HotStringRE :="
              ( Comment Join LTrim
                    S)                         ;Study
                    ^:                         ;a ':' at start of line
                    .*?                        ;options (ungreedy)
                    :                          ;a ':'
                    (.+)                       ;$1 the hotstring
                    ::                         ;two ':'s
                    .*                         ;rest of line
                    $                          ;end of line
              )"
      , HotKeyRE :="
              ( LTrim Join Comment
                    S)                         ;Study
                    ^                          ;at start of line
                    (.+)                       ;$1 the hotkey at least one character (but including whitespace)
                    ::                         ;two ':'s
                    .*                         ;rest of line
                    $                          ;end of line
              )"
      , HotKeyCommandRE :="
              ( LTrim Join Comment
                    iS)(*UCP)                  ;case insensitive (for the Hotkey texts), Study and Unicode (for \s)
                    ^Hotkey                    ;the text 'Hotkey' at start of line
                    (\s*,\s*|\s+)              ;a comma or space
                    (?!If)                     ;not the text 'If'
                    (.+?)                      ;$2 the hotkey
                    \s*                        ;spaces
                    ,                          ;a comma
                    .*                         ;rest of line
                    $                          ;end of line
              )"
      , ContinuationBlock2RE :="
              ( Comment LTrim Join         ; for Continuation Block Method 2
                    iS)(*UCP)                  ;case insensitive (for the option texts), Study and Unicode (for \s and JoinString)
                    ^\(                        ;a '(' at start of line
                    (
                        \s*                         ;optional white space(s)
                        (
                          (Join)                       ;the option Join (Match3)
                          (\S{0,15})                   ;and an optional joinstring (up to 15 characters long) (Match4)
                          |(LTrim)                     ;or the option LTrim (Match5)
                          |(L|R)Trim0                  ;or the option LTrim0 and RTrim0
                          |(C\S*)                      ;or the option Comments (a string that starts with a 'C') (Match7)
                          |(Q\S*)                      ;or the option Quotes (for AHK v2; a string that starts with a 'Q')
                          |(`%)                        ;or the option %
                          |(,)                         ;or the option ,
                          |(``))                       ;or the option `
                   `)*                         ;the above items are optional and can exits multiple times
                    (?!                        ;and the following itmes are not to exist to the right
                        .*?                        ;any optional text (ungreedy)
                        (
                          \)                          ;and a ')'
                          |:$))                       ;or a ':' at the end of line
              )"
      , LabelRE :="
              ( Join LTrim Comment
                    S)(*UCP)                  ;Study and Unicode (for \s)
                    ^([^\s,`:]+)              ;$1 some characters at the start of the line (but no whitespace, comma, backtick or colon)
                    :$                        ;a ':' at the end of line
              )"
      , ContinuationOperatorsRE :="
              (LTrim Join Comment
                    iS)(*UCP)                 ;case insensitive (for 'and' and 'or'), Study and Unicode (for \w)
                    ^(                        ;at the start of line
                       (and|or)[^\w#@$]|      ;either "And" or "Or" followed by non word character
                       &|,|-(?!-)|!|~|/|<|>|=|:|    ;or operators that do not need to be escaped, but no --
                       \\|\.|\*|\?|\+(?!\+)|\||\^)  ;or these operators (that must be preceded by a backslash to be seen as literal), but no ++
              )"
      , DllCallRE :="
              ( Join LTrim Comment
                    i)                        ;case insensitive (for 'DllCall')
                    .*                        ;some code
                    (                         ;$1
                       DllCall                ;the text 'DllCall'
                       \(                     ;a '('
                       .*                     ;some code         ;            if i would make this ungreedy the first ) would be taken, not necessary the right one.
                       \))                    ;closing bracket   ;>>> to fix: takes the last ) in the line, not necessary the right one.
              )"
      , ClassRE :="
              ( Join LTrim Comment
                    iS)(*UCP)                 ;case insensitive (for \s, \w and 'Class'), Study and Unicode (for \s and \w)
                    ^Class                    ;the text 'Class' at the start of line
                    \s+                       ;at least one whitespace
                    ([\w#$@]+)                ;$1 one ore more chracters (A-Za-z0-9_) or #, $, @  (all allowed characters in variable names)
                    .*                        ;rest of the line
              )"
      , FunctionRE :="
              ( Join LTrim Comment            ;$1 the whole line will be a match
                    S)(*UCP)                  ;Study and Unicode (for \w)
                    ^                         ;at the start of line
                    [\w$#@]+                  ;one ore more chracters (A-Za-z0-9_) or #, $, @  (all allowed characters in variable names)
                    \(                        ;a '('
              )"
      , PropertyRE :="
              ( Join LTrim Comment            ;$1 the whole line will be a match
                    S)(*UCP)                  ;Study and Unicode (for \w)
                    ^                         ;at the start of line
                    [\w$#@]+                  ;one ore more chracters (A-Za-z0-9_) or #, $, @  (all allowed characters in variable names)
              )"
      , OTBCommandsRE :="
              ( Join LTrim Comment
                    iS)(*UCP)^(                                           ;case insensitive and at start of line
                    If((Not)?Exist|MsgBox)?|                              ; either If|If[Not]Exit|IfMsgBox
                    If((Not)?(Equal|InString)|(Greater|Less)(OrEqual)?)|  ; or If[not]Equal|If[not]Equal|If[Greater|Less][OrEqual]
                    IfWin(Not)?(Active|Exist)|                            ; or IfWin[Not][Active|Exist]
                    Else|Try|Catch|Finally|                               ; or
                    Loop|While|For)                                       ; or
                    [,\s(]                                                ; followed by an ',' space or '('
              )"
      , IncludeRE :="
              ( Join LTrim Comment
                    iS)(*UCP)                 ;case insensitive
                    ^#Include                 ;the text '#Include' at the start of line
                    \s+                       ;at least one whitespace
                    (\*i\s)?                  ;maybe the option "*i" and at least a single whitespace
                    \s*                       ;potentially more whitespaces
                    (?P<File>.*)              ;rest of the line
              )"
      , GlobalVarsRE :=" 
              ( Join LTrim Comment
                    iS)(*UCP)                 ;case insensitive
                    ^global                   ;the text 'global' at the start of line
                    \s+                       ;at least one whitespace
                    (.*)                      ;rest of the line
              )"
      ;distinguish super globals and globals?        
      ;local variable without initialization
      , TotalNumberOfLine, PhysicalLineNum, Line, TempLine, TempLineNum, FuncName, IM, Count

#Include   *i       Dummy.file 

  ;>>> Begin to parse script line by line
  TotalNumberOfLine := Lines.MaxIndex()
  For PhysicalLineNum, Line In Lines {
    Line := Trim(Line)        ;remove leading/trailing whitespaces

    If (DocComment <> "")     ;extract DocComment regardless of where it is (even inside a comment or comment section)
      ParseAndAddNode(Tree, tnNote, IM_File, Line, DocCommRE, "$2", PhysicalLineNum)

    ;>>> Remove all comments and skip empty lines ----------------------------------------------------------------------
    ;Skip comment section
    ;the /* and */ symbols comment out an entire section, but only if the symbols appear at the beginning of a line
    ;code after the */ is not part of the comment section
    If (InCommentSection) {
      If (SubStr(Line, 1, 2) = "*/"){
        InCommentSection := False
        Line := Trim(SubStr(Line, 3))   ;remove the /* from the beginning of the line and continue checking
      }Else
        Continue                        ;discard this line, it is in a Comment Section
    }Else If (SubStr(Line, 1, 2) = "/*") {
      InCommentSection := True
      Continue
    }

    ;when InContinuationBlock2 empty lines matter and maybe even comments
    ;hence, this has to be done before comments are stipped off and empty lines are skipped
    If (InContinuationBlock2) {
      If (SubStr(Line, 1, 1) = ")"){             ;it's the end of the continuation section
        InContinuationBlock2 := False
        AllowComments := False
        Line := SubStr(Line, 2)                  ;remove ) from line
      }
      If !AllowComments                          ;check if comments are allowed literaly
        Line := RemoveComments(Line)
      ;when still in continuation section concatenate the line with the JoinString,
      ;otherwise the code after the ) will be concatenated without any string
      ContinuationBuffer .= (InContinuationBlock2 ? JoinString : "") . Line
      Continue                                   ;go to next line
    }

    ;Remove any comment and skip empty lines (If not the last line)
    If ((!Line := RemoveComments(Line)) AND PhysicalLineNum <> TotalNumberOfLine)
      Continue

    ;>>> HotStrings & HotKeys ----------------------------------------------------------------------------------------
    ;HotStrings & HotKeys are not allowed inside of functions or classes or on the same line as the } of a {} block
    ;but AHK takes care of it, so I will not worry and assume that the code provided is valid AHK code.
    ;potential HotKeys and HotStrings contain a double colon
    If (InStr(RemoveQuotedStrings(Line), "::")){
      If ParseAndAddNode(Tree, tnHotString, IM_Point, Line, HotStringRE, "$1", PhysicalLineNum)
        Continue                                   ;>>> to fix: escaped characters are not escaped in code explorer
     If ParseAndAddNode(Tree, tnHotKey, IM_Point, Line, HotKeyRE, "$1", PhysicalLineNum)
        Continue                                   ;>>> to fix: DLLCalls on same line will not be shown, but it should be rare
    }
    
    ;>>> #Include ----------------------------------------------------------------------------------------------------
    If (InStr(RemoveQuotedStrings(Line), "#Include")){
      If ParseAndAddNode(Tree, tnInclude, IM_Point, Line, IncludeRE, "${File}", PhysicalLineNum)
        Continue                                   ;>>> to fix: escaped characters are not escaped in code explorer
    }

    ;>>> Collect continuation lines ==================================================================================

    ;>>> Check for Labels And/Or Start collecting continuation lines
    ;Label names are not case sensitive, and may consist of any characters other than space, tab, comma and the escape character (`).
    ;they are allowed inside of functions definitions, thus they are detected here but will be used later (detected again)
    If (RegExMatch(Line, LabelRE) or ContinuationBuffer = "") {
      ;this is not a continuation line. It is a label or the first line to be put into the buffer.

      ;Labels checked here to avoid false positives in checks below
      ;Since labels are allowed within a function body, they might be preceded with a brace, e.g.
      ;e.g. when a label is the first line after a multiline function definition without OTB
;       FuncDef()
;       { Label:    ;this label would not be catched correctly here
;
;       }
      ;or when it is following immediatly a {} block  (within in a function body or outside)
;       If(  )
;       {
;
;       } Label:    ;this label would not be catched correctly here

      ;thus do nothing just now, it will be catched later
      ;within functions first the {} blocks have to be analysed and the barces trimmed off,
      ;then the line has to be scanned again, but re-scanning can not start before the swap of lines
      ; (due to check for continuation) since this might screw up the order of lines
      ;thus, everything that is relevant within the function body has to be processed after the swap of lines

      ;in case there is no line in buffer, get next one
      ;this could happen when a label was detected very early, e.g. on the very first line in file.
      If (ContinuationBuffer = ""){
        ContinuationBuffer := Line
        ContinuationBufferLineNum := PhysicalLineNum
        If (PhysicalLineNum <> TotalNumberOfLine)
          Continue                    ;go to next line, but not in case of last line
      }

    ;>>> Collect continuation section Method 2
    ;used to merge a large number of lines; can also be used with any command or expression (assignment)
    ;in most cases there shouldn't be any valuable info for the code explorer on any of these lines (including any code on last line after ")")
    }Else If (RegExMatch(Line, ContinuationBlock2RE, Match)) {  ;it's the start of the continuation section when it starts with (
      InContinuationBlock2 := True                                ;but doesn't have a ), execption is after Join; it could be an expressions like (x.y)[z]()
                                                                ;and doesn't have a : at it's start or end, execption is after Join; it could be a label, hotkey or hoststring
      JoinString := Match3 ? "``n" : ""               ;JoinString is by default `n, when Join is present it is 'no space'
      JoinString := Match4 ? Match4 : JoinString      ;when a string is given right after Join, it is used instead
      AllowComments := Match7 ? True : False
      Continue                   ;go to next line     ;other parameters are ignored, because they do not matter for code explorer, e.g. LTRIM or `s

    ;>>> Collect continuation lines Method 1
    ;A line that starts with the following operators is automatically merged with the line directly above it
    ;operators: "and", "or", ||, &&, a comma or a period and all other expression operators except ++ and --
    ;AHK ignores also ::, but since hotstrings are caught above I see no need in this script
    }Else If (RegExMatch(Line, ContinuationOperatorsRE)){
      ContinuationBuffer .= " " Line   ;merge lines with a space
      If (PhysicalLineNum <> TotalNumberOfLine)
        Continue                       ;go to next line, but not in case of last line
    }

    ;>>> Swap buffer with current line
    ProcessLastLine:
    TempLine           := ContinuationBuffer
    ContinuationBuffer := Line             ;the current line is now buffered to be checked later
    Line               := TempLine         ;Line is now the previously buffered line
    TempLineNum               := ContinuationBufferLineNum
    ContinuationBufferLineNum := PhysicalLineNum
    PhysicalLineNum           := TempLineNum

    ;>>> GlobalVars ----------------------------------------------------------------------------------------------------
    If InStr(Line, "global")
      ParseAndAddNode(Tree, tnGlobals, IM_Proc, Line, GlobalVarsRE, "$1", PhysicalLineNum)

    ;>>> DllCalls ----------------------------------------------------------------------------------------------------
    ;>>> who has a need for showing DllCall in code explorer?
    If InStr(Line, "DLLCall")
      ParseAndAddNode(Tree, tnDll, IM_Proc, Line, DllCallRE, "$1", PhysicalLineNum)

    ;>>> Open block counter for classes and functions ------------------------------------------------------------------
    ;Process braces at the start of a line
    ;the concept with InStr() was taken from CoCo's ListClasses scipt (line 52; http://ahkscript.org/boards/viewtopic.php?p=43349#p42793)
    While (i := InStr("}}{", SubStr(Line, 1, 1)) ) {
      If (ClassLevel > 0  AND !tnCurrentFuncDef ){  ;we are in a class definition
        BlockLevel[ClassLevel] += i - 2
        If (BlockLevel[ClassLevel] < 1)
          ClassLevel--
      }Else If (tnCurrentFuncDef){                  ;we are in a function definition
        FuncBlockLevel += i - 2
        If (FuncBlockLevel < 1){
          FuncBlockLevel = 0
          tnCurrentFuncDef = 0
        }
      }Else                                         ;neither in a class nor function definition
        Break                                         ;don't trim line and break loop
      If !(Line := LTrim(SubStr(Line, 2), " `t"))
        Continue, 2             ;when no more braces and line is empty go to next line
    }


    ;>>> Class definitions ===========================================================================================
    ;a Class definition starts with the keyword "class"
    ;Class definitions can contain variable declarations, method and property definitions, Meta-Functions and nested class definitions
    ;they are not alowed inside a function definition
    tn := ClassLevel > 0 ? tnClasses[ClassLevel] : tnClass
    If (tn := ParseAndAddNode(Tree, tn, IM_Obj, Line, ClassRE, "$1", PhysicalLineNum)) {
      ClassLevel++
      tnClasses[ClassLevel] := tn
      BlockLevel[ClassLevel] := 0
      If RegExMatch(Line, "\{$")      ;check OTB
        BlockLevel[ClassLevel]++
      Continue
    }

    ;>>> Functions / methods / meta functions / class properties =====================================================
    ;function/method/metaFunction definitions are only allowed outside of function/method definitions (outside or inside of class) and on base level of a class
;     func()      ;case 1
;     {
;     }
;
;     func(){     ;case 2
;     }
;
;     class classname
;     {
;        MethodOrMetaFunction()    ;case 3
;        {
;        }
;
;        MethodOrMetaFunction(){   ;case 4
;        }
;     }

    If (!tnCurrentFuncDef AND (ClassLevel = 0 Or BlockLevel[ClassLevel] = 1)){
    ; we are not in another function definition and (outside of a class or at the base level of a class)
      ;>>> Check for a new function/method/metaFunction definition
      If (RegExMatch(Line, FunctionRE, FuncName)) {    ;potential function definition or call without return value, let's check the end of line or next not empty linep
        If ( (SubStr(Line, 0) = ")" AND SubStr(ContinuationBuffer, 1, 1) = "{")   ;case 1 & 3: function definition with { on next line
          OR (SubStr(Line, 0) = "{" ))                                            ;case 2 & 4: function definition with OTB
          tnCurrentFuncDef := 1                  ;set that something was found, (the var for the hwnd os misused as a flag)
      }

      ;class property definitions are only allowed on base level of a class
      ;they can only have Get and Set functions, but since these would be function definitions within function definition, these will be skipped
;       class classname
;       {
;          prop      ;case 1
;          {
;             get {
;                 return ...
;             }
;             set {
;                 return ... := value
;             }
;          }
;
;          prop{     ;case 2
;          }
;
;          prop[]    ;case 3
;          {
;          }
;
;          prop[]{   ;case 4
;          }
;       }
             ;"ClassLevel > 0" is redundant because BlockLevel[0] would not be 1, but for clearity I leave it in
      Else If (ClassLevel > 0 AND BlockLevel[ClassLevel] = 1){
      ;we are not in another function definition and in a class and at the base level of a class

        ;>>> Check for a new class property definition
        If (RegExMatch(Line, PropertyRE, FuncName)) {    ;potential a property definition, let's check the end of line or next not empty linep
           If (SubStr(FuncName, 0) = "["
               AND ((SubStr(Line, 0) = "]" AND SubStr(ContinuationBuffer, 1, 1) = "{") OR SubStr(Line, 0) = "{")   ;case 3 & 4
            Or SubStr(Line, 0) = "{" )                                                                                                       ;case 1 & 2
              tnCurrentFuncDef := 1              ;set that something was found, (the var for the hwnd os misused as a flag)
        }
      }

      ;>>> Previous checks found a function, method, meta function or class property
      If (tnCurrentFuncDef){
        If (SubStr(Line, 0) = "{"){       ;check again for OTB
          FuncBlockLevel++
          Line := RTrim(Line , " {")
        }
        tn := ClassLevel > 0 ? tnClasses[ClassLevel] : tnFunc        ;distinguish Functions       from methods/meta functions/ClassProperties
        IM := InStr(FuncName, "(") ? IM_Funct : IM_Prop              ;distinguish ClassProperties from methods/meta functions
        tnCurrentFuncDef := ParseAndAddNode(Tree, tn, IM, Line, "(.*)", "$1", PhysicalLineNum)
        Continue
      }
    }

    ;>>> Search for braces at the end of a line (OTB)
    ;    for classes no check at end of the line is done, because only definitions are allowed inside a class definition,
    ;    no flow commands that would allow OTB
    If (tnCurrentFuncDef AND SubStr(Line, 0) = "{"){
        ;we are in a function definition and at end of line is a { with some text before it
        ;class, functions/methods and parameters have been checked for OTB previously
        ;need to check if the line is a command that supports OTB
        ;this avoids false positives like "Msgbox, {" or "StringReplace, Out, In, Search, {"
        ;it is still not 100% robust but close, e.g. "IfEqual, var, {" would still be a false positive.
        If (RegExMatch(Line, OTBCommandsRE)){
          FuncBlockLevel++
          Continue
        }
    }

    ;>>> Labels ----------------------------------------------------------------------------------------------------
    ;Label names are not case sensitive, and may consist of any characters other than space, tab, comma and the escape character (`).
    ;they are allowed inside of functions definitions, in this case they are 'belonging' to the function definitions
    ;since all the block braces are trimmed off, the remaining of the line is the label
    tn := tnCurrentFuncDef ? tnCurrentFuncDef : tnLab
    If ParseAndAddNode(Tree, tn, IM_Point, Line, LabelRE, "$1", PhysicalLineNum)
      Continue

    ;>>> Hotkey Command
    If ParseAndAddNode(Tree, tnHotKey, IM_Point, Line, HotKeyCommandRE, "$2", PhysicalLineNum)
       Continue

    If (PhysicalLineNum = TotalNumberOfLine - 1 )
      GoTo ProcessLastLine

    ;every line that makes it through to this point is a 'normal' command
    ;in the case of the code explorer nothig needs to be done
   }

   ;remove all empty master nodes
   SortOrDeleteNode(tnClass, True)
   SortOrDeleteNode(tnFunc, True)
   SortOrDeleteNode(tnLab, True)
   SortOrDeleteNode(tnDll, True)
   SortOrDeleteNode(tnNote, True)
   SortOrDeleteNode(tnHotKey, True)
   SortOrDeleteNode(tnHotString, True)
   SortOrDeleteNode(tnInclude, True)
   SortOrDeleteNode(tnGlobals, True)

   ;Count items under each Master tree node
   tn := 0
   While (tn := TV_GetNext(tn)){
      tnChild := TV_GetChild(tn)
      Count := 1
      While (tnChild := TV_GetNext(tnChild))
        Count++
      TV_GetText(Title, tn)
      TV_Modify(tn, "", Title " (count " Count ")")
   }

   ;expand all nodes except for DLLCall, Hotkey and HotString
   tn := 0
   While (tn := TV_GetNext(tn, "Full"))
      If (tn <> tnDll And tn <> tnHotKey and tn <> tnHotString)
        TV_Modify(tn, "Expand")
}