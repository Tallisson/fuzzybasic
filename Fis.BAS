#include "FuzzySet.bas"
#include "FuzzyRules.bas"
#include "FuzzyIO.bas"

InitializationFis:     
     _ENTRADA = 0
     _SAIDA = 1
     _ID = 1
     _SEPARATOR = ":" 
     _NUM_DISCRET = 500
     
     GoSub InitializationSet
     GoSub InitializationRule      
     GoSub InitializationIO
Return     
               
' @brief Rotina para criação do Sistema de Inferência Fuzzy, 
' inicializa estrutura para manter as variáveis e os conjuntos fuzzy.
'
' @param QtdInVars <int> - Número de Variaveis de Entrada Fuzzy
' @param QtdOutVars <int> - Número de Variaveis de Saída Fuzzy
' @param QtdSets <int> - Número de Conjuntos Fuzzy
' @param QtdRules <int> - Número de Regras Fuzzy         
Sub CreateFis(QtdInVars, QtdOutVars, QtdSets, QtdRules)
    QtdVars = QtdInVars + QtdOutVars + 1
    Dim Fis[QtdVars, 6]
    
    Fis[0,0] = "Nome"
    Fis[0,1] = "Tipo"
    Fis[0,2] = "ConjuntoInicial"
    Fis[0,3] = "ConjuntoFinal"   
    Fis[0,4] = "LimInf"
    Fis[0,5] = "LimSup"
    
    call CreateSets(QtdSets+1)
    call CreateRules(QtdRules+1)
    call CreateIO(QtdOutVars+1)
Return

Sub GetName(Id, &Nome)
    RecordGet Fis,Id
Return

Sub GetType(Id, &Tipo)
    RecordGet Fis,Id 
Return

Sub GetInitialSet(Id, &ConjuntoInicial)
    RecordGet Fis,Id 
Return

Sub GetFinalSet(Id, &ConjuntoFinal)
    RecordGet Fis,Id 
Return

Sub GetInfLimit(Id, &LimInf)
    RecordGet Fis,Id
Return

Sub GetSupLimit(Id, &LimSup)
    RecordGet Fis,Id
Return

Sub UpdateInitialSet(Id, Set)    
    RecordGet Fis,Id
    ConjuntoInicial = Set
    RecordPut Fis,Id     
Return

Sub UpdateFinalSet(Id, Set)
    RecordGet Fis,Id
    ConjuntoFinal = Set
    RecordPut Fis,Id
Return

' @brief Rotina para retornar todas as informações associadas a uma variavel fuzzy
'
' @param Id <int> - Indice indicando o bloco de dado onde onde está o registro da variavel
' @param Nome out <string> - Variavel que referencia o nome da variável
' @param Tipo out <int> - Variavel que referencia o Tipo da variável
' @param ConjuntoInicial out <int> - Variavel que referencia o apontador para C. Inicial
' @param ConjuntoInicial out <int> - Variavel que referencia o apontador para C. Final
Sub GetFuzzyVar(Id, &Nome, &Tipo, &ConjuntoInicial, &ConjuntoFinal, &LimInf, &LimSup)
    RecordGet Fis,Id
Return

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

Sub UpdateSets(Id, Set)
    RecordGet Fis,Id
    
    'call GetFinalSet(Id, FinalSet)     
    if (vType(ConjuntoFinal) == 0 OR vType(ConjuntoFinal) == 48)
         ConjuntoInicial = Set
    endif
    ConjuntoFinal = Set
    
    RecordPut Fis,Id
Return
 
' @brief Rotina para criacao de um Conjunto Fuzzy, associado a uma Variavel Fuzzy
' 
' @param Nome <string> - Rótulo do Conjunto
' @param Variavel <int> - Referência para a Variável Fuzzy
' @param P1 <float> - Ponto  Um, dos quatro potos característicos que definem a função
' @param P2 <float> - Ponto Dois
' @param P3 <float> - Ponto Três
' @param P4 <float> - Ponto Quatro
'
' @return Id <int> - Identificador do conjunto Fuzzy  
Sub InsertFuzzySet(Nome, Variavel, P1, P2, P3, P4)
    call NewFuzzySet(Nome, Variavel, P1, P2, P3, P4)
    Id = NewFuzzySet__Result
    
    call GetFinalSet(Variavel, Anterior)       
    if vType(Anterior) <> 0 
       call SetNext(Anterior, Id)
    endif

    call UpdateSets(Variavel, Id)          
    call UpdateLimits(Variavel, P1, P4)
Return Id

' @brief Rotina para criação de variável de entrada Fuzzy
'
' @param Nome <mixed> - Rótulo da Variável
' @return Id <int> - Identificador da Variável
Sub NewInputVar(Nome)
    Nome = toString(Nome) 

    Tipo = _ENTRADA
    Id = _ID
    _ID += 1
    
    RecordPut Fis,Id
Return Id

' @brief Rotina para criação de variável de saída Fuzzy
'     
' @param Nome <string> - Rótulo da Variável
' @return Id <int> - Identificador da Variável
Sub NewOutputVar(Nome)
    Nome = toString(Nome)
    Tipo = _SAIDA     
    Id = _ID
    _ID += 1
    
    RecordPut Fis,Id
    call NewIO(Id)                                                               
Return Id 

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

Sub CalculateFactor(Var)
    Factor = .0
    call GetInfLimit(Var, LimInf)
    call GetSupLimit(Var, LimSup)

    Factor = 1.0*(LimSup-LimInf)/(_NUM_DISCRET-1)
Return Factor

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
