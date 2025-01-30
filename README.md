# DIO - Desafio criação de projeto lógico de banco de dados para eCommerce

# Roteiro de leitura "README.md" e entendimento do script SQL "DioHeinekeinProjetoLogicoEcommerce.sql":

A) Definição dos objetivos.

B) Narrativa original.

C) Narrativa refinada - Desenvolvimento do script.

## A) Objetivos
Desenvolver e executar o script para criação do banco de dados (dio_ecommercedb), utilizando MySQL Workbench, conhecimentos adquiridos em aula e experiência, incluindo também:

- Identificação individualizada do cliente como CPF ou CNPJ.
- Formas de pagamento.
- Controle sobre as entregas.

## B) Narrativa original

O escopo geral do negócio será a venda online de produtos originários da própria plataforma e de vendedores terceiros. Serão envolvidos majoritariamente os vendedores, fornecedores, produtos, estoques, pedidos, transportadoras, operadores financeiros, meios de pagamento, endereços de entrega e clientes.

Por lógica, a construção de um modelo com a complexidade mínima necessária, irá envolver até mesmo mais agentes que os descritos na narrativa original. 

- Produtos / fornecedor
  - Os produtos são vendidos por uma única plataforma online;
  - Estes produtos apresentados para venda na plataforma, também poderão ser originários de vendedores terceiros (outros que não a própria plataforma);
  - Cada produto possui um fornecedor - ou um vendedor terceiro;
  - Um ou mais produtos compõem um pedido.
- Clientes
  - O cliente pode se cadastrar no site como pessoa física (CPF) ou pessoa jurídica (CNPJ), mas não pode ter as duas informações;
  - A bem do negócio, por lógica e também para facilitar a modelagem, subentende-se que poderão existir clientes estrangeiros.
  - O endereço do cliente irá determinar o valor do frete;
  - Um cliente pode comprar mais de um pedido;
  - O pedido tem um período de carência - em dias corridos, para devolução do produto.
- Pedidos
  - Os pedidos são criados por clientes e possuem informações de compra, endereço e status da entrega;
  - Um ou mais produtos compõem o pedido;
  - O pedido pode ser cancelado.
- Pagamentos
  - Pode ser cadastrado mais de uma forma de pagamento.
- Entregas
  - Possui status e código de rastreio.

## C) Narrativa Refinada - Desenvolvimento do script

A seguir iremos listar o desenvolvimento do script para criação do bando de dados, nomeado de dio_ecommercedb, para o site de vendas online, onde buscamos seguir a mesma ordem relatada na narrativa.

Com relação a nomenclaturas para tabelas e campos que irão compor o banco de dados e-Commerce, assumimos as mesmas que já foram utilizadas no decorrer do curso para a criação das referidas tabelas e campos.

Finalmente, o script foi documentado com comentários relevantes, bem como os campos das tabelas possuem validações (optamos majoritariamente por constraints) e comentários sobre seu conteúdo, o que pode ser conferido no script DIOHEINEKEINPROJETOLOGICOECOMMERCE.SQL, assim como eventuais casos que entendemos tenham de ser tratados a nível de aplicação, como por exemplo:
  - Validação de CPF.
  - Validação de CNPJ.
  - Não validações para o caso de clientes estrangeiros.
  - Ativação e desativação de praças de entrega.
  - Cancelamento de pedidos pelo campo STATUS.
  - Necessidade de definição ampla de regras de negócio.
  - etc...

## 1. Produtos:
- Para atendimento das necessidades, ajustamos e/ou criamos as tabelas PRODUTO, PRODUTOS POR VENDEDOR E PRODUTOS POR FORNECEDOR (ex DISPONIBILIZANDO UM PRODUTO).
- Prazo de devolução: para atender a legislação e a narrativa, criamos o campo de PRAZO PARA DEVOLUÇÃO (em dias), na tabela PRODUTO.
- Com relação ao PRAZO DE DEVOLUÇÃO do produto, temos que seguir a LEGISLAÇÃO NACIONAL no que se refere ao prazo mínimo para se proceder com uma devolução de venda. Assim sendo terá de ser criada UMA REGRA DE NEGÓCIO, dentro do MODELO DE NEGÓCIOS para estar sempre conforme (ou acima) ao que determina a LEI BRASILEIRA evitando assim eventuais erros de cadastro de produtos.
- Estoques: o controle de estoques na tabela ESTOQUE abrange apenas produtos vendidos pelo site, já os estoques de VENDEDORES TERCEIROS são as quantidades apresentadas no site pelos mesmos.
- Entradas & saídas em estoque: as inclusões (disponibilização para venda no site) em estoque, entradas (compras ou devoluções de vendas) e saídas são tratadas por outros processos, que não foram aqui tratados. Então, temos que um pedido realizado NÃO COMPROMETE (baixa ou reserva) o saldo em estoque até que ocorra o pagamento da compra e seu consequente faturamento, os quais não são aqui tratados.
- Categorias: o processo de categorização de produtos é extremamente importante para um site de vendas online, seja pelo serviço que oferece a seus clientes e também pela questão de SEO. Via de regra, normalmente essa integração já vem dos VENDEDORES ou dos FORNECEDORES. Aqui estamos entendendo que o MODELO DE NEGÓCIOS opta por tratar isso internamente (ponto de reflexão futura).

## 2. Fornecedores:
- Criamos os campos CÓDIGO DE CONTRIBUINTE (ver abaixo) e APELIDO (nome comum ou de fantasia para o fornecedor).
- Alteramos o campo NOME para RAZÃO SOCIAL, de modo a manter o padrão.
- Foi criado o conceito de CÓDIGO DE CONTRIBUINTE e consequentemente o campo necessário para armazenar o CNPJ - cadastro nacional pessoa jurídica, CPF - cadastro pessoa física e também para armazenar o próprio código fiscal referente a eventuais fornecedores estrangeiros.
- A diferenciação entre pessoa física (CPF) ou pessoa jurídica (CNPJ) poderá ser feita pela quantidade de caracteres informados pelo usuário do site - 11 para CPF e 14 para CPNJ, podendo assim os mesmos serem validados individualmente através dos cálculos dos dígitos verificadores (Atenção!.
- Porém, para redução de complexidade, assumimos apenas fornecedores nacionais nesse momento, até mesmo porque o processo de importação requer certa estrutura física e intelectual para o negócio e ainda, isso não constava na narrativa original.
- Temos então que a validação do código de contribuinte para fornecedores estrangeiros será tratada ou, por estabelecimento de conexão com a tabela NACIONALIDADE ou através de código a critério das definições futuras do MODELO DO NEGÓCIO, restando simples fazer a eventual futura conexão com a tabela NACIONALIDADE.

## 3. Vendedor Terceiro:
- Alteramos o nome da tabela TERCEIRO - VENDEDOR para VENDEDOR e criamos campos CÓDIGO DE CONTRIBUINTE (ver abaixo) e APELIDO (nome comum ou de fantasia para o vendedor).
- Foi criado o conceito de CÓDIGO DE CONTRIBUINTE e consequentemente os campos necessários para armazenar o CNPJ - cadastro nacional pessoa jurídica, CPF - cadastro pessoa física e também para eventuais vendedores estrangeiros.
- A diferenciação entre pessoa física (CPF) ou pessoa jurídica (CNPJ) poderá ser feita pela quantidade de caracteres informados pelo usuário do site - 11 para CPF e 14 para CPNJ, podendo assim os mesmos serem validados individualmente através dos cálculos dos dígitos verificadores.
- Porém, para redução de complexidade, assumimos apenas vendedores nacionais nesse momento, até mesmo porque o processo de importação requer certa estrutura física e intelectual para o negócio e ainda, isso não constava na narrativa original.
- Temos então que a validação do código de contribuinte para vendedores estrangeiros será tratada ou, por estabelecimento de conexão com a tabela NACIONALIDADE ou através de código a critério das definições futuras do MODELO DO NEGÓCIO, restando simples fazer a eventual futura conexão com a tabela NACIONALIDADE.

## 4. Cliente:
- Foi criado o conceito de CÓDIGO DE CONTRIBUINTE para armazenar CNPJ - cadastro nacional pessoa jurídica, CPF - cadastro pessoa física e também para eventuais vendas realizadas para clientes estrangeiros.
- A diferenciação entre pessoa física (CPF) ou pessoa jurídica (CNPJ) será feita pela quantidade de caracteres informados - 11 para CPF e 14 para CPNJ, podendo assim, os mesmos serem validados individualmente através dos cálculos dos dígitos verificadores.
- Vinculada a tabela CLIENTE, criamos a tabela NACIONALIDADE para diferenciar os clientes pelo seu país de origem. Assim sendo, clientes brasileiros terão de ter CPF ou CNPJ validados, enquanto clientes estrangeiros poderão a seu critério informar os seus respectivos códigos fiscais de contribuintes de seus países de origem, sem a necessidade de validação.
- Isso poderá acrescentar um serviço futuro ao modelo de negócios, como por exemplo os convênios de TAX FREE e eventuais isenções de impostos, resultando em redução de preços finais pelos descontos dos referidos valores de impostos sobre a venda.
- Mantivemos o campo NOME para armazenar o NOME do cliente (pessoa física) ou a RAZÃO SOCIAL (pessoa jurídica).
- Criamos também os campos TELEFONE1, WHATSAPP1 e email, os quais devem ser apresentados (e passíveis) de alteração ao cliente por ocasião do fechamento da venda.
- NÃO ESTAREMOS TRATANDO DE QUESTÕES DE SEGURANÇA E VALIDAÇÃO EM 2 PASSOS.  

## 5. Endereços de entrega:
- Vinculada a tabela CLIENTE, criamos a tabela ENDEREÇOS DE ENTREGA para armazenar diferentes endereços de entrega a critério do cliente.
- Dentro da tabela ENDEREÇOS DE ENTREGA, além dos dados normais necessários para eventuais cálculos de fretes e dos dados da entrega, incluímos o campo de nome APELIDO, de modo que o cliente possa ter diversos endereços de entrega por ele identificados - casa, trabalho, praia, ...
- Também incluímos como diferencial um campo de PONTO DE REFERÊNCIA, para que o cliente possa facilitar a entrega ou enviar algum "recado" para o entregador: "Próximo à Praça da Sé", "Entregar para o zelador", "Ligar para xxxxx", "Interfonar que eu desço", "Cuidado com o cão", ... 

## 6. Meios de pagamento:
- Vinculada a tabela CLIENTE, criamos a tabela MEIOS DE PAGAMENTO, de modo que o cliente possa incluir a seu critério, diversos meios de pagamento, com os campos:
	- NÚMERO DO CARTÃO.
 	- VALIDADE DO CARTÃO.
  - APELIDO, que se apresenta como um serviço ao cliente, onde ele pode identificar a seu critério o meio de pagamento por ele cadastrado - VISA, MASTER, ...
- Códigos de segurança de cartões de crédito não serão armazenados e serão requeridos a cada compra.
- Para os casos de pagamentos que requerem um agente financeiro, vinculada a tabela MEIOS DE PAGAMENTO, criamos a tabela OPERADOR FINANCEIRO, a qual possui os campos necessários para identificação do operador financeiro, bem como um campo de APELIDO.
- Vinculada a tabela OPERADOR FINANCEIRO, criamos a tabela OPERADORAS(BANDEIRAS), a qual possui os dados necessários para cadastramento de operadoras de cartões de crédito (VISA, MASTER, AMEX, ...).
- Vinculada a tabela OPERADOR FINANCEIRO, criamos a TABELA PREÇOS OPERADOR FINANCEIRO (Atenção! Redução de complexidade: existem serviços que disponibilizam essas informações sem a necessidade da criação da tabela), a qual contém campos como
	- NOME OU CAMPANHA para nominar a tabela ou a campanhas de venda promocional impulsionada por uma operadora como VISA e MASTER);
 	- VALIDADE INÍCIO e VALIDADE FIM, para determinar a validade da tabela de preços.
  - PARCELAMENTO MÁXIMO (MESES), para disponibilizar o limite mínimo (para o vencimento) e máximo de parcelas da venda.
  - COBRAR JUROS A PARTIR DE, para determinar em até quantas parcelas não haverá cobrança de juros da venda.
  - TAXA DE JUROS MENSAL, para o caso de cobrança de juros sobre os parcelamentos.
- Os bancos disputam entre si os clientes e um serviço ofertado são as condições de pagamento. Então, é comum um cliente do Banco do Brasil obter uma condição de parcelamento diferente em relação a um cliente da CEF, no que se refere a compras parceladas via cartão de crédito, por exemplo.

## 7. Pedidos:
- Vinculada a tabela PEDIDO, criamos a TABELA PREÇO FRETE (Atenção! Redução de complexidade: existem serviços que disponibilizam essas informações sem a necessidade da criação da tabela), que será utilizada para eventuais cálculos dos custos com fretes, tomando como sempre como base o CEP - código de endereçamento postal brasileiro, com os campos:
	- CEP ORIGEM
 	- CEP DESTINO
  - VALOR KG
  - VALOR CM3
  - % SOBRE VALOR
  - VALIDADE INÍCIO (início da validade da tabela)
  - VALIDADE FIM (fim da validade da tabela)
- Vinculada a TABELA PREÇO FRETE, criamos a tabela TRANSPORTADOR, para identificar os fornecedores de serviços de transporte (entregas).
- E, vinculada a tabela TRANSPORTADOR, por sua vez, criamos a tabela PRAÇAS TRANSPORTADOR, que irá abrigar as praças (locais de entrega) atendidos pelo transportador.
- Por fim, vinculada a TABELA PRAÇAS TRANSPORTADOR, criamos a tabela PRAÇAS, a qual a partir do critério do CEP, identifica as possíveis praças de entrega atendidas pela empresa que possui o site de vendas online.
- Atenção! Na tabela PRAÇAS, temos campo (STATUS) para identificá-la como ATIVA ou INATIVA, com base em critérios de segurança (assaltos, vandalismo, ...), por exemplo.
- Deverão ser criadas REGRAS DE NEGÓCIO para definir "FRETE GRÁTIS" e/ou "DESCONTO NO FRETE".
- Os pedidos poderão ser criados e "abandonados" pelo cliente, o que significa que deverá existir uma rotina de varredura para ações de marketing sobre os carrinhos de compras abandonados pelos clientes e/ou para exclusão (cancelamento automático) dos mesmos, sempre em conformidade com os TERMOS DE USO DAS INFORMAÇÕES DO SITE e LGPD brasileira. 
- Um cliente poderá a seu critério cancelar (excluir) um ítem de um pedido até o seu completo cancelamento (eliminação), restando necessário a critério do MODELO DE NEGÓCIOS, a captura de dados de vendas canceladas para futuras AÇÕES DE MARKETING vinculadas aos TERMOS DE USO DAS INFORMAÇÕES DO SITE e LGPD brasileira.
- Uma venda só se efetiva (processo de faturamento) e executa a consequente atualização de estoque, após o recebimento financeiro da venda.
- O cliente poderá escolher a seu critério o endereço de entrega por ele cadastrado no momento da finalização da venda.
- Também a seu critério, o cliente poderá determinar o meio de pagamento por ele cadastrado no momento da finalização da venda, bem como se ele deseja armazenar esses dados para futuros pagamentos.
- Devem ser criadas REGRAS DE NEGÓCIO para definir o STATUS dos pedidos e poder assim prover serviços ao cliente, encaminhando avisos e emails sobre o andamento de sua compra, por exemplo:
	- Aguardando pagamento: para itens anexados ao pedido (carrinho de compras).
 	- Pagos: para pedidos pagos pelo cliente.
  - Em preparação: para itens pagos e direcionados ao armazém logístico para o processo de embalamento e embarque.
  - A caminho do Centro de Distribuição XXX: para os casos de transbordo de entregas.
  - A caminho de sua casa: para os casos em que o pedido está em rota de entrega final.
  - Entregue e pendente de avaliação.
  - Entregue e avaliado.
  - Cancelado: para pedidos cancelados pelo cliente (não são excluídos e ficarão como uma memória).
  - Ação de marketing: para os casos em que o cliente abandonou o pedido (carrinho de compras) e o site, conforme definido no MODELO DE NEGÓCIOS, está executando ações de convencimento sobre o cliente - e eventualmente sobre o vendedor, de modo a tentar convencê-lo de concluir a compra.
  - Excluído pelo site: vendas abandonadas e que já tiveram ações de marketing esgotadas. (não devem aparecer para o cliente, para evitar raiva, por exemplo)
  - ... e muitos outros mais.
- O cliente deverá ser informado do prazo legal de devolução de sua compra (arrependimento, qualidade ou qualquer) no momento da compra.
- O processo de devolução de vendas não é contemplado neste modelo.
- O cliente deverá ter condições de consultar o andamento de seu pedido a qualquer momento.
- O cliente deverá poder alterar os telefones de contato no fechamento da venda.
- NÃO ESTAREMOS TRATANDO DE QUESTÕES DE SEGURANÇA E VALIDAÇÃO EM 2 PASSOS.

## 8. Entregas:
- Vinculada a tabela PEDIDOS, criamos a tabela ENTREGAS (Atenção! Redução de complexidade: existem serviços que disponibilizam essas informações sem a necessidade da criação da tabela), que possui a finalidade de controlar o andamento das entregas, com os seguintes campos:
	- PEDIDO
 	- TRANSPORTADOR
	- CÓDIGO DE RASTREAMENTO
 	- STATUS DA ENTREGA
  - DATA DA COLETA
  - DATA DA 1ª TENTATIVA DE ENTREGA
  - DATA DA 2ª TENTATIVA DE ENTREGA
  - DATA DA 3ª TENTATIVA DE ENTREGA
  - DATA ENTREGA
  - OBSERVAÇÕES: para incluir eventuais comentários sobre a entrega ou sobre tentativas infrutíferas.
- Deverão ser criadas REGRAS DE NEGÓCIO para determinar quantas tentativas de entrega devem ser feitas antes de eventualmente retornar a venda.
- Também deverão ser criadas REGRAS DE NEGÓCIO quanto a cancelamentos de venda por impossibilidade de entrega.

## Projeto Lógico:

Consta anexo neste repositório o arquivo PNG com o projeto lógico.

## Ferramentas:

- MySQL Workbench
- PyCharm
- Git / Github
