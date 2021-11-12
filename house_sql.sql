------------------------------------ Data Cleaning and Exploration------------------------------------

select * from house.dbo.HousingData

---Convert 
Select SaleDate,Convert(Date,SaleDate) as NewDate
from House.dbo.HousingData
----Add a column with columnname ConvertDate to the table.

Alter table House.dbo.HousingData
add ConvertDate Date

----Updating and Updating the new date into the Table.

Update House.dbo.HousingData
set ConvertDate=Convert(Date,SaleDate)


---- Drop colum from the table


Alter table House.dbo.HousingData
drop Column DateConvert

select * from house.dbo.HousingData

select * from house.dbo.HousingData
order by ParcelId


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,Isnull(a.PropertyAddress,b.PropertyAddress)
from house.dbo.HousingData a
 join house.dbo.HousingData b
on a.ParcelId=b.ParcelId
and a.UniqueId<>b.UniqueID
where a.PropertyAddress is null

Update a
set a.PropertyAddress=Isnull(a.PropertyAddress,b.PropertyAddress)
from house.dbo.HousingData a
 join house.dbo.HousingData b
on a.ParcelId=b.ParcelId
and a.UniqueId<>b.UniqueID
where a.PropertyAddress is null

select * from house.dbo.HousingData


Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)as address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress))as city
from house.dbo.HousingData

Alter table house.dbo.HousingData
add SplitAddress varchar(200)

Update house.dbo.HousingData
set SplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 


select * from house.dbo.HousingData


Alter table house.dbo.HousingData
add SplitCity Varchar(150)

Update house.dbo.HousingData
set SplitCity=substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress))

select * from house.dbo.HousingData

select 
PARSENAME(REplace(Owneraddress,',','.'),3) as Address,
PARSENAME(Replace(OwnerAddress,',','.'),2) as City,
PARSENAME(Replace(OwnerAddress,',','.'),1)as State
from house.dbo.HousingData

Alter table house.dbo.HousingData
add OwnStreet varchar(120)

Update house.dbo.HousingData
set OwnStreet=PARSENAME(REplace(Owneraddress,',','.'),3)


Alter table house.dbo.HousingData
add OwnCity varchar(120)

Update house.dbo.HousingData
set OwnCity=ParseName(REplace(Owneraddress,',','.'),2)

Alter table house.dbo.HousingData
add OwnState varchar(120)

Update House.dbo.HousingData
set OwnState=Parsename(Replace(OwnerAddress,',','.'),1)

select * from house.dbo.HousingData


delete OwnAddress
from house.dbo.HousingData

select Distinct SoldAsVacant,Count(SoldAsVacant)
from house.dbo.HousingData
group  by SoldAsVacant
order by 2

select SoldAsVacant,
CASE When SoldAsVacant='Y' then 'Yes'
                         when SoldAsVacant='N' then 'No'
						 else SoldAsVacant
						 end
from house.dbo.HousingData


Update house.dbo.HousingData
set SoldAsVacant=case when SoldAsVacant='Y' then 'Yes'
                         when SoldAsVacant='N' then 'No'
						 else SoldAsVacant
						 end


Alter table house.dbo.HousingData
drop column OwnAddress

select * from house.dbo.HousingData

Removing Duplicates
----shows the duplicaes in row_num
with cte as(
Select * ,ROW_NUMBER() over(
Partition by 
ParcelID,SaleDate,SalePrice,TotalValue
order by UniqueID
)row_num
from house.dbo.HousingData
)
Select * from cte where row_num>1

with cte as
(Select *,ROW_NUMBER() over(
Partition by ParcelID,OwnerName,TaxDistrict,TotalValue,YearBuilt
order by UniqueID
)duplicate_row
from house.dbo.HousingData
)
delete from cte where duplicate_row>1

Select SalePrice from house.dbo.HousingData

--Max Price of HoseData

Select Max(SalePrice) as MaxSale from house.dbo.HousingData

--Max Price of building Value

Select Max(BuildingValue) as MaxBuildingValue from house.dbo.HousingData

--shows the correlation between the year and no of buildings built
select Distinct YearBuilt,Count(YearBuilt)
from house.dbo.HousingData
group  by YearBuilt
order by 1 

---Shows the Max Number of Sales on one day
select ConvertDate,Count(1) as sales_count,sum(Saleprice) as Price_sum
from house.dbo.HousingData
group by ConvertDate
Order by sales_count desc

--shows the City with highest average price per sale
Select OwnCity,Avg(SalePrice) as avg_Price,count(OwnCity) as SalesCount
from house.dbo.HousingData
group by OwnCity
Order by avg_Price desc

--which year has lowest no of sales

Select ConvertDate,Count(SaleDate) as Sale_Count,Sum(SalePrice) as Price_sum
from house.dbo.HousingData
group by ConvertDate
order by 2

--Which Year has most sales in a year
select year(ConvertDate) as year,count(SalePrice) as SaleCount,sum(SalePrice) as TotalSalePrice 
from house.dbo.HousingData
Group by year(ConvertDate)
Order by 3 desc

--Which month has most sales in the year 2015?

select top 1 month(ConvertDate) as months,sum(SalePrice) as SumSales from house.dbo.HousingData 
where year(ConvertDate)='2015' 
Group by month(ConvertDate)
order by SumSales desc

--Years with lowest no of sales

select year(ConvertDate) Year,count(SaleDate) NumSales ,sum(SalePrice) SumSales
from house.dbo.HousingData 
group by year(ConvertDate)
Order by 2 

--Distinct  Cities in the Table
select distinct SplitCity from  house.dbo.HousingData 

--Cities with the highest average price per sale
select top 5 SplitCity,Round(avg(SalePrice),2) AvgSalePrice,Count(SaleDate) NoOfSales
from  house.dbo.HousingData 
group by  SplitCity
order by 2 desc
 
--select top 5 Cities by price in each year using windows function


select year(ConvertDate) as year,max(SalePrice) as MostSales
from house.dbo.HousingData
where year(ConvertDate)='2015'
group by month(ConvertDate)
Order by 2 desc

select * from house.dbo.HousingData


--select top 5 Cities by price in each year using windows function
--windows function (window function can perform an aggregation based on the partition and 
--return the result back to a row.A window function does not cause rows to become grouped into a single output row.)
--aggregate using Over()
--the OVER clause that makes an aggregate a SQL window function

select  SplitCity,year(SaleDate) as Years,sum(SalePrice) as SaleP
from house.dbo.HousingData
group by year(SaleDate),SplitCity
order by 2 

--get the ranking of the total price by each year
select SplitCity,Years, SaleP,ROW_NUMBER() over(Partition by Years order by SaleP desc) as ranking from
(
select  SplitCity,year(SaleDate) as Years,sum(SalePrice) as SaleP
from house.dbo.HousingData
group by year(SaleDate),SplitCity)a

-- select all records with ranking smaller than or equal to 5
select Years,SplitCity,SaleP,ranking from
(
select  Years,SplitCity,SaleP,ROW_NUMBER() over(Partition by Years order by SaleP desc) as ranking
from(select  SplitCity,year(SaleDate) as Years,sum(SalePrice) as SaleP
from house.dbo.HousingData
group by year(SaleDate),SplitCity) a
)b
where ranking<=5
order by Years,ranking


select distinct Bedrooms from house.dbo.HousingData
order by Bedrooms

--How much sale of 2 and 3 bedrooms in each year using CASE 

Select year(SaleDate) as Years,
sum(case when Bedrooms='2' then 1 else 0 end) as Sum2BEdroom,
sum(case when Bedrooms='3' then 1 else 0 end) as Sum3Bedroom 
from house.dbo.HousingData
group by year(SaleDate)
order by 1

--Average price difference between twoBedroom and 3Bedroom

select year(SaleDate) as Years,
round(avg(case when Bedrooms='2' then Saleprice else null end),2)as Avg2Bedroom,
round(avg(case when Bedrooms='3' then Saleprice else null end),2)as Avg3Bedrooms
from house.dbo.HousingData
group by year(SaleDate)
order by 1


