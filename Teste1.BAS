#include "Fis.bas"

Main:
     call Teste()
End
Sub Teste()
    GoSub InitializationFis      
    call CreateFis(2, 1, 9, 12)  
    
    ' Criando variaveis linguisticas
    call NewInputVar("Temperatura")
    temperatura = NewInputVar__Result
    
    call NewInputVar("Pressao")  
    pressao = NewInputVar__Result
    
    call NewOutputVar("Volume")
    volume = NewOutputVar__Result
    
    ' Criando conjuntos para variavel Temperatura
    call InsertFuzzySet("Baixa", temperatura, 100, 100, 200, 300)
    TempBaixa = InsertFuzzySet__Result
    
    call InsertFuzzySet("Media", temperatura, 200, 300, 300, 400)
    TempMedia = InsertFuzzySet__Result
    
    call InsertFuzzySet("Alta", temperatura, 300, 400, 500, 500)
    TempAlta = InsertFuzzySet__Result
    
    ' Criando conjuntos para variavel Umidade
    call InsertFuzzySet("Pequena", pressao, 2, 2, 3, 6)
    PressaoPequena = InsertFuzzySet__Result
    
    call InsertFuzzySet("Media", pressao, 3, 6, 6, 9)
    PressaoMedia = InsertFuzzySet__Result
    
    call InsertFuzzySet("Alta", pressao, 6, 9, 10, 10)
    PressaoAlta = InsertFuzzySet__Result
    
    ' Criando conjuntos para variavel Volume
    call InsertFuzzySet("Baixo",volume, 4, 4, 6, 8)
    VolBaixo = InsertFuzzySet__Result
    
    call InsertFuzzySet("Medio", volume, 6, 8, 8, 10) 
    VolMedio = InsertFuzzySet__Result
    
    call InsertFuzzySet("Alto", volume, 8, 10, 12, 12)
    VolAlto = InsertFuzzySet__Result
    
    ' Criando Regras Se Entao
    call NewRule()
    r1 = NewRule__Result
    
    data AntecedentSets;TempBaixa,PressaoPequena
    call AddMultiplesAnd(r1)
    call AddConsequent(r1, VolBaixo)
    
    call NewRule()
    r2 = NewRule__Result
    
    data AntecedentSets;TempMedia,PressaoPequena
    call AddMultiplesAnd(r2)
    call AddConsequent(r2, VolBaixo)
      
    call NewRule()
    r3 = NewRule__Result
    
    data AntecedentSets;TempAlta,PressaoPequena
    call AddMultiplesAnd(r3)
    call AddConsequent(r3, VolMedio)
    
    call NewRule()
    r4 = NewRule__Result
    
    data AntecedentSets;TempBaixa,PressaoMedia
    call AddMultiplesAnd(r4)
    call AddConsequent(r4, VolBaixo)
    
    call NewRule()
    r5 = NewRule__Result
    
    data AntecedentSets;TempMedia,PressaoMedia
    call AddMultiplesAnd(r5)
    call AddConsequent(r5, VolMedio)
    
    call NewRule()
    r6 = NewRule__Result
    
    data AntecedentSets;TempAlta,PressaoMedia
    call AddMultiplesAnd(r6)
    call AddConsequent(r6, VolAlto)
    
    call NewRule()
    r7 = NewRule__Result
    
    data AntecedentSets;TempBaixa,PressaoAlta
    call AddMultiplesAnd(r7)
    call AddConsequent(r7, VolMedio)
    
    call NewRule()
    r8 = NewRule__Result
    
    data AntecedentSets;TempMedia,PressaoAlta
    call AddMultiplesAnd(r8)
    call AddConsequent(r8, VolAlto)
    
    call NewRule()
    r9 = NewRule__Result
    
    data AntecedentSets;TempAlta,PressaoAlta
    call AddMultiplesAnd(r9)
    call AddConsequent(r9, VolAlto)

    data FuzzyInputs;temperatura,147.25,pressao,8.43
    call EvaluateFis()
    
    call GetOutput(pressao, saida)
    print saida
    
    data FuzzyInputs;temperatura,120.25,pressao,7.70
    call EvaluateFis()
    
    call GetOutput(pressao, saida)
    print saida
Return
