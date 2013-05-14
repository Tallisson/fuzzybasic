' @brief Label para inicialização  
InitializationSet:
    _ID_SET = 1
Return

' @brief Sub-rotina responsável por criar o Pseudo-objeto Set que irá manter os Conjuntos Fuzzy
Sub CreateSets(QtdSets)
    Dim Set[QtdSets, 7]
    
    Set[0,0] = "Variavel"
    Set[0,1] = "P1"
    Set[0,2] = "P2"
    Set[0,3] = "P3"
    Set[0,4] = "P4"
    Set[0,5] = "Proximo"
    Set[0,6] = "Pertinencia"
Return
 
' @brief Sub-rotina para inserir referência p/ próximo conjunto fuzzy relacionado a uma determinada
' variável linguística
'
' @param Id <int> - Identificador do Conjunto
' @param Set <int> - Referência para próximo conjunto
Sub SetNext(Id, Set)
    RecordGet Set,Id
    Proximo = Set
    RecordPut Set,Id
Return

' @brief Sub-rotina reposável por inserir um novo Fuzzy Set
' 
' @param Variavel <int> Referencia para a Variavel fuzzy ao qual o Fuzzy Set está associado
' @param P1 <float> - Primeiro ponto característico do Fuzzy Set
' @param P2 <float> - Primeiro ponto característico 
' @param P3 <float> - Terceiro ponto característico 
' @param P4 <float> - Quarto ponto característico
Sub NewFuzzySet(Variavel, P1, P2, P3, P4)
    Id = _ID_SET
    _ID_SET += 1
    
    RecordPut Set,Id     
Return Id

' @brief Sub-rotina para retornar a variável linguística associada ao Fuzzy Set
'
' @param Variavel inout <int>  -  Variavel que referencia a variável linguística associada ao Conjunto
Sub GetVar(Id, &Variavel)
    RecordGet Set,Id
Return

' @brief Sub-rotina para retornar os pontos característicos do conjunto
'
' @param P1 inout <float> - Primeiro ponto característico do Fuzzy Set
' @param P2 inout <float> - Primeiro ponto característico 
' @param P3 inout <float> - Terceiro ponto característico 
' @param P4 inout <float> - Quarto ponto característico
Sub GetCoords(Id, &P1, &P2, &P3, &P4)
    RecordGet Set,Id
return

' @brief Sub-rotina para retornar a referência p/ próximo conjunto fuzzy
'
' @param Proximo inout <String>  -  Variavel que referência o próximo conjunto
Sub GetNext(Id, &Proximo)        
    RecordGet Set,Id
Return

' @brief Sub-rotina para retornar a referência próximo conjunto fuzzy
'
' @param Proximo inout <String>  -  Variavel que referencia o próximo conjunto
Sub GetMembership(Id, &Pertinencia)
    RecordGet Set,Id
Return                                             

' @brief Rotina para retornar todas as informações associadas ao Conjunto Fuzzy
'
' @param Id <int> - Valor indicando o bloco de dado onde está o registro do Conjunto
' @param Variavel inout <int> - Variavel que referencia o Tipo da variável associada ao Conjunto
' @param P1 <float> - Primeiro ponto característico do Fuzzy Set
' @param P2 <float> - Primeiro ponto característico 
' @param P3 <float> - Terceiro ponto característico 
' @param P4 <float> - Quarto ponto característico
' @param Proximo inout <int> - Variavel que referencia o Próximo Conjunto
Sub GetFuzzySet(Id, &Variavel, &P1, &P2, &P3, &P4, &Proximo)
    RecordGet Set,Id     
Return

' @brief Sub-rotina Responsável por retornar primeiro ponto característico
' 
' @brief Id <int> - Valor indicando o bloco de dado onde está o registro do Conjunto
' @brief P1 inout <float> - Primeiro ponto característico do Fuzzy Set 
Sub GetP1(Id, &P1)
    RecordGet Set,Id
    P1 *= 1.0
Return

' @brief Sub-rotina Responsável por retornar primeiro ponto característico
' 
' @brief Id <int> - Valor indicando o bloco de dado onde está o registro do Conjunto
' @param P4 <float> - Quarto ponto característico
Sub GetP4(Id, &P4)
    RecordGet Set,Id
    P4 *= 1.0
Return

' @brief Sub-rotina Responsável por Calcular o Valor Fuzzy para uma Entra Crisp
'
' @param Set <int> - Referência para o Conjunto Fuzzy
' @param CrispValue <float> - Valor Crisp
' @return Membership <float> - Valor Fuzzy para uma dada entrada
Sub CalcFuzzyValue(Set, CrispValue)
    call GetCoords(Set, P1, P2, P3, P4)    
    
    Membership = .0
    if(CrispValue > P1 AND CrispValue < P2)
        Membership = 1.0*(CrispValue-P1)/(P2-P1)
    elseif(CrispValue >= P2 AND CrispValue <= P3)
        Membership = 1.0
    elseif(CrispValue > P3 AND CrispValue < P4)
        Membership = 1.0*(P4-CrispValue)/(P4-P3)
    endif
Return Membership

' @brief Sub-rotina Responsável por Setar o Valor da Pertinencia de uma Entrada Crisp para um determinado
' Conjunyto Fuzzy
' @param Id <int> - Referência para o Conjunto Fuzzy
Sub SetMembership(Id, Membership)
    RecordGet Set,Id
    Pertinencia = Membership
    RecordPut Set,Id
Return

' @brief Sub-rotina Responsável por Resetar a pertinência dos Conjuntos Fuzzy
Sub CleanMembershipSets()
    for i = 1 to (_ID_SET-1)
        call SetMembership(i, .0)
    next
Return
