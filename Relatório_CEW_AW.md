# AdventureWorks Analytics — Relatório Estratégico

## Visão Geral do Projeto
O projeto tem como objetivo responder perguntas de negócio estratégicas da AdventureWorks utilizando um Data Warehouse modelado no DBT Cloud e um dashboard analítico no Power BI.  
As análises englobam vendas, clientes, produtos, regiões, métodos de pagamento e motivos de compra, permitindo decisões baseadas em dados para aumentar receita e eficiência operacional.

---

## Perguntas de Negócio Respondidas
1. Qual o número de pedidos, quantidade comprada e valor total negociado?  
   → Disponível na Visão Geral e Performance, com segmentadores por produto, cartão, motivo de venda, data, cliente, status, cidade, estado e país.

2. Quais produtos têm maior ticket médio por mês, ano, cidade, estado e país?  
   → Analisado no painel Produto, com ranking de ticket médio e filtros temporais e geográficos.

3. Quem são os 10 clientes que mais compraram em valor total?  
   → Mostrado no painel Clientes, com ranking e possibilidade de filtro cruzado com outras dimensões.

4. Quais as 5 cidades com maior valor total negociado?  
   → Apresentado no painel Cidades, com ranking e análise de concentração geográfica de vendas.

5. Qual o desempenho mensal e anual em pedidos, quantidade e faturamento?  
   → Visualizado no painel Performance, com gráficos de série temporal e indicadores de crescimento.

6. Qual produto teve mais unidades vendidas para o motivo “Promotion”?  
   → Evidenciado no painel Promoção, destacando o produto campeão em volume para campanhas promocionais.

---

## Arquitetura e Modelagem do Data Warehouse
O modelo segue a abordagem estrela (*Star Schema*) com as seguintes tabelas:

- **Fato:**  
  - `FCT_SALES_ORDER` — métricas consolidadas de vendas.
- **Dimensões:**  
  - `DIM_PRODUCTS` — informações de produtos e categorias.  
  - `DIM_CUSTOMER` — dados de clientes e segmentação.  
  - `DIM_ADDRESS` — localizações (cidade, estado, país).  
  - `DIM_CREDITCARD` — métodos de pagamento.  
  - `DIM_SALESREASON` — motivos associados às vendas.

**Pipeline de Dados:**
1. Staging: extração e padronização.  
2. Intermediária: junção de dimensões e fatos.  
3. Marts: camadas analíticas para visualização no Power BI.

---

## Métricas Consolidadas (2011–2014)
- Pedidos realizados: 21,45 mil  
- Produtos vendidos: 274,91 mil  
- Faturamento bruto: $110,37 milhões
- Valor liquido negociado $ 109,84 milhões

---

## Insights Estratégicos
- Ticket médio elevado: concentrar esforços em produtos com maior margem de lucro.  
- Promoções eficazes: campanhas bem direcionadas aumentam significativamente o volume vendido.  
- Potencial regional: cidades como Toronto, Londres e Paris concentram alta receita.  
- Perfil de clientes: top 10 clientes representam parcela relevante do faturamento total.

---

## Dashboards no Power BI

### Visão Geral
![Página de Visão Geral](prints/6bbd2b26-7edb-46b0-a40d-abf27c00be7a.png)

### Produtos
![Página de Produtos](prints/983efbeb-e3a2-460c-b395-cd4053bca48a.png)

### Clientes
![Página de Clientes](prints/8eca00b8-ae3e-4f19-b701-c50e97951b70.png)

### Cidades
![Página de Cidades](prints/f3a6f3a3-9d6d-4778-a782-9d04e0979265.png)

### Performance
![Página de Performance](prints/4a3a1c67-afa0-494a-8ec0-92a37ece3ff4.png)

### Promoção
![Página de Promoção](prints/707912a3-1d89-4267-acd0-f2af907ff3b6.png)
