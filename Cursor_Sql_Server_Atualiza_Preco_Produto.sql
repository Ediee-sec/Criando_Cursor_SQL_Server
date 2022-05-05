-- Declarando as variáveis
DECLARE
			@ProductID		INT
		,	@ProductNumber	VARCHAR(15)
		,	@NewPrice		FLOAT = 0.15

-- Criando o Cursor
DECLARE cur_Atualiza_Preco CURSOR FOR

	-- Realizando a Query do cursor
	SELECT ProductID, ProductNumber
	FROM Production.Product 
	WHERE Class = 'L' AND ListPrice > 0

-- Abrindo o Cursor
OPEN cur_Atualiza_Preco

-- Realizando a busca dentro dos dados do cursor
FETCH NEXT FROM cur_Atualiza_Preco INTO @ProductID, @ProductNumber

-- Realizando o Loop nos dados do cursor, enquanto não for o final da tabela executo o cursor
WHILE @@FETCH_STATUS = 0
	BEGIN 
		-- Atualizando a Tabela de preços 
		UPDATE Production.Product
		SET ListPrice = ListPrice + @NewPrice
		WHERE	ProductID = @ProductID
		AND	ProductNumber = @ProductNumber
		
		-- Indo para o próximo registro do cursor após atualizar a linha
		FETCH NEXT FROM cur_Atualiza_Preco INTO @ProductID, @ProductNumber
	END

-- Fechando o Cursor
CLOSE cur_Atualiza_Preco
DEALLOCATE cur_Atualiza_Preco