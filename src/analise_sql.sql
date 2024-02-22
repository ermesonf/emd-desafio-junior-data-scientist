-- 1. Quantos chamados foram abertos no dia 01/04/2023?
SELECT COUNT(*) qtd_chamados
FROM `datario.administracao_servicos_publicos.chamado_1746` 
WHERE data_particao = "2023-04-01" and
DATE(data_inicio) = "2023-04-01";
-- RESPOSTA: 73 chamados.

-- 2. Qual o tipo de chamado que teve mais reclamações no dia 01/04/2023?
SELECT tb_a.tipo tipo, COUNT(*) qtd_chamados
FROM `datario.administracao_servicos_publicos.chamado_1746` tb_a
WHERE data_particao = "2023-04-01" AND DATE(data_inicio) = "2023-04-01"
GROUP BY tb_a.tipo
ORDER BY qtd_chamados DESC
LIMIT 1;
-- RESPOSTA: Poluição sonora, 24 chamados ou reclamações.

-- 3. Quais os nomes dos 3 bairros que mais tiveram chamados abertos nesse dia?
SELECT nome bairro, COUNT(*) quantidade
FROM `datario.administracao_servicos_publicos.chamado_1746` tb_a
JOIN `datario.dados_mestres.bairro` tb_b ON tb_a.id_bairro = tb_b.id_bairro 
WHERE data_particao = "2023-04-01" AND DATE(data_inicio) = "2023-04-01" 
GROUP BY nome
ORDER BY quantidade DESC
LIMIT 3;
-- RESPOSTA: Engenho de Dentro com 8 chamados, Campo Grande e Leblon com 6 chamados.

-- 4. Qual o nome da subprefeitura com mais chamados abertos nesse dia?
SELECT subprefeitura, COUNT(*) qtd_chamados
FROM `datario.administracao_servicos_publicos.chamado_1746` tb_a
JOIN `datario.dados_mestres.bairro` tb_b ON tb_a.id_bairro = tb_b.id_bairro 
WHERE data_particao = "2023-04-01" AND DATE(data_inicio) = "2023-04-01" 
GROUP BY subprefeitura
ORDER BY qtd_chamados DESC
LIMIT 1;
-- RESPOSTA: Zona Norte com 25 chamados.

-- 5. Existe algum chamado aberto nesse dia que não foi associado a um bairro ou subprefeitura na tabela de bairros? Se sim, por que isso acontece?
SELECT *
FROM `datario.administracao_servicos_publicos.chamado_1746` AS tb_a
LEFT JOIN `datario.dados_mestres.bairro` AS tb_b ON tb_a.id_bairro = tb_b.id_bairro
WHERE data_particao = "2023-04-01" AND DATE(tb_a.data_inicio) = "2023-04-01"
AND (tb_b.id_bairro IS NULL OR tb_b.subprefeitura IS NULL)
LIMIT 1;
/*RESPOSTA: Sim, há um chamado que não foi associado a um bairro e nem a uma subprefeitura neste dia. id_chamado = 18516246, realizado pela SMTR - Secretaria Municipal de Transportes este chamado é da categoria serviço, tipo = Ônibus e subtipo = Verificação de ar condicionado inoperante no ônibus.
Isto ocorre por que a natureza do chamado (chamados internos) podem envolver atividades ou processos que não estão diretamente relacionados a uma localização geográfica específica. Por exemplo, um chamado para manutenção de equipamentos internos, treinamento de funcionários ou gerenciamento de projetos pode ser tratado internamente pelo departamento responsável e não exigir uma associação a uma localidade.*/

-- 6. Quantos chamados com o subtipo "Perturbação do sossego" foram abertos desde 01/01/2022 até 31/12/2023 (incluindo extremidades)?
SELECT COUNT(*) qtd_chamados
FROM `datario.administracao_servicos_publicos.chamado_1746` tb_a
WHERE data_particao BETWEEN "2022-01-01" AND "2023-12-31"
AND tb_a.id_subtipo = "5071"; --id_subtipo = 5071 "Perturbação do sossego"
-- RESPOSTA: 42408 chamados.

-- 7. Selecione os chamados com esse subtipo que foram abertos durante os eventos contidos na tabela de eventos (Reveillon, Carnaval e Rock in Rio).
SELECT tb_a.id_chamado
FROM `datario.administracao_servicos_publicos.chamado_1746` tb_a
INNER JOIN `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` tb_c 
ON DATE(tb_a.data_inicio) BETWEEN tb_c.data_inicial AND tb_c.data_final
WHERE tb_a.id_subtipo = "5071"; --id_subtipo = 5071 "Perturbação do sossego"
-- RESPOSTA: 1212 chamados do subtipo "Perturbação do sossego" foram abertos durante o Reveillon, Carnaval e Rock in Rio.

-- 8. Quantos chamados desse subtipo foram abertos em cada evento?
SELECT tb_c.evento eventos, COUNT(*) qtd_chamados
FROM `datario.administracao_servicos_publicos.chamado_1746` tb_a
INNER JOIN `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` tb_c 
ON DATE(tb_a.data_inicio) BETWEEN tb_c.data_inicial AND tb_c.data_final
WHERE tb_a.id_subtipo = "5071"
GROUP BY tb_c.evento;
-- RESPOSTA: Rock in Rio teve 834 chamados, Carnaval teve 241 chamados e Reveillon teve 137 chamados.

-- 9. Qual evento teve a maior média diária de chamados abertos desse subtipo?
SELECT tb_c.evento eventos,
ROUND(COUNT(*) / COUNT(DISTINCT DATE(tb_a.data_inicio)),0) media_diaria_chamados
FROM `datario.administracao_servicos_publicos.chamado_1746` tb_a
INNER JOIN `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` tb_c 
ON DATE(tb_a.data_inicio) BETWEEN tb_c.data_inicial AND tb_c.data_final
WHERE tb_a.id_subtipo = "5071"
GROUP BY tb_c.evento
ORDER BY media_diaria_chamados DESC
LIMIT 1;
-- RESPOSTA: Rock in Rio com 119 chamados em média por dia do subtipo "Perturbação do sossego".

-- 10. Compare as médias diárias de chamados abertos desse subtipo durante os eventos específicos (Reveillon, Carnaval e Rock in Rio) e a média diária de chamados abertos desse subtipo considerando todo o período de 01/01/2022 até 31/12/2023.
SELECT tb_c.evento eventos,
ROUND(COUNT(*) / COUNT(DISTINCT DATE(tb_a.data_inicio)), 2) AS media_diaria_chamados
FROM `datario.administracao_servicos_publicos.chamado_1746` tb_a
INNER JOIN `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` tb_c 
ON DATE(tb_a.data_inicio) BETWEEN tb_c.data_inicial AND tb_c.data_final
WHERE tb_a.id_subtipo = "5071"
GROUP BY tb_c.evento
UNION ALL
SELECT "01/01/2022 até 31/12/2023" AS evento, 
ROUND(COUNT(*) / COUNT(DISTINCT DATE(tb_a.data_inicio)),2) AS media_diaria_chamados
FROM `datario.administracao_servicos_publicos.chamado_1746` tb_a
WHERE id_subtipo = "5071"
AND DATE(data_inicio) BETWEEN '2022-01-01' AND '2023-12-31';
/* RESPOSTA: Durante o período de 01/01/2022 a 31/12/2023, com uma média de 63 chamados diários,
 o Rock in Rio se destacou com a maior média diária de chamados (119),
 representando um aumento de 88,5%. Por outro lado,
 o Carnaval teve uma média de 60 chamados, uma redução de 4,66%,
  enquanto o Reveillon registrou uma média de 46 chamados, uma redução de 27,73%.
*/