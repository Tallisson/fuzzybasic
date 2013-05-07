#include "FuzzySet.bas"
#include "FuzzyRules.bas"
 
InitializationFis:
     ENTRADA = 0
     SAIDA = 1
     ID = 1
     SEPARATOR = ":"
     print ENTRADA
     GoSub InitializationSet
     GoSub InitializationRule      
Return     
               
' @brief Rotina para cria��o do Sistema de Infer�ncia Fuzzy, 
' inicializa estrutura para manter as vari�veis e os conjuntos fuzzy.
'
' @param QtdVars <int> - N�mero de Variaveis Fuzzy
' @param QtdSets <int> - N�mero de Conjuntos Fuzzy
' @param QtdSets <int> - N�mero de Regras Fuzzy         
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

' @brief Rotina para retornar todas as informa��es associadas a uma variavel fuzzy
'
' @param Id <int> - Indice indicando o bloco de dado onde onde est� o registro da variavel
' @param Nome out <string> - Variavel que referencia o nome da vari�vel
' @param Tipo out <int> - Variavel que referencia o Tipo da vari�vel
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
' @param Nome <string> - R�tulo do Conjunto
' @param Variavel <int> - Refer�ncia para a Vari�vel Fuzzy
' @param P1 <float> - Ponto  Um, dos quatro potos caracter�sticos que definem a fun��o
' @param P2 <float> - Ponto Dois
' @param P3 <float> - Ponto Tr�s
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

' @brief Rotina para cria��o de vari�vel de entrada Fuzzy
'
' @param Nome <mixed> - R�tulo da Vari�vel
' @return Id <int> - Identificador da Vari�vel
Sub NewInputVar(Nome)
    Nome = toString(Nome) 
    print 
    Tipo = _ENTRADA
    Id = _ID
    _ID += 1
    
    RecordPut Fis,Id
Return Id

' @brief Rotina para cria��o de vari�vel de sa�da Fuzzy
'     
' @param Nome <string> - R�tulo da Vari�vel
' @return Id <int> - Identificador da Vari�vel
Sub NewOutputVar(Nome)
    Nome = toString(Nome)
    Tipo = _SAIDA     
    Id = _ID
    _ID += 1
    
    RecordPut Fis,Id                                                               
Return Id 