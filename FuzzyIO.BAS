InitializationIO:
    _ID_OUTPUT = 1
Return

Sub CreateIO(QtdVars)
    dim OutputVar[QtdVars, 2]

    OutputVar[0,0] = "Variavel"
    OutputVar[0,1] = "Saida"    
Return

Sub GetOutputVar(Id, &Variavel, &Saida)
    RecordGet OutputVar,Id
Return

Sub GetVariable(Id, &Variavel)
     RecordGet OutputVar,Id
Return

Sub NewIO(Variavel)
    Id = _ID_OUTPUT
    _ID_OUTPUT += 1

    RecordPut OutputVar,Id
    RecordGet OutputVar,Id
Return

Sub GetOutput(Var, &Saida)
    for i = 1 to (_ID_OUTPUT-1)
        RecordGet OutputVar,i
        if(Var == Variavel)
               break
        endif
    next
Return

Sub SetOutput(Id, Output)
    RecordGet OutputVar,Id 
    Saida = Output
    RecordPut OutputVar,Id
Return
