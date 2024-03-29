-- Standardize Date Format

SELECT SaleDate, SaleDateConverted, CONVERT(Date,SaleDate)
FROM NashvilleHousing.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

---------------------------------------------------------------------------

-- Populate Property Address Data

SELECT *
FROM NashvilleHousing.dbo.NashvilleHousing
-- WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing.dbo.NashvilleHousing a
JOIN NashvilleHousing.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing.dbo.NashvilleHousing a
JOIN NashvilleHousing.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

------------------------------------------------------------------------------------------

-- Breaking Out Address Into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM NashvilleHousing.dbo.NashvilleHousing
-- WHERE PropertyAddress IS NULL
-- ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))  AS City
FROM NashvilleHousing.dbo.NashVilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

SELECT *
FROM NashvilleHousing.dbo.NashvilleHousing

SELECT OwnerAddress
FROM NashvilleHousing.dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM NashvilleHousing.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

SELECT *
FROM NashvilleHousing.dbo.NashvilleHousing

-------------------------------------------------------------------------------------

--Change 1 and 0 to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

ALTER TABLE NashvilleHousing.dbo.NashvilleHousing
ALTER COLUMN SoldAsVacant VARCHAR(3)

UPDATE NashvilleHousing.dbo.NashvilleHousing
SET SoldAsVacant = CASE 
                      WHEN SoldAsVacant = '1' THEN 'Yes'
                      WHEN SoldAsVacant = '0' THEN 'No'
                      ELSE SoldAsVacant
                   END;

--------------------------------------------------------------------

--Removing Duplicates (For Practice)

WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY
				UniqueID
				) Row_Num
FROM NashvilleHousing.dbo.NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE Row_Num > 1
ORDER BY PropertyAddress

----------------------------------------------------------------------

-- Delete Unused Columns

SELECT *
FROM NashvilleHousing.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing.dbo.NashvilleHousing
DROP COLUMN SaleDate
