-- 1. Quantos chamados foram abertos no dia 01/04/2023?
SELECT COUNT(*) 
FROM `datario.administracao_servicos_publicos.chamado_1746` 
WHERE DATE(data_inicio) = DATE("2023-04-01");

-- 2. Qual o tipo de chamado que teve mais reclamações no dia 01/04/2023?
SELECT tipo
FROM `datario.administracao_servicos_publicos.chamado_1746`
WHERE DATE(data_inicio) = DATE("2023-04-01")
GROUP BY tipo
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 3. Quais os nomes dos 3 bairros que mais tiveram chamados abertos nesse dia?
SELECT nome bairro, COUNT(*) quantidade
FROM `datario.administracao_servicos_publicos.chamado_1746` tb_a
JOIN `datario.dados_mestres.bairro` tb_b ON tb_a.id_bairro = tb_b.id_bairro 
WHERE DATE(data_inicio) = DATE("2023-04-01") 
GROUP BY nome
ORDER BY quantidade DESC
LIMIT 3;

-- 4. Qual o nome da subprefeitura com mais chamados abertos nesse dia?
SELECT subprefeitura, COUNT(*) quantidade
FROM `datario.administracao_servicos_publicos.chamado_1746` tb_a
JOIN `datario.dados_mestres.bairro` tb_b ON tb_a.id_bairro = tb_b.id_bairro 
WHERE DATE(data_inicio) = DATE("2023-04-01") 
GROUP BY subprefeitura
ORDER BY quantidade DESC
LIMIT 1;

-- 5. Existe algum chamado aberto nesse dia que não foi associado a um bairro ou subprefeitura na tabela de bairros? Se sim, por que isso acontece?
SELECT COUNT(*) AS total_chamados,
       COUNT(tb_a.id_bairro) AS chamados_com_bairro,
       COUNT(tb_b.subprefeitura) AS chamados_com_subprefeitura
FROM `datario.administracao_servicos_publicos.chamado_1746` tb_a
LEFT JOIN `datario.dados_mestres.bairro` tb_b ON tb_a.id_bairro = tb_b.id_bairro 
WHERE DATE(tb_a.data_inicio) = DATE("2023-04-01");
-- RESPOSTA: Sim, há um chamado que não foi associado a um bairro e nem a uma subprefeitura neste dia.
-- id_chamado = 18516246, realizado pela SMTR - Secretaria Municipal de Transportes este chamado é da categoria
-- serviço, tipo = Ônibus e subtipo = Verificação de ar condicionado inoperante no ônibus.
-- Isto ocorre por que a natureza do chamado (chamados internos) podem envolver atividades ou processos que não estão diretamente relacionados a uma localização geográfica específica. Por exemplo, um chamado para manutenção de equipamentos internos, treinamento de funcionários ou gerenciamento de projetos pode ser tratado internamente pelo departamento responsável e não exigir uma associação a uma localidade.
SELECT *
FROM `datario.administracao_servicos_publicos.chamado_1746` AS tb_a
LEFT JOIN `datario.dados_mestres.bairro` AS tb_b ON tb_a.id_bairro = tb_b.id_bairro
WHERE DATE(tb_a.data_inicio) = DATE('2023-04-01')
AND (tb_b.id_bairro IS NULL OR tb_b.subprefeitura IS NULL)
LIMIT 1;

SELECT COUNT(*) quantidade, categoria
FROM `datario.administracao_servicos_publicos.chamado_1746` tb_a
JOIN `datario.dados_mestres.bairro` tb_b ON tb_a.id_bairro = tb_b.id_bairro 
WHERE DATE(data_inicio) = DATE("2023-04-01")
--AND (tb_b.id_bairro IS NULL OR tb_b.subprefeitura IS NULL) 
GROUP BY categoria
ORDER BY quantidade DESC;
--LIMIT 3;

select count(*) qtde, tipo
FROM `datario.administracao_servicos_publicos.chamado_1746` tb_a
WHERE DATE(data_inicio) = DATE("2023-04-01")
group by tipo
ORDER BY qtde DESC;