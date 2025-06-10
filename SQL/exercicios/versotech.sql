-- Exercícios focados no banco de dados WINTHOR

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
FROM WINT.PCPEDI AS ITENS
JOIN WINT.PCPEDC AS PEDIDO
  ON ITENS.NUMPED = PEDIDO.NUMPED
JOIN WINT.PCPRODUT AS PRODUTO
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
	SUM(PCPEDI.QT) AS QTD_ITENS_VENDIDOS
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

-- Traga os produtos que somaram mais de 200 unidades vendidas no total (QT), mostrando o nome e a quantidade total.

SELECT
	PCPRODUT.DESCRICAO,
	SUM(PCPEDI.QT) QTD_VENDIDA
FROM
	WINT.PCPEDI
	INNER JOIN WINT.PCPRODUT
		ON PCPEDI.CODPROD = PCPRODUT.CODPROD
GROUP BY
	PCPRODUT.DESCRICAO
HAVING
	SUM(PCPEDI.QT) > 200;

-- Liste os produtos que aparecem em pedidos diferentes de pelo menos 2 clientes distintos.


SELECT
	PCPEDI.CODPROD,
	COUNT(DISTINCT PCPEDI.CODCLI) AS QTD_CLIENTE
FROM
	WINT.PCPEDI
GROUP BY
	PCPEDI.CODPROD
HAVING
	COUNT(DISTINCT PCPEDI.CODCLI) > 2
ORDER BY
	PCPEDI.CODPROD;

-- Exiba os pedidos cujo valor total (VLTOTAL) está acima da média de todos os pedidos no sistema.

SELECT
	PCPEDC.NUMPED,
	PCPEDC.VLTOTAL
FROM
	WINT.PCPEDC
WHERE PCPEDC.VLTOTAL > (
		SELECT
			AVG(PCPEDC.VLTOTAL)
		FROM
			WINT.PCPEDC);


-- Mostre os 5 produtos mais vendidos em quantidade, com a descrição e nome do fornecedor correspondente.

SELECT
	PCPEDI.CODPROD,
	PCPRODUT.DESCRICAO,
	PCFORNEC.FORNECEDOR,
	SUM(PCPEDI.QT) AS QTD_VENDIDA
FROM
	WINT.PCPEDI
	INNER JOIN WINT.PCPRODUT
		ON PCPEDI.CODPROD = PCPRODUT.CODPROD
	INNER JOIN WINT.PCFORNEC
		ON PCPRODUT.CODFORNEC = PCFORNEC.CODFORNEC
GROUP BY
	PCPEDI.CODPROD,
	PCPRODUT.DESCRICAO,
	PCFORNEC.FORNECEDOR
ORDER BY
	QTD_VENDIDA DESC
FETCH FIRST 5 ROWS ONLY;

-- Liste os pedidos em que o total de produtos vendidos tenha peso líquido superior a 20 kg.


SELECT
	PCPEDI.NUMPED,
	SUM(PCPRODUT.PESOLIQ * PCPEDI.QT) AS SOMA_PESOLIQ
FROM
	WINT.PCPEDI
	INNER JOIN WINT.PCPRODUT
		ON PCPEDI.CODPROD = PCPRODUT.CODPROD
GROUP BY
	PCPEDI.NUMPED
HAVING
	SUM(PCPRODUT.PESOLIQ * PCPEDI.QT) > 20
ORDER BY
	PCPEDI.NUMPED;


-- Mostre os pedidos em que a quantidade total de unidades vendidas (soma de QT) ultrapassou 50.

SELECT
	PCPEDI.NUMPED,
	SUM(PCPEDI.QT) QTD_VENDIDA
FROM
	WINT.PCPEDI
GROUP BY
	PCPEDI.NUMPED
HAVING
	SUM(PCPEDI.QT) > 50
FETCH FIRST 10 ROWS ONLY;


-- Encontre os clientes que fizeram pedidos em março de 2024, mas não fizeram nenhum em fevereiro de 2024.


SELECT
	PCCLIENT.CLIENTE,
	PCPEDC."DATA"
FROM
	WINT.PCPEDC
	INNER JOIN WINT.PCCLIENT
		ON PCPEDC.CODCLI = PCCLIENT.CODCLI
WHERE
	PCPEDC."DATA" BETWEEN '01/03/2024' AND '31/03/2024'
	AND PCPEDC."DATA" NOT BETWEEN '01/02/2024' AND '28/02/2024';
	
-- Liste os 3 produtos com maior volume de vendas (em unidades QT), mas cuidado: 
-- alguns produtos podem aparecer em múltiplos pedidos — considere a soma total correta.

SELECT
	PCPRODUT.DESCRICAO,
	SUM(PCPEDI.QT) QTD
FROM
	WINT.PCPEDI
	INNER JOIN WINT.PCPRODUT
		ON PCPEDI.CODPROD = PCPRODUT.CODPROD
GROUP BY
	PCPRODUT.DESCRICAO
ORDER BY
	QTD DESC
FETCH FIRST 3 ROWS ONLY;



-- Mostre os pedidos em que houve mais de um produto com o mesmo código (CODPROD), 
-- ou seja, repetições de produto no mesmo pedido.

SELECT
	PCPEDI.NUMPED,
	PCPEDI.CODPROD,
	COUNT(PCPEDI.CODPROD) QTD_COMPRADA
FROM
	WINT.PCPEDI
GROUP BY
	PCPEDI.NUMPED,
	PCPEDI.CODPROD
HAVING
	COUNT(PCPEDI.CODPROD) > 1;


-- Liste os produtos que nunca foram vendidos, mas cuidado para não excluir produtos com QT = 0.
-- Lembre-se: ausência no PCPEDI é diferente de quantidade zerada.

SELECT
	PCPEDI.CODPROD,
	PCPEDI.QT
FROM
	WINT.PCPRODUT
	INNER JOIN WINT.PCPEDI
		ON PCPRODUT.CODPROD = PCPEDI.CODPROD
		WHERE PCPEDI.CODPROD IS NULL;


-- Traga todos os pedidos com valor total acima da média,
-- mas somente se o pedido tiver mais de 2 itens distintos vendidos.

SELECT
	PCPEDC.NUMPED,
	PCPEDC.VLTOTAL,
	COUNT(DISTINCT )
FROM
	WINT.PCPEDC
	INNER JOIN WINT.PCPEDI
		ON PCPED 
WHERE 
	PCPEDC.VLTOTAL > (
		SELECT 
			AVG(PCPEDC.VLTOTAL)
		FROM
			WINT.PCPEDC)

-- Você precisa gerar um relatório com os seguintes critérios:

-- 1. Traga os produtos vendidos em 2024 com volume (QT total) entre 100 e 300 unidades.
-- 2. Para cada produto, exiba: código, nome do produto, total vendido, número de pedidos distintos.
-- 3. Inclua também o nome do fornecedor vinculado ao produto.
-- 4. Organize o resultado pelo maior volume vendido primeiro.
-- 5. Limite o resultado aos 10 primeiros produtos.

-- Tabelas disponíveis: PCPEDI, PCPEDC, PCPRODUT, PCFORNEC.

SELECT
	PCPEDI.CODPROD 						AS COD_PRODUTO,
	PCPRODUT.DESCRICAO 					AS NOME_PRODUTO,
	SUM(PCPEDI.QT) 						AS QT_VENDIDA,
	COUNT(DISTINCT PCPEDI.NUMPED) 		AS QTD_PEDIDOS,
	PCFORNEC.FORNECEDOR					AS FORNECEDOR
FROM
	WINT.PCPEDC
	INNER JOIN WINT.PCPEDI 
		ON PCPEDC.NUMPED = PCPEDI.NUMPED
	INNER JOIN WINT.PCPRODUT
		ON PCPEDI.CODPROD = PCPRODUT.CODPROD
	INNER JOIN WINT.PCFORNEC 
		ON PCPRODUT.CODFORNEC = PCFORNEC.CODFORNEC
WHERE
	EXTRACT(YEAR FROM PCPEDC.DATA) = 2024
GROUP BY
	PCPEDI.CODPROD,
	PCPRODUT.DESCRICAO,
	PCFORNEC.FORNECEDOR
HAVING
	SUM(PCPEDI.QT) BETWEEN 100 AND 300
ORDER BY
	SUM(PCPEDI.QT)  DESC
FETCH FIRST 10 ROWS ONLY;


-- O analista precisa de um relatório para entender o desempenho de alguns produtos ao longo de 2024.

-- Ele quer visualizar os produtos que tiveram um volume relevante de vendas no ano, junto com o número de pedidos em que apareceram, e qual fornecedor está vinculado.

-- Ele também quer ver só os principais resultados, ordenados pela quantidade vendida, e não quer ver produtos que só venderam pouco ou apareceram uma única vez.


SELECT
	PCPEDI.CODPROD,
	PCPRODUT.DESCRICAO,
	PCFORNEC.FORNECEDOR,
	SUM(PCPEDI.QT) QTD_VENDIDA,
	COUNT(DISTINCT PCPEDI.NUMPED) QTD_PEDIDOS
FROM
	WINT.PCPEDI
	INNER JOIN WINT.PCPEDC 
		ON PCPEDI.NUMPED = PCPEDC.NUMPED
	INNER JOIN WINT.PCPRODUT
		ON PCPRODUT.CODPROD = PCPEDI.CODPROD
	INNER JOIN WINT.PCFORNEC
		ON PCPRODUT.CODFORNEC = PCFORNEC.CODFORNEC
WHERE
	EXTRACT(YEAR FROM PCPEDC.DATA) = 2024
GROUP BY
	PCPEDI.CODPROD,
	PCPRODUT.DESCRICAO,
	PCFORNEC.FORNECEDOR
HAVING
	COUNT(DISTINCT PCPEDI.NUMPED) > 1
	AND SUM(PCPEDI.QT) > 100
ORDER BY
	QTD_VENDIDA DESC;

-- Crie um relatório que traga os produtos vendidos em pedidos,
-- mostrando o código, nome do produto e a quantidade total vendida (QT).
-- Além disso, crie uma coluna chamada "CATEGORIA_VENDA" com os seguintes critérios:

-- - Se a soma total vendida for maior que 250 → mostrar 'ALTO'
-- - Se estiver entre 201 e 250 → mostrar 'MÉDIO'
-- - Se for até 200 → mostrar 'BAIXO'

-- Ordene do maior para o menor volume vendido.
-- Use apenas tabelas confiáveis: PCPEDI e PCPRODUT.

SELECT
	PCPEDI.CODPROD,
	PCPRODUT.DESCRICAO,
	SUM(PCPEDI.QT) AS QTD_VENDIDA,
	CASE
		WHEN SUM(PCPEDI.QT) > 250 THEN 'ALTO'
		WHEN SUM(PCPEDI.QT) BETWEEN 201 AND 250 THEN 'MÉDIO'
		ELSE 'BAIXO'
	END AS CATEGORIA_VENDA
FROM
	WINT.PCPEDI
	INNER JOIN WINT.PCPRODUT 
		ON PCPEDI.CODPROD = PCPRODUT.CODPROD
GROUP BY
	PCPEDI.CODPROD,
	PCPRODUT.DESCRICAO
ORDER BY
	QTD_VENDIDA DESC;

-- Crie um relatório que mostre o código, nome e embalagem dos produtos,
-- e uma coluna chamada "TIPO_CAIXA" com os seguintes valores:
-- - Se a embalagem for 'CX' → mostrar 'Caixa'
-- - Se for 'UN' ou 'UND' → mostrar 'Unidade Simples'
-- - Qualquer outro valor → mostrar 'Outro Tipo'

-- Mostre os produtos ordenados pelo nome.


SELECT
	PCPRODUT.CODPROD,
	PCPRODUT.DESCRICAO,
	PCPRODUT.EMBALAGEM,
	CASE
		WHEN PCPRODUT.EMBALAGEM = 'CX' THEN 'Caixa'
		WHEN PCPRODUT.EMBALAGEM = 'UN'
			OR PCPRODUT.EMBALAGEM = 'UND'THEN 'Unidade Simples'
		ELSE 'Outro tipo'
	END AS TIPO_EMBALAGEM
FROM
	WINT.PCPRODUT
ORDER BY
	PCPRODUT.DESCRICAO;

-- ------------------------------------------------------------

-- Gere um relatório com o código e nome dos produtos e uma classificação de peso:
-- - Se o peso líquido for até 0.2 kg → mostrar 'Leve'
-- - De 0.21 até 1 kg → mostrar 'Médio'
-- - Acima de 1 kg → mostrar 'Pesado'

-- Exiba apenas os produtos com peso preenchido e ordene pelo mais pesado primeiro.


SELECT
	PCPRODUT.CODPROD,
	PCPRODUT.DESCRICAO,
	PCPRODUT.PESOLIQ,
	CASE
		WHEN PCPRODUT.PESOLIQ > 1 THEN 'Pesado'
		WHEN PCPRODUT.PESOLIQ BETWEEN 0.21 AND 1 THEN 'Médio'
		ELSE 'LEVE'
	END AS CLASSIFICACAO_PESO
FROM
	WINT.PCPRODUT;

-- ------------------------------------------------------------

-- Liste os produtos vendidos (com base em PCPEDI), exibindo:
-- código, nome, quantidade total vendida, e uma categoria:
-- - Até 185 unidades → 'Pouco Procurado'
-- - De 186 a 230 → 'Popular'
-- - Acima de 250 → 'Muito Vendido'

-- Mostre os 20 produtos mais vendidos.

SELECT
	PCPEDI.CODPROD,
	PCPRODUT.DESCRICAO,
	SUM(PCPEDI.QT) AS QTD_VENDIDA,
	CASE
		WHEN SUM(PCPEDI.QT) > 230 THEN 'Muito vendido'
		WHEN SUM(PCPEDI.QT) BETWEEN 186 AND 230 THEN 'Popular'
		ELSE 'Pouco procurado'
	END AS CATEGORIA
FROM
	WINT.PCPEDI
	INNER JOIN WINT.PCPRODUT
		ON PCPEDI.CODPROD = PCPRODUT.CODPROD
GROUP BY
	PCPEDI.CODPROD,
	PCPRODUT.DESCRICAO;
-- ------------------------------------------------------------

-- Crie um relatório de produtos com base na descrição.
-- Se a descrição contiver 'MOUSE', 'TECLADO' ou 'HEADSET', crie uma coluna chamada "CATEGORIA_PRODUTO":
-- - Contendo 'MOUSE' → 'Mouse'
-- - Contendo 'TECLADO' → 'Teclado'
-- - Contendo 'HEADSET' → 'Headset'
-- - Caso contrário → 'Outro'

-- Mostre todos os produtos, agrupados por categoria.

SELECT
	CATEGORIA_PRODUTO,
	COUNT(CATEGORIA_PRODUTO) AS QTD_CATEGORIA
FROM (
	SELECT
		CASE
			WHEN PCPRODUT.DESCRICAO LIKE '%MOUSE%' THEN 'Mouse'
			WHEN PCPRODUT.DESCRICAO LIKE '%TECLADO%' THEN 'Teclado'
			WHEN PCPRODUT.DESCRICAO LIKE '%HEADSET%' THEN 'Headset'
			ELSE 'Outro'
		END AS CATEGORIA_PRODUTO
	FROM
		WINT.PCPRODUT
		)
GROUP BY
	CATEGORIA_PRODUTO
ORDER BY
	QTD_CATEGORIA DESC;

-- Crie um relatório que traga os produtos vendidos em pedidos,
-- mostrando: código, nome, quantidade total vendida (QT), e uma coluna chamada "PORTE" com:
-- 'Leve' se PESOLIQ for até 1, senão 'Pesado'.

SELECT
	PCPEDI.CODPROD,
	PCPRODUT.CODPROD,
	SUM(PCPEDI.QT) AS TOTAL_VENDIDO,
	CASE
		WHEN PCPRODUT.PESOLIQ > 1 THEN 'Pesado'
		ELSE 'Leve'
	END AS PORTE
FROM
	WINT.PCPEDI
	INNER JOIN WINT.PCPRODUT
		ON PCPEDI.CODPROD = PCPRODUT.CODPROD
GROUP BY
	PCPEDI.CODPROD,
	PCPRODUT.CODPROD;

SELECT
    PCPEDI.CODPROD,
    PCPRODUT.DESCRICAO,
    SUM(PCPEDI.QT) AS TOTAL_VENDIDO,
    CASE
        WHEN PCPRODUT.PESOLIQ > 1 THEN 'Pesado'
        ELSE 'Leve'
    END AS PORTE
FROM WINT.PCPEDI
JOIN WINT.PCPRODUT ON PCPEDI.CODPROD = PCPRODUT.CODPROD
GROUP BY
    PCPEDI.CODPROD,
    PCPRODUT.DESCRICAO,
    CASE
        WHEN PCPRODUT.PESOLIQ > 1 THEN 'Pesado'
        ELSE 'Leve'
    END;


-- Para cada fornecedor, calcule a participação percentual de cada produto nas vendas totais do fornecedor em 2024,
-- mostrando fornecedor, produto, total vendido do produto e percentual sobre o total do fornecedor.


SELECT
	PCFORNEC.FORNECEDOR,
	PCPRODUT.CODPROD,
	SUM(PCPEDI.QT) * 100 / SUM(SUM(PCPEDI.QT)) OVER (PARTITION BY PCFORNEC.FORNECEDOR) AS PERC_FORNECEDOR
FROM
	WINT.PCFORNEC
	INNER JOIN WINT.PCPRODUT
		ON PCFORNEC.CODFORNEC = PCPRODUT.CODFORNEC
	INNER JOIN WINT.PCPEDI 
		ON PCPRODUT.CODPROD = PCPEDI.CODPROD
GROUP BY
	PCFORNEC.FORNECEDOR,
	PCPRODUT.CODPROD
ORDER BY
	PCFORNEC.FORNECEDOR,
	PCPRODUT.CODPROD;


-- Liste os códigos de produtos cujas descrições comecem com 'M' 
-- e os cujas descrições terminem com 'O'.

SELECT
	PCPRODUT.CODPROD
FROM
	WINT.PCPRODUT
WHERE
	PCPRODUT.DESCRICAO LIKE 'M%'
UNION
SELECT
	PCPRODUT.CODPROD
FROM
	WINT.PCPRODUT
WHERE
	PCPRODUT.DESCRICAO LIKE '%O';


-- Traga os números de pedido feitos em março de 2024 
-- e os números de pedido feitos em abril de 2024.

SELECT
	PCPEDC.NUMPED,
	PCPEDC."DATA" AS DATA
FROM
	WINT.PCPEDC
WHERE
	EXTRACT(YEAR FROM PCPEDC."DATA") = 2024
	AND EXTRACT(MONTH FROM PCPEDC."DATA") = 3
UNION
	SELECT
	PCPEDC.NUMPED,
	PCPEDC."DATA"
FROM
	WINT.PCPEDC
WHERE
	EXTRACT(YEAR FROM PCPEDC."DATA") = 2024
	AND EXTRACT(MONTH FROM PCPEDC."DATA") = 4
ORDER BY 
	DATA;


-- Encontre os códigos de produto vendidos em Outubro de 2011
-- que não foram vendidos em Novembro de 2011.


SELECT DISTINCT
	PCPEDI.CODPROD
FROM
	WINT.PCPEDI
WHERE
	EXTRACT (YEAR FROM PCPEDI."DATA") = 2011
	AND EXTRACT (MONTH FROM PCPEDI."DATA") = 10
MINUS
SELECT 
	PCPEDI.CODPROD
FROM
	WINT.PCPEDI
WHERE
	EXTRACT (YEAR FROM PCPEDI."DATA") = 2011
	AND EXTRACT (MONTH FROM PCPEDI."DATA") = 11;

-- Liste os códigos de produto que aparecem em pedidos 
-- que também os códigos de produto cadastrados em PCPRODUT.


SELECT
	PCPEDI.CODPROD
FROM
	WINT.PCPEDI
INTERSECT
SELECT
	PCPRODUT.CODPROD
FROM
	WINT.PCPRODUT;

-- Mostre os números de pedido em que houve mais de 3 itens distintos 
-- e os números de pedido em que houve apenas 1 item distinto.

SELECT
	NUMPED
FROM (
	SELECT 
		PCPEDI.NUMPED,
		COUNT(DISTINCT PCPEDI.CODPROD)
	FROM
		WINT.PCPEDI
	GROUP BY
		PCPEDI.NUMPED
	HAVING
		COUNT(DISTINCT PCPEDI.CODPROD) > 3)
UNION
SELECT
	NUMPED
FROM (
	SELECT 
		PCPEDI.NUMPED,
		COUNT(DISTINCT PCPEDI.CODPROD)
	FROM
		WINT.PCPEDI
	GROUP BY
		PCPEDI.NUMPED
	HAVING
		COUNT(DISTINCT PCPEDI.CODPROD) = 1);


-- Liste os códigos de produto cujas descrições contenham 'USB' 
-- e os que contenham 'HDMI'.

SELECT
	PCPRODUT.CODPROD
FROM
	WINT.PCPRODUT
WHERE
	PCPRODUT.DESCRICAO LIKE '%USB%'
	OR PCPRODUT.DESCRICAO LIKE '%HDMI%';

-- se feito com UNION:

SELECT
	PCPRODUT.CODPROD
FROM
	WINT.PCPRODUT
WHERE
	PCPRODUT.DESCRICAO LIKE '%USB%'
UNION
SELECT
	PCPRODUT.CODPROD
FROM
	WINT.PCPRODUT
WHERE
	PCPRODUT.DESCRICAO LIKE '%HDMI%';


-- Traga os códigos de pedido feitos no primeiro semestre de 2024 
-- e os códigos de pedido feitos no segundo semestre de 2024.

SELECT
	PCPEDC.NUMPED
FROM
	WINT.PCPEDC
WHERE
	PCPEDC."DATA" BETWEEN '01/01/2024' AND '30/06/2024';


-- Encontre os códigos de produto que aparecem em PCPEDC (via PCPEDI) 
-- e subtraia os que também aparecem na lista de códigos de PCPRODUT com marca vazia.

SELECT
	DISTINCT PCPEDI.CODPROD
FROM
	WINT.PCPEDI
MINUS
SELECT
	PCPRODUT.CODPROD
FROM
	WINT.PCPRODUT
WHERE
	PCPRODUT.MARCA IS NULL 
	OR PCPRODUT.MARCA = '';
	

-- Liste os códigos de pedido em que a soma de QT foi menor que 200 
-- e os códigos de pedido em que a soma de QT for aproximadamente 253.

SELECT
	CODPROD
FROM (
	SELECT
		PCPEDI.CODPROD,
		SUM(PCPEDI.QT)
	FROM
		WINT.PCPEDI
	GROUP BY
		PCPEDI.CODPROD
	HAVING
		SUM(PCPEDI.QT) < 200)
UNION
SELECT
	CODPROD
FROM(
	SELECT
		PCPEDI.CODPROD,
		SUM(PCPEDI.QT)
	FROM
		WINT.PCPEDI
	GROUP BY
		PCPEDI.CODPROD
	HAVING
		SUM(PCPEDI.QT) BETWEEN 250 AND 255);



--CONSULTA QUE TRAGA SOMENTE OS PRODUTOS QUE POSSUEM FORNECEDOR CADASTRADO. APRESENTANDO, PRODUTO EM ORDEM ALFABÉTICA, MARCA E FORNECEDOR;

SELECT
	PCPRODUT.DESCRICAO,
	PCPRODUT.MARCA,
	PCFORNEC.FORNECEDOR
FROM 
	WINT.PCPRODUT
	INNER JOIN WINT.PCFORNEC
		ON PCPRODUT.CODFORNEC = PCFORNEC.CODFORNEC
ORDER BY
	PCPRODUT.DESCRICAO;

--CONSULTA QUE TRAGA SOMENTE OS REPRESENTANTES QUE POSSUEM SUPERVISOR VINCULADO NA TABELA DE SUPERVISORES, POR ORDEM ALFABÉTICA;

SELECT
	PCUSUARI.NOME AS NOME_REPRESENTANTE,
	PCSUPERV.NOME AS NOME_SUPERVISOR
FROM
	WINT.PCUSUARI
	INNER JOIN WINT.PCSUPERV
		ON PCUSUARI.CODSUPERVISOR = PCSUPERV.CODSUPERVISOR
ORDER BY
	NOME_REPRESENTANTE,
	NOME_SUPERVISOR;


--CONSULTA QUE TRAGA TODOS OS PEDIDOS E A QUANTIDADE DE ITENS DE CADA PEDIDO, ORDENANDO POR PEDIDOS COM MAIOR QUANTIDADE PRIMEIRO. (APENAS NUMERO DO PEDIDO E QUANTIDADE DE ITENS)

-- PCPEDI POSSUI NUMERO DE PEDIDO E QUANTIDADE DE ITENS, SERIA FEITO ASSIM:
SELECT
	PCPEDI.NUMPED,
	SUM(PCPEDI.QT)
FROM
	WINT.PCPEDI
GROUP BY
	PCPEDI.NUMPED;

-- MAS ACREDITO QUE QUERIA QUE FOSSE FEITO ASSIM:
SELECT
	PCPEDC.NUMPED,
	SUM(PCPEDI.QT) AS QTD_ITENS
FROM
	WINT.PCPEDC
	INNER JOIN WINT.PCPEDI
		ON PCPEDC.NUMPED = PCPEDI.NUMPED
GROUP BY
	PCPEDC.NUMPED
ORDER BY
	QTD_ITENS DESC;



-- Traga a média de venda para cada mês do ano de 2023

SELECT
	EXTRACT (MONTH FROM PCPEDC."DATA") 	AS MES_2023,
	ROUND(AVG(PCPEDC.VLTOTAL), 2)		AS MEDIA_VLTOTAL
FROM 
	WINT.PCPEDC
WHERE
	EXTRACT (YEAR FROM PCPEDC."DATA") = 2023
GROUP BY
	EXTRACT (MONTH FROM PCPEDC."DATA")
ORDER BY
	EXTRACT (MONTH FROM PCPEDC."DATA")

-- Liste os produtos (código e nome) cujo total vendido (soma de QT) entre 01/10/2011 e 30/11/2011 
-- seja maior que a média de vendas de todos os produtos nesse mesmo período.

SELECT
	PCPEDI.CODPROD,
	PCPRODUT.DESCRICAO,
	SUM(PCPEDI.QT) AS QTD_VENDIDO
FROM
	WINT.PCPEDI
	INNER JOIN WINT.PCPRODUT
		ON PCPEDI.CODPROD = PCPRODUT.CODPROD
WHERE
	PCPEDI."DATA" BETWEEN 
						TO_DATE('01/10/2011','DD/MM/YYYY') 
						AND TO_DATE('30/11/2011','DD/MM/YYYY')
GROUP BY
	PCPEDI.CODPROD,
	PCPRODUT.DESCRICAO
HAVING
	SUM(PCPEDI.QT) > (
		SELECT 
			AVG(SOMA_QTD.QTD_TOTAL)
		FROM(
			SELECT 
				SUM(SUBPCPEDI.QT) AS QTD_TOTAL
			FROM
				WINT.PCPEDI SUBPCPEDI
			WHERE
				SUBPCPEDI."DATA" BETWEEN 
										TO_DATE('01/10/2011','DD/MM/YYYY') 
										AND TO_DATE('30/11/2011','DD/MM/YYYY')
			GROUP BY
				SUBPCPEDI.CODPROD
			) SOMA_QTD);



-- Apresente os números de pedido cuja VLTOTAL seja igual ao maior valor registrado
-- em todo o período de janeiro/2023 a dezembro/2024.

SELECT
	PCPEDC.NUMPED,
	PCPEDC.VLTOTAL
FROM
	WINT.PCPEDC
WHERE
	PCPEDC.VLTOTAL = 
		(
		SELECT
			MAX(SUBPEDC.VLTOTAL)
		FROM
			WINT.PCPEDC SUBPEDC
		WHERE
			SUBPEDC."DATA" BETWEEN
								TO_DATE('01/01/2023', 'DD/MM/YYYY')
								AND TO_DATE('31/12/2024', 'DD/MM/YYYY'));

-- Liste os produtos (código e nome) que foram vendidos ao menos uma vez em outubro de 2011.

SELECT
	PCPRODUT.CODPROD,
	PCPRODUT.DESCRICAO
FROM
	WINT.PCPRODUT
WHERE
	PCPRODUT.CODPROD IN
	(
	SELECT
		PCPEDI.CODPROD
	FROM
		WINT.PCPEDI
	WHERE
		PCPEDI."DATA" BETWEEN
						TO_DATE('01/10/2011', 'DD/MM/YYYY')
						AND TO_DATE('31/10/2011', 'DD/MM/YYYY')); 


-- Encontre os números de pedido que não tiveram nenhum item com quantidade maior que 5.

SELECT
    PCPEDC.NUMPED
FROM 
	WINT.PCPEDC
WHERE NOT EXISTS (
    SELECT 
    	PCPEDI.NUMPED
    FROM 
    	WINT.PCPEDI
    WHERE 
    	PCPEDI.NUMPED = PCPEDC.NUMPED
      	AND PCPEDI.QT > 5
);

-- Traga os fornecedores que cadastraram pelo menos um produto (via PCPRODUT).

SELECT
	PCFORNEC.CODFORNEC,
	PCFORNEC.FORNECEDOR
FROM
	WINT.PCFORNEC
WHERE 
	EXISTS (
		SELECT
			PCPRODUT.CODFORNEC
		FROM
			WINT.PCPRODUT
		WHERE
			PCPRODUT.CODFORNEC = PCFORNEC.CODFORNEC);

SELECT DISTINCT
    Fornecedor.CODFORNEC,
    Fornecedor.FORNECEDOR
FROM WINT.PCFORNEC Fornecedor
WHERE EXISTS (
    SELECT 1
    FROM WINT.PCPRODUT Produto2
    WHERE Produto2.CODFORNEC = Fornecedor.CODFORNEC
);

-- Liste os produtos (código e descrição) cujo **preço de venda máximo** (PVENDA) 
-- seja **menor** que a **média** de todos os PVENDA registrados em itens de pedido.


SELECT
	PCPRODUT.CODPROD,
	PCPRODUT.DESCRICAO
FROM
	WINT.PCPRODUT
WHERE
	(
	SELECT
		MAX(PCPEDI.PVENDA)
	FROM
		WINT.PCPEDI
	WHERE
		PCPEDI.CODPROD = PCPRODUT.CODPROD
	) > (
		SELECT
			AVG(PCPEDI.PVENDA)
		FROM
			WINT.PCPEDI);


 
-- Em cada produto, exiba código, descrição e uma coluna "QT_PEDIDOS" 
-- que traz a quantidade de pedidos distintos em que o produto apareceu entre 01/10/2011 e 30/11/2011.
-- (subselect no SELECT)

SELECT
	PCPRODUT.CODPROD,
	PCPRODUT.DESCRICAO,
	(
		SELECT 
			COUNT(DISTINCT PCPEDI.NUMPED) 
		FROM 
			WINT.PCPEDI 
		WHERE 
			PCPRODUT.CODPROD = PCPEDI.CODPROD
			AND PCPEDI."DATA" BETWEEN
									TO_DATE('01/10/2011','DD/MM/YYYY') 
									AND TO_DATE('30/11/2011','DD/MM/YYYY') 
	)AS QTD_PEDIDOS
FROM
	WINT.PCPRODUT;

-- Mostrar código e descrição de cada produto, acompanhado do número de pedidos distintos em que ele foi vendido entre outubro e novembro de 2011.

SELECT
	PCPRODUT.CODPROD,
	PCPRODUT.DESCRICAO,
	(
		SELECT
			COUNT(DISTINCT PCPEDI.NUMPED)
		FROM
			WINT.PCPEDI
		WHERE
			PCPEDI.CODPROD = PCPRODUT.CODPROD
			AND PCPEDI."DATA" BETWEEN
									TO_DATE('01/10/2011', 'DD/MM/YYYY')
									AND TO_DATE('30/11/2011', 'DD/MM/YYYY')
	)AS PEDIDOS_DISTINTOS
FROM 
	WINT.PCPRODUT
;



-- Para cada pedido de 2023, trazer o número do pedido, a data e o código do produto que teve a maior quantidade vendida naquele pedido.

SELECT
	PCPEDC.NUMPED,
	PCPEDC."DATA",
	(
		SELECT
			MAX(PCPEDI.QT)
		FROM
			WINT.PCPEDI
		WHERE
			PCPEDI.NUMPED = PCPEDC.NUMPED
	) AS MAIOR_QTD_VENDIDA
FROM
	WINT.PCPEDC
WHERE
	EXTRACT(YEAR FROM PCPEDC."DATA") = 2023
ORDER BY
	PCPEDC.NUMPED;
	


-- Apresentar o nome de cada fornecedor e o total de unidades de seus produtos vendidas em 2011, exibindo apenas quem superou a média anual de vendas por fornecedor.


SELECT
	PCFORNEC.FORNECEDOR,
	SUM(PCPEDI.QT)
FROM
	WINT.PCFORNEC
	INNER JOIN WINT.PCPRODUT
		ON PCFORNEC.CODFORNEC = PCPRODUT.CODFORNEC
	INNER JOIN WINT.PCPEDI
		ON PCPRODUT.CODPROD = PCPEDI.CODPROD
GROUP BY
	PCFORNEC.FORNECEDOR
HAVING
	SUM(PCPEDI.QT) > (
						SELECT
							AVG(MEDIA_TOTAL.TOTAL_POR_FORNECEDOR)
						FROM
							(
							SELECT
								SUM(SUBPCPEDI.QT) AS TOTAL_POR_FORNECEDOR
							FROM
								WINT.PCPEDI SUBPCPEDI
								INNER JOIN WINT.PCPRODUT SUBPCPRODUT
									ON SUBPCPEDI.CODPROD = SUBPCPRODUT.CODPROD
							WHERE
								EXTRACT(YEAR FROM SUBPCPEDI."DATA") = 2011
								GROUP BY
									SUBPCPRODUT.CODFORNEC
								) MEDIA_TOTAL
					 );



-- Mostrar, para cada produto vendido entre 01/10/2011 e 30/11/2011, o código, a descrição e quantos pedidos distintos o incluíram. 

SELECT
	PCPEDI.CODPROD,
	PCPRODUT.DESCRICAO,
	COUNT(DISTINCT NUMPED) AS PEDIDOS_DISTINTOS
FROM
	WINT.PCPEDI
	INNER JOIN WINT.PCPRODUT
		ON PCPEDI.CODPROD = PCPRODUT.CODPROD
WHERE
	PCPEDI."DATA" BETWEEN 
						TO_DATE('01/10/2011','DD/MM/YYYY') 
                   		AND TO_DATE('30/11/2011','DD/MM/YYYY')
GROUP BY
	PCPEDI.CODPROD,
	PCPRODUT.DESCRICAO
ORDER BY
	PCPEDI.CODPROD ASC;

-- ou em subselect

SELECT DISTINCT
	PCPEDI.CODPROD,
	PCPRODUT.DESCRICAO,
	(
		SELECT
			COUNT(DISTINCT SUBPCPEDI.NUMPED)
		FROM
			WINT.PCPEDI SUBPCPEDI
		WHERE
			SUBPCPEDI.CODPROD = PCPEDI.CODPROD
			AND SUBPCPEDI."DATA" BETWEEN TO_DATE('01/10/2011','DD/MM/YYYY') 
                                   AND TO_DATE('30/11/2011','DD/MM/YYYY')
	) PEDIDOS_DISTINTOS
FROM
	WINT.PCPEDI
	INNER JOIN WINT.PCPRODUT
		ON PCPEDI.CODPROD = PCPRODUT.CODPROD
WHERE
	PCPEDI."DATA" BETWEEN
						TO_DATE('01/10/2011', 'DD/MM/YYYY')
						AND TO_DATE('30/11/2011', 'DD/MM/YYYY')
ORDER BY
	PCPEDI.CODPROD ASC;


-- Listar os pedidos de outubro e novembro de 2011 que tiveram menos que 1% de desconto(PERDESC < 1)

SELECT
	PCPEDI.NUMPED
FROM
	WINT.PCPEDI
WHERE
	PCPEDI."DATA" BETWEEN
						TO_DATE('01/10/2011', 'DD/MM/YYYY')
						AND TO_DATE('30/11/2011', 'DD/MM/YYYY')
GROUP BY
	PCPEDI.NUMPED
HAVING
	COUNT(1) = COUNT(
						CASE
							WHEN PCPEDI.PERDESC < 1  THEN 1
						END	
					);

-- Crie uma lista com o código do produto e o total vendido (soma de QT) no mesmo período, 
-- usando uma subquery no FROM para calcular primeiro a soma por produto.

SELECT
	SOMAR_POR_PRODUTO.CODPROD,
	SOMAR_POR_PRODUTO.QTD_VENDIDA
FROM
	(SELECT
		PCPEDI.CODPROD,
		SUM(PCPEDI.QT) QTD_VENDIDA
	FROM
		WINT.PCPEDI
	WHERE
		PCPEDI."DATA" BETWEEN
							TO_DATE('01/10/2011','DD/MM/YYYY') 
							AND TO_DATE('30/11/2011','DD/MM/YYYY') 
	GROUP BY
		PCPEDI.CODPROD
) SOMAR_POR_PRODUTO;

-- Liste os números de pedido de 2023 que tenham mais de 4 itens no total,
-- determinando isso com um subselect no WHERE que conta as linhas de PCPEDI.

SELECT
	PCPEDC.NUMPED
FROM
	WINT.PCPEDC
WHERE
	EXTRACT(YEAR FROM PCPEDC."DATA") = 2023
	AND
	 (
		SELECT
			COUNT(PCPEDI.CODPROD)
		FROM
			WINT.PCPEDI
		WHERE
			PCPEDI.NUMPED = PCPEDC.NUMPED
	) > 4;


-- Exiba todos os produtos cujo total vendido (soma de QT em out/nov 2011) 
-- seja maior que 100, usando subselect no WHERE para calcular o total por produto.

SELECT
	PCPRODUT.CODPROD,
	PCPRODUT.DESCRICAO
FROM
	WINT.PCPRODUT
WHERE
	(SELECT
		SUM(PCPEDI.QT)
	FROM
		WINT.PCPEDI PCPEDI
	WHERE
		PCPEDI.CODPROD = PCPRODUT.CODPROD
		AND
		PCPEDI."DATA" BETWEEN
							TO_DATE('01/10/2011', 'DD/MM/YYYY')
							AND TO_DATE('30/11/2011','DD/MM/YYYY')
	GROUP BY
		PCPEDI.CODPROD) > 100;


-- Agrupe os pedidos de 2023 por mês (YYYY-MM) e exiba mês e soma de VLTOTAL,
-- mas só inclua meses cuja soma mensal ultrapasse a média mensal de todo o ano.
-- (subselect no HAVING)

SELECT
	EXTRACT (MONTH FROM PCPEDC."DATA") 							AS MES_2023,
	ROUND(AVG(PCPEDC.VLTOTAL), 2)								AS MEDIA_VLTOTAL
FROM 
	WINT.PCPEDC
WHERE
	EXTRACT (YEAR FROM PCPEDC."DATA") = 2023
GROUP BY
	EXTRACT (MONTH FROM PCPEDC."DATA")
HAVING
	ROUND(SUM(PCPEDC.VLTOTAL), 2) >
	(
		SELECT
			ROUND(AVG(SOMA_MENSAL), 2)							AS MEDIA_VLTOTAL
		FROM 
			(
			SELECT 
				SUM(SUBPCPEDC.VLTOTAL) 							AS SOMA_MENSAL
			FROM
				WINT.PCPEDC SUBPCPEDC
			WHERE
				EXTRACT (YEAR FROM SUBPCPEDC."DATA") = 2023
			GROUP BY
				EXTRACT (MONTH FROM SUBPCPEDC."DATA")
			)
	)
ORDER BY
	EXTRACT (MONTH FROM PCPEDC."DATA");


-- Para cada produto, calcule soma de QT em out/nov 2011 e inclua apenas 
-- aqueles cujo valor está acima da média de soma de todos os produtos. 
-- (subselect no HAVING sobre agregação)

SELECT
	PCPEDI.CODPROD,
	SUM(PCPEDI.QT) AS QT_TOTAL
FROM 
	WINT.PCPEDI
WHERE
	PCPEDI."DATA" BETWEEN
						TO_DATE('01/10/2011', 'DD/MM/YYYY')
						AND TO_DATE('30/11/2011', 'DD/MM/YYYY')
GROUP BY
	PCPEDI.CODPROD
HAVING
	SUM(PCPEDI.QT) > (
						SELECT
							AVG(CALCULO.SOMA_MEDIA)
						FROM
							(
								SELECT
									SUM(SUBPCPEDI.QT) AS SOMA_MEDIA
								FROM
									WINT.PCPEDI SUBPCPEDI
								GROUP BY
									SUBPCPEDI.CODPROD
							) CALCULO
						);

-- Monte um relatório de pedidos de 2024 que, no SELECT, mostre número do pedido, VLTOTAL 
-- e uma coluna "ITENS_DISTINTOS" obtida por subselect que conte `COUNT(DISTINCT CODPROD)` em PCPEDI.

-- subselect no select
SELECT
	PCPEDC.NUMPED,
	PCPEDC.VLTOTAL,
	(
		SELECT
			COUNT(DISTINCT PCPEDI.CODPROD)
		FROM
			WINT.PCPEDI
		WHERE
			PCPEDI.NUMPED = PCPEDC.NUMPED
		GROUP BY
			PCPEDI.NUMPED
	) AS ITENS_DISTINTOS
FROM
	WINT.PCPEDC
WHERE
	EXTRACT(YEAR FROM PCPEDC."DATA") = 2024;


-- subselect no from
SELECT
	PCPEDC.NUMPED,
	PCPEDC.VLTOTAL,
	SUBPCPEDI.ITENS_DISTINTOS
FROM
	WINT.PCPEDC
	INNER JOIN (
					SELECT
						PCPEDI.NUMPED,
						COUNT(DISTINCT PCPEDI.CODPROD) AS ITENS_DISTINTOS
					FROM
						WINT.PCPEDI
					GROUP BY
						PCPEDI.NUMPED
				) SUBPCPEDI
		ON PCPEDC.NUMPED = SUBPCPEDI.NUMPED;


-- Liste os fornecedores que aparecem em PCPRODUT, mas sem repetir, 
-- usando um subselect no FROM para extrair códigos distintos de fornecedores.


SELECT
	FORNECEDORES_DISTINTOS.COD_FORNECEDORES
FROM
	(
		SELECT
			DISTINCT PCPRODUT.CODFORNEC AS COD_FORNECEDORES
		FROM
			WINT.PCPRODUT
	) FORNECEDORES_DISTINTOS;

SELECT
	PCPEDI.NUMPED
FROM
	WINT.PCPEDI
WHERE
	PCPEDI."DATA" BETWEEN
						TO_DATE('01/10/2011', 'DD/MM/YYYY')
						AND TO_DATE('30/11/2011', 'DD/MM/YYYY')
GROUP BY
	PCPEDI.NUMPED
HAVING
	COUNT(1) = COUNT(
						CASE
							WHEN PCPEDI.PERDESC < 1  THEN 1
						END	
					);

-- Crie uma consulta que mostre, para cada supervisor que tenha representantes vendendo produtos da marca "VERSOTOOLS" em 2024:
--   • Código do supervisor e nome do supervisor
--   • Soma total de vendas (VLTOTAL) de todos os pedidos faturados com valor maior que R$ 2.000,00
--   • Quantidade de clientes distintos que compraram esses produtos
--   • Média de unidades vendidas por pedido (soma de QT dividido pelo número de pedidos)
--   • Quantidade de dias distintos em que houve pelo menos uma venda desses produtos
--   • Código e descrição do representante que obteve a maior venda individual (VLTOTAL) dentro do grupo desse supervisor
--
-- Use apenas as tabelas PCPEDC, PCPEDI, PCUSUARI, PCSPERV, PCPRODUT, PCCLIENT, e evite subqueries se possível. As regras:
--   • Considere apenas pedidos faturados (POSICAO = 'F') de 2024.
--   • Inclua somente vendas de produtos cuja MARCA = 'VERSOTOOLS' e cujo valor total do pedido seja > 2000.
--   • Ordene o resultado pelo nome do supervisor em ordem alfabética.


  SELECT PCPEDC.CODSUPERVISOR,
  		 PCSUPERV.NOME													AS NOME_SUPERVISOR,
	     SUM(PCPEDC.VLTOTAL) 											AS TOTAL_VENDAS,
	     COUNT(DISTINCT PCPEDC.CODCLI) 									AS CLIENTES_DISTINTOS,
	     ROUND(SUM(PCPEDI.QT) / COUNT(DISTINCT PCPEDI.NUMPED), 2) 		AS MEDIA_UNIDADES_VENDIDAS,
	     COUNT(DISTINCT PCPEDC.DATA) 									AS QTD_DIAS_POSITIVADOS,
  		 MAX(PCPEDI.QT * PCPEDI.PVENDA)									AS MAIOR_VENDA
    FROM WINT.PCPEDC
    JOIN WINT.PCPEDI
      ON PCPEDC.NUMPED = PCPEDI.NUMPED
     AND PCPEDI.POSICAO = 'F'
    JOIN WINT.PCPRODUT
      ON PCPEDI.CODPROD = PCPRODUT.CODPROD
    JOIN WINT.PCUSUARI
      ON PCPEDC.CODUSUR = PCUSUARI.CODUSUR
    JOIN WINT.PCSUPERV
      ON PCUSUARI.CODSUPERVISOR = PCSUPERV.CODSUPERVISOR
   WHERE PCPRODUT.MARCA = 'VERSOTOOLS'
     AND EXTRACT(YEAR FROM PCPEDC.DATA) = 2024
GROUP BY PCPEDC.CODSUPERVISOR,
		 PCSUPERV.NOME
  HAVING SUM(PCPEDC.VLTOTAL) > 2000
ORDER BY PCSUPERV.NOME;


/*Crie uma única query que, para cada supervisor que teve representantes vendendo produtos da marca “VERSOTOOLS” em março de 2024, identifique o representante que comercializou o maior número de SKUs distintos nesse mês, exibindo o nome do supervisor, o nome do representante, a quantidade de SKUs diferentes vendidos e o total de vendas (soma de QT×PVENDA) desse representante em março de 2024, considerando apenas pedidos faturados; ordene o resultado pelo nome do supervisor.
 */

  SELECT PCSUPERV.NOME AS NOME_SUPERVISOR,
	     PCUSUARI.NOME AS NOME_REPRESENTANTE,
	     COUNT(DISTINCT PCPEDI.CODPROD) AS SKU_ITENS,
	     SUM(PCPEDI.QT * PCPEDI.PVENDA) AS TOTAL_VENDAS
	FROM WINT.PCPEDC
	JOIN WINT.PCPEDI
	  ON PCPEDC.NUMPED = PCPEDI.NUMPED
	 AND PCPEDI.POSICAO = 'F'
	JOIN WINT.PCPRODUT
	  ON PCPEDI.CODPROD = PCPRODUT.CODPROD
	 AND PCPRODUT.MARCA = 'VERSOTOOLS'
	JOIN WINT.PCUSUARI
	  ON PCPEDC.CODUSUR = PCUSUARI.CODUSUR
	JOIN WINT.PCSUPERV
	  ON PCUSUARI.CODSUPERVISOR = PCSUPERV.CODSUPERVISOR
   WHERE EXTRACT(YEAR FROM PCPEDC.DATA) = 2024
   	 AND EXTRACT(MONTH FROM PCPEDC.DATA) = 3
GROUP BY PCSUPERV.NOME,
       	 PCUSUARI.NOME
ORDER BY NOME_SUPERVISOR;

-- Sua tarefa é escrever uma única consulta SQL que, ao considerar somente os itens concluídos e pertencentes à marca VERSOTOOLS durante o mês de outubro de 2011, retorne para cada produto o seu identificador, descrição, o total em valor vendido (calculado pelo preço de venda vezes a quantidade), a quantidade de pedidos distintos nos quais ele apareceu, o total de unidades vendidas e o nome do fornecedor que o atende. Não é necessário detalhar exatamente de quais tabelas ou colunas cada campo vem; basta garantir que os critérios de filtro (itens finalizados, mês/ano corretos e marca VERSOTOOLS) sejam aplicados antes de agrupar pelo produto e exibir os resultados solicitados.
  
  
  SELECT PCPRODUT.CODPROD								AS CODIGO_PRODUTO,
  		 PCPRODUT.DESCRICAO,
  		 SUM(PCPEDI.QT * PCPEDI.PVENDA) 				AS TOTAL_VENDIDO,
  		 COUNT(DISTINCT PCPEDI.NUMPED) 					AS QTD_PEDIDOS,
  		 SUM(PCPEDI.QT) 								AS TOTAL_UNIDADES,
  		 PCFORNEC.FORNECEDOR
    FROM WINT.PCPEDI
    JOIN WINT.PCPRODUT
      ON PCPEDI.CODPROD = PCPRODUT.CODPROD
     AND PCPRODUT.MARCA = 'VERSOTOOLS'
    JOIN WINT.PCFORNEC
      ON PCPRODUT.CODFORNEC = PCFORNEC.CODFORNEC
   WHERE PCPEDI.POSICAO = 'F'
   	 AND EXTRACT(YEAR FROM PCPEDI.DATA) = 2011
     AND EXTRACT(MONTH FROM PCPEDI.DATA) = 10
GROUP BY PCPRODUT.CODPROD,
  		 PCPRODUT.DESCRICAO,
  		 PCFORNEC.FORNECEDOR
ORDER BY PCPRODUT.CODPROD;


-- Relatório de vendas por representante em 2024
-- 
-- Objetivo: Para cada representante (CODUSUR), apresentar:
--   1) Total acumulado de vendas no ano de 2024
--   2) Quantidade de pedidos finalizados em 2024
--   3) Média do valor por pedido em 2024
--   4) Data do último pedido concluído em 2024
--
-- Critério: considerar apenas pedidos com status finalizado ao longo de 2024.
-- Agrupar resultados por representante.

  SELECT PCUSUARI.CODUSUR,
  		 PCUSUARI.NOME,
  		 SUM(PCPEDC.VLTOTAL)				AS TOTAL_ACUMULADO,
  	     COUNT(DISTINCT PCPEDC.NUMPED) 		AS QTD_PEDIDOS,
  	     ROUND(AVG(PCPEDC.VLTOTAL), 2) 		AS MEDIA_VALOR,
  	     MAX(PCPEDC.DATA) 					AS ULTIMO_PEDIDO
	FROM WINT.PCPEDC
	JOIN WINT.PCUSUARI
	  ON PCPEDC.CODUSUR = PCUSUARI.CODUSUR
   WHERE PCPEDC.POSICAO = 'F'
  	 AND EXTRACT(YEAR FROM PCPEDC.DATA) = 2024
GROUP BY PCUSUARI.CODUSUR,
  		 PCUSUARI.NOME
ORDER BY PCUSUARI.CODUSUR;

/* Imagine que o diretor pediu para você preparar um levantamento sobre o desempenho de cada fornecedor nos meses finais de 2024. Ele quer entender, de forma geral, como cada fornecimento se traduziu em receita, quantos itens foram movimentados e qual foi o preço médio cobrado, mas não deixou tudo na ponta do lápis — apenas indicou que fosse considerado o período de outubro a dezembro e que filtrássemos apenas os registros finalizados. Em outras palavras, ele espera uma única consulta que revele, para cada fornecedor ativo, o total de vendas gerado por seus produtos, a quantidade de itens comercializados e o valor médio praticado por unidade, levando em conta somente o estágio de pedido “F” e a janela de datas indicada.
 */

  SELECT PCFORNEC.CODFORNEC							AS CODIGO_FORNECEDOR,
  		 PCFORNEC.FORNECEDOR,						
  		 SUM(PCPEDI.PVENDA * PCPEDI.QT) 			AS TOTAL_VENDA,
  		 SUM(PCPEDI.QT)								AS QTD_COMERCIALIZADA,
  		 ROUND(AVG(PCPEDI.PVENDA), 2)				AS PRECO_MEDIO
	FROM WINT.PCPEDI
	JOIN WINT.PCPRODUT
      ON PCPEDI.CODPROD = PCPRODUT.CODPROD
    JOIN WINT.PCFORNEC
      ON PCPRODUT.CODFORNEC = PCFORNEC.CODFORNEC
   WHERE PCPEDI.POSICAO = 'F'
   	 AND PCPEDI.DATA BETWEEN TO_DATE('01/10/2011', 'DD/MM/YYYY')
   	 					 AND TO_DATE('31/12/2011', 'DD/MM/YYYY')
GROUP BY PCFORNEC.CODFORNEC,
  		 PCFORNEC.FORNECEDOR
ORDER BY PCFORNEC.CODFORNEC;

 /* Seu gestor solicitou um levantamento dos produtos da marca VERSOSQL vendidos ao longo de 2011. Ele não especificou tudo em detalhes, mas quer ter uma visão geral do desempenho desses produtos, especialmente daqueles que geraram valor de venda. Com base nisso, prepare uma única consulta SQL que permita responder às seguintes questões de forma implícita: quais produtos da marca foram vendidos, quanto cada um rendeu em valor total, quantos pedidos distintos eles apareceram e quando foi a última vez que cada produto foi vendido. Lembre-se de considerar apenas registros finalizados no ano de 2023.
  */
  
  SELECT PCPEDI.CODPROD,
  		 SUM(PCPEDI.PVENDA * PCPEDI.QT) 		AS VALOR_TOTAL,
  		 COUNT(DISTINCT PCPEDI.NUMPED)			AS QTD_PEDIDOS,
  		 MAX(PCPEDI.DATA) 						AS ULTIMO_PEDIDO
	FROM WINT.PCPEDI
	JOIN WINT.PCPRODUT
	  ON PCPEDI.CODPROD = PCPRODUT.CODPROD
	 AND PCPRODUT.MARCA = 'VERSOSQL'
   WHERE PCPEDI.POSICAO = 'F'
     AND EXTRACT (YEAR FROM PCPEDI.DATA) = 2011
GROUP BY PCPEDI.CODPROD
ORDER BY PCPEDI.CODPROD;
  

/*
 O diretor quer compreender melhor como cada representante e cada fornecedor estão interligados nas vendas de 2024, mas não deixou tudo explicito. Ele espera que você crie uma única consulta capaz de cruzar informações de representantes, pedidos, itens, produtos e fornecedores para exibir, para cada combinação de representante e fornecedor, quantos itens foram vendidos e quanto isso gerou em receita ao longo do ano. O filtro principal é considerar apenas pedidos e itens finalizados em 2011, mas não explique passo a passo qual coluna vem de qual tabela—tratá-las como dados prontos que devem se cruzar para revelar as parcerias entre reps e fornecedores.
 */
  
  SELECT PCPEDI.CODUSUR 												AS COD_REPRESENTANTE,
  		 (CASE
  		 	WHEN PCUSUARI.NOME IS NULL THEN 'Sem nome cadastrado'
  		 	ELSE PCUSUARI.NOME
  		 END)  															AS REPRESENTANTE,
  		 PCFORNEC.FORNECEDOR											AS FORNECEDOR,
  		 SUM(PCPEDI.QT) 												AS QTD_ITENS,
  		 SUM(PCPEDI.PVENDA * PCPEDI.QT)									AS RECEITA_TOTAL
 	FROM WINT.PCPEDI
 	LEFT JOIN WINT.PCUSUARI
 	  ON PCPEDI.CODUSUR = PCUSUARI.CODUSUR
 	LEFT JOIN WINT.PCPRODUT
 	  ON PCPEDI.CODPROD = PCPRODUT.CODPROD
 	JOIN WINT.PCFORNEC
 	  ON PCPRODUT.CODFORNEC = PCFORNEC.CODFORNEC
   WHERE PCPEDI.POSICAO = 'F'
     AND EXTRACT(YEAR FROM PCPEDI.DATA) = 2011
GROUP BY PCPEDI.CODUSUR,
  		 PCUSUARI.NOME,
  		 PCFORNEC.FORNECEDOR
ORDER BY PCPEDI.CODUSUR;
  
  
  
/*
 O diretor quer entender não apenas quanto cada representante vendeu em 2024, mas também como eles se comportaram a cada mês, qual a participação de cada um no total daquele período e em que posição ficaram dentro do grupo para cada mês. Para isso, ele espera um único relatório que liste, para cada representante e para cada mês de 2024, o valor total vendido, o número de pedidos finalizados, a participação percentual desse valor em relação ao acumulado de vendas daquele mês e a classificação do representante naquele mês por valor de vendas. Use filtros para considerar apenas registros finalizados e trabalhe com agregações e funções de janela para obter percentual e ranking.
 */
  
  SELECT EXTRACT(MONTH FROM PCPEDC.DATA) 	AS MES,
   		 SUM(PCPEDC.VLTOTAL) 				AS TOTAL_VENDIDO,
  		 COUNT(DISTINCT PCPEDC.NUMPED) 		AS QTD_PEDIDOS,
  		 ROUND((COUNT(DISTINCT PCPEDC.NUMPED) / SUM(PCPEDC.VLTOTAL) * 100), 2)  AS PERCENTUAL_MES
    FROM WINT.PCPEDC
   WHERE PCPEDC.POSICAO = 'F'
     AND PCPEDC.DATA BETWEEN TO_DATE('01/01/2024', 'DD/MM/YYYY')
   						 AND TO_DATE('31/12/2024', 'DD/MM/YYYY')
GROUP BY EXTRACT(MONTH FROM PCPEDC.DATA)
ORDER BY MES;

-- Relatório solicitado: Produtos da marca VERSOTOOLS que venderam acima da média da própria marca em 2011.
-- 
-- Objetivo: Apresentar os produtos da marca VERSOTOOLS cuja receita total de vendas em 2011 foi superior à média de receita de todos os produtos da mesma marca no mesmo período.
-- 
-- Para cada produto listado, exibir: código do produto, descrição, valor total vendido e quantidade total vendida.
-- Considere apenas registros finalizados e vendas do ano de 2011.

  
  SELECT PCPRODUT.CODPROD,
  		 PCPRODUT.DESCRICAO,
  		 SUM(PCPEDI.PVENDA * PCPEDI.QT) 	AS VALOR_TOTAL,
  		 SUM(PCPEDI.QT) 					AS QTD_TOTAL_VENDIDA
    FROM WINT.PCPEDI
    JOIN WINT.PCPRODUT
      ON PCPEDI.CODPROD = PCPRODUT.CODPROD
     AND PCPRODUT.MARCA = 'VERSOTOOLS'
   WHERE EXTRACT(YEAR FROM PCPEDI.DATA) = 2011
GROUP BY PCPRODUT.CODPROD,
  		 PCPRODUT.DESCRICAO
  HAVING SUM(PCPEDI.PVENDA * PCPEDI.QT)> (
							  		 	  SELECT ROUND(AVG(TABELA_SOMA.SOMA_VALOR), 2)
										    FROM (
											    	  SELECT SUBPCPEDI.CODPROD,
											    	   		  SUM(SUBPCPEDI.PVENDA * SUBPCPEDI.QT) AS SOMA_VALOR
											    	    FROM WINT.PCPEDI SUBPCPEDI
											    	    JOIN WINT.PCPRODUT SUBPCPRODUT
											    	      ON SUBPCPEDI.CODPROD = SUBPCPRODUT.CODPROD
											    	     AND SUBPCPRODUT.MARCA = 'VERSOTOOLS'
											    	   WHERE EXTRACT(YEAR FROM SUBPCPEDI.DATA) = 2011
										    	    GROUP BY SUBPCPEDI.CODPROD
												 ) TABELA_SOMA
  		 	 							 )
ORDER BY PCPRODUT.CODPROD;



-- Liste os códigos e nomes dos representantes cujo total de vendas em 2024
-- superou a média de vendas de todos os representantes no mesmo período.
-- Para cada um, exiba o total acumulado de vendas e a quantidade de pedidos finalizados.
-- Considere apenas registros com POSICAO = 'F' em PCPEDC e agrupe por representante.

  SELECT PCPEDC.CODUSUR 						AS CODIGO_REPRESENTANTE,
  		 PCUSUARI.NOME,
	 	 SUM(PCPEDC.VLTOTAL) 					AS ACUMULADO_VENDAS,
  		 COUNT(DISTINCT PCPEDC.NUMPED) 			AS PEDIDOS_FINALIZADOS
    FROM WINT.PCPEDC
    JOIN WINT.PCUSUARI
      ON PCPEDC.CODUSUR = PCUSUARI.CODUSUR
   WHERE PCPEDC.POSICAO = 'F'
     AND EXTRACT(YEAR FROM PCPEDC.DATA) = 2024
GROUP BY PCPEDC.CODUSUR,
  		 PCUSUARI.NOME
  HAVING SUM(PCPEDC.VLTOTAL) > (
  								SELECT AVG(CALCULO_SOMA.TOTAL_VENDIDO)
							      FROM (
										  SELECT SUBPCPEDC.CODUSUR, 
											     SUM(SUBPCPEDC.VLTOTAL) AS TOTAL_VENDIDO
										    FROM WINT.PCPEDC SUBPCPEDC
										   WHERE SUBPCPEDC.POSICAO = 'F'
										     AND EXTRACT(YEAR FROM SUBPCPEDC.DATA) = 2024
										GROUP BY SUBPCPEDC.CODUSUR
							      	   ) CALCULO_SOMA
  							   )
ORDER BY ACUMULADO_VENDAS DESC;

-- Identifique os produtos cujo total de quantidade vendida em outubro e novembro de 2011
-- ultrapassou a média de quantidade vendida de todos os produtos nesse período.
-- Exiba código, descrição e quantidade total vendida.
-- Use apenas registros com POSICAO = 'F' da PCPEDI.

  SELECT PCPRODUT.CODPROD 					AS CODIGO_PRODUTO,
  		 PCPRODUT.DESCRICAO,
  		 SUM(PCPEDI.QT) 					AS QTD_VENDIDA
    FROM WINT.PCPEDI
    JOIN WINT.PCPRODUT
      ON PCPEDI.CODPROD = PCPRODUT.CODPROD
   WHERE PCPEDI.POSICAO = 'F'
     AND EXTRACT(YEAR FROM PCPEDI.DATA) = 2011 
GROUP BY PCPRODUT.CODPROD,
  		 PCPRODUT.DESCRICAO
  HAVING SUM(PCPEDI.QT) > (
  							SELECT AVG(TABELA_SOMA.SOMA_TOTAL)
						      FROM (
								      SELECT SUBPCPEDI.CODPROD,
								  		     SUM(SUBPCPEDI.QT) AS SOMA_TOTAL
								        FROM WINT.PCPEDI SUBPCPEDI
								       WHERE SUBPCPEDI.POSICAO = 'F'
     									 AND EXTRACT(YEAR FROM SUBPCPEDI.DATA) = 2011
								    GROUP BY SUBPCPEDI.CODPROD
						    	   ) TABELA_SOMA
  						  )
ORDER BY QTD_VENDIDA DESC;




-- Exiba os códigos e nomes dos fornecedores cuja receita de vendas em 2024
-- representou mais de 5% da receita total dos fornecedores no ano.
-- Inclua também a receita total e a quantidade total de itens vendidos.
-- Considere apenas registros com POSICAO = 'F' da PCPEDI.

  SELECT PCFORNEC.CODFORNEC,
  		 PCFORNEC.FORNECEDOR,
  		 SUM(PCPEDI.PVENDA * PCPEDI.QT) 			AS RECEITA_TOTAL,
  		 SUM(PCPEDI.QT) 							AS QTD_TOTAL_VENDIDA
    FROM WINT.PCPEDI
    JOIN WINT.PCPRODUT
      ON PCPEDI.CODPROD = PCPRODUT.CODPROD
    JOIN WINT.PCFORNEC
      ON PCPRODUT.CODFORNEC = PCFORNEC.CODFORNEC
   WHERE PCPEDI.POSICAO = 'F'
     AND EXTRACT(YEAR FROM PCPEDI.DATA) = 2011
GROUP BY PCFORNEC.CODFORNEC,
  		 PCFORNEC.FORNECEDOR
  HAVING SUM(PCPEDI.PVENDA * PCPEDI.QT) > (
									  		SELECT 0.05 * SUM(SUBPCPEDI.PVENDA * SUBPCPEDI.QT)
									  		  FROM WINT.PCPEDI SUBPCPEDI
									  		 WHERE SUBPCPEDI.POSICAO = 'F'
            								   AND EXTRACT(YEAR FROM SUBPCPEDI.DATA) = 2011
									  	  )
ORDER BY RECEITA_TOTAL ASC;



-- Para cada mês de 2011, retorne os meses em que a marca VERSOTOOLS
-- teve receita de vendas superior à média mensal da própria marca no ano.
-- Exiba o número do mês e a receita total do mês. Use registros de PCPEDI com POSICAO = 'F'.

  SELECT EXTRACT(MONTH FROM PCPEDI.DATA) 					AS MES,
  		 SUM(PCPEDI.PVENDA * PCPEDI.QT) 					AS RECEITA_VENDAS
    FROM WINT.PCPEDI
    JOIN WINT.PCPRODUT
      ON PCPEDI.CODPROD = PCPRODUT.CODPROD
     AND PCPRODUT.MARCA = 'VERSOTOOLS'
   WHERE PCPEDI.POSICAO = 'F'
     AND EXTRACT(YEAR FROM PCPEDI.DATA) = 2011
GROUP BY EXTRACT(MONTH FROM PCPEDI.DATA)
HAVING SUM(PCPEDI.PVENDA * PCPEDI.QT) > (
										  SELECT AVG(SOMA_TOTAL.RECEITA_TOTAL)
										    FROM (
												    SELECT EXTRACT(MONTH FROM SUBPCPEDI.DATA)	    AS SUBMES,
												  		   SUM(SUBPCPEDI.PVENDA * SUBPCPEDI.QT) 	AS RECEITA_TOTAL
												      FROM WINT.PCPEDI SUBPCPEDI
												      JOIN WINT.PCPRODUT SUBPCPRODUT
												        ON SUBPCPEDI.CODPROD = SUBPCPRODUT.CODPROD
												       AND SUBPCPRODUT.MARCA = 'VERSOTOOLS'
												     WHERE SUBPCPEDI.POSICAO = 'F'
												       AND EXTRACT(YEAR FROM SUBPCPEDI.DATA) = 2011
												  GROUP BY EXTRACT(MONTH FROM SUBPCPEDI.DATA)
										    	 ) SOMA_TOTAL
										);
  
  

-- Para cada representante que teve vendas totais em 2024 acima da média de todos os representantes,
-- exiba:
--   • Código do representante e nome;
--   • Total de vendas no ano (soma de VLTOTAL em PCPEDC);
--   • Quantidade de clientes distintos atendidos em 2024 (subquery em SELECT);
--   • Média de vendas mensais, considerando apenas os meses em que houve venda (subquery em FROM);
-- 
-- Filtros implícitos:
--   – Considere apenas pedidos com POSICAO = 'F' em PCPEDC;
--   – Use subquery em WHERE para excluir representantes cujo total de vendas esteja abaixo
--     da média de vendas de todos os representantes em 2024;
--   – Use subquery em FROM para montar uma tabela derivada com total por mês de cada representante.
  

  
  SELECT PCUSUARI.CODUSUR,
  		 PCUSUARI.NOME,
  		 SUM(PCPEDC.VLTOTAL) 														AS TOTAL_VENDA,
  		 COUNT(DISTINCT PCPEDC.CODCLI) 												AS QTD_CLIENTES,
  		 MEDIA_VENDAS.MEDIA
    FROM WINT.PCPEDC
    JOIN WINT.PCUSUARI
      ON PCPEDC.CODUSUR = PCUSUARI.CODUSUR
    JOIN (  SELECT VENDAS_MES.CODUSUR							AS CODUSUR,
    			   ROUND(AVG(VENDAS_MES.QTD_VENDA), 2)			AS MEDIA
	 	      FROM (
	 	   		    SELECT SUBPCPEDC.CODUSUR					AS CODUSUR,
	 	   		  		   COUNT(SUBPCPEDC.NUMPED) 				AS QTD_VENDA,
	  		  		       EXTRACT(MONTH FROM SUBPCPEDC.DATA)
	  		          FROM WINT.PCPEDC SUBPCPEDC
	  		      GROUP BY SUBPCPEDC.CODUSUR,
	  		     	 	   EXTRACT(MONTH FROM SUBPCPEDC.DATA)
	 	           ) VENDAS_MES
	 	  GROUP BY VENDAS_MES.CODUSUR) 												MEDIA_VENDAS
	  ON PCUSUARI.CODUSUR = MEDIA_VENDAS.CODUSUR
   WHERE PCPEDC.POSICAO = 'F'
     AND EXTRACT(YEAR FROM PCPEDC.DATA) = 2024
 GROUP BY PCUSUARI.CODUSUR,
  		  PCUSUARI.NOME,
  		  MEDIA_VENDAS.MEDIA
 ORDER BY PCUSUARI.CODUSUR;

 -- Identifique os produtos cujo total de quantidade vendida em outubro e novembro de 2011
-- ultrapassou a média de quantidade vendida de todos os produtos nesse período.
-- Exiba código, descrição e quantidade total vendida.
-- Use apenas registros com POSICAO = 'F' da PCPEDI.

  SELECT PCPRODUT.CODPROD 					AS CODIGO_PRODUTO,
  		 PCPRODUT.DESCRICAO,
  		 SUM(PCPEDI.QT) 					AS QTD_VENDIDA
    FROM WINT.PCPEDI
    JOIN WINT.PCPRODUT
      ON PCPEDI.CODPROD = PCPRODUT.CODPROD
   WHERE PCPEDI.POSICAO = 'F'
     AND EXTRACT(YEAR FROM PCPEDI.DATA) = 2011 
GROUP BY PCPRODUT.CODPROD,
  		 PCPRODUT.DESCRICAO
  HAVING SUM(PCPEDI.QT) > (
  							SELECT AVG(TABELA_SOMA.SOMA_TOTAL)
						      FROM (
								      SELECT SUBPCPEDI.CODPROD,
								  		     SUM(SUBPCPEDI.QT) AS SOMA_TOTAL
								        FROM WINT.PCPEDI SUBPCPEDI
								       WHERE SUBPCPEDI.POSICAO = 'F'
     									 AND EXTRACT(YEAR FROM SUBPCPEDI.DATA) = 2011
								    GROUP BY SUBPCPEDI.CODPROD
						    	   ) TABELA_SOMA
  						  )
ORDER BY QTD_VENDIDA DESC;




-- Exiba os códigos e nomes dos fornecedores cuja receita de vendas em 2024
-- representou mais de 5% da receita total dos fornecedores no ano.
-- Inclua também a receita total e a quantidade total de itens vendidos.
-- Considere apenas registros com POSICAO = 'F' da PCPEDI.

  SELECT PCFORNEC.CODFORNEC,
  		 PCFORNEC.FORNECEDOR,
  		 SUM(PCPEDI.PVENDA * PCPEDI.QT) 			AS RECEITA_TOTAL,
  		 SUM(PCPEDI.QT) 							AS QTD_TOTAL_VENDIDA
    FROM WINT.PCPEDI
    JOIN WINT.PCPRODUT
      ON PCPEDI.CODPROD = PCPRODUT.CODPROD
    JOIN WINT.PCFORNEC
      ON PCPRODUT.CODFORNEC = PCFORNEC.CODFORNEC
   WHERE PCPEDI.POSICAO = 'F'
     AND EXTRACT(YEAR FROM PCPEDI.DATA) = 2011
GROUP BY PCFORNEC.CODFORNEC,
  		 PCFORNEC.FORNECEDOR
  HAVING SUM(PCPEDI.PVENDA * PCPEDI.QT) > (
									  		SELECT 0.05 * SUM(SUBPCPEDI.PVENDA * SUBPCPEDI.QT)
									  		  FROM WINT.PCPEDI SUBPCPEDI
									  		 WHERE SUBPCPEDI.POSICAO = 'F'
            								   AND EXTRACT(YEAR FROM SUBPCPEDI.DATA) = 2011
									  	  )
ORDER BY RECEITA_TOTAL ASC;



-- Para cada mês de 2011, retorne os meses em que a marca VERSOTOOLS
-- teve receita de vendas superior à média mensal da própria marca no ano.
-- Exiba o número do mês e a receita total do mês. Use registros de PCPEDI com POSICAO = 'F'.

  SELECT EXTRACT(MONTH FROM PCPEDI.DATA) 					AS MES,
  		 SUM(PCPEDI.PVENDA * PCPEDI.QT) 					AS RECEITA_VENDAS
    FROM WINT.PCPEDI
    JOIN WINT.PCPRODUT
      ON PCPEDI.CODPROD = PCPRODUT.CODPROD
     AND PCPRODUT.MARCA = 'VERSOTOOLS'
   WHERE PCPEDI.POSICAO = 'F'
     AND EXTRACT(YEAR FROM PCPEDI.DATA) = 2011
GROUP BY EXTRACT(MONTH FROM PCPEDI.DATA)
HAVING SUM(PCPEDI.PVENDA * PCPEDI.QT) > (
										  SELECT AVG(SOMA_TOTAL.RECEITA_TOTAL)
										    FROM (
												    SELECT EXTRACT(MONTH FROM SUBPCPEDI.DATA)	    AS SUBMES,
												  		   SUM(SUBPCPEDI.PVENDA * SUBPCPEDI.QT) 	AS RECEITA_TOTAL
												      FROM WINT.PCPEDI SUBPCPEDI
												      JOIN WINT.PCPRODUT SUBPCPRODUT
												        ON SUBPCPEDI.CODPROD = SUBPCPRODUT.CODPROD
												       AND SUBPCPRODUT.MARCA = 'VERSOTOOLS'
												     WHERE SUBPCPEDI.POSICAO = 'F'
												       AND EXTRACT(YEAR FROM SUBPCPEDI.DATA) = 2011
												  GROUP BY EXTRACT(MONTH FROM SUBPCPEDI.DATA)
										    	 ) SOMA_TOTAL
										);
  
  

-- Para cada representante que teve vendas totais em 2024 acima da média de todos os representantes,
-- exiba:
--   • Código do representante e nome;
--   • Total de vendas no ano (soma de VLTOTAL em PCPEDC);
--   • Quantidade de clientes distintos atendidos em 2024 (subquery em SELECT);
--   • Média de vendas mensais, considerando apenas os meses em que houve venda (subquery em FROM);
-- 
-- Filtros implícitos:
--   – Considere apenas pedidos com POSICAO = 'F' em PCPEDC;
--   – Use subquery em WHERE para excluir representantes cujo total de vendas esteja abaixo
--     da média de vendas de todos os representantes em 2024;
--   – Use subquery em FROM para montar uma tabela derivada com total por mês de cada representante.
  

  
  SELECT PCUSUARI.CODUSUR,
  		 PCUSUARI.NOME,
  		 SUM(PCPEDC.VLTOTAL) 														AS TOTAL_VENDA,
  		 COUNT(DISTINCT PCPEDC.CODCLI) 												AS QTD_CLIENTES,
  		 MEDIA_VENDAS.MEDIA
    FROM WINT.PCPEDC
    JOIN WINT.PCUSUARI
      ON PCPEDC.CODUSUR = PCUSUARI.CODUSUR
    JOIN (  SELECT VENDAS_MES.CODUSUR							AS CODUSUR,
    			   ROUND(AVG(VENDAS_MES.QTD_VENDA), 2)			AS MEDIA
	 	      FROM (
	 	   		    SELECT SUBPCPEDC.CODUSUR					AS CODUSUR,
	 	   		  		   COUNT(SUBPCPEDC.NUMPED) 				AS QTD_VENDA,
	  		  		       EXTRACT(MONTH FROM SUBPCPEDC.DATA)
	  		          FROM WINT.PCPEDC SUBPCPEDC
	  		      GROUP BY SUBPCPEDC.CODUSUR,
	  		     	 	   EXTRACT(MONTH FROM SUBPCPEDC.DATA)
	 	           ) VENDAS_MES
	 	  GROUP BY VENDAS_MES.CODUSUR) 												MEDIA_VENDAS
	  ON PCUSUARI.CODUSUR = MEDIA_VENDAS.CODUSUR
   WHERE PCPEDC.POSICAO = 'F'
     AND EXTRACT(YEAR FROM PCPEDC.DATA) = 2024
 GROUP BY PCUSUARI.CODUSUR,
  		  PCUSUARI.NOME,
  		  MEDIA_VENDAS.MEDIA
 ORDER BY PCUSUARI.CODUSUR;
   
 
  
-- Exercício: Análise de produtos cadastrados versus vendidos em 2011 usando INTERSECT, MINUS e UNION
--
-- Contexto:
--   • PCPRODUT lista todos os produtos registrados (com CODPROD).
--   • PCPEDI contém apenas vendas de outubro e novembro de 2011 (com CODPROD nos itens).
--   • PCPEDC não possui CODPROD (é apenas cabeçalho), então todas as consultas de produto
--     devem se basear em PCPEDI e PCPRODUT.
--
-- O objetivo é:
--   1) Identificar quais produtos registrados em PCPRODUT foram efetivamente vendidos em 2011.
--      Use INTERSECT entre a lista de todos os CODPROD em PCPRODUT e a lista de CODPROD em PCPEDI (2011).
--   2) Identificar quais produtos existem em PCPRODUT mas NÃO foram vendidos em 2011.
--      Use MINUS para subtrair os CODPROD vendidos em 2011 da lista completa em PCPRODUT.
--   3) Criar uma lista única de todos os produtos que ou venderam em 2011 ou estão apenas cadastrados
--      (ou seja, combinar as listas de PCPRODUT e PCPEDI sem duplicação).
--      Use UNION para unir a lista completa de PCPRODUT com a lista de produtos vendidos em 2011.
--
-- Considere:
--   • Em todas as consultas, filtre PCPEDI com POSICAO = 'F' e DATA entre 2011-10-01 e 2011-11-30.
--   • Em PCPRODUT, não há filtro de data—é a lista estática de todos os produtos.
--   • Todas as saídas devem retornar apenas a coluna CODPROD.
--
  
  
   SELECT PCPRODUT.CODPROD
     FROM WINT.PCPRODUT
INTERSECT
   SELECT PCPEDI.CODPROD
     FROM WINT.PCPEDI
    WHERE PCPEDI.POSICAO = 'F'
      AND EXTRACT(YEAR FROM PCPEDI.DATA) = 2011
     
SELECT PCPRODUT.CODPROD
  FROM WINT.PCPRODUT
 MINUS
SELECT PCPEDI.CODPROD
  FROM WINT.PCPEDI
 WHERE PCPEDI.POSICAO = 'F'
   AND EXTRACT(YEAR FROM PCPEDI.DATA) = 2011
   
SELECT PCPRODUT.CODPROD
  FROM WINT.PCPRODUT
 UNION
SELECT PCPEDI.CODPROD
  FROM WINT.PCPEDI
 WHERE PCPEDI.POSICAO = 'F'
   AND EXTRACT(YEAR FROM PCPEDI.DATA) = 2011
      
    
/* Imagine que foi solicitado um comparativo de representantes entre dois períodos distintos: outubro/novembro de 2011 e todo o ano de 2023, mas sem instruções minuciosas sobre quais colunas usar. Você sabe que PCPEDI traz registros de pedido/item apenas em 2011 e PCPEDC contém os pedidos-header de 2023. Crie um único script SQL capaz de:

listar os códigos dos representantes que aparecem tanto em PCPEDI durante 2011 quanto em PCPEDC em 2023;

listar os códigos dos representantes que aparecem em PCPEDC em 2023 mas não figurem em PCPEDI durante 2011;

unir ambas as listas sem duplicar códigos.

Use INTERSECT, MINUS e UNION, aplique filtro de POSICAO = 'F' em cada tabela e restrinja o ano ou o intervalo correto em cada caso, retornando apenas um resultado por instrução.
 */
   
   SELECT DISTINCT PCPEDC.CODUSUR
     FROM WINT.PCPEDC
    WHERE PCPEDC.POSICAO = 'F'
      AND EXTRACT(YEAR FROM PCPEDC.DATA) = 2023
INTERSECT
   SELECT DISTINCT PCPEDI.CODUSUR
     FROM WINT.PCPEDI
    WHERE PCPEDI.POSICAO = 'F'
      AND EXTRACT(YEAR FROM PCPEDI.DATA) = 2011;
   
SELECT DISTINCT PCPEDC.CODUSUR
  FROM WINT.PCPEDC
 WHERE PCPEDC.POSICAO = 'F'
   AND EXTRACT(YEAR FROM PCPEDC.DATA) = 2023
 MINUS
SELECT DISTINCT PCPEDI.CODUSUR
  FROM WINT.PCPEDI
 WHERE PCPEDI.POSICAO = 'F'
   AND EXTRACT(YEAR FROM PCPEDI.DATA) = 2011;

SELECT DISTINCT PCPEDC.CODUSUR
  FROM WINT.PCPEDC
 WHERE PCPEDC.POSICAO = 'F'
   AND EXTRACT(YEAR FROM PCPEDC.DATA) = 2023
 UNION
SELECT DISTINCT PCPEDI.CODUSUR
  FROM WINT.PCPEDI
 WHERE PCPEDI.POSICAO = 'F'
   AND EXTRACT(YEAR FROM PCPEDI.DATA) = 2011;


-- Liste os representantes que, em 2024, venderam acima da média de todos os representantes no mesmo ano.
-- Para cada um, exiba o código do representante e o total vendido no ano.

  SELECT PCPEDC.CODUSUR      									AS CODIGO_REPRESENTANTE,
  		 SUM(PCPEDC.VLTOTAL) 									AS TOTAL_VENDIDO
    FROM WINT.PCPEDC
   WHERE PCPEDC.POSICAO = 'F'
     AND EXTRACT(YEAR FROM PCPEDC.DATA) = 2024
GROUP BY PCPEDC.CODUSUR
  HAVING SUM(PCPEDC.VLTOTAL) > (
  								SELECT AVG(TOTAL_VENDIDO.SOMA_VENDAS)
							      FROM (
									    SELECT SUBPCPEDC.CODUSUR,
									  	  	   SUM(SUBPCPEDC.VLTOTAL) AS SOMA_VENDAS
									      FROM WINT.PCPEDC SUBPCPEDC
									     WHERE SUBPCPEDC.POSICAO = 'F'
									       AND EXTRACT(YEAR FROM SUBPCPEDC.DATA) = 2024
									  GROUP BY SUBPCPEDC.CODUSUR
							    	 ) TOTAL_VENDIDO
  							   )
ORDER BY CODIGO_REPRESENTANTE ASC;


-- Retorne os produtos cuja venda total no último trimestre de 2022 ficou abaixo da média de venda
-- de todos os produtos no mesmo período. Exiba apenas o código do produto e o valor vendido.
-- Regras: apenas produtos da marca 'VERSOTOOLS'


  SELECT PCPEDI.CODPROD								AS CODIGO_PRODUTO,
  	     SUM(PCPEDI.PVENDA * PCPEDI.QT) 			AS SOMA_VENDAS
    FROM WINT.PCPEDI PCPEDI
    JOIN WINT.PCPRODUT
      ON PCPEDI.CODPROD = PCPRODUT.CODPROD
     AND PCPRODUT.MARCA = 'VERSOTOOLS'
   WHERE PCPEDI.DATA BETWEEN TO_DATE('01/07/2011', 'DD/MM/YYYY')
   					     AND TO_DATE('31/12/2011', 'DD/MM/YYYY')
GROUP BY PCPEDI.CODPROD
  HAVING SUM(PCPEDI.PVENDA * PCPEDI.QT) < (
											  SELECT AVG(SOMA_VENDAS.SOMA_VENDAS)
											    FROM (
											    	   SELECT SUBPCPEDI.CODPROD,
													  		  SUM(SUBPCPEDI.PVENDA * SUBPCPEDI.QT) AS SOMA_VENDAS
													     FROM WINT.PCPEDI SUBPCPEDI
													     JOIN WINT.PCPRODUT SUBPCPRODUT
													       ON SUBPCPEDI.CODPROD = SUBPCPRODUT.CODPROD
													      AND SUBPCPRODUT.MARCA = 'VERSOTOOLS'
													    WHERE SUBPCPEDI.DATA BETWEEN TO_DATE('01/07/2011', 'DD/MM/YYYY')
													   						     AND TO_DATE('31/12/2011', 'DD/MM/YYYY')
													 GROUP BY SUBPCPEDI.CODPROD
											    	 ) SOMA_VENDAS
  										  )
ORDER BY CODIGO_PRODUTO;	


-- Para cada cliente que realizou compras em 2024, exiba o código do cliente, o valor total comprado no ano
-- e a média geral de compras de todos os clientes no mesmo período.
-- Classifique também cada cliente como 'Acima da média' ou 'Abaixo da média', com base nesse valor.
-- Considere apenas pedidos finalizados.

    SELECT PCPEDC.CODCLI					AS CODIGO_CLIENTE,
  		   PCCLIENT.CLIENTE,
  		   SUM(PCPEDC.VLTOTAL) 				AS TOTAL_COMPRADO,
  		   MEDIA_GERAL.MEDIA,
  		   (
  		    CASE
  		 	   WHEN SUM(PCPEDC.VLTOTAL) > MEDIA_GERAL.MEDIA THEN 'Acima da média'
  		       ELSE 'Abaixo da média'
  		    END
  		   ) AS COLOCACAO
      FROM WINT.PCPEDC
      JOIN WINT.PCCLIENT
        ON PCPEDC.CODCLI = PCCLIENT.CODCLI
CROSS JOIN (
	  		  SELECT ROUND(AVG(SOMA_GERAL.SOMA), 2) AS MEDIA
	  		    FROM (
	  		    	     SELECT SUBPCPEDC.CODCLI,
	  		    	            SUM(SUBPCPEDC.VLTOTAL) AS SOMA
		    	           FROM WINT.PCPEDC SUBPCPEDC
		    	          WHERE SUBPCPEDC.POSICAO = 'F'
       						AND EXTRACT(YEAR FROM SUBPCPEDC.DATA) = 2024
	    	           GROUP BY SUBPCPEDC.CODCLI
	  		    	 ) SOMA_GERAL
	  		) MEDIA_GERAL
     WHERE PCPEDC.POSICAO = 'F'
       AND EXTRACT(YEAR FROM PCPEDC.DATA) = 2024
  GROUP BY PCPEDC.CODCLI,
		   PCCLIENT.CLIENTE,
		   MEDIA_GERAL.MEDIA
  ORDER BY CODIGO_CLIENTE;



-- Liste os fornecedores que, durante outubro e novembro de 2011, tiveram volume total de itens vendidos
-- acima da média de todos os fornecedores nesse mesmo período.
-- Exiba o código do fornecedor e a quantidade total de itens.
-- Considere apenas pedidos finalizados. 
    
  SELECT PCPRODUT.CODFORNEC AS CODIGO_FORNECEDOR,
  		 SUM(PCPEDI.QT) AS QTD_VENDIDA
    FROM WINT.PCPEDI
    JOIN WINT.PCPRODUT
      ON PCPEDI.CODPROD = PCPRODUT.CODPROD
   WHERE PCPEDI.POSICAO = 'F'
     AND PCPEDI.DATA BETWEEN TO_DATE('01/10/2011', 'DD/MM/YYYY')
   						 AND TO_DATE('30/11/2011', 'DD/MM/YYYY')
GROUP BY PCPRODUT.CODFORNEC
  HAVING SUM(PCPEDI.QT) > (
  							SELECT AVG(CALCULO_SOMA.SOMA)
  							  FROM (
		  							  SELECT SUBPCPRODUT.CODFORNEC,
									  		 SUM(SUBPCPEDI.QT) AS SOMA
									    FROM WINT.PCPEDI SUBPCPEDI
									    JOIN WINT.PCPRODUT SUBPCPRODUT
									      ON SUBPCPEDI.CODPROD = SUBPCPRODUT.CODPROD
									GROUP BY SUBPCPRODUT.CODFORNEC
  							  	   ) CALCULO_SOMA);
    


-- Liste os clientes que realizaram compras tanto no primeiro semestre quanto no segundo semestre de 2023.
-- Para cada cliente, exiba o código e o total comprado em cada semestre separadamente.
-- Considere apenas pedidos finalizados.

   SELECT PCPEDC.CODCLI,
   		  SUM(PCPEDC.VLTOTAL) AS TOTAL_COMPRADO
     FROM WINT.PCPEDC
    WHERE PCPEDC.DATA BETWEEN TO_DATE('01/07/2023', 'DD/MM/YYYY')
    					  AND TO_DATE('31/12/2023', 'DD/MM/YYYY')
 GROUP BY PCPEDC.CODCLI
INTERSECT
   SELECT PCPEDC.CODCLI,
  		  SUM(PCPEDC.VLTOTAL) AS TOTAL_COMPRADO
     FROM WINT.PCPEDC
    WHERE PCPEDC.DATA BETWEEN TO_DATE('01/01/2023', 'DD/MM/YYYY')
   						  AND TO_DATE('30/06/2023', 'DD/MM/YYYY')
 GROUP BY PCPEDC.CODCLI
 
 -----------------------
 
    SELECT PCPEDC.CODCLI     													AS CODIGO_CLIENTE,
   		   SUM(PCPEDC.VLTOTAL) 													AS COMPRAS_SEMESTRE_1,
   		   VENDAS_SEGUNDO_SEMESTRE.TOTAL_COMPRADO  								AS COMPRAS_SEMESTRE_2
     FROM WINT.PCPEDC
     JOIN (
     		 SELECT PCPEDC.CODCLI,
  		   		    SUM(PCPEDC.VLTOTAL) AS TOTAL_COMPRADO
     	       FROM WINT.PCPEDC
    		  WHERE PCPEDC.DATA BETWEEN TO_DATE('01/07/2023', 'DD/MM/YYYY')
    					  		    AND TO_DATE('31/12/2023', 'DD/MM/YYYY')
 		   GROUP BY PCPEDC.CODCLI
     	  ) VENDAS_SEGUNDO_SEMESTRE
       ON PCPEDC.CODCLI = VENDAS_SEGUNDO_SEMESTRE.CODCLI
    WHERE PCPEDC.DATA BETWEEN TO_DATE('01/01/2023', 'DD/MM/YYYY')
   						  AND TO_DATE('30/06/2023', 'DD/MM/YYYY')
 GROUP BY PCPEDC.CODCLI,
    	  VENDAS_SEGUNDO_SEMESTRE.TOTAL_COMPRADO
ORDER BY CODIGO_CLIENTE;

-- Liste os produtos que tiveram valor total vendido acima da média de vendas dos produtos da mesma marca em out/nov de 2011.
-- Para cada um, exiba o código do produto, a marca e o valor total vendido no período.


  SELECT PCPRODUT.CODPROD				AS CODIGO_PRODUTO,
  		 PCPRODUT.MARCA,
  		 SUM(PCPEDI.PVENDA * PCPEDI.QT) AS TOTAL_VENDIDO
    FROM WINT.PCPEDI
    JOIN WINT.PCPRODUT
      ON PCPEDI.CODPROD = PCPRODUT.CODPROD
   WHERE PCPEDI.POSICAO = 'F'
     AND PCPEDI.DATA BETWEEN TO_DATE('01/10/2011', 'DD/MM/YYYY')
   						 AND TO_DATE('30/11/2011', 'DD/MM/YYYY')
GROUP BY PCPRODUT.CODPROD,
  		 PCPRODUT.MARCA
  HAVING SUM(PCPEDI.PVENDA * PCPEDI.QT) > (
										  	SELECT AVG(VENDAS_POR_PRODUTO.VALOR_PRODUTO)
										  	  FROM (
													  SELECT SUBPCPRODUT.MARCA 					  AS MARCA,
													  		 SUM(SUBPCPEDI.PVENDA * SUBPCPEDI.QT) AS VALOR_PRODUTO
													    FROM WINT.PCPEDI SUBPCPEDI
													    JOIN WINT.PCPRODUT SUBPCPRODUT
													      ON SUBPCPEDI.CODPROD = SUBPCPRODUT.CODPROD
													   WHERE SUBPCPEDI.POSICAO = 'F'
													     AND SUBPCPEDI.DATA BETWEEN TO_DATE('01/10/2011', 'DD/MM/YYYY')
   						  														AND TO_DATE('30/11/2011', 'DD/MM/YYYY')
													     AND SUBPCPRODUT.MARCA = PCPRODUT.MARCA
													GROUP BY SUBPCPRODUT.CODPROD,
															 SUBPCPRODUT.MARCA
										  	  	   ) VENDAS_POR_PRODUTO
  										  )
ORDER BY PCPRODUT.MARCA ASC,
		 CODIGO_PRODUTO ASC;
  

-- Retorne os clientes que, em 2024, compraram mais do que a média geral dos clientes no mesmo ano.
-- Para cada cliente, mostre o código, o nome, o total comprado e uma coluna indicando 'Acima da média' ou 'Abaixo da média'.

    SELECT PCCLIENT.CODCLI  		AS CODIGO_CLIENTE,
  		   PCCLIENT.CLIENTE,
  		   SUM(PCPEDC.VLTOTAL) 	AS TOTAL_COMPRADO,
  		   MEDIA_VENDAS.MEDIA,
  		   (
  		    CASE
  		  	  WHEN SUM(PCPEDC.VLTOTAL) > MEDIA_VENDAS.MEDIA THEN 'Acima da média'
  		  	  ELSE 'Abaixo da média'
  		    END
   		   ) AS CONDICAO
      FROM WINT.PCPEDC
      JOIN WINT.PCCLIENT
        ON PCPEDC.CODCLI = PCCLIENT.CODCLI
CROSS JOIN (
    		SELECT ROUND(AVG(VENDAS_TOTAIS.SOMA), 2) AS MEDIA
			  FROM (
					  SELECT SUBPCPEDC.CODCLI,
					  		 SUM(SUBPCPEDC.VLTOTAL) AS SOMA
					    FROM WINT.PCPEDC SUBPCPEDC
					   WHERE EXTRACT(YEAR FROM SUBPCPEDC.DATA) = 2024
					GROUP BY SUBPCPEDC.CODCLI
				   ) VENDAS_TOTAIS
    	   ) MEDIA_VENDAS
     WHERE EXTRACT(YEAR FROM PCPEDC.DATA) = 2024
  GROUP BY PCCLIENT.CODCLI,
  		   PCCLIENT.CLIENTE,
  		   MEDIA_VENDAS.MEDIA
  ORDER BY CODIGO_CLIENTE ASC;
    

-- Mostre os representantes que, em 2023, realizaram vendas todos os meses do ano (de janeiro a dezembro).
-- Exiba o código do representante e a quantidade de meses em que ele teve pedidos finalizados.
    
  SELECT PCPEDC.CODUSUR,
  		 COUNT(DISTINCT EXTRACT (MONTH FROM PCPEDC.DATA)) AS MESES_POSITIVADOS
    FROM WINT.PCPEDC
   WHERE PCPEDC.POSICAO = 'F'
     AND EXTRACT(YEAR FROM PCPEDC.DATA) = 2023
GROUP BY PCPEDC.CODUSUR
  HAVING COUNT(DISTINCT EXTRACT (MONTH FROM PCPEDC.DATA)) = 12;

 
-- Exiba os fornecedores que tiveram vendas registradas em out/nov de 2011,
-- mas cuja receita foi inferior à média de todos os fornecedores naquele período.
-- Mostre o código do fornecedor e a receita total (valor vendido).

  SELECT PCPRODUT.CODFORNEC						AS CODIGO_FORNECEDOR,
  	 	 SUM(PCPEDI.PVENDA * PCPEDI.QT) 		AS VALOR_VENDIDO
    FROM WINT.PCPEDI
    JOIN WINT.PCPRODUT
      ON PCPEDI.CODPROD = PCPRODUT.CODPROD
   WHERE PCPEDI.POSICAO = 'F'
     AND PCPEDI.DATA BETWEEN TO_DATE('01/10/2011', 'DD/MM/YYYY')
   						 AND TO_DATE('30/11/2011', 'DD/MM/YYYY')
GROUP BY PCPRODUT.CODFORNEC
 HAVING SUM(PCPEDI.PVENDA * PCPEDI.QT) < (
										  SELECT AVG(CALCULO_SOMA.SOMA)
										    FROM (
												    SELECT SUM(SUBPCPEDI.PVENDA * SUBPCPEDI.QT) 		AS SOMA
												      FROM WINT.PCPEDI SUBPCPEDI
												      JOIN WINT.PCPRODUT SUBPCPRODUT
												        ON SUBPCPEDI.CODPROD = SUBPCPRODUT.CODPROD
												       WHERE SUBPCPEDI.POSICAO = 'F'
													     AND SUBPCPEDI.DATA BETWEEN TO_DATE('01/10/2011', 'DD/MM/YYYY')
													   						 AND TO_DATE('30/11/2011', 'DD/MM/YYYY')
												  GROUP BY SUBPCPRODUT.CODFORNEC
										    	 ) CALCULO_SOMA
 										 )
ORDER BY CODIGO_FORNECEDOR;
  
  

-- Para cada cliente que realizou compras em ambos os anos de 2023 e 2024, mostre:
-- o código do cliente, total comprado em 2023 e total comprado em 2024.
-- Considere apenas pedidos finalizados.

  SELECT COMPRAS_2023.CODCLI			AS CODIGO_CLIENTE,
  		 COMPRAS_2023.TOTAL_COMPRADO 	AS TOTAL_COMPRADO_2023,
  		 COMPRAS_2024.TOTAL_COMPRADO 	AS TOTAL_COMPRADO_2024
    FROM (
    	    SELECT PCPEDC.CODCLI,
    	   		   SUM(PCPEDC.VLTOTAL) AS TOTAL_COMPRADO
    	      FROM WINT.PCPEDC
    	     WHERE PCPEDC.POSICAO = 'F'
    	       AND EXTRACT(YEAR FROM PCPEDC.DATA) = 2023
    	  GROUP BY PCPEDC.CODCLI
    	 )COMPRAS_2023
    JOIN (
    	    SELECT PCPEDC.CODCLI,
    	   		   SUM(PCPEDC.VLTOTAL) AS TOTAL_COMPRADO
    	      FROM WINT.PCPEDC
    	     WHERE PCPEDC.POSICAO = 'F'
    	       AND EXTRACT(YEAR FROM PCPEDC.DATA) = 2024
    	  GROUP BY PCPEDC.CODCLI
    	 )COMPRAS_2024
      ON COMPRAS_2023.CODCLI = COMPRAS_2024.CODCLI
ORDER BY CODIGO_CLIENTE ASC;


-- Para cada representante que tiver vendas registradas em PCPEDC nos anos de 2023 e 2024,
-- calcule o total de VLTOTAL em 2023 e o total de VLTOTAL em 2024 e apresente também
-- a diferença percentual ((total_2024 – total_2023) / total_2023 * 100).
-- Use subselects para buscar o total de cada ano, filtrando apenas pedidos com POSICAO = 'F'.

  SELECT VENDAS_2023.CODCLI																						AS CODIGO_CLIENTE,
  		 VENDAS_2023.TOTAL_COMPRADO																				AS TOTAL_2023,
  		 VENDAS_2024.TOTAL_COMPRADO																				AS TOTAL_2024,
  		 ROUND(
  		 	   (VENDAS_2024.TOTAL_COMPRADO - VENDAS_2023.TOTAL_COMPRADO) / VENDAS_2023.TOTAL_COMPRADO * 100
  		 	   , 2) 																							AS DIFERENCA_PERCENTUAL
    FROM (
		    SELECT PCPEDC.CODCLI,
		  	  	   SUM(PCPEDC.VLTOTAL) AS TOTAL_COMPRADO
		      FROM WINT.PCPEDC
		     WHERE PCPEDC.POSICAO = 'F'
		       AND EXTRACT(YEAR FROM PCPEDC.DATA) = 2023
		  GROUP BY PCPEDC.CODCLI
    	 ) VENDAS_2023
    JOIN (
		    SELECT PCPEDC.CODCLI,
		  	  	   SUM(PCPEDC.VLTOTAL) AS TOTAL_COMPRADO
		      FROM WINT.PCPEDC
		     WHERE PCPEDC.POSICAO = 'F'
		       AND EXTRACT(YEAR FROM PCPEDC.DATA) = 2024
		  GROUP BY PCPEDC.CODCLI
    	 ) VENDAS_2024
      ON VENDAS_2023.CODCLI = VENDAS_2024.CODCLI
ORDER BY CODIGO_CLIENTE ASC;

-- Preciso de um relatório que una a lista de clientes que compraram no último trimestre de 2011
-- com os que compraram em todo o ano de 2024, sem duplicações. Para cada cliente, exiba o código
-- e a data da primeira compra em cada período. Use UNION para combinar as duas seleções e subqueries
-- para buscar as datas.

  SELECT PCPEDI.CODCLI,
  		 MIN(PCPEDI.DATA) AS PRIMEIRA_COMPRA
    FROM WINT.PCPEDI
   WHERE PCPEDI.DATA BETWEEN TO_DATE('01/09/2011', 'DD/MM/YYYY')
   						 AND TO_DATE('31/12/2011', 'DD/MM/YYYY') 
GROUP BY PCPEDI.CODCLI
   UNION
  SELECT PCPEDC.CODCLI,
  		 MIN(PCPEDC.DATA) AS PRIMEIRA_COMPRA
    FROM WINT.PCPEDC
   WHERE EXTRACT(YEAR FROM PCPEDC.DATA) = 2024
GROUP BY PCPEDC.CODCLI;


-- Gere uma lista de clientes que tiveram movimento em out/nov de 2011 ou em 2024,
-- apresentando, para cada um, o código e o valor total gasto no período em que houve compra.

  SELECT PCPEDI.CODCLI,
  		 SUM(PCPEDI.PVENDA * PCPEDI.QT) AS TOTAL_GASTO
    FROM WINT.PCPEDI
   WHERE PCPEDI.DATA BETWEEN TO_DATE('01/10/2011', 'DD/MM/YYYY')
						 AND TO_DATE('30/11/2011', 'DD/MM/YYYY')
GROUP BY CODCLI
   UNION
  SELECT PCPEDC.CODCLI,
  		 SUM(PCPEDC.VLTOTAL) AS TOTAL_GASTO
    FROM WINT.PCPEDC
   WHERE EXTRACT(YEAR FROM PCPEDC.DATA) = 2024
GROUP BY PCPEDC.CODCLI;

-- Apresente os representantes que registraram vendas em out/nov de 2011 e também em 2023,
-- retornando apenas o código de cada um.

   SELECT PCPEDI.CODUSUR
     FROM WINT.PCPEDI
    WHERE PCPEDI.DATA BETWEEN TO_DATE('01/10/2011', 'DD/MM/YYYY')
						  AND TO_DATE('30/11/2011', 'DD/MM/YYYY')
INTERSECT
   SELECT PCPEDC.CODUSUR
     FROM WINT.PCPEDC
    WHERE EXTRACT(YEAR FROM PCPEDC.DATA) = 2024;

-- Faça um levantamento dos fornecedores que atuaram em out/nov de 2011 e exiba o código
-- de cada um com sua receita total, separando mentalmente aqueles com desempenho acima
-- e abaixo do patamar médio do período.
   
   
  SELECT PCPRODUT.CODFORNEC,
  		 SUM(PCPEDI.QT) AS SOMA
    FROM WINT.PCPEDI
    JOIN WINT.PCPRODUT
      ON PCPEDI.CODPROD = PCPRODUT.CODPROD
    WHERE PCPEDI.POSICAO = 'F'
      AND PCPEDI.DATA BETWEEN TO_DATE('01/10/2011', 'DD/MM/YYYY')
						  AND TO_DATE('30/11/2011', 'DD/MM/YYYY')
GROUP BY PCPRODUT.CODFORNEC
 HAVING SUM(PCPEDI.QT) > (
						  SELECT AVG(SOMA_TOTAL.TOTAL_QTD) MEDIA_PERIODO
						    FROM (
								   SELECT SUM(SUBPCPEDI.QT) AS TOTAL_QTD
								     FROM WINT.PCPEDI SUBPCPEDI
								     JOIN WINT.PCPRODUT SUBPCPRODUT
								       ON SUBPCPEDI.CODPROD = SUBPCPRODUT.CODPROD
							        WHERE SUBPCPEDI.POSICAO = 'F'
							          AND SUBPCPEDI.DATA BETWEEN TO_DATE('01/10/2011', 'DD/MM/YYYY')
	  													  AND TO_DATE('30/11/2011', 'DD/MM/YYYY')
								 GROUP BY SUBPCPRODUT.CODFORNEC
						   		 ) SOMA_TOTAL);

-- Crie um histórico de vendas mensais para 2023, mostrando o mês e o total faturado,
-- além de incluir uma linha extra que represente o valor médio mensal do ano.
  
  SELECT EXTRACT(MONTH FROM PCPEDC.DATA) 	AS MES,
  		 SUM(PCPEDC.VLTOTAL)				AS TOTAL_FATURADO,
  		 (SELECT ROUND(AVG(CALCULO_SOMA.TOTAL_FATURADO), 2) 
  			 FROM (
		  		     SELECT SUM(PCPEDC.VLTOTAL)				AS TOTAL_FATURADO
					   FROM WINT.PCPEDC
					  WHERE PCPEDC.POSICAO = 'F'
				   GROUP BY EXTRACT(MONTH FROM PCPEDC.DATA)
  			 ) CALCULO_SOMA) VALOR_MEDIO_MENSAL
    FROM WINT.PCPEDC
   WHERE PCPEDC.POSICAO = 'F'
GROUP BY EXTRACT(MONTH FROM PCPEDC.DATA)
ORDER BY MES ASC;