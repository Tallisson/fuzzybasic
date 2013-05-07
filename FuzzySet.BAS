InitializationSet:
    ID_SET = 1
Return

Sub CreateSets(QtdSets)
    Dim Set[QtdSets, 5]
    
    Set[0,0] = "Nome"
    Set[0,1] = "Variavel"
    Set[0,2] = "Coord"
    Set[0,3] = "Proximo"
    Set[0,4] = "Pertinencia"
Return
 
' @brief Fun��o auxiliar a CreateSetFuzzy, respons�vel por atualizar campos ConjuntoInicial
' e ConjuntoFinal Fis.
'
' @param Id <int> - Identificador do Conjunto
' @param Proximo <int> - Apontador para pr�ximo conjunto
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

' @brief Rotina para retornar todas as informa��es associadas ao Conjunto Fuzzy
'
' @param Id <int> - Indice indicando o bloco de dado onde onde est� o registro do Conjunto
' @param Nome inout <string> - Variavel que referencia o nome da conjunto
' @param Variavel inout <int> - Variavel que referencia o Tipo da vari�vel associada ao Conjunto
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

Sub GetFuzzySet(Id, &Nome, &Variavel, &Coord, &Proximo)
    RecordGet Set,Id     
Return