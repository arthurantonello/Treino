--Desafio SQL, montagem da view de Clientes da Versotech

--Abaixo segue o esqueleto da nossa view de clientes com todos os campos que utilizamos
  --vale ressaltar que nem todos terão as informações dentro das tabelas, mas mapeie o que for possível
  
  --As tabelas do Winthor que você irá utilizar são: PCCLIENT, PCUSUARI, PCCIDADE (cadastro de cidades), PCREGIAO (cadastro de região de venda (importante no winthor), 
  -- PCATIVI (cadastros de ramos de atividade (construtora, consumidor final, escola, etc)), PCCOB (cadastro de tipos de cobrança (pix, boleto)), PCPLPAG (cadastro de planos de pagamento (10x, 10/20 dias))
  
  -- Algumas dessas tabelas você não encontrará na base, crie uma estrutura que você ache que faça sentido para preenchimento dos campos da view
  
  -- Qualquer dúvida, pode me chamar!

		  -- CALCULAR_MEDIA_PEDIDOS: Calcula a media de pedidos faturados por cliente
     WITH CALCULAR_MEDIA_PEDIDOS AS (
			  SELECT AVG(PEDIDOS_POR_CLIENTE.QTD_PEDIDOS) 							              AS MEDIA_PEDIDOS
			    FROM (
	                    SELECT COUNT(PCPEDC.NUMPED) 								              AS QTD_PEDIDOS
	                      FROM WINT.PCPEDC
	                     WHERE PCPEDC.POSICAO = 'F'
	                  GROUP BY PCPEDC.CODCLI
	                ) PEDIDOS_POR_CLIENTE
		),
		-- NIVEL_CONFIANCA: classifica cliente pelo número de pedidos relativos à média geral
		/* Aqui o ideal seria verificar score e se paga em dia, porém dessa forma já da para ter uma ideia de confiança,
           utilizando a média de pedidos do cliente */
		VERIFICAR_NIVEL_CONFIANCA AS (
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
                      END) 															                        AS NIVEL
		        FROM WINT.PCPEDC
		  CROSS JOIN CALCULAR_MEDIA_PEDIDOS
		    GROUP BY PCPEDC.CODCLI, CALCULAR_MEDIA_PEDIDOS.MEDIA_PEDIDOS
		),
		-- PCPLPAG: Classifica o cliente em diferentes níveis para diferentes modalidades de pagamento, baseado no nível de confiança
		PCPLPAG AS (
			SELECT VERIFICAR_NIVEL_CONFIANCA.NIVEL									                  AS NIVEL,
				   (CASE
						WHEN VERIFICAR_NIVEL_CONFIANCA.NIVEL = 'ALTA'  
						    THEN 3
						WHEN VERIFICAR_NIVEL_CONFIANCA.NIVEL = 'MÉDIA' 
							THEN 2
						ELSE 1
					END) 															                                    AS ID,
				   -- Condições apenas para parâmetro
				   (CASE
						WHEN VERIFICAR_NIVEL_CONFIANCA.NIVEL = 'ALTA'
							THEN '30/60/90 DD'
						WHEN VERIFICAR_NIVEL_CONFIANCA.NIVEL = 'MÉDIA'
							THEN '30 DD'
						ELSE 'A VISTA'
					END) 															                                    AS CONDICAO,
				   -- Seguindo a lógica da confiança, ganha acessos especiais baseado nela
				   (CASE
				   		WHEN VERIFICAR_NIVEL_CONFIANCA.NIVEL = 'ALTA'
							THEN 'S'
						ELSE 'N'
				   END)																                                  AS ACESSAPLANOESPECIAL,
				   (CASE
				   		WHEN VERIFICAR_NIVEL_CONFIANCA.NIVEL IN ('MÉDIA', 'ALTA')
							THEN 'S'
						ELSE 'N'
				   END)																                                  AS ACESSAFLEX,
				   (CASE
				   		WHEN VERIFICAR_NIVEL_CONFIANCA.NIVEL = 'ALTA'
							THEN '10'
						WHEN VERIFICAR_NIVEL_CONFIANCA.NIVEL = 'MÉDIA'
							THEN '3'
						WHEN VERIFICAR_NIVEL_CONFIANCA.NIVEL = 'BAIXA'
							THEN '0'
				   END)																                                  AS PERCENTUALFLEX
			  FROM VERIFICAR_NIVEL_CONFIANCA
		),
		-- PCREGIAO: Classifica a região por cliente, representante, supervisor e estado.
		PCREGIAO AS(
			 SELECT DENSE_RANK() OVER (ORDER BY PCCLIENT.ESTENT ASC)  				        AS REGIAO_ID,
			  		PCCLIENT.CODCLI									  				                          AS CODCLI,
				    PCCLIENT.ESTENT									  				                          AS ESTADO,
				    PCUSUARI.CODUSUR								  				                          AS COD_REPRESENTANTE,
				    DENSE_RANK() OVER (ORDER BY PCCLIENT.ESTENT ASC)  				          AS REGIAO_ID_REPRESENTANTE,
				    PCUSUARI.CODSUPERVISOR							  				                      AS COD_SUPERVISOR,
				    DENSE_RANK() OVER (ORDER BY PCCLIENT.ESTENT ASC)  				          AS REGIAO_ID_SUPERVISOR
			    FROM WINT.PCCLIENT
			    JOIN WINT.PCUSUARI
			      ON PCCLIENT.CODUSUR1 = PCUSUARI.CODUSUR
			GROUP BY PCCLIENT.ESTENT,
					 PCCLIENT.CODCLI,
					 PCUSUARI.CODUSUR,
				     PCUSUARI.CODSUPERVISOR
		),
		-- PCFRETE: Cria regra de modalidade de fretes
		PCFRETE AS (
			SELECT PCPEDC.NUMPED,
				   PCPEDC.CODCLI,
				   PCPEDC.CODTRANSP,
				   PCPEDC.CODENDENT,
				   TIPOFRETE.TIPOFRETE_ID											    AS TIPOFRETE_ID,
				   TIPOFRETE.TIPOFRETEAPLICADO										AS TIPOFRETEAPLICADO,
				   TIPOFRETE.TIPOFRETEPADRAO										  AS TIPOFRETEPADRAO,
				   TIPOFRETE.PERCTIPOFRETE											  AS PERCTIPOFRETE,
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
						     END)													AS TIPOFRETEPADRAO,
						     (CASE
						     	WHEN SUBPCREGIAO.ESTADO NOT IN ('RS', 'SC', 'PR')
						   			 THEN 1
						   		 WHEN SUBPCREGIAO.ESTADO IN ('RS', 'SC', 'PR') 
						   			 THEN 0
						   		 ELSE 1
						     END)													AS PERCTIPOFRETE
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
         	     OR CLIENTE.BLOQUEIO IS NOT NULL 
         	       THEN 'N' 
         	   ELSE 'S'
          END)                                                              AS ATIVO,
          CLIENTE.DTULTALTER                                                AS DATAATUALIZACAO,
          CLIENTE.FANTASIA													                        AS FANTASIA,
          CLIENTE.CLIENTE                                                   AS RAZAOSOCIAL,
          CLIENTE.CGCENT                                                    AS DOCUMENTORECEITAFEDERAL,
 	      CLIENTE.IEENT                                                       AS INSCRICAOESTADUAL,
          CLIENTE.CEPCOB                                                    AS CEP,
          REGEXP_REPLACE(CLIENTE.ENDERCOB, '[^A-Za-z ]', '')                AS ENDERECO,
          REGEXP_REPLACE(CLIENTE.ENDERCOB, '[^0-9]', '')              		  AS NUMERO,
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
          END)                                                  			      AS PERCENTUALTABELA,
          AVG(TRUNC(PEDIDOC.DATA)- TRUNC(PEDIDOC.DTENTREGA))                AS PRAZOMEDIOVENDA,
          VERIFICAR_NIVEL_CONFIANCA.NIVEL                                   AS NIVELCONFIANCA,
          PCPLPAG.ID                                                        AS PLANOPAGAMENTO_ID,
          CLIENTE.CODCOB                                                    AS COBRANCA_ID,
          PCPLPAG.ID                                                        AS PLANOPAGAMENTO_ID_B2B,
          CLIENTE.CODCOB                                                    AS COBRANCA_ID_B2B,
          (CASE
          	   WHEN LENGTH(CLIENTE.CGCENT) = 18 
          	   	   THEN 'S'
          	   -- Se FOR CNPJ, possui cadastro como b2b
          	   ELSE 'N'
          END) 																AS INTEGRAB2B,
           /* Como na tabela os clientes só possuem um representante, assim já funciona,
            *  porém se houvesse mais, checaria através de uma cartela de representantes */
          (CASE
          	   WHEN LENGTH(CLIENTE.CGCENT) = 18 
          	   	   THEN 'S'
          	   -- Se FOR CNPJ, possui cadastro como b2b
          	   ELSE 'N'
          END) 																AS INTEGRAB2B,
          (CASE
          	   WHEN REPRESENTANTE.TIPOVEND = 'R' 
          	   	   THEN 'S'
          	   ELSE 'N'                             					    
          END)																AS INTEGRAFV,
          (CASE
          	   WHEN REPRESENTANTE.TIPOVEND = 'i'
          	   	   THEN 'S'
          	   ELSE 'N'                             					    
          END)  															AS INTEGRACALLCENTER,
          PCPLPAG.ACESSAPLANOESPECIAL                                       AS ACESSAPLANOESPECIAL,
          PCPLPAG.ACESSAFLEX                                                AS ACESSAFLEX,
          PCPLPAG.PERCENTUALFLEX                                            AS PERCENTUALFLEX,
          PEDIDOC.CODTRANSP                                                 AS TRANSPORTADORA_ID,
          PCFRETE.TIPOFRETE_ID                                              AS TIPOFRETE_ID,
          PCFRETE.DIFERENCA_TIPOFRETE                                       AS DIFERENCA_TIPOFRETE,
          PEDIDOC.CODENDENT                                                 AS ENDERECOENTREGA_ID,
          CLIENTE.TELCOB                                                    AS TELEFONES,
          CLIENTE.EMAIL                                                     AS EMAILS, -- Aqui acredito que fosse uma cartela de emails
          PCREGIAO.REGIAO_ID                                                AS REGIAO_ID,
          CLIENTE.CODPRACA                                                  AS PRACA_ID,
          CLIENTE.CODREDE                                                   AS REDE_ID,
          CLIENTE.CODATV1                                                   AS ATIVIDADE_ID,
          REPRESENTANTE.CODUSUR                                             AS REPRESENTANTE_ID,
          SUPERVISOR.CODSUPERVISOR                                          AS SUPERVISOR_ID,
          NULL                                                              AS OPERACAO_ID,
          CLIENTE.DTCADASTRO                                                AS DATACADASTRO,
          MAX(PEDIDOC.DATA)                                                 AS DATAULTIMACOMPRA,
          CLIENTE.DTPRIMCOMPRA                                              AS DATAPRIMEIRACOMPRA,
          NULL                                                              AS DATAVALIDACAO,
          CLIENTE.CODPROMOCAOMED                                            AS APLICATABELAPROMOCAO,
          'N'                                                               AS APLICATAXAFIXA,
          NULL                                                              AS OBS_LOGISTICA,
          NULL                                                              AS OBS_CREDITO,
          CLIENTE.DTULTCONTATOCOB                                           AS DATAULTIMOCONTATO,
          CLIENTE.TELCOB                                                    AS TELEFONE,
          CLIENTE.EMAIL                                                     AS EMAIL,
          CLIENTE.EMAILCOB                                                  AS EMAIL_COBRANCA,
          CLIENTE.CODATV1                                                   AS ATIVIDADE,
          CLIENTE.CODREDE                                                   AS REDE,
          NULL                             									                AS VALORMINIMO_B2B,
          NULL                                                              AS VALORMINIMO_CALLCENTER,
          NULL                                                              AS VALORMINIMO_FV,
          PCFRETE.PERCTIPOFRETE                                             AS PERCTIPOFRETE,
          0                                                                 AS PERCENTUALRETIRA,
          NULL                                                              AS CODIBGE,
          NULL                                                              AS INFORMACOES_COMP,
          NULL                                                              AS CLIENTEPRINCIPAL_ID,
          CLIENTE.CODGRUPO_DMS                                              AS GRUPO_ID,
          'S'                                                               AS CALCULOIMPOSTO,
          NULL                                                              AS CHAVE_TRIBUTARIA,
          CLIENTE.ORIGEMPRECO                                               AS TABELAPRECO,
          NULL                                                              AS TABELAPRECO_BNF,
          CLIENTE.CODFILIALESTOQUE                                          AS FILIAL_ID,
          'N'                                                               AS VENDE_FORA_CARTEIRA,
          CLIENTE.ISENTOIPI                                                 AS IPI_ISENTO,
          CLIENTE.NUMALVARA                                                 AS ALVARA,
          CLIENTE.DTVENCALVARA                                              AS ALVARA_VALIDADE,
          NULL                                                              AS CLASSIFICACAO_ID,
          NULL                                                              AS CLASSIFICACAO_OBS,
          (CASE
          	   WHEN LENGTH(CLIENTE.CGCENT) = 18 
          	   	   THEN 'S' -- Se FOR CNPJ usa etapas de compra
		       ELSE 'N'
          END)                                                              AS USA_ETAPAS,
          (CASE
          	   WHEN CALC_QTD_PEDIDOS_ULT_12_MESES.QTDPEDIDOS >= 3
          	   	   THEN 'A'
          	   WHEN CALC_QTD_PEDIDOS_ULT_12_MESES.QTDPEDIDOS = 2
          	   	   THEN 'B'
          	   WHEN CALC_QTD_PEDIDOS_ULT_12_MESES.QTDPEDIDOS = 1
          	   	   THEN 'C'
          	   ELSE 'F'
          END) /* Qtd apenas para parâmetro, ideal seria usar qtd maiores*/ AS CATEGORIA,
          NULL                                                              AS GRUPOS_AUTORIZADOS,
          PCREGIAO.REGIAO_ID_REPRESENTANTE                                  AS REGIAO_ID_REPRESENTANTE,
          ROUND(AVG(PEDIDOC.VLTOTAL), 2)                                    AS VALOR_MEDIO_COMPRAS,
          CLIENTE.OBS                                                       AS OBS1,
          CLIENTE.OBS2                                                      AS OBS2,
          CLIENTE.OBS3                                                      AS OBS3,
          CLIENTE.OBS4                                                      AS OBS4,
          CLIENTE.OBS5                                                      AS OBS5,
          'N'                                                               AS APLICA_PERCENTUAL_BASE,
          CLIENTE.SULFRAMA                                                  AS SUFRAMA,
          NULL                                                              AS PROSPECT,
          NULL                                                              AS LOGOTIPO,
          NULL                                                              AS ICONE,
          (CASE
          	   WHEN LENGTH(CLIENTE.CGCENT) = 18 
          	   	   THEN 'S' -- Se FOR CNPJ acesas b2b
		       ELSE 'N'
          END)                                                              AS ACESSAB2B,
          NULL                                                              AS CENTRO_CUSTO,
          1  /*Considerando 1 como contribuinte icms padrão */              AS GRUPOICMS_ID,
          NULL                                                              AS TEMA,
          'S'                                                               AS EXIBE_ORIGEM_PRECO,
          CLIENTE.CLASSEVENDA                                               AS CLASSE_VENDA,
          NULL                                                              AS COLUNA_PRECO,
          (CASE
          	   WHEN REPRESENTANTE.TIPOVEND = 'R' 
          	       THEN MAX(PEDIDOC.DATA)
      		   ELSE NULL 
          END)                                                              AS DATAULTIMACOMPRA_RCA,
          NULL                                                              AS TOTAL_TITULOS_VENCIDOS,
          CLIENTE.BLOQUEIO                                                  AS BLOQUEADO,
          DBMS_LOB.SUBSTR(CLIENTE.MOTIVOBLOQ, 2000, 1)						AS MOTIVO_BLOQUEIO,
          NULL                                                              AS LEGENDAS,
          NULL                                                              AS UTM_SOURCE,
          NULL                                                              AS UTM_MEDIUM,
          NULL                                                              AS UTM_CAMPAIGN,
          NULL                                                              AS USA_UTM_ORCAMENTOS,
          NULL                                                              AS USA_MULTIPLO_ALTERNATIVO
     FROM WINT.PCCLIENT CLIENTE
     JOIN WINT.PCPEDC PEDIDOC
       ON CLIENTE.CODCLI = PEDIDOC.CODCLI
     JOIN WINT.PCUSUARI REPRESENTANTE
	   ON PEDIDOC.CODUSUR = REPRESENTANTE.CODUSUR
LEFT JOIN WINT.PCSUPERV SUPERVISOR
 	   ON REPRESENTANTE.CODSUPERVISOR = SUPERVISOR.CODSUPERVISOR
LEFT JOIN VERIFICAR_NIVEL_CONFIANCA
       ON CLIENTE.CODCLI = VERIFICAR_NIVEL_CONFIANCA.CODCLI
LEFT JOIN PCPLPAG
       ON VERIFICAR_NIVEL_CONFIANCA. NIVEL = PCPLPAG.NIVEL
LEFT JOIN PCREGIAO
 	   ON CLIENTE.CODCLI = PCREGIAO.CODCLI
LEFT JOIN PCFRETE
	   ON PEDIDOC.NUMPED = PCFRETE.NUMPED
  	 JOIN (SELECT SUBCLIENTE.CODCLI											AS CODCLI,
  	 			   COUNT(1)													AS QTDPEDIDOS
			  FROM WINT.PCCLIENT SUBCLIENTE
			  JOIN WINT.PCPEDC SUBPEDIDOC
			    ON SUBCLIENTE.CODCLI = SUBPEDIDOC.CODCLI
			 WHERE SUBPEDIDOC.DATA BETWEEN ADD_MONTHS(SYSDATE, - 12)
			  					       AND SYSDATE
		  GROUP BY SUBCLIENTE.CODCLI) CALC_QTD_PEDIDOS_ULT_12_MESES
  	   ON CLIENTE.CODCLI = CALC_QTD_PEDIDOS_ULT_12_MESES.CODCLI
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
          CLIENTE.TELCOB,
          CLIENTE.EMAIL,
          CLIENTE.CODPRACA,
          CLIENTE.CODREDE,
          CLIENTE.CODATV1,
          CLIENTE.DTCADASTRO,
          CLIENTE.DTPRIMCOMPRA,
          CLIENTE.DTULTCONTATOCOB,
          CLIENTE.CODPROMOCAOMED,
          CLIENTE.EMAILCOB,
          CLIENTE.CODGRUPO_DMS,
          CLIENTE.ORIGEMPRECO,
          CLIENTE.CODFILIALESTOQUE,
          CLIENTE.ISENTOIPI,
          CLIENTE.NUMALVARA,
          CLIENTE.DTVENCALVARA,
          CLIENTE.OBS,
          CLIENTE.OBS2,
          CLIENTE.OBS3,
          CLIENTE.OBS4,
          CLIENTE.OBS5,
          CLIENTE.SULFRAMA,
          CLIENTE.CLASSEVENDA,
          DBMS_LOB.SUBSTR(CLIENTE.MOTIVOBLOQ, 2000, 1),
   	   	  VERIFICAR_NIVEL_CONFIANCA.NIVEL,
     	    PCPLPAG.ID,
     	    PCPLPAG.ACESSAPLANOESPECIAL,
          PCPLPAG.ACESSAFLEX,
          PCPLPAG.PERCENTUALFLEX,
     	    REPRESENTANTE.TIPOVEND,
     	    REPRESENTANTE.CODUSUR,
          SUPERVISOR.CODSUPERVISOR,
     	    PEDIDOC.CODTRANSP,
     	    PEDIDOC.CODENDENT,
     	    PCREGIAO.REGIAO_ID,
     	    PCREGIAO.REGIAO_ID_REPRESENTANTE,
     	    PCFRETE.TIPOFRETE_ID,
     	    PCFRETE.DIFERENCA_TIPOFRETE,
     	    PCFRETE.PERCTIPOFRETE,
     	    CALC_QTD_PEDIDOS_ULT_12_MESES.QTDPEDIDOS;