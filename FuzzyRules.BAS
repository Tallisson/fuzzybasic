InitializationRule:
     _ID_RULE = 1
     _OP_AND = "AND"
     _OP_OR = "OR"
Return

Sub CreateRules(QtdRules)
    Dim Rules[QtdRules, 3] 
    
    Rules[0,0] = "Antecedente"
    Rules[0,1] = "Consequente"
    Rules[0,2] = "GrauAtivacao"
Return

Sub NewRule()
    Id = _ID_RULE
    _ID_RULE += 1 
Return Id

Sub AddSingle(Id, Set)
    RecordGet Rules,Id 
    Antecedente = ToString(Set)
    RecordPut Rules,Id
Return

Sub AddWithAnd(Id, Set1, Set2)
    RecordGet Rules,Id
    Antecedente = ToString(Set1)+" "+ToString(Set2)+" "+_OP_AND
    RecordPut Rules,Id
Return

Sub AddWithOr(Id, Set1, Set2)
    RecordGet Rules,Id
    Antecedente = ToString(Set1)+" "+ToString(Set2)+" "+_OP_OR
    RecordPut Rules,Id 
Return

Sub JoinSingleAnd(Id, Set)
    RecordGet Rules,Id

    condition = (vType(Antecedente) <> 0 AND vType(Antecedente) <> 48)     
    if condition
         Antecedente += " "+toString(Set)+" "+_OP_AND
    else
        Antecedente = toString(Set)         
    endif

    RecordPut Rules,Id
Return

Sub JoinSingleOr(Id, Set)
    RecordGet Rules,Id
    
    condition = (vType(Antecedente) <> 0 AND vType(Antecedente) <> 48)         
    if condition
        Antecedente += " "+toString(Set)+" "+_OP_OR
    else
        Antecedente = toString(Set)
    endif
    
    RecordPut Rules,Id
Return

Sub BuildRule(Operator, flag)
    out = ""

    size = maxDim(AntecedentSets,1) 
    for i=0 to size-1
         if (i+1)==2 then flag = True
         out += toString(AntecedentSets[i])+" "
         if flag AND (size > 1)
            out += (Operator+" ")
         endif
    next
    Dim AntecedentSets[0]
Return out

Sub AddMultiplesAnd(Id)
    RecordGet Rules,Id
    call BuildRule(_OP_AND, False)           
    Antecedente = BuildRule__Result     
    RecordPut Rules,Id
Return

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

Sub AddMultiplesOr(Id)
    RecordGet Rules,Id
    call BuildRule(_OP_OR, False)
    Antecedente = BuildRule__Result          
    RecordPut Rules,Id
Return

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

Sub AddConsequent(Id, Set)
    RecordGet Rules,Id
    Consequente = Set
    RecordPut Rules,Id
Return

Sub GetAntecent(Id, &Antecedent)
    RecordGet Rules,Id
Return

Sub GetConsequent(Id, &Consequente)
    RecordGet Rules,Id
Return                 

Sub GetAtivacao(Id, &GrauAtivacao)
    RecordGet Rules,Id
Return

Sub GetRule(Id, &Antecedente, &Consequente, &GrauAtivacao) 
    RecordGet Rules,Id
Return
