USE PortfolioProject;

/*

Cleaning Data in SQL Queries

*/

Select *
From PortfolioProject.dbo.[NashvilleHousing ]

-----------------------------------------------------------------------------------------------------

-- Standardize Data Format:

Select SaleDateConverted, CONVERT(Date, SaleDate)
From PortfolioProject.dbo.[NashvilleHousing ]

Alter TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)





-----------------------------------------------------------------------------------------------------

--Populate Property Address Data:

SELECT *
FROM PortfolioProject.dbo.[NashvilleHousing ]
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

--SELEF JOIN
SELECT A.ParcelID, B.ParcelID, A.PropertyAddress, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM NashvilleHousing AS A
JOIN NashvilleHousing AS B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID] <> B.[UniqueID]
WHERE A.PropertyAddress IS NULL


UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM NashvilleHousing AS A
JOIN NashvilleHousing AS B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID] <> B.[UniqueID]
WHERE A.PropertyAddress IS NULL









-----------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject.dbo.[NashvilleHousing ]
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


SELECT * 
FROM PortfolioProject.dbo.[NashvilleHousing ]



SELECT OwnerAddress
FROM PortfolioProject.dbo.[NashvilleHousing ]

SELECT PARSENAME (REPLACE (OwnerAddress,',','.'),3)
, PARSENAME (REPLACE (OwnerAddress,',','.'),2),
PARSENAME (REPLACE (OwnerAddress,',','.'),1)
FROM PortfolioProject.dbo.[NashvilleHousing ]




ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME (REPLACE (OwnerAddress,',','.'),3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity  NVARCHAR(255);

UPDATE NashvilleHousing
SET  OwnerSplitCity = PARSENAME (REPLACE (OwnerAddress,',','.'),2)


ALTER TABLE NashvilleHousing
ADD OwnerSplitState  NVARCHAR(255);

UPDATE NashvilleHousing
SET  OwnerSplitState = PARSENAME (REPLACE (OwnerAddress,',','.'),1)





SELECT * 
FROM PortfolioProject.dbo.[NashvilleHousing ]

---------------------------------------------------------------------------

/*Change Y and N to Yes and No in "Sold as Vacant" filed*/

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.[NashvilleHousing ]
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM PortfolioProject.dbo.[NashvilleHousing ]


UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END


----------------------------------------------------------------------------------------
-- Remove Duplicate

WITH RowNumCTE AS (
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY 
			 UniqueID
			 )row_num
FROM PortfolioProject.dbo.[NashvilleHousing ]
--ORDER BY ParcelID
)
DELETE 
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress

WITH RowNumCTE AS (
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY 
			 UniqueID
			 )row_num
FROM PortfolioProject.dbo.[NashvilleHousing ]
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1

--------------------------------------------------------------------------------------------
--Delete Unused Columns:

Select * 
From PortfolioProject.dbo.[NashvilleHousing ]

Alter Table NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, propertyAddress

Alter Table NashvilleHousing
Drop Column SaleDate





















SELECT * 
FROM PortfolioProject.dbo.[NashvilleHousing ]



















