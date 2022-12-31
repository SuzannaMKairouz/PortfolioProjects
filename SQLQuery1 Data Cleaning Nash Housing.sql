/* 

Cleaning Data in SQL

*/

Select * 
From dbo.NashvilleHousing

---------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From dbo.NashvilleHousing

update dbo.NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE dbo.NashvilleHousing
Add SaleDateConverted Date;

update dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

---------------------------------------------------------

-- Populate Property Address Data

Select *
From dbo.NashvilleHousing
--Where PropertyAddress is null 
order by parcelID

Select A.parcelID, A.PropertyAddress, B.parcelID, B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
From dbo.NashvilleHousing A
JOIN dbo.NashvilleHousing B
	on A.parcelID = B.parcelID
	AND A.[UniqueID ] <> B.[UniqueID ]
Where A.PropertyAddress is null 

UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
From dbo.NashvilleHousing A
JOIN dbo.NashvilleHousing B
	on A.parcelID = B.parcelID
	AND A.[UniqueID ] <> B.[UniqueID ]
Where A.PropertyAddress is null 

----------------------------------------------------------------------------

-- Breaking Out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From dbo.NashvilleHousing
--Where PropertyAddress is null 
--order by parcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address 
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

FROM dbo.NashvilleHousing 


ALTER TABLE dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(300);

update dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(300);

update dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *

FROM dbo.NashvilleHousing 


Select OwnerAddress
FROM dbo.NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) 
From dbo.NashvilleHousing


 

ALTER TABLE dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(300);

update dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(300);

update dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(300);

update dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) 

Select *
FROM dbo.NashvilleHousing

-------------------------------------------------------

-- Chage Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(soldasvacant) 
From dbo.NashvilleHousing

Select Soldasvacant
, CASE When Soldasvacant = 'Y' THEN 'Yes'
       When Soldasvacant = 'N' THEN 'No'
	   ELSE Soldasvacant	
	   END
From dbo.NashvilleHousing

update dbo.NashvilleHousing
SET SoldasVacant = CASE When Soldasvacant = 'Y' THEN 'Yes'
       When Soldasvacant = 'N' THEN 'No'
	   ELSE Soldasvacant	
	   END

Select Distinct(soldasvacant), Count(Soldasvacant) 
From dbo.NashvilleHousing
Group by Soldasvacant
Order by 2

-----------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					uniqueID
					) row_num 

From dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1 
Order by PropertyAddress

-----------------------------------------------------

-- Delete Unused Columns

Select *
FROM dbo.NashvilleHousing

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN SaleDate