#include "FuzzySet.bas"
#include "FuzzyRules.bas"

InitializationFis:     
     _ENTRADA = 0
     _SAIDA = 1
     _ID = 1
     _SEPARATOR = ":" 
     
     GoSub InitializationSet
     GoSub InitializationRule      
Return     
               
' @brief Rotina para criação do Sistema de Inferência Fuzzy, 
' inicializa estrutura para manter as variáveis e os conjuntos fuzzy.
'
' @param QtdVars <int> - Número de Variaveis Fuzzy
' @param QtdSets <int> - Número de Conjuntos Fuzzy
' @param QtdSets <int> - Número de Regras Fuzzy         
Sub CreateFis(QtdVars, QtdSets, QtdRules)
    Dim Fis[QtdVars+1, 4]
    
    Fis[0,0] = "Nome"
    Fis[0,1] = "Tipo"
    Fis[0,2] = "ConjuntoInicial"
    Fis[0,3] = "ConjuntoFinal"   
    
    call CreateSets(QtdSets+1)
    call CreateRules(QtdRules+1)
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
Sub GetFuzzyVar(Id, &Nome, &Tipo, &ConjuntoInicial, &ConjuntoFinal)
    RecordGet Fis,Id
Return

Sub UpdateSets(Id, Set)
    call GetFinalSet(Id, FinalSet)
    
    if !vType(FinalSet)
         call UpdateInitialSet(Id, Set)
    endif
    call UpdateFinalSet(Id, Set)
    
    RecordGet Fis,Id
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

Sub EvaluateFis()
    i = 0
    while i < maxDim(FuzzyInputs)-1
        call Fuzzify(FuzzyInputs[i], FuzzyInputs[i+1])
        i += 2
    wend

    call EvaluateRules()
    
    dim FuzzyInputs[0]
Return
