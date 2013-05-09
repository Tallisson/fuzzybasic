#include "Fis.bas"

Main:
     call Teste()
End

Sub Teste()
     GoSub InitializationFis      
     call CreateFis(4, 16, 12)

     ' Criando variaveis linguisticas
     call NewInputVar("Temperatura")
     temperatura = NewInputVar__Result      
     
     call NewInputVar("Umidade")
     umidade = NewInputVar__Result
     
     call NewInputVar("Volume")
     volume = NewInputVar__Result
     
     call NewOutputVar("Pressao")
     pressao = NewOutputVar__Result
     
    ' Criando conjuntos fuzzy e associando-os as variaveis      
     call InsertFuzzySet("Baixa", temperatura, 10, 20, 30, 40)
     tempBaixa = InsertFuzzySet__Result
     
     call InsertFuzzySet("Baixa", umidade, 10, 25, 30, 40)  
     umidBaixa = InsertFuzzySet__Result
     
     call InsertFuzzySet("Baixo", volume, 12.5, 14, 14.5, 16)
     volBaixo = InsertFuzzySet__Result
     
     call InsertFuzzySet("Baixa", pressao, 15, 20, 25, 30)
     pressaoBaixa = InsertFuzzySet__Result
     
     call InsertFuzzySet("Media", temperatura, 20, 30, 40, 50)
     tempMedia = InsertFuzzySet__Result
     
     call InsertFuzzySet("Media", umidade, 25, 30, 40, 45)   
     umidMedia = InsertFuzzySet__Result
     
     call InsertFuzzySet("Medio", volume, 14, 14.5, 16, 17)
     volMedio = InsertFuzzySet__Result 
     
     call InsertFuzzySet("Media", pressao, 20, 25, 30, 35) 
     pressaoMedia = InsertFuzzySet__Result     
     
     call InsertFuzzySet("Alta", temperatura, 30, 40, 50, 60)
     tempAlta = InsertFuzzySet__Result
     
     call InsertFuzzySet("Alta", umidade, 30, 40, 45, 50)   
     umidAlta = InsertFuzzySet__Result
     
     call InsertFuzzySet("Alto", volume, 16, 16.5, 17, 17.5)
     volAlto = InsertFuzzySet__Result     
     
     call InsertFuzzySet("Alta", pressao, 25, 30, 35, 40)
     pressaoAlta = InsertFuzzySet__Result       
      
     'for i = 1 to 4
     '    call GetFuzzyVar(i, Nome, Tipo, Inicio, Fim)     
     '    print i;Nome;Inicio;Fim
     'next
     
     'for i = 1 to 12
     '    call GetFuzzySet(i, Nome, Variavel, Coord, Proximo)
     '    print i;Nome;Variavel;Coord;
     '    if vType(Proximo) <> 0
     '       print "/"+Proximo
     '    else 
     '         print crlf()
     '    endif
     'next
     
     ' Criando Regras Fuzzy
     call NewRule()
     r1 = NewRule__Result
     
     call NewRule()
     r2 = NewRule__Result
     
     call NewRule()
     r3 = NewRule__Result

     ' Associando os Antecedentes e os Consequentes      
     call AddConsequent(r1, pressaoAlta)
     call JoinSingleAnd(r1, volAlto)
     call GetRule(r1, Antecedente, Consequente, Ativacao) 
     'print "Rule";r1;Antecedente;Consequente
     
     call AddWithAnd(r1, tempAlta, umidAlta)
     call AddConsequent(r1, pressaoAlta)
     call JoinSingleOr(r1, volAlto)
     call GetRule(r1, Antecedente, Consequente, Ativacao1)       
     'print "Rule";r1;Antecedente;Consequente
     
     call AddWithOr(r2, tempAlta, umidAlta)
     call AddConsequent(r2, pressaoAlta) 
     call GetRule(r2, Antecedente, Consequente, Ativacao2) 
     'print "Rule";r2;Antecedente;Consequente
     
     call AddWithAnd(r3, tempBaixa, umidBaixa)
     call AddConsequent(r3, pressaoBaixa)
     call GetRule(r3, Antecedente, Consequente, Ativacao3) 
     'print "Rule";r3;Antecedente;Consequente
    
     data AntecedentSets;tempAlta,umidAlta,volAlto     
     call AddMultiplesAnd(r2)
     call GetRule(r2, Antecedente, Consequente, Ativacao4) 
     'print "Rule";r2;Antecedente;Consequente
     
     data AntecedentSets;tempBaixa,umidBaixa,volBaixo
     call AddMultiplesAnd(r3)
     call GetRule(r3, Antecedente, Consequente, Ativacao5) 
     'print "Rule";r3;Antecedente;Consequente
     
     data AntecedentSets;tempMedia,umidMedia,volMedio
     call AddMultiplesOr(r1)
     call AddConsequent(r1, pressaoMedia)
     call GetRule(r1, Antecedente, Consequente, Ativacao6) 
     'print "Rule";r1;Antecedente;Consequente
     
     data AntecedentSets;tempBaixa,umidBaixa,volBaixo
     call JoinMultiplesAnd(r1)
     call AddConsequent(r1, pressaoBaixa)
     call GetRule(r1, Antecedente, Consequente, Ativacao7) 
     'print "Rule";r1;Antecedente;Consequente
     
     data AntecedentSets;tempMedia,umidMedia,volMedio
     call JoinMultiplesOr(r2)
     call AddConsequent(r2, pressaoBaixa)
     call GetRule(r2, Antecedente, Consequente, Ativacao8) 
     'print "Rule";r2;Antecedente;Consequente

     data FuzzyInputs;temperatura,27,umidade,27.5,volume,16
     call EvaluateFis()       
     
Return

