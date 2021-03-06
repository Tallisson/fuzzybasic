' @brief Label para inicializa��o
InitializationIO:
    _ID_OUTPUT = 1
Return

' @brief Sub-rotina respons�vel por definir pseudo-objeto para manter Vari�veis de Sa�da
' e Sa�das Inferidas
' @param QtdVars <int> - Quantidade de vari�veis de Sa�da
Sub CreateIO(QtdVars)
    dim OutputVar[QtdVars, 2]

    OutputVar[0,0] = "Variavel"
    OutputVar[0,1] = "Saida"    
Return

' @brief Sub-rotina para obter um registro completo
' 
' @param Id out <int> - Refer�ncia para registro
' @param Variavel out <int> - Refer�ncia para Vari�vel Lingu�stica de Sa�da
' @param Saida out <float> - Valor de Sa�da Deduzido 
Sub GetOutputVar(Id, &Variavel, &Saida)
    RecordGet OutputVar,Id
Return

' @brief Sub-rotina para obter a refer�ncia para vari�vel de Sa�da
'
' @param Id out <int> - Refer�ncia para o Registro
' @param Variavel out <int> - Refer�ncia para Vari�vel Lingu�stica de Sa�da
Sub GetVariable(Id, &Variavel)
     RecordGet OutputVar,Id
Return

' @brief Sub-rotina para Cadastrar novo registro
'
' @param Variavel out <int> - Refer�ncia para Vari�vel Lingu�stica de Sa�da
Sub NewIO(Variavel)
    Id = _ID_OUTPUT
    _ID_OUTPUT += 1

    RecordPut OutputVar,Id
    RecordGet OutputVar,Id
Return

' @brief Sub-rotina para obter Valor de Sa�da Deduzido
'
' @param Saida out <float> - Valor de Sa�da
Sub GetOutput(Var, &Saida)
    for i = 1 to (_ID_OUTPUT-1)
        RecordGet OutputVar,i
        if(Var == Variavel)
               break
        endif
    next
Return

' @brief Sub-rotina para setar Valor de Sa�da Deduzido
'
' @param Saida <float> - Valor de Sa�da
Sub SetOutput(Id, Output)                   
    RecordGet OutputVar,Id 
    Saida = Output
    RecordPut OutputVar,Id
Return
