/*

Cleaning Data in SQL Queries

*/


Select *
From NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

select saledate,CONVERT(date,saledate)
from NashvilleHousing

update NashvilleHousing 
set saledate =CONVERT(date,saledate)

Alter table  NashvilleHousing 
add saledateconverted date;


update NashvilleHousing 
set saledateconverted =CONVERT(date,saledate)

select saledateconverted,CONVERT(date,saledate)
from NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- If it doesn't Update properly

select PropertyAddress
from NashvilleHousing
where PropertyAddress is null 


select*
from NashvilleHousing
--where PropertyAddress is null 
order by ParcelID

select*
from NashvilleHousing a 
join NashvilleHousing b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress ,b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

--PropertyAddress

select propertyaddress
from NashvilleHousing


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
from Nashvillehousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

select *
from NashvilleHousing


--OwnerAddress

Select OwnerAddress
From NashvilleHousing

select 
PARSENAME(REPLACE(owneraddress, ',','.'),3),
PARSENAME(REPLACE(owneraddress, ',','.'),2),
PARSENAME(REPLACE(owneraddress, ',','.'),1)
from NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(owneraddress, ',','.'),3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(owneraddress, ',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitstate Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitstate = PARSENAME(REPLACE(owneraddress, ',','.'),1)





Select *
From  portfolioproject.dbo.Nashvillehousing



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


select DISTINCT(soldasvacant),COUNT(soldasvacant)
from portfolioproject.dbo.Nashvillehousing
group by soldasvacant
order by 2


select SoldAsVacant,
CASE WHEN SoldAsVacant ='Y' THEN 'YES'
     WHEN SoldAsVacant ='N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
from portfolioproject.dbo.Nashvillehousing

update  portfolioproject.dbo.Nashvillehousing 
set SoldAsVacant = CASE WHEN SoldAsVacant ='Y' THEN 'YES'
     WHEN SoldAsVacant ='N' THEN 'NO'
	 ELSE SoldAsVacant
	 END

Select *
From  portfolioproject.dbo.Nashvillehousing



-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates


WITH rownumcte as(
select *,
  ROW_NUMBER() OVER(
       PARTITION BY parcelid,
	                propertyaddress,
	                saledate,
					saleprice,
					LegalReference
					order by
					uniqueid) row_num
From  portfolioproject.dbo.Nashvillehousing 
)
select *
from RowNumCte
where row_num > 1
order by uniqueid


delete 
from RowNumCte
where row_num > 1


Select *
From PortfolioProject.dbo.NashvilleHousing



---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
From PortfolioProject.dbo.NashvilleHousing 
order by ParcelID

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate 



