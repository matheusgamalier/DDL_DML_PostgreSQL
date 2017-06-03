CREATE SCHEMA EC;

CREATE DOMAIN EC.CPF AS CHAR(11);
CREATE DOMAIN EC.TELEFONE AS VARCHAR(12);

CREATE TABLE EC.CLIENTE
(
	CPF EC.CPF NOT NULL,
    NOME VARCHAR(50) NOT NULL,
    EMAIL VARCHAR(50) NOT NULL,
    DATA_NASCIMENTO DATE NOT NULL,
    TEL_P EC.TELEFONE,
    TEL_R EC.TELEFONE,
    CONSTRAINT PK_CLIENTE PRIMARY KEY (CPF),
    CONSTRAINT UQ_EMAIL UNIQUE (EMAIL)
);

CREATE TABLE EC.ENDERECO 
(
	END_ID SERIAL NOT NULL,
    LOGRADOURO VARCHAR(50) NOT NULL,
    NUMERO INT NOT NULL,
    COMPLEMENTO VARCHAR(15),
    ESTADO CHAR(2) NOT NULL,
    CIDADE VARCHAR(30) NOT NULL,
    BAIRRO VARCHAR(30) NOT NULL,
    CEP CHAR(8) NOT NULL,
    CPF_CLIENTE EC.CPF NOT NULL,
    CONSTRAINT PK_ENDERECO PRIMARY KEY (END_ID),
    CONSTRAINT FK_CLIENTE_ENDERECO FOREIGN KEY (CPF_CLIENTE)
    	REFERENCES EC.CLIENTE(CPF)
);

CREATE TABLE EC.PEDIDO 
(
	PED_ID SERIAL NOT NULL,
    DATA_PEDIDO DATE NOT NULL,
    STATUS CHAR(1) NOT NULL,
    CPF_CLIENTE EC.CPF NOT NULL,
    CONSTRAINT PK_PEDIDO PRIMARY KEY (PED_ID),
    CONSTRAINT CHK_STATUS CHECK (STATUS = 'A' OR STATUS = 'S' OR STATUS = 'T' OR STATUS = 'E'), -- AGUARDANDO, SEPARAÇÃO, TRANSPORTE, ENTREGUE
    CONSTRAINT FK_CLIENTE_PEDIDO FOREIGN KEY (CPF_CLIENTE)
    	REFERENCES EC.CLIENTE(CPF)
);

CREATE TABLE EC.COBRANCA
(
	DANFE INT,
    DATA_COBRANCA DATE NOT NULL,
    PED_ID_PEDIDO SERIAL NOT NULL,
    END_ID_ENDERECO SERIAL NOT NULL,
    CONSTRAINT PK_COBRANCA PRIMARY KEY(PED_ID_PEDIDO),
    CONSTRAINT FK_PEDIDO_COBRANCA FOREIGN KEY (PED_ID_PEDIDO)
    	REFERENCES EC.PEDIDO(PED_ID),
    CONSTRAINT FK_ENDERECO_COBRANCA FOREIGN KEY (END_ID_ENDERECO)
    	REFERENCES EC.ENDERECO (END_ID)
);

CREATE TABLE EC.TRANSPORTADORA
(
	TRA_ID SERIAL NOT NULL,
    NOME VARCHAR(50),
    CONSTRAINT PK_TRANSPORTADORA PRIMARY KEY (TRA_ID)
);

ALTER TABLE EC.PEDIDO
	ADD TRA_ID_TRANSPORTADORA INT;

ALTER TABLE EC.PEDIDO
	ADD CONSTRAINT FK_TRANSPORTADORA_PEDIDO FOREIGN KEY (TRA_ID_TRANSPORTADORA)
    	REFERENCES EC.TRANSPORTADORA(TRA_ID);

CREATE TABLE EC.ENTREGA
(
	DATA_ENTREGA DATE NOT NULL,
    PED_ID_PEDIDO SERIAL NOT NULL,
    END_ID_ENDERECO SERIAL NOT NULL,
    TRA_ID_TRANSPORTADORA SERIAL NOT NULL,
    CONSTRAINT PK_ENTREGA PRIMARY KEY(PED_ID_PEDIDO),
    CONSTRAINT FK_PEDIDO_ENTREGA FOREIGN KEY (PED_ID_PEDIDO)
    	REFERENCES EC.PEDIDO(PED_ID),
    CONSTRAINT FK_ENDERECO_ENTREGA FOREIGN KEY (END_ID_ENDERECO)
    	REFERENCES EC.ENDERECO (END_ID),
    CONSTRAINT FK_TRANSPORTADORA_ENTREGA FOREIGN KEY (TRA_ID_TRANSPORTADORA)
    	REFERENCES EC.TRANSPORTADORA(TRA_ID)
);

CREATE TABLE EC.PRODUTO
(
	SKU CHAR(8) NOT NULL,
    NOME VARCHAR(30) NOT NULL,
    FABRICANTE VARCHAR(30) NOT NULL,
    DESCRICAO VARCHAR(200) NOT NULL,
    ATIVO BOOLEAN DEFAULT FALSE,
    CONSTRAINT PK_PRODUTO PRIMARY KEY (SKU)
);

CREATE TABLE EC.PRECO
(
	PRE_ID SERIAL NOT NULL,
    DATA_INICIO DATE NOT NULL,
    DATA_TERMINO DATE,
    VALOR FLOAT NOT NULL,
    SKU_PRODUTO CHAR(8) NOT NULL,
    CONSTRAINT PK_PRECO PRIMARY KEY (PRE_ID),
    CONSTRAINT FK_PRODUTO_PRECO FOREIGN KEY (SKU_PRODUTO)
    	REFERENCES EC.PRODUTO(SKU)
);

CREATE TABLE EC.ITEM
(
	ITE_ID SERIAL NOT NULL,
    VALOR FLOAT NOT NULL,
    QTDE INT NOT NULL,
    DESCONTO FLOAT,
    PED_ID_PEDIDO SERIAL NOT NULL,
    SKU_PRODUTO CHAR(8) NOT NULL,
    CONSTRAINT PK_ITEM PRIMARY KEY (ITE_ID),
    CONSTRAINT FK_PEDIDO_ITEM FOREIGN KEY (PED_ID_PEDIDO)
    	REFERENCES EC.PEDIDO(PED_ID),
    CONSTRAINT FK_PRODUTO_ITEM FOREIGN KEY (SKU_PRODUTO)
    	REFERENCES EC.PRODUTO(SKU)
);

CREATE TABLE EC.CATEGORIA
(
	ALIAS CHAR(8) NOT NULL,
    NOME VARCHAR(30),
    ALIAS_PAI CHAR(8),
    CONSTRAINT PK_CATEGORIA PRIMARY KEY (ALIAS),
    CONSTRAINT FK_CATEGORIA FOREIGN KEY (ALIAS_PAI)
    	REFERENCES EC.CATEGORIA(ALIAS)
);

CREATE TABLE EC.PRODCAT
(
	SKU_PRODUTO CHAR(8) NOT NULL,
    ALIAS_CATEGORIA CHAR(8) NOT NULL,
    CONSTRAINT PK_PRODCAT PRIMARY KEY (SKU_PRODUTO, ALIAS_CATEGORIA),
    CONSTRAINT FK_PRODUTO_PRODCAT FOREIGN KEY (SKU_PRODUTO)
    	REFERENCES EC.PRODUTO(SKU),
    CONSTRAINT FK_CATEGORIA_PRODCAT FOREIGN KEY (ALIAS_CATEGORIA)
    	REFERENCES EC.CATEGORIA(ALIAS)
);


