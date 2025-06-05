/* 
Consulta de Vendedores: Escreva uma query para listar todos os vendedores ativos, mostrando as colunas id, nome, salario. Ordene o resultado pelo nome em ordem ascendente.
 */

  select vendedores.id_vendedor 		as id,
	     vendedores.nome,
	     vendedores.salario
    from vendedores
   where vendedores.inativo is false
order by vendedores.nome asc;

/*
Funcionários com Salário Acima da Média: Escreva uma query para listar os funcionários que possuem um salário acima da média salarial de todos os funcionários. A consulta deve mostrar as colunas id, nome, e salário, ordenadas pelo salário em ordem descendente.
*/

  select vendedores.id_vendedor		as id,
  		 vendedores.nome,
  		 vendedores.salario
    from vendedores
   where vendedores.salario > (
   								select avg(subvendedores.salario)
   								  from vendedores as subvendedores
   							  )
order by vendedores.salario desc;

/*
Resumo por cliente: Escreva uma query para listar todos os clientes e o valor total de pedidos já transmitidos. A consulta deve retornar as colunas id, razao_social, total, ordenadas pelo total em ordem descendente.
*/

   select clientes.id_cliente								AS id,
  	      clientes.razao_social,
  	      coalesce(sum(pedido.valor_total), 0) 				AS total
     from clientes
left join pedido
       on clientes.id_cliente = pedido.id_cliente
 group by clientes.id_cliente,
  	      clientes.razao_social
 order by total desc;
   

/*
Situação por pedido: Escreva uma query que retorne a situação atual de cada pedido da base. A consulta deve retornar as colunas id, valor, data e situacao. A situacao deve obedecer a seguinte regra:
Se possui data de cancelamento preenchido: CANCELADO
Se possui data de faturamento preenchido: FATURADO
Caso não possua data de cancelamento e nem faturamento: PENDENTE
Retorno esperado: SELECIONE * DA TABELA ID IN (
SELECIONE SITUAÇÃO ONDE (SITUAÇÃO = CANCELADO,FATURADO E PENDENTE)
 */
   
  select pedido.id_pedido			as id,
  		 pedido.valor_total			as valor,
  		 pedido.data_emissao 		as data,
      	 (
      	  case
      	  	when pedido.data_cancelamento is not null then 'CANCELADO'
      	  	when pedido.data_faturamento is not null then 'FATURADO'
      	  	else 'PENDENTE'
      	  end
      	 ) as situacao
    from pedido;
  
/*
Produtos mais vendidos: Escreva uma query que retorne o produto mais vendido ( em quantidade ), incluindo o valor total vendido deste produto, quantidade de pedidos em que ele apareceu e para quantos clientes diferentes ele foi vendido. A consulta deve retornar as colunas id_produto, quantidade_vendida, total_vendido, clientes, pedidos. Caso haja empate em quantidade de vendas, utilizar o total vendido como critério de desempate.
 */
  
  select itens_pedido.id_produto,
  		 sum(itens_pedido.quantidade) 									as quantidade_vendida,
  		 sum(itens_pedido.preco_praticado * itens_pedido.quantidade) 	as total_vendido,
  		 count(distinct pedido.id_cliente) 								as clientes,
  		 count(distinct pedido.id_pedido) 								as pedidos
    from itens_pedido
  	join pedido
      on itens_pedido.id_pedido = pedido.id_pedido
group by itens_pedido.id_produto
order by quantidade_vendida desc,
		 total_vendido desc
limit 1;