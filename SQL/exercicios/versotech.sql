-- Exercícios focados no banco de dados WINT

-- Liste o nome do cliente e a soma total de pedidos (VLTOTAL) que ele fez,
-- mas inclua também clientes que ainda não têm pedidos.
-- Ordene pelo valor total decrescente e mostre apenas quem ultrapassou R$ 10.000.
-- Tabelas: PCCLIENT (clientes), PCPEDC (pedidos - cabeçalho)

SELECT
	PCCLIENT.CLIENTE,
	SUM(PCPEDC.VLTOTAL) ValorTotal
FROM 
	WINT.PCCLIENT
	LEFT JOIN WINT.PCPEDC
		ON PCCLIENT.CODCLI = PCPEDC.CODCLI
GROUP BY 
	PCCLIENT.CLIENTE
HAVING 
	SUM(PCPEDC.VLTOTAL) < 100000
ORDER BY
	ValorTotal DESC;


-- Para cada pedido (NUMPED), exiba o número de itens distintos (contagem de CODPROD)
-- e o valor médio por item (VLTOTAL/NUMITENS),
-- mas só mostre pedidos com mais de 3 itens.
-- Tabelas: PCPEDC (pedidos - cabeçalho), PCPEDI (pedidos - itens)

SELECT
	PEDIDO.NUMPED,
	COUNT(DISTINCT ITENS.CODPROD) itens_distintos,
	ROUND(
			AVG(PEDIDO.VLTOTAL/NULLIF(PEDIDO.NUMITENS,0))
		, 2) valor_medio
FROM 
	WINT.PCPEDC PEDIDO 
	INNER JOIN WINT.PCPEDI ITENS
		ON PEDIDO.NUMPED = ITENS.NUMPED
GROUP BY
	PEDIDO.NUMPED
HAVING 
	COUNT(DISTINCT ITENS.CODPROD) > 3
	
SELECT 
    ped.NUMPED,
    COUNT(DISTINCT i.CODPROD)        AS qtd_produtos,
    ped.VLTOTAL / NULLIF(ped.NUMITENS,0) AS media_valor_item
FROM WINT.PCPEDC ped
JOIN WINT.PCPEDI i
  ON ped.NUMPED = i.NUMPED
GROUP BY ped.NUMPED, ped.VLTOTAL, ped.NUMITENS
HAVING COUNT(DISTINCT i.CODPROD) > 3;

-- Traga todos os pedidos (NUMPED, “DATA”, VLTOTAL) em que o representante (CODUSUR)
-- não tenha feito nenhuma venda acima de R$ 5.000 em nenhum item (PVENDA).
-- Tabelas: PCPEDC (pedidos - cabeçalho), PCPEDI (pedidos - itens)

SELECT
	PEDIDO.NUMPED,
	PEDIDO."DATA",
	PEDIDO.VLTOTAL
FROM 
	WINT.PCPEDC PEDIDO
WHERE NOT EXISTS (
	SELECT 
		1
	FROM 
		WINT.PCPEDI ITENS
	WHERE 
		ITENS.NUMPED = PEDIDO.NUMPED
		AND ITENS.PVENDA > 5000
	);
	
	


-- Liste fornecedores (FORNECEDOR) que usam o mesmo CEP que algum cliente (CEPENT),
-- trazendo o nome do cliente e do fornecedor.
-- Inclua também fornecedores cujo CEP não tenha correspondência.
-- Tabelas: PCFORNEC (fornecedores), PCCLIENT (clientes)

SELECT 
	FORNECEDORES.FORNECEDOR,
	FORNECEDORES.CEP,
	CLIENTE.CLIENTE,
	CLIENTE.CEPENT
FROM 
	WINT.PCFORNEC FORNECEDORES
	LEFT JOIN WINT.PCCLIENT CLIENTE
		ON FORNECEDORES.CEP = CLIENTE.CEPENT;

-- Qual produto (CODPROD, DESCRICAO) teve o maior número de vendas (soma de QT)
-- em pedidos feitos em março de 2025?
-- Exiba o total vendido por produto.
-- Tabelas: PCPEDI (itens do pedido), PCPEDC (cabeçalho do pedido), PCPRODUT (produtos)
		
SELECT 
	PRODUTO.CODPROD,
	PRODUTO.DESCRICAO,
	SUM(ITENS.QT) SomaQuantidade
FROM 
	WINT.PCPRODUT PRODUTO
	INNER JOIN WINT.PCPEDI ITENS
		ON PRODUTO.CODPROD = ITENS.CODPROD
	INNER JOIN WINT.PCPEDC PEDIDOCABECALHO
		ON PRODUTO.CODPROD = PEDIDOCABECALHO.CODPROD;
GROUP BY
	PRODUTO.CODPROD,
	PRODUTO.DESCRICAO
FETCH NEXT 5 ROWS ONLY

SELECT 
    ITENS.CODPROD,
    PRODUTO.DESCRICAO,
    SUM(ITENS.QT) AS total_vendido
FROM WINT.PCPEDI ITENS
JOIN WINT.PCPEDC PEDIDO
  ON ITENS.NUMPED = PEDIDO.NUMPED
JOIN WINT.PCPRODUT PRODUTO
  ON ITENS.CODPROD = PRODUTO.CODPROD
WHERE EXTRACT(YEAR FROM PEDIDO."DATA") = 2025
  AND EXTRACT(MONTH FROM PEDIDO."DATA") = 3
GROUP BY ITENS.CODPROD, PRODUTO.DESCRICAO
ORDER BY total_vendido DESC
FETCH FIRST 1 ROWS ONLY;

-- Liste os 10 primeiros clientes com seus nomes e CEP de entrega.
-- Tabela: PCCLIENT

SELECT
	PCCLIENT.CLIENTE,
	CONCAT(PCCLIENT.ENDERENT, PCCLIENT.BAIRROENT) ENDERECO_entrega
FROM 
	WINT.PCCLIENT
FETCH FIRST 10 ROWS ONLY;

-- Mostre os produtos (código e descrição) cujo volume seja 1.
-- Tabela: PCPRODUT

SELECT 
	PCPRODUT.CODPROD,
	PCPRODUT.DESCRICAO,
	PCPRODUT.VOLUME
FROM 
	WINT.PCPRODUT
WHERE PCPRODUT.VOLUME = 1.0;

-- Liste os fornecedores cadastrados na cidade de 'SÃO PAULO'.
-- Tabela: PCFORNEC

SELECT 
	*
FROM 
	WINT.PCFORNEC
WHERE PCFORNEC.CIDADE = 'São Paulo';

-- Mostre os 5 pedidos mais recentes com número do pedido, data e valor total.
-- Tabela: PCPEDC

SELECT
	PCPEDC.NUMPED,
	PCPEDC."DATA",
	PCPEDC.VLTOTAL
FROM 
	WINT.PCPEDC
FETCH FIRST 10 ROWS ONLY;

-- Ex5: Encontre os nomes dos usuários (vendedores/representantes) que têm e-mail cadastrado.
--      Tabela: PCUSUARI
SELECT
	PCUSUARI.NOME,
	PCUSUARI.EMAIL
FROM
	WINT.PCUSUARI
WHERE
	PCUSUARI.EMAIL IS NOT NULL

-- Mostre todos os produtos do fornecedor de código 10 (CODFORNEC = 1).
-- Tabelas: PCPRODUT

SELECT
	*
FROM
	WINT.PCPRODUT
WHERE
	PCPRODUT.CODFORNEC = 1
	

-- Liste o nome do cliente e a soma total de pedidos (VLTOTAL) que ele fez,
-- mas inclua também clientes que ainda não têm pedidos.
-- Ordene pelo valor total decrescente e mostre apenas quem ultrapassou R$ 10.000.
-- Tabelas: PCCLIENT (clientes), PCPEDC (pedidos - cabeçalho)

SELECT
	PCCLIENT.CLIENTE,
	SUM(PCPEDC.VLTOTAL) ValorTotal
FROM 
	WINT.PCCLIENT
	LEFT JOIN WINT.PCPEDC
		ON PCCLIENT.CODCLI = PCPEDC.CODCLI
GROUP BY 
	PCCLIENT.CLIENTE
HAVING 
	SUM(PCPEDC.VLTOTAL) < 100000
ORDER BY
	ValorTotal DESC;


-- Para cada pedido (NUMPED), exiba o número de itens distintos (contagem de CODPROD)
-- e o valor médio por item (VLTOTAL/NUMITENS),
-- mas só mostre pedidos com mais de 3 itens.
-- Tabelas: PCPEDC (pedidos - cabeçalho), PCPEDI (pedidos - itens)

SELECT
	PEDIDO.NUMPED,
	COUNT(DISTINCT ITENS.CODPROD) itens_distintos,
	ROUND(
			AVG(PEDIDO.VLTOTAL/NULLIF(PEDIDO.NUMITENS,0))
		, 2) valor_medio
FROM 
	WINT.PCPEDC PEDIDO 
	INNER JOIN WINT.PCPEDI ITENS
		ON PEDIDO.NUMPED = ITENS.NUMPED
GROUP BY
	PEDIDO.NUMPED
HAVING 
	COUNT(DISTINCT ITENS.CODPROD) > 3
	
SELECT 
    ped.NUMPED,
    COUNT(DISTINCT i.CODPROD)        AS qtd_produtos,
    ped.VLTOTAL / NULLIF(ped.NUMITENS,0) AS media_valor_item
FROM WINT.PCPEDC ped
JOIN WINT.PCPEDI i
  ON ped.NUMPED = i.NUMPED
GROUP BY ped.NUMPED, ped.VLTOTAL, ped.NUMITENS
HAVING COUNT(DISTINCT i.CODPROD) > 3;

-- Traga todos os pedidos (NUMPED, “DATA”, VLTOTAL) em que o representante (CODUSUR)
-- não tenha feito nenhuma venda acima de R$ 5.000 em nenhum item (PVENDA).
-- Tabelas: PCPEDC (pedidos - cabeçalho), PCPEDI (pedidos - itens)

SELECT
	PEDIDO.NUMPED,
	PEDIDO."DATA",
	PEDIDO.VLTOTAL
FROM 
	WINT.PCPEDC PEDIDO
WHERE NOT EXISTS (
	SELECT 
		1
	FROM 
		WINT.PCPEDI ITENS
	WHERE 
		ITENS.NUMPED = PEDIDO.NUMPED
		AND ITENS.PVENDA > 5000
	);
	
	


-- Liste fornecedores (FORNECEDOR) que usam o mesmo CEP que algum cliente (CEPENT),
-- trazendo o nome do cliente e do fornecedor.
-- Inclua também fornecedores cujo CEP não tenha correspondência.
-- Tabelas: PCFORNEC (fornecedores), PCCLIENT (clientes)

SELECT 
	FORNECEDORES.FORNECEDOR,
	FORNECEDORES.CEP,
	CLIENTE.CLIENTE,
	CLIENTE.CEPENT
FROM 
	WINT.PCFORNEC FORNECEDORES
	LEFT JOIN WINT.PCCLIENT CLIENTE
		ON FORNECEDORES.CEP = CLIENTE.CEPENT;

-- Qual produto (CODPROD, DESCRICAO) teve o maior número de vendas (soma de QT)
-- em pedidos feitos em março de 2025?
-- Exiba o total vendido por produto.
-- Tabelas: PCPEDI (itens do pedido), PCPEDC (cabeçalho do pedido), PCPRODUT (produtos)
		
SELECT 
	PRODUTO.CODPROD,
	PRODUTO.DESCRICAO,
	SUM(ITENS.QT) SomaQuantidade
FROM 
	WINT.PCPRODUT PRODUTO
	INNER JOIN WINT.PCPEDI ITENS
		ON PRODUTO.CODPROD = ITENS.CODPROD
	INNER JOIN WINT.PCPEDC PEDIDOCABECALHO
		ON PRODUTO.CODPROD = PEDIDOCABECALHO.CODPROD;
GROUP BY
	PRODUTO.CODPROD,
	PRODUTO.DESCRICAO
FETCH NEXT 5 ROWS ONLY

SELECT 
    ITENS.CODPROD,
    PRODUTO.DESCRICAO,
    SUM(ITENS.QT) AS total_vendido
FROM WINT.PCPEDI ITENS
JOIN WINT.PCPEDC PEDIDO
  ON ITENS.NUMPED = PEDIDO.NUMPED
JOIN WINT.PCPRODUT PRODUTO
  ON ITENS.CODPROD = PRODUTO.CODPROD
WHERE EXTRACT(YEAR FROM PEDIDO."DATA") = 2025
  AND EXTRACT(MONTH FROM PEDIDO."DATA") = 3
GROUP BY ITENS.CODPROD, PRODUTO.DESCRICAO
ORDER BY total_vendido DESC
FETCH FIRST 1 ROWS ONLY;

-- Liste os 10 primeiros clientes com seus nomes e CEP de entrega.
-- Tabela: PCCLIENT

SELECT
	PCCLIENT.CLIENTE,
	CONCAT(PCCLIENT.ENDERENT, PCCLIENT.BAIRROENT) ENDERECO_entrega
FROM 
	WINT.PCCLIENT
FETCH FIRST 10 ROWS ONLY;

-- Mostre os produtos (código e descrição) cujo volume seja 1.
-- Tabela: PCPRODUT

SELECT 
	PCPRODUT.CODPROD,
	PCPRODUT.DESCRICAO,
	PCPRODUT.VOLUME
FROM 
	WINT.PCPRODUT
WHERE PCPRODUT.VOLUME = 1.0;

-- Liste os fornecedores cadastrados na cidade de 'SÃO PAULO'.
-- Tabela: PCFORNEC

SELECT 
	*
FROM 
	WINT.PCFORNEC
WHERE PCFORNEC.CIDADE = 'São Paulo';

-- Mostre os 5 pedidos mais recentes com número do pedido, data e valor total.
-- Tabela: PCPEDC

SELECT
	PCPEDC.NUMPED,
	PCPEDC."DATA",
	PCPEDC.VLTOTAL
FROM 
	WINT.PCPEDC
FETCH FIRST 10 ROWS ONLY;

-- Encontre os nomes dos usuários (vendedores/representantes) que têm e-mail cadastrado.
-- Tabela: PCUSUARI
SELECT
	PCUSUARI.NOME,
	PCUSUARI.EMAIL
FROM
	WINT.PCUSUARI
WHERE
	PCUSUARI.EMAIL IS NOT NULL

-- Mostre todos os produtos do fornecedor de código 10 (CODFORNEC = 1).
-- Tabelas: PCPRODUT

SELECT
	*
FROM
	WINT.PCPRODUT
WHERE
	PCPRODUT.CODFORNEC = 1
	
-- Conte quantos pedidos existem no sistema.
-- Tabela: PCPEDC
	
	
SELECT
	COUNT(1) QtdPedidos
FROM
	WINT.PCPEDC

-- Mostre o nome do cliente e o limite de crédito (LIMCRED) apenas dos que têm mais de R$ 5.000.
-- Tabela: PCCLIENT
	
	
SELECT
	PCCLIENT.CLIENTE,
	PCCLIENT.LIMCRED Limite_credito
FROM
	WINT.PCCLIENT

-- Liste os 10 produtos com maior peso líquido.
-- Mostre o código, descrição e PESOLIQ.
-- Tabela: PCPRODUT

SELECT 
	PCPRODUT.PESOLIQ
FROM 
	WINT.PCPRODUT
ORDER BY PCPRODUT.PESOLIQ DESC
FETCH NEXT 10 ROWS ONLY


-- Mostre os nomes de cidades distintas dos fornecedores.
-- Tabela: PCFORNEC

SELECT 
	DISTINCT PCFORNEC.CIDADE
FROM
	WINT.PCFORNEC


-- Encontre todos os clientes cujo nome comece com 'S'.
-- Tabela: PCCLIENT
	
SELECT
	PCCLIENT.CLIENTE
FROM
	WINT.PCCLIENT
WHERE
	PCCLIENT.CLIENTE LIKE 'S%'
	

-- Liste todos os pedidos feitos entre 01/03/2024 e 31/03/2024.
-- Mostre o número, a data e o valor total.
-- Tabela: PCPEDC
	
SELECT 
	*
FROM 
	WINT.PCPEDC
WHERE
	PCPEDC."DATA" BETWEEN '01-03-2024' AND '31-03-2024'


-- Mostre os nomes dos usuários que têm supervisor (CODSUPERVISOR IS NOT NULL).
-- Tabela: PCUSUARI
	
SELECT
	PCUSUARI.NOME,
	PCUSUARI.CODSUPERVISOR
FROM
	WINT.PCUSUARI
WHERE
	PCUSUARI.CODSUPERVISOR IS NOT NULL

-- Encontre todos os produtos com descrição contendo a palavra 'GAMER'.
-- Tabela: PCPRODUT
	
SELECT 
	PCPRODUT.DESCRICAO
FROM 
	WINT.PCPRODUT
WHERE 
	PCPRODUT.DESCRICAO LIKE '%GAMER%'

-- Liste os nomes e cidades dos clientes que estão no estado de 'SÃO PAULO'.
-- Tabela: PCCLIENT
	
SELECT 
	*
FROM
	WINT.PCCLIENT
WHERE
	PCCLIENT.ESTCOB = 'SP'

-- Mostre os produtos cujo volume esteja entre 0.5 e 1.5.
-- Tabela: PCPRODUT
	
SELECT
	PCPRODUT.VOLUME
FROM
	WINT.PCPRODUT
WHERE
	PCPRODUT.VOLUME BETWEEN 0.5 AND 1.5

-- Liste os 5 fornecedores mais antigos (com a menor data de cadastro).
-- Mostre o nome, cidade e DTCADASTRO.
-- Tabela: PCFORNEC
	
SELECT
	PCFORNEC.FORNECEDOR,
	PCFORNEC.CIDADE,
	PCFORNEC.DTCADASTRO
FROM
	WINT.PCFORNEC
ORDER BY 
	PCFORNEC.DTCADASTRO
FETCH NEXT 5 ROWS ONLY
	

-- Conte quantos usuários existem por tipo de vendedor (TIPOVEND).
--  Tabela: PCUSUARI

SELECT 
	PCUSUARI.TIPOVEND,
	COUNT(PCUSUARI.CODUSUR) Usuario_por_tipo
FROM 
	WINT.PCUSUARI
GROUP BY
	PCUSUARI.TIPOVEND


-- Liste o nome do cliente, número do pedido e valor total, incluindo clientes que ainda não fizeram pedidos.

SELECT
	PCCLIENT.CLIENTE,
	PCPEDC.NUMPED,
	PCPEDC.VLTOTAL
FROM
	WINT.PCCLIENT
	LEFT JOIN WINT.PCPEDC
		ON PCCLIENT.CODCLI = PCPEDC.CODCLI
ORDER BY
	PCCLIENT.CLIENTE,
	PCPEDC.NUMPED;


-- Mostre os nomes dos representantes e seus supervisores, mas traga também os representantes que ainda não possuem supervisor atribuído.

SELECT
	PCUSUARI.NOME AS NOME_REPRESENTANTE,
	PCSUPERV.NOME AS NOME_SUPERVISOR
FROM
	WINT.PCUSUARI
	LEFT JOIN WINT.PCSUPERV
		ON PCUSUARI.CODSUPERVISOR = PCSUPERV.CODSUPERVISOR;


-- Exiba os produtos com suas descrições e os nomes de seus fornecedores, mas apenas os produtos que possuem fornecedor cadastrado.

SELECT
	PCPRODUT.DESCRICAO,
	PCFORNEC.FORNECEDOR
FROM 
	WINT.PCPRODUT
	INNER JOIN WINT.PCFORNEC
		ON PCPRODUT.CODFORNEC = PCFORNEC.CODFORNEC;

-- Liste os nomes dos clientes e os nomes dos fornecedores que compartilham o mesmo CEP..


SELECT
	PCCLIENT.CLIENTE,
	PCFORNEC.FORNECEDOR,
	PCCLIENT.CEPENT
FROM
	WINT.PCCLIENT
	JOIN WINT.PCFORNEC
		ON PCCLIENT.CEPENT = PCFORNEC.CEP;

-- Mostre o número do pedido, a data e o nome do representante que o registrou.

SELECT
	PCPEDC.NUMPED,
	PCPEDC."DATA",
	PCUSUARI.NOME
FROM
	WINT.PCPEDC
	INNER JOIN WINT.PCUSUARI
		ON PCPEDC.CODUSUR = PCUSUARI.CODUSUR;

-- Liste o nome dos produtos e a quantidade total vendida, mesmo que algum produto ainda não tenha sido vendido, ordenando pelo mais vendido primeiro.

SELECT
	PCPRODUT.DESCRICAO,
	SUM(PCPEDI.QT) AS QTD_VENDIDA
FROM	
	WINT.PCPRODUT
	LEFT JOIN WINT.PCPEDI
		ON PCPRODUT.CODPROD = PCPEDI.CODPROD
GROUP BY
	PCPRODUT.DESCRICAO
ORDER BY
	QTD_VENDIDA DESC;


-- Mostre todos os fornecedores e a quantidade de produtos cadastrados para cada um deles.

SELECT
	PCFORNEC.FORNECEDOR,
	LISTAGG(PCPRODUT.CODPROD,', ') AS PRODUTOS,
	SUM(PCPEDI.QT) AS QTD_TOTAL
FROM
	WINT.PCFORNEC
	INNER JOIN WINT.PCPRODUT
		ON PCFORNEC.CODFORNEC = PCPRODUT.CODFORNEC
GROUP BY
	PCFORNEC.FORNECEDOR;


-- Liste os pedidos feitos em março de 2024, com o nome do cliente e o número total de itens no pedido.

SELECT
	PCCLIENT.CLIENTE,
	SUM(PCPEDI.QT) AS QTD_ITENS
FROM
	WINT.PCPEDC
	INNER JOIN WINT.PCCLIENT
		ON PCPEDC.CODCLI = PCCLIENT.CODCLI
	INNER JOIN WINT.PCPEDI
		ON PCPEDC.NUMPED = PCPEDI.NUMPED
WHERE
	PCPEDC."DATA" BETWEEN '01/03/2024' AND '31/03/2024'
GROUP BY
	PCPEDC.NUMPED,
	PCCLIENT.CLIENTE;

-- Apresente os nomes dos produtos e os nomes dos representantes que venderam esses produtos, sem excluir produtos que ainda não tenham sido vendidos.

SELECT
	PCPRODUT.DESCRICAO,
	PCUSUARI.NOME
FROM
	WINT.PCPRODUT
	LEFT JOIN WINT.PCPEDI
		ON PCPRODUT.CODPROD = PCPEDI.CODPROD
	LEFT JOIN WINT.PCPEDC
		ON PCPEDI.NUMPED = PCPEDC.NUMPED
	LEFT JOIN WINT.PCUSUARI
		ON PCPEDC.CODUSUR = PCUSUARI.CODUSUR;

-- Liste os produtos com embalagem igual a 'CX' e que tenham peso líquido entre 0.5 e 1.5 kg, exibindo código, descrição e unidade.

SELECT
	PCPRODUT.CODPROD,
	PCPRODUT.DESCRICAO,
	PCPRODUT.EMBALAGEM,
	PCPRODUT.PESOLIQ
FROM
	WINT.PCPRODUT
WHERE 
	PCPRODUT.PESOLIQ BETWEEN 0.5 AND 1.5
	AND PCPRODUT.EMBALAGEM = 'CX';

-- Mostre os nomes dos clientes que não possuem e-mail cadastrado.

SELECT
	PCCLIENT.CLIENTE
FROM
	WINT.PCCLIENT
WHERE
	PCCLIENT.EMAIL IS NULL;

-- Traga os nomes dos representantes e o total de pedidos que cada um registrou, mostrando apenas quem realizou mais de 10 pedidos.

SELECT
	PCUSUARI.NOME,
	COUNT(PCPEDC.NUMPED) AS QTD_PEDIDOS
FROM
	WINT.PCUSUARI
	INNER JOIN WINT.PCPEDC
		ON PCUSUARI.CODUSUR = PCPEDC.CODUSUR
GROUP BY
	PCUSUARI.NOME
HAVING
	COUNT(PCPEDC.NUMPED) > 10;
	

-- Exiba os fornecedores da cidade de 'PORTO ALEGRE' que compartilham o mesmo CEP com algum cliente.

SELECT DISTINCT
	PCFORNEC.FORNECEDOR
FROM
	WINT.PCFORNEC
	INNER JOIN WINT.PCCLIENT
	ON PCFORNEC.CEP = PCCLIENT.CEPCOB
WHERE
	PCFORNEC.CIDADE = 'Porto Alegre';


-- Apresente os produtos que nunca foram vendidos (nenhuma linha correspondente na tabela de itens de pedido).

SELECT
	PCPRODUT.CODPROD,
    PCPRODUT.DESCRICAO,
    PCPRODUT.UNIDADE
FROM
	WINT.PCPRODUT
	LEFT JOIN WINT.PCPEDI
		ON PCPRODUT.CODPROD = PCPEDI.CODPROD
		WHERE PCPEDI.CODPROD IS NULL;

-- Liste os nomes dos clientes que fizeram pedidos em janeiro de 2024, junto com a data do pedido.

SELECT
	PCCLIENT.CLIENTE,
	PCPEDC."DATA"
FROM
	WINT.PCCLIENT
	INNER JOIN WINT.PCPEDC
		ON PCCLIENT.CODCLI = PCPEDC.CODCLI
		WHERE PCPEDC."DATA" BETWEEN '01/01/2024' AND '31/01/2024'
ORDER BY
	PCPEDC."DATA",
	PCCLIENT.CLIENTE;


-- Mostre o número do pedido, o nome do cliente e a quantidade total de itens vendidos no pedido, apenas para pedidos com mais de 5 itens.

SELECT
	PCPEDC.NUMPED,
	PCCLIENT.CLIENTE,
	SUM(PCPEDI.QT) QTD_ITENS_VENDIDOS
FROM
	WINT.PCPEDC
	INNER JOIN WINT.PCCLIENT
		ON PCPEDC.CODCLI = PCCLIENT.CODCLI
	INNER JOIN WINT.PCPEDI
		ON PCPEDC.NUMPED = PCPEDI.NUMPED
GROUP BY
	PCPEDC.NUMPED,
	PCCLIENT.CLIENTE
HAVING
	SUM(PCPEDI.QT) > 5
ORDER BY
	PCPEDC.NUMPED,
	PCCLIENT.CLIENTE;

-- Encontre todos os produtos vendidos em março de 2024 por representantes que têm o tipo de vendedor igual a 'R'.

SELECT
	PCPEDI.CODPROD,
	PCUSUARI.TIPOVEND
FROM
	WINT.PCPEDI
	LEFT JOIN WINT.PCUSUARI
		ON PCPEDI.CODUSUR = PCUSUARI.CODUSUR
WHERE
	PCPEDI."DATA" BETWEEN '01/03/2024' AND '31/03/2024'
	AND
		PCUSUARI.TIPOVEND = 'R';


-- Exiba o nome dos representantes que nunca realizaram nenhum pedido.

SELECT
	PCUSUARI.NOME
FROM
	WINT.PCUSUARI
	LEFT JOIN WINT.PCPEDC
		ON PCUSUARI.CODUSUR = PCPEDC.CODUSUR
		WHERE
			PCPEDC.CODUSUR IS NULL

-- Mostre os nomes dos produtos e o nome dos fornecedores, incluindo também os produtos que ainda não têm fornecedor definido.
			
SELECT
	PCPRODUT.DESCRICAO,
	PCFORNEC.CODFORNEC
FROM
	WINT.PCPRODUT
	LEFT JOIN WINT.PCFORNEC
		ON PCPRODUT.CODFORNEC = PCFORNEC.CODFORNEC
ORDER BY
	PCFORNEC.CODFORNEC;
