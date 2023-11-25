select * from 
[Nashville Housing Data for Data Cleaning csv]

---Date Conversion

select SaleDate,convert(date,saledate)  
from [Nashville Housing Data for Data Cleaning csv]

alter table [Nashville Housing Data for Data Cleaning csv]
add SaleDateConverted date

update [Nashville Housing Data for Data Cleaning csv]
set SaleDateConverted=convert(date,saledate) 

---Populate PropertyAddress

select * from
[Nashville Housing Data for Data Cleaning csv]
--where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,
ISNULL(a.PropertyAddress,b.PropertyAddress) 
from [Nashville Housing Data for Data Cleaning csv]a
Join [Nashville Housing Data for Data Cleaning csv]b
on a.ParcelID=b.ParcelID
and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null

update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress) 
from [Nashville Housing Data for Data Cleaning csv]a
Join [Nashville Housing Data for Data Cleaning csv]b
on a.ParcelID=b.ParcelID
and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null

---Breaking out address into individual columns(Address,City,State)

select PropertyAddress
from [Nashville Housing Data for Data Cleaning csv]

select SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
as Address
from [Nashville Housing Data for Data Cleaning csv]

alter table [Nashville Housing Data for Data Cleaning csv]
add PropertySplitAddress nvarchar(200)

update [Nashville Housing Data for Data Cleaning csv]
set PropertySplitAddress=SUBSTRING(PropertyAddress,1, 
CHARINDEX(',',PropertyAddress)-1)

alter table [Nashville Housing Data for Data Cleaning csv]
add PropertySplitCity nvarchar(200)

update [Nashville Housing Data for Data Cleaning csv]
set PropertySplitCity=SUBSTRING(PropertyAddress,
CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

select
PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from [Nashville Housing Data for Data Cleaning csv]

alter table [Nashville Housing Data for Data Cleaning csv]
add OwnerSplitAddress nvarchar(200)

update [Nashville Housing Data for Data Cleaning csv]
set OwnerSplitAddress=PARSENAME(replace(OwnerAddress,',','.'),3)


alter table [Nashville Housing Data for Data Cleaning csv]
add OwnerSplitCity nvarchar(200)

update [Nashville Housing Data for Data Cleaning csv]
set OwnerSplitCity=PARSENAME(replace(OwnerAddress,',','.'),3)

alter table [Nashville Housing Data for Data Cleaning csv]
add OwnerSplitState nvarchar(200)

update [Nashville Housing Data for Data Cleaning csv]
set OwnerSplitState=PARSENAME(replace(OwnerAddress,',','.'),3)

---Change Y and N to Yes and No

select distinct(SoldAsVacant),count(SoldAsVacant) 
from [Nashville Housing Data for Data Cleaning csv]
Group by SoldAsVacant
Order by 2

select SoldAsVacant,
Case
when SoldAsVacant='Y'then 'Yes'
when SoldAsVacant='N'then 'No'
else SoldAsVacant
end
from [Nashville Housing Data for Data Cleaning csv]

update [Nashville Housing Data for Data Cleaning csv]
set SoldAsVacant=Case
when SoldAsVacant='Y'then 'Yes'
when SoldAsVacant='N'then 'No'
else SoldAsVacant
end

select SoldAsVacant from 
[Nashville Housing Data for Data Cleaning csv]

---Remove Duplicates

With RowNumCTE as(
select *,
ROW_NUMBER() over(
partition by ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
Order by
UniqueID) Row_Num
from [Nashville Housing Data for Data Cleaning csv]
)
delete from RowNumCTE
where Row_Num>1
--The one below comes before the one after when studying personally
select * from RowNumCTE
where Row_Num>1

---Delete unused columns

Alter table [Nashville Housing Data for Data Cleaning csv]
Drop column OwnerAddress,TaxDistrict,PropertyAddress,SaleDate


select * from [Nashville Housing Data for Data Cleaning csv]

