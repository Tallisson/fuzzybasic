#include "FuzzySet.bas"
#include "FuzzyRules.bas"
#include "FuzzyIO.bas"

' @brief Label para Inicializa��o
InitializationFis:     
     _ENTRADA = 0
     _SAIDA = 1
     _ID = 1
     _NUM_DISCRET = 500
     
     GoSub InitializationSet
     GoSub InitializationRule      
     GoSub InitializationIO
Return     
               
' @brief Sub-rotina para cria��o do Sistema de Infer�ncia Fuzzy, 
' inicializa estrutura para manter as vari�veis e os conjuntos fuzzy.
'
' @param QtdInVars <int> - N�mero de Variaveis de Entrada Fuzzy
' @param QtdOutVars <int> - N�mero de Variaveis de Sa�da Fuzzy
' @param QtdSets <int> - N�mero de Conjuntos Fuzzy
' @param QtdRules <int> - N�mero de Regras Fuzzy         
Sub CreateFis(QtdInVars, QtdOutVars, QtdSets, QtdRules)
    GoSub InitializationFis      
    QtdVars = QtdInVars + QtdOutVars + 1
    Dim Fis[QtdVars, 5]
    
    Fis[0,0] = "Tipo"
    Fis[0,1] = "ConjuntoInicial"
    Fis[0,2] = "ConjuntoFinal"   
    Fis[0,3] = "LimInf"
    Fis[0,4] = "LimSup"
    
    call CreateSets(QtdSets+1)
    call CreateRules(QtdRules+1)
    call CreateIO(QtdOutVars+1)
Return

' @brief Sub-rotina para obter o tipo da Vari�vel
' @param Id <int> - Indice indicando o bloco de dado onde onde est� o registro da variavel
' @param Tipo out <int> - Variavel que referencia o Tipo da vari�vel
Sub GetType(Id, &Tipo)
    RecordGet Fis,Id 
Return

' @brief Sub-rotina para obter o conjunto associado primeiramente a Vari�vel Lingu�stica
' @param Id <int> - Indice indicando o bloco de dado onde onde est� o registro da variavel
' @param ConjuntoInicial out <int> - Variavel que referencia o C. Inicial
Sub GetInitialSet(Id, &ConjuntoInicial)
    RecordGet Fis,Id 
Return

' @brief Sub-rotina para obter o conjunto associado por �ltimo a Vari�vel Lingu�stica
' @param Id <int> - Indice indicando o bloco de dado onde onde est� o registro da variavel
' @param ConjuntoInicial out <int> - Variavel que referencia o C. Final
Sub GetFinalSet(Id, &ConjuntoFinal)
    RecordGet Fis,Id 
Return

' @brief Sub-rotina para obter o limite inferior do Dom�nio da Vari�vel Lingu�stica
' @param Id <int> - Indice indicando o bloco de dado onde onde est� o registro da variavel
' @param LimInf out <float> - Variavel que referencia o Limite Inferior do Dom�nio 
Sub GetInfLimit(Id, &LimInf)
    RecordGet Fis,Id
Return

' @brief Sub-rotina para obter o limite superior do Dom�nio da Vari�vel Lingu�stica
' @param Id <int> - Indice indicando o bloco de dado onde onde est� o registro da variavel
' @param LimInf out <float> - Variavel que referencia o Limite Superior do Dom�nio 
Sub GetSupLimit(Id, &LimSup)
    RecordGet Fis,Id
Return

' @brief Sub-rotina para retornar todas as informa��es associadas a uma variavel fuzzy
'
' @param Id <int> - Indice indicando o bloco de dado onde onde est� o registro da variavel
' @param Nome out <string> - Variavel que referencia o nome da vari�vel
' @param Tipo out <int> - Variavel que referencia o Tipo da vari�vel
' @param ConjuntoInicial out <int> - Variavel que referencia o apontador para C. Inicial
' @param ConjuntoInicial out <int> - Variavel que referencia o apontador para C. Final
Sub GetFuzzyVar(Id, &Nome, &Tipo, &ConjuntoInicial, &ConjuntoFinal, &LimInf, &LimSup)
    RecordGet Fis,Id
Return

' @brief Sub-rotina para Registrar os Limites do Dom�nio da Vari�vel Lingu�stica
' @param Id <int> - Indice indicando o bloco de dado onde onde est� o registro da variavel
' @param Initial <float> - Limite Inferior
' @param Final <float> - Limite Superior
Sub UpdateLimits(Id, Initial, Final)
    RecordGet Fis,Id

    if (vType(LimInf) == 0 OR vType(LimInf) == 48)
       LimInf = Initial
    elseif LimInf > Initial
       LimInf = Initial
    endif
    
    if (vType(LimSup) == 0 OR vType(LimSup) == 48) 
       LimSup = Final
    elseif LimSup < Final
       LimSup = Final 
    endif
    
    RecordPut Fis,Id
Return

' @brief Sub-rotina para Atualizar as Refer�ncias para os Conjuntos Fuzzy pertencentes a uma vari�vel 
' Lingu�stica
'
' @param Set <int> - Refer�ncia para o Conjunto Inserido
Sub UpdateSets(Id, Set)
    RecordGet Fis,Id
    
    if (vType(ConjuntoFinal) == 0 OR vType(ConjuntoFinal) == 48)
         ConjuntoInicial = Set
    endif
    ConjuntoFinal = Set
    
    RecordPut Fis,Id
Return
 
' @brief Sub-rotina para criacao de um Conjunto Fuzzy, associado a uma Variavel Fuzzy
' 
' @param Variavel <int> - Refer�ncia para a Vari�vel Fuzzy
' @param P1 <float> - Ponto  Um, dos quatro potos caracter�sticos que definem a fun��o
' @param P2 <float> - Ponto Dois
' @param P3 <float> - Ponto Tr�s
' @param P4 <float> - Ponto Quatro
'
' @return Id <int> - Identificador do conjunto Fuzzy  
Sub InsertFuzzySet(Variavel, P1, P2, P3, P4)
    call NewFuzzySet(Variavel, P1, P2, P3, P4)
    Id = NewFuzzySet__Result
    
    call GetFinalSet(Variavel, Anterior)       
    if vType(Anterior) <> 0 
       call SetNext(Anterior, Id)
    endif

    call UpdateSets(Variavel, Id)          
    call UpdateLimits(Variavel, P1, P4)
Return Id

' @brief Rotina para cria��o de vari�vel de entrada Fuzzy
'
' @return Id <int> - Identificador da Vari�vel
Sub NewInputVar()
    Tipo = _ENTRADA
    Id = _ID
    _ID += 1
    
    RecordPut Fis,Id
Return Id

' @brief Sub-rotina para cria��o de vari�vel de sa�da Fuzzy
'     
' @return Id <int> - Identificador da Vari�vel
Sub NewOutputVar()
    Tipo = _SAIDA     
    Id = _ID
    _ID += 1
    
    RecordPut Fis,Id
    call NewIO(Id)                                                               
Return Id 

' @brief Sub-rotina para fuzzifica��o de uma Valor Crisp
' @param Var <int> - Refer�ncia para a Vari�vel Lingu�stica
' @param Value <float> - Valor Crisp a ser fuzzificado
Sub Fuzzify(Var, Value)
    call GetInitialSet(Var, InitialSet)
    i=InitialSet
    while True
        call CalcFuzzyValue(i, Value)
        FuzzyValue = CalcFuzzyValue__Result
        call SetMembership(i, FuzzyValue)
        
        call GetNext(i, NextSet)         
        if(vType(NextSet) <> 0 AND vType(NextSet) <> 48)
              i = NextSet
        else
            break
        endif         
    wend
Return

' @brief Sub-rotina auxiliar a Fun��o de Defuzzifica��o, respons�vel por calcular a pertin�ncia para 
' os pontos do Dom�nio
'
' @param Var <int> - Refer�ncia para a Vari�vel Lingu�stica
' @param CrispValue <float> - Ponto do Dom�nio pertencente ao intervalo de discretiza��o trabalhado
' @return FuzzyValue <float> - Valor entre zero ou um, que indica a pertin�ncia para os pontos do Dom�nio
Sub CalculateValue(Var, CrispValue)
    call GetInitialSet(Var, InitialSet)
    i=InitialSet
    FuzzyValue = .0     
    while True
        call GetMembership(i, Membership)
        if(vType(Membership) <> 0 AND vType(Membership) <> 48)
            if(Membership > 0)
                call CalcFuzzyValue(i, CrispValue)
                Value = CalcFuzzyValue__Result   
                if(Value > Membership) then Value = Membership
                FuzzyValue = MaxV(FuzzyValue, Value)
            endif
        endif
        
        call GetNext(i, NextSet)         
        if(vType(NextSet) <> 0 AND vType(NextSet) <> 48)
              i = NextSet
        else
            break
        endif         
    wend     
Return FuzzyValue

' @brief Sub-rotina auxiliar a Fun��o de Defuzzifica��o, respons�vel por calcular a raz�o de discretiza��o
' do Dom�nio
' 
' @param Var <int> - Refer�ncia para a Vari�vel Lingu�stica
' @return Factor <float> - Raz�o de discretiza��o
Sub CalculateFactor(Var)
    Factor = .0
    call GetInfLimit(Var, LimInf)
    call GetSupLimit(Var, LimSup)

    Factor = 1.0*(LimSup-LimInf)/(_NUM_DISCRET-1)
Return Factor

' @brief Sub-rotina respons�vel por transformar a Infer�cia produzida pelo Sistema Fuzzy em um Valor Crisp
Sub Defuzzify() 
    for i = 1 to (_ID_OUTPUT-1)
        Set = ""
        Num = 0
        Den = 0            
        Condition = True

        call GetVariable(i, Var)
        call GetInfLimit(Var, InfLimit)
        ActualPoint = InfLimit
        MaxPoint = InfLimit
        call CalculateFactor(Var)
        Factor = CalculateFactor__Result 
        while True
            if(isString(Set) OR ActualPoint > MaxPoint OR Condition)
                Condition = False
                if(isString(Set))
                    call GetInitialSet(Var, Set)
                else
                    call GetNext(Set, NextSet)
                    if(vType(NextSet) <> 0 AND vType(NextSet) <> 48)
                        Set = NextSet
                    else
                        break
                    endif
                endif

                call GetP4(Set, MaxPoint)                      
                call GetMembership(Set, Membership)                                  
                if(vType(Membership) == 0 OR vType(Membership) == 48)
                    Condition = True
                    continue
                elseif(Membership == 0)
                    Condition = True
                    continue
                endif

                call GetP1(Set, MinPoint)
                if(ActualPoint < MinPoint)
                    N = RoundUp((MinPoint-InfLimit)/Factor)
                    ActualPoint = 1.0*InfLimit+Factor*N
                endif
            else
                ActualPoint += Factor            
            endif
            if(ActualPoint < MaxPoint)
                call CalculateValue(Var, ActualPoint)
                FuzzyValue = CalculateValue__Result
                Num += ActualPoint*FuzzyValue
                Den += FuzzyValue
            endif
        wend
        call SetOutput(i, (Num/Den))
    next
Return

' @brief Sub-rotina que controla o processo de Infer�ncia do Sistema Fuzzy
Sub EvaluateFis()
    i = 0
    while i < maxDim(FuzzyInputs)-1
        call Fuzzify(FuzzyInputs[i], FuzzyInputs[i+1])
        i += 2
    wend

    call EvaluateRules()
    call Defuzzify()
    call CleanMembershipSets()
    call CleanFireRules()
    dim FuzzyInputs[0]
Return
