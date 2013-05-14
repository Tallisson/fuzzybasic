' @brief Label para Inicialização
InitializationRule:
     _ID_RULE = 1
     _OP_AND = "AND"
     _OP_OR = "OR"
Return

' @brief Sub-rotina responsável por definir o pseudo-objeto que irá manter os Conjuntos Fuzzy
' 
' @param Qtd <int> - Quantidade de Regras a serem definidas
Sub CreateRules(QtdRules)
    Dim Rules[QtdRules, 3] 
    
    Rules[0,0] = "Antecedente"
    Rules[0,1] = "Consequente"
    Rules[0,2] = "GrauAtivacao"
Return

' @brief Sub-rotina responsável por criar um novo Conjunto Fuzzy
'
' @return Id <int> - Referência para a Regra Fuzzy criada      
Sub NewRule()
    Id = _ID_RULE
    _ID_RULE += 1 
Return Id

' @brief Sub-rotina responsável por adicionar um Único Conjunto ao antecedente da Regra Fuzzy
'
' @param Id <int> - Referência para a Regra Fuzzy
' @param Set <int> - Conjunto a ser atribuído
Sub AddSingle(Id, Set)
    RecordGet Rules,Id 
    Antecedente = ToString(Set)
    RecordPut Rules,Id
Return

' @brief Sub-rotina responsável por adicionar dois Conjuntos ao antecedente da Regra Fuzzy relacionados
' atraves do operador AND
'
' @param Id <int> - Referência para a Regra Fuzzy
' @param Set1 <int> - Conjunto um a ser atribuído ao antecedente da Regra Fuzzy
' @param Set1 <int> - Conjunto dois a ser atribuído ao antecedente da Regra Fuzzy
Sub AddWithAnd(Id, Set1, Set2)
    RecordGet Rules,Id
    Antecedente = ToString(Set1)+" "+ToString(Set2)+" "+_OP_AND
    RecordPut Rules,Id
Return

' @brief Sub-rotina responsável por atribuir dois Conjuntos ao antecedente da Regra Fuzzy relacionados
' através do operador OR
'
' @param Id <int> - Referência para a Regra Fuzzy 
' @param Set1 <int> - Conjunto um a ser atribuído ao antecedente da Regra Fuzzy
' @param Set1 <int> - Conjunto dois a ser atribuído ao antecedente da Regra Fuzzy
Sub AddWithOr(Id, Set1, Set2)
    RecordGet Rules,Id
    Antecedente = ToString(Set1)+" "+ToString(Set2)+" "+_OP_OR
    RecordPut Rules,Id 
Return

' @brief Sub-rotina responsável por adicionar um Conjunto ao antecedente da Regra Fuzzy relacionando-o
' aos demais através do operador AND
' 
' @param Id <int> - Referência para a Regra Fuzzy 
' @param Set <int> - Conjunto a ser adicionado
Sub JoinSingleAnd(Id, Set)
    RecordGet Rules,Id
    
    if (vType(Antecedente) <> 0 AND vType(Antecedente) <> 48)     
         Antecedente += " "+toString(Set)+" "+_OP_AND
    else
        Antecedente = toString(Set)         
    endif

    RecordPut Rules,Id
Return

' @brief Sub-rotina responsável por adicionar dois Conjuntos ao antecedente da Regra Fuzzy relacionando-o
' aos demais através do operador OR
'
' @param Id <int> - Referência para a Regra Fuzzy 
' @param Set <int> - Conjunto a ser adicionado
Sub JoinSingleOr(Id, Set)
    RecordGet Rules,Id
    
    if (vType(Antecedente) <> 0 AND vType(Antecedente) <> 48)         
        Antecedente += " "+toString(Set)+" "+_OP_OR
    else
        Antecedente = toString(Set)
    endif
    
    RecordPut Rules,Id
Return

' @brief Sub-rotina auxiliar as sub-rotinas que adicionam Múltiplos antecedentes
' 
' @param Operator <string> - Indicativo para o operador que relaciona os conjuntos do antecedente
' @param Flag <boolean> - Booleano indicando para concatenar o antecedente já existente com os valores 
' passados
' @return Out <string> - Antecedente atual
Sub BuildRule(Operator, Flag)
    Out = ""

    Size = maxDim(AntecedentSets,1) 
    for i=0 to Size-1
         if (i+1)==2 then Flag = True
         Out += toString(AntecedentSets[i])+" "
         if Flag AND (Size > 1)
            Out += (Operator+" ")
         endif
    next
    Dim AntecedentSets[0]
Return Out

' @brief Sub-rotina para inserir multiplos antecedentes relaiconados através do operador AND
' 
' @param Id <int> - Referência para a Regra Fuzzy 
Sub AddMultiplesAnd(Id)
    RecordGet Rules,Id
    call BuildRule(_OP_AND, False)           
    Antecedente = BuildRule__Result     
    RecordPut Rules,Id
Return

' @brief Sub-rotina para adicionar multiplos antecedentes relaiconados através do operador AND
'
' @param Id <int> - Referência para a Regra Fuzzy 
Sub JoinMultiplesAnd(Id)
    RecordGet Rules,Id
    
    condition = (vType(Antecedente) <> 0 AND vType(Antecedente) <> 48)         
    call BuildRule(_OP_AND, condition)    
    if condition
       Antecedente += BuildRule__Result
    else
       Antecedente = BuildRule__Result          
    endif
    
    RecordPut Rules,Id
Return

' @brief Sub-rotina para inserir multiplos antecedentes relaiconados através do operador OR
' 
' @param Id <int> - Referência para a Regra Fuzzy 
Sub AddMultiplesOr(Id)
    RecordGet Rules,Id
    call BuildRule(_OP_OR, False)
    Antecedente = BuildRule__Result          
    RecordPut Rules,Id
Return

' @brief Sub-rotina para adicionar multiplos antecedentes relaiconados através do operador AND
'
' @param Id <int> - Referência para a Regra Fuzzy 
Sub JoinMultiplesOr(Id)
    RecordGet Rules,Id
    
    condition = (vType(Antecedente) <> 0 AND vType(Antecedente) <> 48)
    call BuildRule(_OP_OR, condition)    
    if condition     
       Antecedente += BuildRule__Result          
    else
       Antecedente = BuildRule__Result
    endif
    
    RecordPut Rules,Id
Return

' @brief Sub-rotina para atribuir o consequente
'
' @param Id <int> - Referência para a Regra Fuzzy 
' @param Set <int> - Referência para o Conjunto Fuzzy que irá compor o Consequente
Sub AddConsequent(Id, Set)
    RecordGet Rules,Id          
    Consequente = Set
    RecordPut Rules,Id
Return

' @brief Sub-rotina para obter o Antecedente
'
' @param Id <int> - Referência para a Regra Fuzzy 
' @param Antecedente out <int> - Conjuntos Fuzzy que compõem o Antecedente
Sub GetAntecedent(Id, &Antecedente)
    RecordGet Rules,Id
Return

' @brief Sub-rotina para obter o Consequente
'
' @param Id <int> - Referência para a Regra Fuzzy 
' @param Consequente out <int> - Conjunto Fuzzy que compõem o Consequente
Sub GetConsequent(Id, &Consequente)
    RecordGet Rules,Id
Return                 

' @brief Sub-rotina para obter o Grau de Ativação da Regra Fuzzy
' 
' @param Id <int> - Referência para a Regra Fuzzy 
' @param GrauAtivacao out <int> - Grau de Ativação da Regra
Sub GetFire(Id, &GrauAtivacao)
    RecordGet Rules,Id
Return

' @brief Sub-rotina para obter a descrição completa da Regra Fuzzy
'
' @param Id <int> - Referência para a Regra Fuzzy
' @param Antecedente out <int> - Conjuntos Fuzzy que compõem o Antecedente
' @param Consequente out <int> - Conjunto Fuzzy que compõem o Consequente 
' @param GrauAtivacao out <int> - Grau de Ativação da Regra 
Sub GetRule(Id, &Antecedente, &Consequente, &GrauAtivacao) 
    RecordGet Rules,Id
Return

' @brief Sub-rotina auxiliar a Sub-rotina de avaliacao da Regras Fuzzy, inferindo o grau de ativação
' da Regra
' 
' @return Fire <float> - Grau de Ativação da Regra
Sub IsFired()
    call GetMembership(Stack[0], Fire)
    Op = .0
    for i = 1 to maxDim(Stack)-1
        if isNumber(Stack[i])
           call GetMembership(Stack[i], Op)
        elseif Stack[i] == _OP_AND 
           Fire = 1.0*MinV(Op, Fire)   
        elseif Stack[i] == _OP_OR
           Fire = 1.0*MaxV(Op, Fire)
        endif
    next      
Return Fire

' @brief Sub-rotina para avaliar as Regras Fuzzy
Sub EvaluateRules()
    for i = 1 to (_ID_RULE-1)
        call GetAntecedent(i, Antecedent)
        
        mFromString Stack,Antecedent," "         
        call IsFired()
        Fire = IsFired__Result         
        call SetFired(i, Fire)          
 
        call GetConsequent(i, Consequent)
        call GetMembership(Consequent, Membership)
        if(vType(Membership) == 0 OR vType(Membership) == 48)                
             call SetMembership(Consequent, Fire)
        elseif(Fire > Membership)
             call SetMembership(Consequent, Fire)
        endif
    next
Return

' @brief Sub-rotina para Setar o Grau de Ativação de um Conjunto Fuzzy
' 
' @param Id <int> - Referência para a Regra Fuzzy 
' @param Fired <float> - Valor do Grau de Ativação
Sub SetFired(Id, Fired)
    RecordGet Rules,Id
    GrauAtivacao = Fired
    RecordPut Rules,Id
Return

' @brief Sub-rotina responsável por resetar Regras Fuzzy
Sub CleanFireRules()
    for i = 1 to (_ID_RULE-1)
        call SetFired(i, .0)
    next
Return
