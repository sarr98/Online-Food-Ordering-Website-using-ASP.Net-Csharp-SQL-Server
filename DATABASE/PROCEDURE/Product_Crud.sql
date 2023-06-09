USE [FoodieDB]
GO
/****** Object:  StoredProcedure [dbo].[Product_Crud]    Script Date: 05/04/2023 11:09:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Product_Crud]
	-- Add the parameters for the stored procedure here
	@Action VARCHAR(20), 
	@ProductId INT=NULL, 
	@Name VARCHAR(100)=NULL, 
	@Description VARCHAR(max)=NULL, 
	@Price DECIMAL(18,2)=0, 
	@Quantity INT=NULL, 
	@ImageUrl VARCHAR(MAX) = NULL,
	@CategoryId INT = NULL, 
	@IsActive BIT = false 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

     --SELECT
	IF @Action='SELECT'
		BEGIN
			SELECT p.*,c.Name AS CategoryName FROM dbo.Products p
			INNER JOIN dbo.Categories c ON c.CategoryId = p.CategoryId ORDER BY p.CreatedDate DESC
		END

     --ACTIVEPRODUCT
	IF @Action='ACTIVEPROD'
		BEGIN
			SELECT p.*,c.Name AS CategoryName FROM dbo.Products p
			INNER JOIN dbo.Categories c ON c.CategoryId = p.CategoryId
			WHERE P.IsActive = 1
		END


	--INSERT
	IF @Action ='INSERT'
		BEGIN
			INSERT INTO DBO.Products(Name,Description,Price,Quantity,ImageUrl,CategoryId,IsActive,CreatedDate)
			VALUES (@Name,@Description,@Price,@Quantity,@ImageUrl,@CategoryId,@IsActive,GETDATE())
		END

	--UPDATE
	IF @Action ='UPDATE'
		BEGIN
			DECLARE @UPDATE_IMAGE VARCHAR(20)
			SELECT @UPDATE_IMAGE = (CASE WHEN @ImageUrl IS NULL THEN 'NO' ELSE 'YES' END)
			IF @UPDATE_IMAGE ='NO'
				BEGIN
					UPDATE DBO.Products SET Name =@Name , Description=@Description , Price=@Price , 
					Quantity=@Quantity , CategoryId=@CategoryId , IsActive= @IsActive
					WHERE ProductId = @ProductId
				END
			ELSE 
				BEGIN
					UPDATE DBO.Products SET Name =@Name , Description=@Description , Price=@Price , Quantity=@Quantity , 
					CategoryId=@CategoryId , IsActive= @IsActive
					WHERE ProductId = @ProductId
				END
			END

	--UPDATE QUANTITY
	IF @Action ='QTYUPDATE'
		BEGIN
			UPDATE DBO.Products SET  Quantity= @Quantity  
			WHERE ProductId = @ProductId
		END
	END

	--DELETE
	IF @Action ='DELETE'
		BEGIN
			DELETE FROM DBO.Products WHERE ProductId = @ProductId
		END

	--GETBYID
	IF @Action ='GETBYID'
		BEGIN
			SELECT * FROM DBO.Products WHERE ProductId = @ProductId
		END


