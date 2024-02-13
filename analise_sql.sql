--Quantos chamados foram abertos no dia 01/04/2023?
SELECT COUNT(*) 
FROM `datario.administracao_servicos_publicos.chamado_1746` 
WHERE data_inicio >= "2023-04-01" AND data_inicio < "2023-04-02";

--Qual o tipo de chamado que teve mais reclamações no dia 01/04/2023?

--Quais os nomes dos 3 bairros que mais tiveram chamados abertos nesse dia?

--Qual o nome da subprefeitura com mais chamados abertos nesse dia?

--Existe algum chamado aberto nesse dia que não foi associado a um bairro ou subprefeitura na tabela de bairros? Se sim, por que isso acontece?
