-- Desafio - Dio X Heinekein X MySQL Workbench
-- Criando e implementando um um Projeto Lógico de Banco de Dados
-- Autor: Raimundo Sulzbach
--
-- (*) Atenção! O script Apaga e reinicia o banco de dados dio_ecomercedb.
--
-- Data: 30/01/2025
-- Ferramentas utilizadas: MySQL e PyCharm
--
-- Banco: dio_ecommercedb - banco de dados para um ecommerce que tem produtos próprios e de terceiros para venda
-- 
-- Tabelas =>
-- 
-- cliente: cadastro de clientes
-- endereços de entrega: endereços de entrega para os clientes
-- nacionalidade: cadastro de nacionalidades dos clientes
-- meios de pagamento: maios de pagamento dos clientes
-- operador financeiro: cadastro com os operadores financeiros dos diversos meios de pagamento dos clientes
-- operadorbandeiras: bandeiras de cartões de crédito e débito referentes a alguns meios de pagamento
-- 
-- transportador: cadastro com as transportadoras que entregam as vendas do site
-- praças: cadastro com as praças de entrega das transportadoras
-- tabela preço frete: tabela com os preços dos fretes de entrega dos produtos comprados
-- 
-- estoque: estoques dos produtos em venda
-- locais de estoque: cadastro com as localizações dos estoques
-- 
-- produto: cadastro com os produtos disponíveis para venda
-- 
-- fornecedor: cadastro de fornecedores
-- produtos por fornecedor: cadastro com os produtos por fornecedor
-- 
-- vendedor: cadastro com os vendedores terceiros do site
-- produtos por vendedor: cadastro com os produtos por vendedor terceiro
-- 
-- pedido: cadastro de pedidos dos clientes
-- (*) Atenção: o controle sobre a exclusão de pedidos tem de ser sobre o campo STATUS, através de Regras de Negócio. 
-- relação de produto pedido: cadastro com os produtos comprados por pedido de cliente
-- 

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema dio_ecommercedb
-- -----------------------------------------------------
--
-- apaga o banco de dados se ele existe
--
DROP SCHEMA IF EXISTS `dio_ecommercedb` ;
--
-- cria o banco de dados
--
CREATE SCHEMA IF NOT EXISTS `dio_ecommercedb` DEFAULT CHARACTER SET utf8 ;
USE `dio_ecommercedb` ;

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`Nacionalidade`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`Nacionalidade` ;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`Nacionalidade` (
  `idNacionalidade` INT NOT NULL AUTO_INCREMENT,
  `País` VARCHAR(100) NOT NULL COMMENT 'País de origem do cliente. Clientes nacionais = sempre Brasil. Não sendo Brasil, o cliente é estrangeiro e não terá os cálculos de dígito verificador para CPF ou CNPJ à nível de aplicação.',
  PRIMARY KEY (`idNacionalidade`),
  UNIQUE INDEX `País_UNIQUE` (`País` ASC) VISIBLE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`Cliente`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`Cliente` ;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`Cliente` (
  `idCliente` INT NOT NULL AUTO_INCREMENT COMMENT 'Código interno para o cliente.',
  `Nacionalidade_idNacionalidade` INT NOT NULL COMMENT 'Nacionalidade do cliente',
  `Nome` VARCHAR(100) NOT NULL COMMENT 'Nome ou razão social do cliente. Optamos por manter um campo pois poderão haver vendas para PJ.',
  `Código de Contribuinte` VARCHAR(14) NOT NULL COMMENT 'Campo para armazenar o código de contribuinte do cliente, pode ser CNPJ (PJ - pessoa jurídica e 14 caracteres), CPF (PF - pessoa física e 11 caracteres) ou estrangeiro. Se for de nacionalidade brasileira, a aplicação terá de calcular os dígitos verificadores. Se não for, não calcula. A diferenciação entre PJ e PF será pela quantidade de caracteres à nível de aplicação.',
  `Identificação` VARCHAR(45) NOT NULL COMMENT 'Documento de identificação. PF - qualquer documento com foto ou  PJ - cartão de CNPJ ou então, documento de estrangeiro (cartão de cidadão, título de residência ou passaporte) para Nacionalidade não brasileira.',
  `Endereço` VARCHAR(100) NOT NULL COMMENT 'Endereço de localização do cliente. Optamos por manter em um campo em função do espaço de visualização no ERR. Na tabela de  endereços de entrega os campos estarão distribuídos para o endereço.',
  `Telefone1` VARCHAR(45) NOT NULL COMMENT 'Telefone de contato do cliente.',
  `Whatsapp1` VARCHAR(45) NOT NULL COMMENT 'Whatsapp (ou número telefôncio para receber SMS) do cliente.',
  `email` VARCHAR(45) NOT NULL COMMENT 'email do cliente.',
  PRIMARY KEY (`idCliente`, `Nacionalidade_idNacionalidade`),
  UNIQUE INDEX `idCliente_UNIQUE` (`idCliente` ASC) VISIBLE,
  UNIQUE INDEX `Código de Contribuinte_UNIQUE` (`Código de Contribuinte` ASC) VISIBLE,
  INDEX `fk_Cliente_Nacionalidade1_idx` (`Nacionalidade_idNacionalidade` ASC) VISIBLE,
  CONSTRAINT `fk_Cliente_Nacionalidade1`
    FOREIGN KEY (`Nacionalidade_idNacionalidade`)
    REFERENCES `dio_ecommercedb`.`Nacionalidade` (`idNacionalidade`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`Endereços de Entrega`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`Endereços de Entrega` ;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`Endereços de Entrega` (
  `idEndereços de Entrega` INT NOT NULL,
  `Cliente_idCliente` INT NOT NULL,
  `CEP` VARCHAR(10) NULL,
  `Rua` VARCHAR(200) NULL,
  `Bairro` VARCHAR(100) NULL,
  `Cidade` VARCHAR(100) NULL,
  `Número` VARCHAR(10) NULL,
  `Complemento` VARCHAR(45) NULL,
  `Apelido do Endereço` VARCHAR(100) NULL,
  `Ponto de referência` VARCHAR(200) NULL,
  PRIMARY KEY (`idEndereços de Entrega`, `Cliente_idCliente`),
  INDEX `fk_Endereços de Entrega_Cliente1_idx` (`Cliente_idCliente` ASC) VISIBLE,
  CONSTRAINT `fk_Endereços de Entrega_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `dio_ecommercedb`.`Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`OperadorasBandeiras`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`OperadorasBandeiras` ;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`OperadorasBandeiras` (
  `idOperadorasBandeiras` INT NOT NULL AUTO_INCREMENT COMMENT 'Código interno para o operador do cartão de crédito ou débito.',
  `Código de Contribuinte` VARCHAR(14) NOT NULL COMMENT 'Campo para armazenar o código de contribuinte do operador da bandeira do cartão. Apenas CNPJ (PJ - pessoa jurídica e 14 caracteres), A aplicação terá de calcular os dígitos verificadores.',
  `Razão Social` VARCHAR(100) NOT NULL COMMENT 'Razão social para o operador do cartão de crédito ou débito.',
  `Bandeira` VARCHAR(45) NOT NULL COMMENT 'Bandeira do cartão de crédito ou débito.',
  `Apelido` VARCHAR(100) NOT NULL COMMENT 'Apelido para o operador do cartão.',
  PRIMARY KEY (`idOperadorasBandeiras`),
  UNIQUE INDEX `Bandeira_UNIQUE` (`Bandeira` ASC) VISIBLE,
  UNIQUE INDEX `Código de Contribuinte_UNIQUE` (`Código de Contribuinte` ASC) VISIBLE,
  UNIQUE INDEX `idOperadorasBandeiras_UNIQUE` (`idOperadorasBandeiras` ASC) VISIBLE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`Operador Financeiro`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`Operador Financeiro` ;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`Operador Financeiro` (
  `idOperador Financeiro` INT NOT NULL AUTO_INCREMENT COMMENT 'Código interno para o operador financeiro do cartão.',
  `OperadorasBandeiras_idOperadorasBandeiras` INT NOT NULL COMMENT 'Chave para vínculo com a tabela de bandeiras de cartões.',
  `Código de Contribuinte` VARCHAR(14) NOT NULL COMMENT 'Campo para armazenar o código de contribuinte do cliente. Neste caso, apenas CNPJ (PJ - pessoa jurídica e 14 caracteres). A aplicação terá de calcular os dígitos verificadores.',
  `Razão Social` VARCHAR(100) NOT NULL COMMENT 'Razão social do operador financeiro.',
  `Apelido` VARCHAR(100) NOT NULL COMMENT 'Nome comum ou de fantasia para o oerador financeiro.',
  PRIMARY KEY (`idOperador Financeiro`, `OperadorasBandeiras_idOperadorasBandeiras`),
  INDEX `fk_Operador Financeiro_Operadoras (bandeiras)1_idx` (`OperadorasBandeiras_idOperadorasBandeiras` ASC) VISIBLE,
  UNIQUE INDEX `Código de Contribuinte_UNIQUE` (`Código de Contribuinte` ASC) VISIBLE,
  UNIQUE INDEX `idOperador Financeiro_UNIQUE` (`idOperador Financeiro` ASC) VISIBLE,
  UNIQUE INDEX `OperadorasBandeiras_idOperadorasBandeiras_UNIQUE` (`OperadorasBandeiras_idOperadorasBandeiras` ASC) VISIBLE,
  CONSTRAINT `fk_Operador Financeiro_Operadoras (bandeiras)1`
    FOREIGN KEY (`OperadorasBandeiras_idOperadorasBandeiras`)
    REFERENCES `dio_ecommercedb`.`OperadorasBandeiras` (`idOperadorasBandeiras`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`Meios de Pagamento`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`Meios de Pagamento` ;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`Meios de Pagamento` (
  `idMeios de Pagamento` INT NOT NULL AUTO_INCREMENT COMMENT 'Código interno para o meio de pagamento, o qual pode ser PIX, Boleto, Cartão de Débito, Cartão de Crédito, PayPal e outros.',
  `Cliente_idCliente` INT NOT NULL COMMENT 'Chave para vínculo com o cliente.',
  `Operador Financeiro_idOperador Financeiro` INT NOT NULL COMMENT 'Chave para vínculo com o operador financeiro.',
  `Número do cartão` VARCHAR(16) NOT NULL COMMENT 'Número do cartão de crédito ou débito do cliente (caso ele decida mantê-lo armazenado conosco para futuras compras - decisão à nível de aplicação).',
  `Validade do cartão` VARCHAR(6) NOT NULL COMMENT 'Validade do cartão (formato: DDAAAA).',
  `Apelido` VARCHAR(100) NOT NULL COMMENT 'Apelido para este cartão, definido pelo cliente à nível de aplicação. Como default definir a nível de aplicação = bandeira e o cliente pode alterar.',
  PRIMARY KEY (`idMeios de Pagamento`, `Cliente_idCliente`, `Operador Financeiro_idOperador Financeiro`),
  INDEX `fk_Meios de Pagamento_Cliente1_idx` (`Cliente_idCliente` ASC) VISIBLE,
  INDEX `fk_Meios de Pagamento_Operador Financeiro1_idx` (`Operador Financeiro_idOperador Financeiro` ASC) VISIBLE,
  UNIQUE INDEX `Número do cartão_UNIQUE` (`Número do cartão` ASC) VISIBLE,
  CONSTRAINT `fk_Meios de Pagamento_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `dio_ecommercedb`.`Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Meios de Pagamento_Operador Financeiro1`
    FOREIGN KEY (`Operador Financeiro_idOperador Financeiro`)
    REFERENCES `dio_ecommercedb`.`Operador Financeiro` (`idOperador Financeiro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`Transportador`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`Transportador` ;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`Transportador` (
  `idTransportador` INT NOT NULL AUTO_INCREMENT COMMENT 'Código interno para o transportador.',
  `Código de Contribuinte` VARCHAR(14) NOT NULL COMMENT 'Campo para armazenar o código de contribuinte, neste caso CNPJ (14 caracteres - calcula dígito e tamanho a nível de aplicação). Transportadores, apenas pessoa jurídica.',
  `Razão Social` VARCHAR(100) NOT NULL COMMENT 'Razão social para o transportador.',
  `Apelido` VARCHAR(100) NOT NULL COMMENT 'Nome comum opu nome de fantasia para o transportador.',
  PRIMARY KEY (`idTransportador`),
  UNIQUE INDEX `Código de COntribuinte_UNIQUE` (`Código de Contribuinte` ASC) VISIBLE,
  UNIQUE INDEX `idTransportador_UNIQUE` (`idTransportador` ASC) VISIBLE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`Tabela preco frete`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`Tabela preco frete`;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`Tabela preco frete` (
  `idTabela preco frete` INT NOT NULL AUTO_INCREMENT COMMENT 'Código interno para a tabela de preços de frete.',
  `Transportador_idTransportador` INT NOT NULL COMMENT 'Código para vínculo com a tabela de transportadores.',
  `CEP_origem` VARCHAR(10) NOT NULL COMMENT 'CEP - código de endereçamento postal, de origem do pedido.',
  `CEP_destino` VARCHAR(10) NOT NULL COMMENT 'CEP - código de endereçamento postal, de destino do pedido.',
  `Valor_kg` DECIMAL(12,5) NOT NULL DEFAULT 0.00000 COMMENT 'Custo de frete por kg - quilograma, transportado.',
  `Valor_m3` DECIMAL(12,5) NOT NULL DEFAULT 0.00000 COMMENT 'Custo de frete por m3 - metro cúbico, transportado.',
  `Percent_sobre_valor` DECIMAL(12,5) NOT NULL DEFAULT 0.00000 COMMENT 'Custo de frete em % sobre o valor do pedido.',
  `Validade_inicio` DATETIME NOT NULL COMMENT 'Data de início da validade da tabela de frete.',
  `Validade_fim` DATETIME NOT NULL COMMENT 'Data de fim da validade desta tabela de frete.',
  PRIMARY KEY (`idTabela preco frete`, `Transportador_idTransportador`),
  INDEX `fk_Tabela preco frete_Transportador1_idx` (`Transportador_idTransportador` ASC),
  CONSTRAINT `fk_Tabela preco frete_Transportador1`
    FOREIGN KEY (`Transportador_idTransportador`)
    REFERENCES `dio_ecommercedb`.`Transportador` (`idTransportador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CHECK (`Valor_kg` >= 0),
  CHECK (`Valor_m3` >= 0),
  CHECK (`Percent_sobre_valor` >= 0)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`Pedido`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`Pedido`;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`Pedido` (
  `idPedido` INT NOT NULL AUTO_INCREMENT COMMENT 'Código interno para o pedido.',
  `Cliente_idCliente` INT NOT NULL COMMENT 'Chave para vínculo com a tabela de clientes.',
  `Enderecos_de_Entrega_idEnderecos_de_Entrega` INT NOT NULL COMMENT 'Chave para vínculo com a tabela de endereços de entrega do cliente.',
  `Meios_de_Pagamento_idMeios_de_Pagamento` INT NOT NULL COMMENT 'Chave para vínculo com a tabela de meios de pagamento do cliente.',
  `Tabela preco frete_idTabela preco frete` INT NOT NULL COMMENT 'Chave para vínculo com a tabela de preços de frete para cálculo do frete para a entrega do cliente.',
  `Status_do_pedido` VARCHAR(45) NOT NULL COMMENT 'Status do pedido (definir a nível de Regra de Negócio, sobre o que e como se quer controlar, inclusive e principalmente priorizações e ações de marketing).',
  `Frete` DECIMAL(12,2) NOT NULL DEFAULT 0.00 COMMENT 'Frete calculado para a entrega do pedido. Se for zero, o frete é grátis.',
  PRIMARY KEY (`idPedido`, `Cliente_idCliente`, `Enderecos_de_Entrega_idEnderecos_de_Entrega`, `Meios_de_Pagamento_idMeios_de_Pagamento`, `Tabela preco frete_idTabela preco frete`),
  INDEX `fk_Pedido_Cliente1_idx` (`Cliente_idCliente` ASC) VISIBLE,
  INDEX `fk_Pedido_Enderecos_de_Entrega1_idx` (`Enderecos_de_Entrega_idEnderecos_de_Entrega` ASC) VISIBLE,
  INDEX `fk_Pedido_Meios_de_Pagamento1_idx` (`Meios_de_Pagamento_idMeios_de_Pagamento` ASC) VISIBLE,
  INDEX `fk_Pedido_Tabela preco frete1_idx` (`Tabela preco frete_idTabela preco frete` ASC) VISIBLE,
  UNIQUE INDEX `idPedido_UNIQUE` (`idPedido` ASC) VISIBLE,
  CONSTRAINT `fk_Pedido_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `dio_ecommercedb`.`Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedido_Enderecos_de_Entrega1`
    FOREIGN KEY (`Enderecos_de_Entrega_idEnderecos_de_Entrega`)
    REFERENCES `dio_ecommercedb`.`Enderecos_de_Entrega` (`idEnderecos_de_Entrega`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedido_Meios_de_Pagamento1`
    FOREIGN KEY (`Meios_de_Pagamento_idMeios_de_Pagamento`)
    REFERENCES `dio_ecommercedb`.`Meios_de_Pagamento` (`idMeios_de_Pagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedido_Tabela preco frete1`
    FOREIGN KEY (`Tabela preco frete_idTabela preco frete`)
    REFERENCES `dio_ecommercedb`.`Tabela preco frete` (`idTabela preco frete`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CHECK (`Frete` >= 0)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`Produto`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`Produto`;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`Produto` (
  `idProduto` INT NOT NULL AUTO_INCREMENT COMMENT 'Código interno para o produto.',
  `Descricao` VARCHAR(100) NOT NULL COMMENT 'Descrição do produto.',
  `Valor` DECIMAL(15,5) NOT NULL DEFAULT 0.00001 COMMENT 'Valor unitário de venda do produto.',
  `Prazo_para_devolucao` INT NOT NULL DEFAULT 1 COMMENT 'Prazo para devolução em dias (atenção: existem mínimos legais a serem seguidos para essa definição, que terão de ser considerados).',
  `Categoria` VARCHAR(100) NOT NULL COMMENT 'Categoria de identificação do produto no site.',
  `Foto1` BLOB NOT NULL COMMENT 'Foto 1 do produto',
  `Foto2` BLOB NULL COMMENT 'Foto 2 do produto.',
  `Foto3` BLOB NULL COMMENT 'Foto 3 do produto.',
  `Foto4` BLOB NULL COMMENT 'Foto 4 do produto.',
  `Video1` LONGBLOB NULL COMMENT 'Video do produto.',

  PRIMARY KEY (`idProduto`),
  CHECK (`Valor` > 0),
  CHECK (`Prazo_para_devolucao` > 0)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`Fornecedor`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`Fornecedor` ;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`Fornecedor` (
  `idFornecedor` INT NOT NULL COMMENT 'Código interno para o fornecedor.',
  `Código de Contribuinte` VARCHAR(14) NOT NULL COMMENT 'Campo para armazenar o código de contribuinte, neste caso CNPJ (14 caracteres - calcula dígito e tamanho a nível de aplicação). Fornecedores apenas pessoa jurídica.',
  `Razão Social` VARCHAR(100) NOT NULL COMMENT 'Razão social do fornecedor.',
  `Apelido` VARCHAR(100) NOT NULL COMMENT 'Nome comum ou nome de fantasia para o fornecedor.',
  PRIMARY KEY (`idFornecedor`),
  UNIQUE INDEX `CNPJ_UNIQUE` (`Código de Contribuinte` ASC) VISIBLE,
  UNIQUE INDEX `idFornecedor_UNIQUE` (`idFornecedor` ASC) VISIBLE)
ENGINE = InnoDB
COMMENT = ' ';

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`Produtos por Fornecedor`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`Produtos por Fornecedor` ;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`Produtos por Fornecedor` (
  `Fornecedor_idFornecedor` INT NOT NULL,
  `Produto_idProduto` INT NOT NULL,
  PRIMARY KEY (`Fornecedor_idFornecedor`, `Produto_idProduto`),
  INDEX `fk_Fornecedor_has_Produto_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  INDEX `fk_Fornecedor_has_Produto_Fornecedor_idx` (`Fornecedor_idFornecedor` ASC) VISIBLE,
  CONSTRAINT `fk_Fornecedor_has_Produto_Fornecedor`
    FOREIGN KEY (`Fornecedor_idFornecedor`)
    REFERENCES `dio_ecommercedb`.`Fornecedor` (`idFornecedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fornecedor_has_Produto_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `dio_ecommercedb`.`Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`Locais estoque`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`Locais estoque` ;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`Locais estoque` (
  `idEstoque` INT NOT NULL AUTO_INCREMENT COMMENT 'Código interno para a localização do estoque.',
  `Local` VARCHAR(45) NOT NULL COMMENT 'Nome do local onde está armazenado o estoque.',
  PRIMARY KEY (`idEstoque`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`Estoque`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`Estoque`;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`Estoque` (
  `Produto_idProduto` INT NOT NULL COMMENT 'Chave para vínculo com a tabela de produtos.',
  `Estoque_idEstoque` INT NOT NULL COMMENT 'Chave para vínculo com a tabela de locais onde são armazenados os estoques.',
  `Quantidade` INT NOT NULL DEFAULT 0 COMMENT 'Quantidade de produto na localização.',
  PRIMARY KEY (`Produto_idProduto`, `Estoque_idEstoque`),
  INDEX `fk_Produto_has_Estoque_Estoque1_idx` (`Estoque_idEstoque` ASC) VISIBLE,
  INDEX `fk_Produto_has_Estoque_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  CONSTRAINT `fk_Produto_has_Estoque_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `dio_ecommercedb`.`Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Produto_has_Estoque_Estoque1`
    FOREIGN KEY (`Estoque_idEstoque`)
    REFERENCES `dio_ecommercedb`.`Locais_estoque` (`idEstoque`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CHECK (`Quantidade` >= 0)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`Relacao de produto pedido`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`Relacao de produto pedido`;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`Relacao de produto pedido` (
  `Produto_idProduto` INT NOT NULL COMMENT 'Código para vínculo com a tabela de produtos ofertados pelo vendedor.',
  `Pedido_idPedido` INT NOT NULL COMMENT 'Código para vínculo com a tabela de pedidos.',
  `Quantidade` INT NOT NULL DEFAULT 1 COMMENT 'Quantidade de produto oferecida pelo vendedor e que será vinculada ao pedido. É diferente da quantidade em estoque e ofertada pelo vendedor para venda no site.',
  `Tipo_de_Frete` VARCHAR(20) NOT NULL COMMENT 'Os tipos de frete devem ser definidos a nível de regra do negócio. Pode ser como uma representatividade de CIF (por conta do vendedor) ou FOB (por conta do cliente) a 100% ou então podem haver reduções nos custos de frete a partir da campanhas promocionais, volume comprado, peso (kg), metragem cúbica (m3), ou, até mesmo combinações de tudo isso.',
  PRIMARY KEY (`Produto_idProduto`, `Pedido_idPedido`),
  INDEX `fk_Produto_has_Pedido_Pedido1_idx` (`Pedido_idPedido` ASC) VISIBLE,
  INDEX `fk_Produto_has_Pedido_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  CONSTRAINT `fk_Produto_has_Pedido_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `dio_ecommercedb`.`Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Produto_has_Pedido_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `dio_ecommercedb`.`Pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CHECK (`Quantidade` > 0)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`Vendedor`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`Vendedor` ;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`Vendedor` (
  `idVendedor` INT NOT NULL AUTO_INCREMENT COMMENT 'Código interno para o vendedor',
  `Código de Contribuinte` VARCHAR(14) NOT NULL COMMENT 'Campo para armazenar o código de contribuinte, neste caso CNPJ (14 caracteres - calcula dígito e tamanho a nível de aplicação). Vendedores apenas pessoa jurídica.',
  `Razão Social` VARCHAR(100) NOT NULL COMMENT 'Razão social para o vendedor',
  `Local` VARCHAR(45) NULL COMMENT 'Local onde o vendedor se encontra',
  `Apelido` VARCHAR(100) NOT NULL COMMENT 'Nome comum ou nome de fantasia para o vendedor',
  PRIMARY KEY (`idVendedor`),
  UNIQUE INDEX `Código de Contribuinte_UNIQUE` (`Código de Contribuinte` ASC) VISIBLE,
  UNIQUE INDEX `idVendedor_UNIQUE` (`idVendedor` ASC) VISIBLE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`Produtos por vendedor`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`Produtos por vendedor`;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`Produtos por vendedor` (
  `Vendedor_idVendedor` INT NOT NULL,
  `Produto_idProduto` INT NOT NULL,
  `Quantidade` INT NOT NULL DEFAULT 0 COMMENT 'Quantidade do produto que estará sendo ofertada pelo vendedor no site. É o estoque disponível para venda. Não poderá ser feita venda fracionada.',
  PRIMARY KEY (`Vendedor_idVendedor`, `Produto_idProduto`),
  INDEX `fk_Terceiro_Vendedor_has_Produto_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  INDEX `fk_Terceiro_Vendedor_has_Produto_Terceiro_Vendedor1_idx` (`Vendedor_idVendedor` ASC) VISIBLE,
  CONSTRAINT `fk_Terceiro_Vendedor_has_Produto_Terceiro_Vendedor1`
    FOREIGN KEY (`Vendedor_idVendedor`)
    REFERENCES `dio_ecommercedb`.`Vendedor` (`idVendedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Terceiro_Vendedor_has_Produto_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `dio_ecommercedb`.`Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CHECK (`Quantidade` >= 0)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`Entregas`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`Entregas` ;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`Entregas` (
  `idEntregas` INT NOT NULL AUTO_INCREMENT COMMENT 'Código interno para a entrega.',
  `Pedido_idPedido` INT NOT NULL COMMENT 'Chave para vínculo com a tabela de pedidos.',
  `Transportador_idTransportador` INT NOT NULL COMMENT 'Chave interna para vínculo com a tabela de transportadores.',
  `Código de Rastreamento` VARCHAR(45) NOT NULL COMMENT 'Código de rastreio da encomenda dentro do transportador (vem do transportador).',
  `Status da Entrega` VARCHAR(100) NOT NULL COMMENT 'Status da entrega. Deve ter uma lista de diferentes status definida a nível de Regra de Negócio (o que se quer controlar e quais devem ser priorizados em situações de crise, por exemplo).',
  `Data da Coleta` DATETIME NOT NULL COMMENT 'Data da coleta da venda para encaminhamento da entrega.',
  `Data 1ª tentativa entrega` DATETIME NOT NULL COMMENT 'Data da 1ª tentativa de entrega pelo transportador.',
  `Data 2ª tentativa entrega` DATETIME NULL COMMENT 'Data da 2ª tentativa de entrega pelo transportador.',
  `Data 3ª tentativa entrega` DATETIME NULL COMMENT 'Data da 3ª tentativa de entrega pelo transportador.',
  `Data entrega` DATETIME NOT NULL COMMENT 'Data da entrega efetivada pelo transportador.',
  `Observações` TINYTEXT NOT NULL COMMENT 'Observações quanto a processo da entrega, eventualmente anotados pelo entregador.',
  PRIMARY KEY (`idEntregas`, `Pedido_idPedido`, `Transportador_idTransportador`),
  INDEX `fk_Entregas_Pedido1_idx` (`Pedido_idPedido` ASC) VISIBLE,
  INDEX `fk_Entregas_Transportador1_idx` (`Transportador_idTransportador` ASC) VISIBLE,
  UNIQUE INDEX `Código de Rastreamento_UNIQUE` (`Código de Rastreamento` ASC) VISIBLE,
  CONSTRAINT `fk_Entregas_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `dio_ecommercedb`.`Pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Entregas_Transportador1`
    FOREIGN KEY (`Transportador_idTransportador`)
    REFERENCES `dio_ecommercedb`.`Transportador` (`idTransportador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`Praças transportador`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`Praças transportador` ;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`Praças transportador` (
  `idPraças de Entrega` INT NOT NULL COMMENT 'Chave para vínculo com a tabela de praças.',
  `Transportador_idTransportador` INT NOT NULL COMMENT 'Chave para vínculo com a tabela de transportadores.',
  PRIMARY KEY (`idPraças de Entrega`, `Transportador_idTransportador`),
  INDEX `fk_Praças de Entrega_Transportador1_idx` (`Transportador_idTransportador` ASC) VISIBLE,
  CONSTRAINT `fk_Praças de Entrega_Transportador1`
    FOREIGN KEY (`Transportador_idTransportador`)
    REFERENCES `dio_ecommercedb`.`Transportador` (`idTransportador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`Praças`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`Praças` ;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`Praças` (
  `idPraças` INT NOT NULL COMMENT 'Código interno para definir a praça de entrega.',
  `Praças por transportador_idPraças de Entrega` INT NOT NULL COMMENT 'Chave para vínculo com as praças atendidas pelo transportador.',
  `Praça` VARCHAR(100) NOT NULL COMMENT 'Nome da praça.',
  `Status` TINYINT NOT NULL COMMENT 'Status da praça. T = atendida pelo transportador. F = não atendida pelo transportador.',
  `CEP` VARCHAR(10) NOT NULL COMMENT 'CEP - código de endereçamento postal da praça.',
  PRIMARY KEY (`idPraças`, `Praças por transportador_idPraças de Entrega`),
  INDEX `fk_Praças_Praças por transportador1_idx` (`Praças por transportador_idPraças de Entrega` ASC) VISIBLE,
  CONSTRAINT `fk_Praças_Praças por transportador1`
    FOREIGN KEY (`Praças por transportador_idPraças de Entrega`)
    REFERENCES `dio_ecommercedb`.`Praças transportador` (`idPraças de Entrega`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`Tabela precos operador financeiro`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`Tabela precos operador financeiro`;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`Tabela precos operador financeiro` (
  `idTabela precos operador financeiro` INT NOT NULL AUTO_INCREMENT COMMENT 'Código interno para a tabela de preços do cartão de débito ou crédito.',
  `Operador_Financeiro_idOperador_Financeiro` INT NOT NULL COMMENT 'Chave de vínculo com a tabela de operadores financeiros.',
  `Nome_ou_campanha` VARCHAR(100) NOT NULL COMMENT 'Nome da tabela ou da campanha promocional definida pelo operador para uso do cartão.',
  `Validade_inicio` DATETIME NOT NULL COMMENT 'Data de início da validade da tabela de preços.',
  `Validade_fim` DATETIME NOT NULL COMMENT 'Data de fim da validade da tabela de preços.',
  `Parcelamento_maximo_meses` INT NOT NULL DEFAULT 0 COMMENT 'Número máximo de parcelas para o meio de pagamento.',
  `Cobrar_juros_a_partir_de` INT NOT NULL DEFAULT 0 COMMENT 'A taxa de juros definida pelo operador deve ser cobrada a partir de qual modalidade de parcelamento - em número de parcelas.',
  `Taxa_de_juros_mensal` DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Taxa de juros mensal desta tabela de preços. Sempre tem de ser >= 0.',
  PRIMARY KEY (`idTabela precos operador financeiro`, `Operador_Financeiro_idOperador_Financeiro`),
  INDEX `fk_Tabela precos operador financeiro_Operador_Financeiro1_idx` (`Operador_Financeiro_idOperador_Financeiro` ASC) VISIBLE,
  UNIQUE INDEX `Nome_ou_campanha_UNIQUE` (`Nome_ou_campanha` ASC) VISIBLE,
  CONSTRAINT `fk_Tabela precos operador financeiro_Operador_Financeiro1`
    FOREIGN KEY (`Operador_Financeiro_idOperador_Financeiro`)
    REFERENCES `dio_ecommercedb`.`Operador_Financeiro` (`idOperador_Financeiro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CHECK (`Parcelamento_maximo_meses` >= 0),
  CHECK (`Cobrar_juros_a_partir_de` >= 0),
  CHECK (`Taxa_de_juros_mensal` >= 0)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `dio_ecommercedb`.`timestamps`
-- -----------------------------------------------------
--
-- apaga a tabela
--
DROP TABLE IF EXISTS `dio_ecommercedb`.`timestamps` ;
--
-- cria a tabela
--
CREATE TABLE IF NOT EXISTS `dio_ecommercedb`.`timestamps` (
  `create_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` TIMESTAMP NULL);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

--
-- mostra bancos de dados existentes
--
show databases;

--
-- mostra tabelas criadas
--
show tables;
