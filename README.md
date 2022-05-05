### Cursor SQL Server
---
---

> *Os cursores em SQL são bastante úteis quando uma triggers ou uma procedure não atende a um determinado problema, pois eles checam linha a linha do resultado da Query... Com está premissa temos inúmeras possibilidades, uma das que eu mais utilizo em meu trabalho é para fazer UPDATE, com um valor fixo, mas pra diversás condições diferentes*
* **Exemplo:**
> **Em um banco de dados, o cliente passa uma lista com 1000 produtos diferentes e te informa que todos esses produtos terão seu preço atualizado em 5% em cima do valor atual.**

> *Na forma convencional, precisariamos criar 1000 linhas diferente passando o produto único no WHERE, porém para este tipo de problema temos o cursor*


*Lembrando que os cursores devem ser utilizados com extrema cautela, pois são extremamente lentos e pode impactar na disponibilidade do banco de dados, no caso abaixo daria para realizar com um UPDATE diretamente, porém coloquei dentro de um cursor apenas para fins didáticos, na maioria dos casos uma procedure ou uma trigger irá resolver o seu problema, traté o cursosr como um último caso*
****
***

#### SINTAXE

~~~sql
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
~~~