' @brief Label para inicialização
InitializationIO:
    _ID_OUTPUT = 1
Return

' @brief Sub-rotina responsável por definir pseudo-objeto para manter Variáveis de Saída
' e Saídas Inferidas
' @param QtdVars <int> - Quantidade de variáveis de Saída
Sub CreateIO(QtdVars)
    dim OutputVar[QtdVars, 2]

    OutputVar[0,0] = "Variavel"
    OutputVar[0,1] = "Saida"    
Return

' @brief Sub-rotina para obter um registro completo
' 
' @param Id out <int> - Referência para registro
' @param Variavel out <int> - Referência para Variável Linguística de Saída
' @param Saida out <float> - Valor de Saída Deduzido 
Sub GetOutputVar(Id, &Variavel, &Saida)
    RecordGet OutputVar,Id
Return

' @brief Sub-rotina para obter a referência para variável de Saída
'
' @param Id out <int> - Referência para o Registro
' @param Variavel out <int> - Referência para Variável Linguística de Saída
Sub GetVariable(Id, &Variavel)
     RecordGet OutputVar,Id
Return

' @brief Sub-rotina para Cadastrar novo registro
'
' @param Variavel out <int> - Referência para Variável Linguística de Saída
Sub NewIO(Variavel)
    Id = _ID_OUTPUT
    _ID_OUTPUT += 1

    RecordPut OutputVar,Id
    RecordGet OutputVar,Id
Return

' @brief Sub-rotina para obter Valor de Saída Deduzido
'
' @param Saida out <float> - Valor de Saída
Sub GetOutput(Var, &Saida)
    for i = 1 to (_ID_OUTPUT-1)
        RecordGet OutputVar,i
        if(Var == Variavel)
               break
        endif
    next
Return

' @brief Sub-rotina para setar Valor de Saída Deduzido
'
' @param Saida <float> - Valor de Saída
Sub SetOutput(Id, Output)                   
    RecordGet OutputVar,Id 
    Saida = Output
    RecordPut OutputVar,Id
Return
