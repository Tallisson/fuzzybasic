InitializationSet:
    _ID_SET = 1
Return

Sub CreateSets(QtdSets)
    Dim Set[QtdSets, 5]
    
    Set[0,0] = "Nome"
    Set[0,1] = "Variavel"
    Set[0,2] = "Coord"
    Set[0,3] = "Proximo"
    Set[0,4] = "Pertinencia"
Return
 
' @brief Função auxiliar a CreateSetFuzzy, responsável por atualizar campos ConjuntoInicial
' e ConjuntoFinal Fis.
'
' @param Id <int> - Identificador do Conjunto
' @param Proximo <int> - Apontador para próximo conjunto
Sub SetNext(Id, Set)
    RecordGet Set,Id
    Proximo = Set
    RecordPut Set,Id
Return

Sub NewFuzzySet(Nome, Variavel, P1, P2, P3, P4)
    Nome = toString(Nome)
    Coord = toString(P1)+_SEPARATOR+toString(P2)+_SEPARATOR+toString(P3)+_SEPARATOR+toString(P4)
    Id = _ID_SET
    _ID_SET += 1
    
    RecordPut Set,Id     
Return Id

' @brief Rotina para retornar todas as informações associadas ao Conjunto Fuzzy
'
' @param Id <int> - Indice indicando o bloco de dado onde onde está o registro do Conjunto
' @param Nome inout <string> - Variavel que referencia o nome da conjunto
' @param Variavel inout <int> - Variavel que referencia o Tipo da variável associada ao Conjunto
' @param Coord inout <string> - Variavel que referencia as Coordenadas do Conjunto
Sub GetNome(Id, &Nome)
    RecordGet Set,Id
Return

Sub GetVar(Id, &Variavel)
    RecordGet Set,Id
Return

Sub GetCoords(Id, &Coord)
    RecordGet Set,Id
return

Sub GetNext(Id, &Proximo)        
    RecordGet Set,Id
Return

Sub GetMembership(Id, &Pertinencia)
    RecordGet Set,Id
Return

Sub GetFuzzySet(Id, &Nome, &Variavel, &Coord, &Proximo)
    RecordGet Set,Id     
Return

Sub GetP1(Id, &P1)
    call GetCoords(Id, Coords)
    P1 = 1.0*toNumber(Extract(Coords, _SEPARATOR, 1))
Return

Sub GetP4(Id, &P4)
    call GetCoords(Id, Coords)
    P4 = 1.0*toNumber(Extract(Coords, _SEPARATOR, 4))
Return

Sub CalcFuzzyValue(Set, CrispValue)
    call GetCoords(Set, Coords)    
    mFromString aux,Coords,_SEPARATOR
    
    membership = .0
    if(CrispValue > aux[0] AND CrispValue < aux[1])
        membership = 1.0*(CrispValue-aux[0])/(aux[1]-aux[0])
    elseif(CrispValue >= aux[1] AND CrispValue <= aux[2])
        membership = 1.0
    elseif(CrispValue > aux[2] AND CrispValue < aux[3])
        membership = 1.0*(aux[3]-CrispValue)/(aux[3]-aux[2])
    endif
Return membership

Sub SetMembership(Id, Membership)
    RecordGet Set,Id
    Pertinencia = Membership
    RecordPut Set,Id
Return

Sub CleanMembershipSets()
    for i = 1 to (_ID_SET-1)
        call SetMembership(i, .0)
    next
Return
