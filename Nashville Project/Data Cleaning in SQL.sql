create database Nashville_Housing


--Cleaning Data in SQL Queries
select * from Nashville_Housing;

--Standardize Date Format

select saleDate 
from Nashville_Housing

select saleDate, CONVERT(Date, saleDate)
from Nashville_Housing

update Nashville_Housing
set saleDate = CONVERT(Date,saleDate)

alter table Nashville_Housing
add saleDateconverted Date;

update Nashville_Housing
set SaleDate = CONVERT(Date,saleDate)

select saleDateConverted, convert(Date,saleDate)
from Nashville_Housing

--Populate Property Address data

select PropertyAddress
from Nashville_Housing

select * from Nashville_Housing
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.parcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from Nashville_Housing as a
join Nashville_Housing as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from Nashville_Housing as a
join Nashville_Housing as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out Address into Individual columns (Address,City,State)

select
SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) as Address
from Nashville_Housing

alter table Nashville_Housing
add PropertySplitAddress nvarchar(255);

update Nashville_Housing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress)-1)

alter table Nashville_Housing
add PropertySplitCity nvarchar(255);

update Nashville_Housing
set PropertySplitCity= SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress))


select * from Nashville_Housing

select
PARSENAME(Replace(OwnerAddress, ',',','), 3)
,PARSENAME(Replace(OwnerAddress, ',', ','), 2)
,PARSENAME(Replace(OwnerAddress, ',',','), 1)
from Nashville_Housing

alter table Nashville_Housing
add OwnersplitAddress nvarchar(255);

update Nashville_Housing
set OwnerAddress = PARSENAME(Replace(OwnerAddress, ',',','), 3)

alter table Nashville_Housing
add OwnersplitCity nvarchar(255);

update Nashville_Housing
set OwnersplitCity = PARSENAME(Replace(OwnerAddress, ',', ','), 2)


alter table Nashville_Housing
add OwnersplitState nvarchar(255);

update Nashville_Housing
set Ownersplitstate = PARSENAME(Replace(OwnerAddress, ',',','), 1)

select *
from Nashville_Housing

--Change Y and N to Yes and No in "Sold as Vacant ' field

select distinct(soldAsVacant), count(soldAsVacant)
from Nashville_Housing
group by SoldAsVacant
order by 2


select soldasvacant
, case when SoldAsVacant = 'Y' Then 'Yes'
when SoldAsVacant = 'N' Then 'No'
else SoldAsVacant
end
from Nashville_Housing


update Nashville_Housing
set SoldAsVacant = case when SoldAsVacant = 'Y' Then 'Yes'
when SoldAsVacant = 'N' Then 'No'
else SoldAsVacant
end

--Removes Duplicates

with RowNumCTE as(
select *,
Row_Number() over (
partition by ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
order by
UniqueID
) row_num

from Nashville_Housing
)
select *
from RowNumCTE
where row_num > 1
order by PropertyAddress


with RowNumCTE as(
select *,
Row_Number() over (
partition by ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
order by
UniqueID
) row_num

from Nashville_Housing
)
Delete *
from RowNumCTE
where row_num > 1
--order by PropertyAddress


--Delete Unused Columns

select * from Nashville_Housing

alter table Nashville_Housing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table Nashville_Housing
drop column SaleDate


