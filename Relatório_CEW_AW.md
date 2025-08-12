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
- Faturamento liquido: $109,84 milhões  


---

## Analise  Estratégicos
- Produtos com alto ticket médio concentram grande parte da receita, sugerindo foco de marketing nesses itens.  
- Promoções têm impacto significativo no volume de vendas, reforçando a importância de segmentação correta.  
- As cidades líderes em faturamento indicam mercados prioritários para expansão Toronto (Canadá), London (Reino Unido), Paris (França), Seattle (EUA), Burnaby (Canadá).  
- O top 10 de clientes representa uma fatia relevante do faturamento, apontando potencial para programas de fidelidade.
- Produtos com maior ticket médio: Road 150 Red, Mountain-100 Silver.







