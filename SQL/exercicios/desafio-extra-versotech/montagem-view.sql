--Desafio SQL, montagem da view de Clientes da Versotech

--Abaixo segue o esqueleto da nossa view de clientes com todos os campos que utilizamos
  --vale ressaltar que nem todos terão as informações dentro das tabelas, mas mapeie o que for possível
  
  --As tabelas do Winthor que você irá utilizar são: PCCLIENT, PCUSUARI, PCCIDADE (cadastro de cidades), PCREGIAO (cadastro de região de venda (importante no winthor), 
  -- PCATIVI (cadastros de ramos de atividade (construtora, consumidor final, escola, etc)), PCCOB (cadastro de tipos de cobrança (pix, boleto)), PCPLPAG (cadastro de planos de pagamento (10x, 10/20 dias))
  
  -- Algumas dessas tabelas você não encontrará na base, crie uma estrutura que você ache que faça sentido para preenchimento dos campos da view
  
  -- Qualquer dúvida, pode me chamar!

     WITH CALCULAR_MEDIA_PEDIDOS AS (
			  SELECT AVG(PEDIDOS_POR_CLIENTE.QTD_PEDIDOS) 					AS MEDIA_PEDIDOS
			    FROM (
	                    SELECT COUNT(PCPEDC.NUMPED) 						AS QTD_PEDIDOS
	                      FROM WINT.PCPEDC
	                 GROUP BY PCPEDC.CODCLI
	                ) PEDIDOS_POR_CLIENTE
		),
		VERIFICAR_NIVEL_CONFIANCA AS (
		/* Aqui o ideal seria verificar score e se paga em dia, porém dessa forma já da para ter uma ideia de confiança,
           utilizando a média de pedidos do cliente */
		      SELECT PCPEDC.CODCLI,
                     (CASE
                          WHEN COUNT(PCPEDC.NUMPED) 
                         	 	   >= CALCULAR_MEDIA_PEDIDOS.MEDIA_PEDIDOS
                          THEN 'ALTA'
                          WHEN COUNT(PCPEDC.NUMPED) 
	                         	   BETWEEN CALCULAR_MEDIA_PEDIDOS.MEDIA_PEDIDOS * 0.7 
	                     			   AND CALCULAR_MEDIA_PEDIDOS.MEDIA_PEDIDOS * 0.99
					     	  THEN 'MÉDIA'
                          ELSE 'BAIXA'
                      END) 															AS NIVEL
		        FROM WINT.PCPEDC
		  CROSS JOIN CALCULAR_MEDIA_PEDIDOS
		    GROUP BY PCPEDC.CODCLI, CALCULAR_MEDIA_PEDIDOS.MEDIA_PEDIDOS
		),
		PCPLPAG AS (
			SELECT VERIFICAR_NIVEL_CONFIANCA.NIVEL									AS NIVEL,
				   (CASE
						WHEN VERIFICAR_NIVEL_CONFIANCA.NIVEL = 'ALTA'  THEN 3
						WHEN VERIFICAR_NIVEL_CONFIANCA.NIVEL = 'MÉDIA' THEN 2
						ELSE 1
					END) 															AS ID,
				   -- Condições apenas para parâmetro
				   (CASE
						WHEN VERIFICAR_NIVEL_CONFIANCA.NIVEL = 'ALTA'
							THEN '30/60/90 DD'
						WHEN VERIFICAR_NIVEL_CONFIANCA.NIVEL = 'MÉDIA'
							THEN '30 DD'
						ELSE 'A VISTA'
					END) 															AS CONDICAO,
				   -- Seguindo a lógica da confiança, ganha acessos especiais baseado nela
				   (CASE
				   		WHEN VERIFICAR_NIVEL_CONFIANCA.NIVEL = 'ALTA'
							THEN 'S'
						ELSE 'N'
				   END)																AS ACESSAPLANOESPECIAL,
				   (CASE
				   		WHEN VERIFICAR_NIVEL_CONFIANCA.NIVEL IN ('MÉDIA', 'ALTA')
							THEN 'S'
						ELSE 'N'
				   END)																AS ACESSAFLEX,
				   (CASE
				   		WHEN VERIFICAR_NIVEL_CONFIANCA.NIVEL = 'ALTA'
							THEN '10'
						WHEN VERIFICAR_NIVEL_CONFIANCA.NIVEL = 'MÉDIA'
							THEN '3'
						WHEN VERIFICAR_NIVEL_CONFIANCA.NIVEL = 'BAIXA'
							THEN '0'
				   END)																AS PERCENTUALFLEX
			  FROM VERIFICAR_NIVEL_CONFIANCA
		),
		PCREGIAO AS(
			SELECT PCCLIENT.CODCLI													AS CODCLI,
				   PCCLIENT.ESTCOB													AS ESTADO
			  FROM WINT.PCCLIENT
		),
		PCFRETE AS (
			SELECT PCPEDC.NUMPED,
				   PCPEDC.CODCLI,
				   PCPEDC.CODTRANSP,
				   PCPEDC.CODENDENT,
				   TIPOFRETE.TIPOFRETE_ID											AS TIPOFRETE_ID,
				   TIPOFRETE.TIPOFRETEAPLICADO										AS TIPOFRETEAPLICADO,
				   TIPOFRETE.TIPOFRETEPADRAO										AS TIPOFRETEPADRAO,
				   (CASE
						WHEN PCREGIAO.ESTADO NOT IN ('RS', 'SC', 'PR')
						 AND TIPOFRETE.TIPOFRETEPADRAO != TIPOFRETE.TIPOFRETEAPLICADO
							THEN 'S'
					   	WHEN PCREGIAO.ESTADO IN ('RS', 'SC', 'PR')
					   	 AND TIPOFRETE.TIPOFRETEPADRAO != TIPOFRETE.TIPOFRETEAPLICADO
					   		THEN 'S'
						WHEN PCREGIAO.ESTADO IN ('SC', 'PR')
						 AND TIPOFRETE.TIPOFRETEPADRAO != TIPOFRETE.TIPOFRETEAPLICADO
							THEN 'S'
						ELSE 'N'
				   END)																AS DIFERENCA_TIPOFRETE
			  FROM WINT.PCPEDC
			  JOIN PCREGIAO
			    ON PCPEDC.CODCLI = PCREGIAO.CODCLI
			  JOIN (
			  		 SELECT SUBPCPEDC.NUMPED										AS NUMPED,
			  		 		(CASE
						   		 WHEN SUBPCREGIAO.ESTADO NOT IN ('RS', 'SC', 'PR')
						   			 THEN 1
						   		 WHEN SUBPCREGIAO.ESTADO IN ('RS', 'SC', 'PR') 
						   			 THEN 2
						   		 ELSE 3
						    END)													AS TIPOFRETE_ID,
				   			-- Para regiões do sul, frete CIF, senão frete FOB
						    (CASE
						   		 WHEN SUBPCREGIAO.ESTADO NOT IN ('RS', 'SC', 'PR')
						   			 THEN 'FOB'
						   		 WHEN SUBPCREGIAO.ESTADO IN ('RS', 'SC', 'PR') 
						   			 THEN 'CIF'
						   		 ELSE 'Outro'
						    END)													AS TIPOFRETEAPLICADO,
			  		 		(CASE
						   		 WHEN SUBPCREGIAO.ESTADO NOT IN ('RS', 'SC', 'PR')
						   			 THEN 'FOB'
						   		 WHEN SUBPCREGIAO.ESTADO IN ('RS', 'SC', 'PR') 
						   			 THEN 'CIF'
						   		 ELSE 'Outro'
						     END)													AS TIPOFRETEPADRAO
			  		   FROM WINT.PCPEDC SUBPCPEDC
					   JOIN PCREGIAO SUBPCREGIAO
					     ON SUBPCPEDC.CODCLI = SUBPCREGIAO.CODCLI
			  	   ) TIPOFRETE
			  	ON PCPEDC.NUMPED = TIPOFRETE.NUMPED
		)
   SELECT STANDARD_HASH(CLIENTE.CGCENT || CLIENTE.CLIENTE, 'MD5')           AS HASH,
          CLIENTE.CODCLI                                                    AS ID,
          (CASE
         	   WHEN CLIENTE.DTULTCOMP < ADD_MONTHS(SYSDATE, -36) -- Inativado após 3 anos sem compras
         	     OR CLIENTE.BLOQUEIO IS NOT NULL THEN 'N' 
         	   ELSE 'S'
          END)                                                              AS ATIVO,
          CLIENTE.DTULTALTER                                                AS DATAATUALIZACAO,
          CLIENTE.FANTASIA													AS FANTASIA,
          CLIENTE.CLIENTE                                                   AS RAZAOSOCIAL,
          CLIENTE.CGCENT                                                    AS DOCUMENTORECEITAFEDERAL,
 	      CLIENTE.IEENT                                                     AS INSCRICAOESTADUAL,
          CLIENTE.CEPCOB                                                    AS CEP,
          REGEXP_REPLACE(CLIENTE.ENDERCOB, '[^A-Za-z ]', '')                AS ENDERECO,
          REGEXP_REPLACE(CLIENTE.ENDERCOB, '[^0-9]', '')              		AS NUMERO,
          CLIENTE.COMPLEMENTOCOB                                            AS COMPLEMENTO,
          CLIENTE.BAIRROCOB                                                 AS BAIRRO,
          CLIENTE.MUNICCOB                                                  AS MUNICIPIO,
          CLIENTE.ESTCOB                                                    AS UF,
          (CASE
           	   WHEN CLIENTE.PERDESC2 IS NOT NULL 
         	   	   THEN CLIENTE.PERDESC + CLIENTE.PERDESC2
	       	   WHEN CLIENTE.PERDESC3 IS NOT NULL 
	         	   THEN CLIENTE.PERDESC + CLIENTE.PERDESC3
	           WHEN CLIENTE.PERDESC4 IS NOT NULL 
	         		THEN CLIENTE.PERDESC + CLIENTE.PERDESC4
	     	   WHEN CLIENTE.PERDESC5 IS NOT NULL 
	         		THEN CLIENTE.PERDESC + CLIENTE.PERDESC5
	     	   ELSE CLIENTE.PERDESC
          END)                                                  			AS PERCENTUALTABELA,
          AVG(TRUNC(PCPEDC.DATA)- TRUNC(PCPEDC.DTENTREGA))                  AS PRAZOMEDIOVENDA,
          VERIFICAR_NIVEL_CONFIANCA.NIVEL                                   AS NIVELCONFIANCA,
          PCPLPAG.ID                                                        AS PLANOPAGAMENTO_ID,
          CLIENTE.CODCOB                                                    AS COBRANCA_ID,
          PCPLPAG.ID                                                        AS PLANOPAGAMENTO_ID_B2B,
          CLIENTE.CODCOB                                                    AS COBRANCA_ID_B2B,
          (CASE
          	   WHEN LENGTH(CLIENTE.CGCENT) = 18 THEN 'S' -- Se FOR CNPJ, possui cadastro como b2b
          	   ELSE 'N'
          END) 																AS INTEGRAB2B,
           -- Como na tabela os clientes só possuem um representante, assim já funciona, porém
          -- se houvesse mais, checaria através de uma cartela de representantes
          (CASE
          	   WHEN LENGTH(CLIENTE.CGCENT) = 18 THEN 'S' -- Se FOR CNPJ, possui cadastro como b2b
          	   ELSE 'N'
          END) 																AS INTEGRAB2B,
          (CASE
          	   WHEN REPRESENTANTE.TIPOVEND = 'R' THEN 'S'
          	   ELSE 'N'                             					    
          END)																AS INTEGRAFV,
          (CASE
          	   WHEN REPRESENTANTE.TIPOVEND = 'i' THEN 'S'
          	   ELSE 'N'                             					    
          END)  															AS INTEGRACALLCENTER,
          PCPLPAG.ACESSAPLANOESPECIAL                                       AS ACESSAPLANOESPECIAL,
          PCPLPAG.ACESSAFLEX                                                AS ACESSAFLEX,
          PCPLPAG.PERCENTUALFLEX                                            AS PERCENTUALFLEX,
          PCPEDC.CODTRANSP                                                  AS TRANSPORTADORA_ID,
          PCFRETE.TIPOFRETE_ID                                              AS TIPOFRETE_ID,
          PCFRETE.DIFERENCA_TIPOFRETE                                       AS DIFERENCA_TIPOFRETE,
          PCPEDC.CODENDENT                                                  AS ENDERECOENTREGA_ID,
          NULL                                                              AS TELEFONES,
          NULL                                                              AS EMAILS,
          NULL                                                              AS REGIAO_ID,
          NULL                                                              AS PRACA_ID,
          NULL                                                              AS REDE_ID,
          NULL                                                              AS ATIVIDADE_ID,
          NULL                                                              AS REPRESENTANTE_ID,
          NULL                                                              AS SUPERVISOR_ID,
          NULL                                                              AS OPERACAO_ID,
          NULL                                                              AS DATACADASTRO,
          NULL                                                              AS DATAULTIMACOMPRA,
          NULL                                                              AS DATAPRIMEIRACOMPRA,
          NULL                                                              AS DATAVALIDACAO,
          NULL                                                              AS APLICATABELAPROMOCAO,
          NULL                                                              AS APLICATAXAFIXA,
          NULL                                                              AS OBS_LOGISTICA,
          NULL                                                              AS OBS_CREDITO,
          NULL                                                              AS DATAULTIMOCONTATO,
          NULL                                                              AS TELEFONE,
          NULL                                                              AS EMAIL,
          NULL                                                              AS EMAIL_COBRANCA,
          NULL                                                              AS ATIVIDADE,
          NULL                                                              AS REDE,
          NULL                                                              AS VALORMINIMO_B2B,
          NULL                                                              AS VALORMINIMO_CALLCENTER,
          NULL                                                              AS VALORMINIMO_FV,
          NULL                                                              AS PERCTIPOFRETE,
          NULL                                                              AS PERCENTUALRETIRA,
          NULL                                                              AS CODIBGE,
          NULL                                                              AS INFORMACOES_COMP,
          NULL                                                              AS CLIENTEPRINCIPAL_ID,
          NULL                                                              AS GRUPO_ID,
          NULL                                                              AS CALCULOIMPOSTO,
          NULL                                                              AS CHAVE_TRIBUTARIA,
          NULL                                                              AS TABELAPRECO,
          NULL                                                              AS TABELAPRECO_BNF,
          NULL                                                              AS FILIAL_ID,
          NULL                                                              AS VENDE_FORA_CARTEIRA,
          NULL                                                              AS IPI_ISENTO,
          NULL                                                              AS ALVARA,
          NULL                                                              AS ALVARA_VALIDADE,
          NULL                                                              AS CLASSIFICACAO_ID,
          NULL                                                              AS CLASSIFICACAO_OBS,
          NULL                                                              AS USA_ETAPAS,
          NULL                                                              AS CATEGORIA,
          NULL                                                              AS GRUPOS_AUTORIZADOS,
          NULL                                                              AS REGIAO_ID_REPRESENTANTE,
          NULL                                                              AS VALOR_MEDIO_COMPRAS,
          NULL                                                              AS OBS1,
          NULL                                                              AS OBS2,
          NULL                                                              AS OBS3,
          NULL                                                              AS OBS4,
          NULL                                                              AS OBS5,
          NULL                                                              AS APLICA_PERCENTUAL_BASE,
          NULL                                                              AS SUFRAMA,
          NULL                                                              AS PROSPECT,
          NULL                                                              AS LOGOTIPO,
          NULL                                                              AS ICONE,
          NULL                                                              AS ACESSAB2B,
          NULL                                                              AS CENTRO_CUSTO,
          NULL                                                              AS GRUPOICMS_ID,
          NULL                                                              AS TEMA,
          NULL                                                              AS EXIBE_ORIGEM_PRECO,
          NULL                                                              AS CLASSE_VENDA,
          NULL                                                              AS COLUNA_PRECO,
          NULL                                                              AS DATAULTIMACOMPRA_RCA,
          NULL                                                              AS TOTAL_TITULOS_VENCIDOS,
          NULL                                                              AS BLOQUEADO,
          NULL                                                              AS MOTIVO_BLOQUEIO,
          NULL                                                              AS LEGENDAS,
          NULL                                                              AS UTM_SOURCE,
          NULL                                                              AS UTM_MEDIUM,
          NULL                                                              AS UTM_CAMPAIGN,
          NULL                                                              AS USA_UTM_ORCAMENTOS,
          NULL                                                              AS USA_MULTIPLO_ALTERNATIVO
     FROM WINT.PCCLIENT CLIENTE
     JOIN WINT.PCPEDC
       ON CLIENTE.CODCLI = PCPEDC.CODCLI
     JOIN WINT.PCUSUARI REPRESENTANTE
	   ON PCPEDC.CODUSUR = REPRESENTANTE.CODUSUR
LEFT JOIN VERIFICAR_NIVEL_CONFIANCA
       ON CLIENTE.CODCLI = VERIFICAR_NIVEL_CONFIANCA.CODCLI
LEFT JOIN PCPLPAG
       ON VERIFICAR_NIVEL_CONFIANCA. NIVEL = PCPLPAG.NIVEL
LEFT JOIN PCREGIAO
 	   ON CLIENTE.CODCLI = PCREGIAO.CODCLI
LEFT JOIN PCFRETE
	   ON PCPEDC.NUMPED = PCFRETE.NUMPED
 GROUP BY CLIENTE.CGCENT,
          CLIENTE.CLIENTE,
          CLIENTE.CODCLI,
          CLIENTE.DTULTCOMP,
          CLIENTE.BLOQUEIO,
          CLIENTE.DTULTALTER,
          CLIENTE.FANTASIA,
          CLIENTE.IEENT,
          CLIENTE.CEPCOB,
          CLIENTE.ENDERCOB,
          CLIENTE.COMPLEMENTOCOB,
          CLIENTE.BAIRROCOB,
          CLIENTE.MUNICCOB,
          CLIENTE.ESTCOB,
          CLIENTE.PERDESC,
          CLIENTE.PERDESC2,
          CLIENTE.PERDESC3,
          CLIENTE.PERDESC4,
          CLIENTE.PERDESC5,
          CLIENTE.CODCOB,
   	   	  VERIFICAR_NIVEL_CONFIANCA.NIVEL,
     	  PCPLPAG.ID,
     	  PCPLPAG.ACESSAPLANOESPECIAL,
          PCPLPAG.ACESSAFLEX,
          PCPLPAG.PERCENTUALFLEX,
     	  REPRESENTANTE.TIPOVEND,
     	  PCPEDC.CODTRANSP,
     	  PCPEDC.CODENDENT,
     	  PCFRETE.TIPOFRETE_ID,
     	  PCFRETE.DIFERENCA_TIPOFRETE;
    