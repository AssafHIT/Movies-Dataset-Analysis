
# Movie Industry Data Analysis 🎬🎭

## 📽️ Project Overview
This project analyzes a movie dataset to gain insights into various aspects of the film industry. The dataset includes information about movies, such as their name, genre, budget, gross earnings, company, director, stars, and more. The project involves cleaning the data, performing SQL queries, and creating a Tableau dashboard for visual analysis.

The goal is to:
- ✅ Analyze movie financial performance 
- ✅ Identify top-performing genres, companies, and actors
- ✅ Explore correlations between movie ratings, budgets, and gross earnings
- ✅ Provide data-driven insights into the film industry

🛠️ Technologies Used:
- SQL Server
- Jupyter Notebook
- Python (for data cleaning)
- Pandas
---

## 📂 Dataset: `Movie Industry` 
The dataset contains **real world information** of worldwide films. https://www.kaggle.com/datasets/danielgrijalvas/movies

---

## 🛠️ SQL Data Cleaning Steps

### 1. Standardize Date Format
```sql
-- Standardize Date Format (Remove '00:00:00:0000')
Select SaleDate, Convert(Date, SaleDate)
from PortfolioProject..NashvilleHousing

Update PortfolioProject..NashvilleHousing
SET SaleDate = Convert(Date, SaleDate)
```
**Explanation:** Converts the SaleDate field to a standard date format by removing the time component.

### 2. Populate Missing Property Addresses
```sql
-- Populate empty Property Address data based on equal ParcelID
select * from PortfolioProject..NashvilleHousing 
where PropertyAddress is null    --  After updating nothing will show

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a JOIN PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

update a SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a JOIN PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null
```
**Explanation:** Identifies records with missing addresses and fills them by matching records with the same ParcelID, since properties with identical ParcelIDs should have the same address.

### 3. Break Out Property Address into Individual Columns
```sql
-- Breaking out PropertyAddress into individual columns (Address, City) using Substring
select 
Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
Substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
from PortfolioProject..NashvilleHousing 

ALTER TABLE PortfolioProject..NashvilleHousing 
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject..NashvilleHousing 
Set PropertySplitAddress = Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) 

ALTER TABLE PortfolioProject..NashvilleHousing 
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject..NashvilleHousing 
SET PropertySplitCity = Substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) 
```
**Explanation:** Splits the PropertyAddress field into separate address and city columns using SUBSTRING and CHARINDEX functions, creating a more structured format for analysis.

### 4. Break Out Owner Address into Individual Columns
```sql
-- Breaking out OwnerAddress into individual columns (Address, City, State) using Parsename
Select OwnerAddress From PortfolioProject..NashvilleHousing

-- Parsename separates each '.'
-- Replacing ',' with dots:
select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From PortfolioProject..NashvilleHousing;

ALTER TABLE PortfolioProject..NashvilleHousing 
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject..NashvilleHousing 
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

ALTER TABLE PortfolioProject..NashvilleHousing 
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject..NashvilleHousing 
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

ALTER TABLE PortfolioProject..NashvilleHousing 
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject..NashvilleHousing 
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);
```
**Explanation:** Uses the PARSENAME function (after replacing commas with periods) to separate the OwnerAddress field into address, city, and state columns for better data organization.

### 5. Standardize Values in SoldAsVacant Field
```sql
-- Change Y and N to "Yes" and "No" in SoldAsVacant field 
Update PortfolioProject..NashvilleHousing 
Set SoldAsVacant =
	CASE When CAST(SoldAsVacant as VARCHAR(MAX)) = 'Y' THEN 'Yes'
		 When CAST(SoldAsVacant as VARCHAR(MAX)) = 'N' THEN 'No'
		 ELSE CAST(SoldAsVacant as VARCHAR(MAX))
		 End

-- Check results:
SELECT DISTINCT CAST(SoldAsVacant AS VARCHAR(MAX)), count(CAST(SoldAsVacant AS VARCHAR(MAX)))
FROM PortfolioProject..NashvilleHousing
Group by CAST(SoldAsVacant AS VARCHAR(MAX))
```
**Explanation:** Standardizes the SoldAsVacant field by converting 'Y' and 'N' values to 'Yes' and 'No' using CASE statements, ensuring consistency in categorical data.

### 6. Remove Duplicate Records
```sql
-- Remove Duplicates
WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER(
            PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
            ORDER BY UniqueID
        ) AS row_num
    FROM PortfolioProject..NashvilleHousing
)
Delete FROM RowNumCTE
where row_num > 1
```
**Explanation:** Uses a Common Table Expression (CTE) with the ROW_NUMBER() window function to identify and remove duplicate records based on key fields, ensuring data integrity.

### 7. Delete Unused Columns
```sql
-- Delete unused columns
Select * From PortfolioProject..NashvilleHousing

Alter Table PortfolioProject..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table PortfolioProject..NashvilleHousing
Drop Column SaleDate
```
**Explanation:** Removes the original columns that are no longer needed after creating more structured versions, optimizing the table schema.

---

## 💡 Skills Demonstrated
- 📊 **Data cleaning with SQL**
- 🔍 **Handling NULL values**
- 🔤 **String manipulation and parsing**
- 🛠️ **Table alterations**
- 📑 **Common Table Expressions (CTEs)**
- 🔢 **Window functions**
- ⚖️ **CASE statements**

---

## 🔄 Results
After running these scripts, the Nashville Housing data is:
- 🧹 Free of duplicates
- 📆 Standardized date formats
- 🏠 Address information broken into component parts
- 📊 Categorical values standardized
- ⚡ Optimized with only necessary columns

---

## 📈 Future Improvements
- Creating indexes on frequently queried columns
- Adding additional data validation rules
- Creating views for common analysis scenarios
