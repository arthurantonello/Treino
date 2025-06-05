

-- Encontre os representantes cuja primeira venda em 2023 ocorreu antes da data média
-- de todas as primeiras vendas de 2023. Para cada um, exiba o código do representante
-- e a data da primeira venda. Use um subselect correlacionado que calcule a média
-- das primeiras datas de venda em 2023.



-- Exercício 3:
-- Liste todos os produtos cadastrados em PCPRODUT que não aparecem em nenhum registro de PCPEDI
-- entre 1 de outubro e 30 de novembro de 2011. Exiba o código do produto e a descrição,
-- utilizando um subselect com NOT IN para filtrar os produtos que não tiverem sido vendidos
-- naquele intervalo.


-- Exercício 4:
-- Identifique os fornecedores que, em outubro/novembro de 2011, enviaram mais itens (soma de QT)
-- do que a média de itens enviada por fornecedor naquele mesmo período. Para cada fornecedor,
-- exiba o código e a quantidade total de itens. Use um subselect que calcule a média de soma(QT)
-- agrupada por CODFORNEC em PCPEDI (filtrado por data e POSICAO).


-- Exercício 5:
-- Exiba os clientes que realizaram compras em outubro/novembro de 2011 (PCPEDI) e depois voltaram
-- a comprar somente em 2024 (PCPEDC), mas não compraram em 2023. Para cada cliente, mostre o código,
-- a data da primeira compra em 2011 e a data da primeira compra em 2024. Utilize subselects com
-- INTERSECT e MINUS de forma implícita para compor esse resultado sem expor diretamente as operações
-- de conjunto nas instruções.

  
  
  
  
  
  
  
  
  	