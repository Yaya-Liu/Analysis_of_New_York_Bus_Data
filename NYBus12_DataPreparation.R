library(tidyverse)
library(chron)
library(geosphere)

##Import dataset, total 6462122 rows and 17 columns.
df <- read.csv("C:\\Rdata\\Bussiness_Analytics\\mta_1712.csv", stringsAsFactors = FALSE)
names(df)[names(df) == "VehicleLocation.Latitude"] <- "VehicleLocationLatitude"
names(df)[names(df) == "VehicleLocation.Longitude"] <- "VehicleLocationLongitude"

summary(df)
summary.default(df)
nrow(df)    #6462122 rows

TableLineName <- table(df$PublishedLineName)
AllPublishedLineNames <-  names(TableLineName)
length(AllPublishedLineNames)   #329 bus Lines

##Drop rows including missing values, 
MTA_Dec1712 <- na.omit(df)

##Drop records for express routes
MTA_Dec1712 <- dplyr::filter(MTA_Dec1712, !grepl("BM|BxM|M Shuttle Bus|QM|X", MTA_Dec1712$PublishedLineName))

summary(MTA_Dec1712)  
nrow(MTA_Dec1712)   #4856508 rows

##Get all published Line names
TableLineName1 <- table(MTA_Dec1712$PublishedLineName)
AllPublishedLineNames1 <-  names(TableLineName1)
length(AllPublishedLineNames1)   #206 bus Lines



##Calculate the scheduled Hours, Minutes and Seconds. 
MTA_Dec1712_TD <- filter(MTA_Dec1712, hours(RecordedAtTime) >= 3 & hours(RecordedAtTime) < 23)

Bus_scheduled_hours <- hours(strptime(MTA_Dec1712_TD$ScheduledArrivalTime,
                                       format = "%H:%M:%S",
                                       tz = "America/New_York"))
Bus_scheduled_minutes <- minutes(strptime(MTA_Dec1712_TD$ScheduledArrivalTime,
                                           format = "%H:%M:%S",
                                           tz = "America/New_York"))
Bus_scheduled_seconds <- seconds(strptime(MTA_Dec1712_TD$ScheduledArrivalTime,
                                           format = "%H:%M:%S",
                                           tz = "America/New_York"))


##Store the the scheduled Hours, Minutes and Seconds to the data frame temporarily
MTA_Dec1712_TD$ScheduledHours <- Bus_scheduled_hours
MTA_Dec1712_TD$ScheduledMinutes <- Bus_scheduled_minutes
MTA_Dec1712_TD$ScheduledSeconds <- Bus_scheduled_seconds

MTA_Dec1712_TD <- na.omit(MTA_Dec1712_TD)

##Get expected arrival hours, minutes and seconds
Bus_expected_hours <- hours(MTA_Dec1712_TD$ExpectedArrivalTime)
Bus_expected_minutes <- minutes(MTA_Dec1712_TD$ExpectedArrivalTime)
Bus_expected_seconds <- seconds(MTA_Dec1712_TD$ExpectedArrivalTime)

##Calculate delay time based on the expected arrival time and the scheduled arrival time
MTA_Dec1712_TD$Delay <- 3600 * (Bus_expected_hours - MTA_Dec1712_TD$ScheduledHours) +
  60 * (Bus_expected_minutes - MTA_Dec1712_TD$ScheduledMinutes) +
  (Bus_expected_seconds - MTA_Dec1712_TD$ScheduledSeconds)

MTA_Dec1712_TD$Delay <- round(MTA_Dec1712_TD$Delay, 0)

##Remove temporial columns
MTA_Dec1712_TD[ ,c('ScheduledHours', 'ScheduledMinutes', 'ScheduledSeconds')] <- list(NULL)


##Calculate the distance from starting point to the current location(km)
DistOriCurrVector <- round(distCosine(MTA_Dec1712_TD[, 6:5], MTA_Dec1712_TD[, 12:11], r=6378137)/1000,2)

##Calculate the bus route length(km)
DistOriDestVector <- round(distCosine(MTA_Dec1712_TD[, 6:5], MTA_Dec1712_TD[, 9:8], r=6378137)/1000,2)

MTA_Dec1712_TD$DistOriCurr <- DistOriCurrVector
MTA_Dec1712_TD$DistOriDest <- DistOriDestVector
MTA_Dec1712_TD[, c("DistOriCurr", "DistOriDest")]

##Generate a unique sequence and store it in the first column of the dataset
##It will serve as the primary key to create table by using SQL.

PrimaryKey <- seq(1, nrow(MTA_Dec1712_TD), by = 1)
MTA_Dec1712_TD$PrimaryKey <- PrimaryKey
MTA_Dec1712_TD <- MTA_Dec1712_TD[, c(21, 1:20)]

nrow(MTA_Dec1712_TD)  #4581067 rows
summary(MTA_Dec1712_TD)

sort(table(MTA_Dec1712_TD$PublishedLineName), decreasing = T)

TableLineName2 <- table(MTA_Dec1712_TD$PublishedLineName)
AllPublishedLineNames2 <-  names(TableLineName2)
length(AllPublishedLineNames2)   #206 bus Lines

##Try to print more decimals on latitude/longitude
print(summary(MTA_Dec1712_TD$VehicleLocationLatitude),digits = 8)


##Create new CSV file
write.csv(MTA_Dec1712_TD, file = "C:\\Rdata\\Bussiness_Analytics\\MTA_Dec1712_TD.csv", 
          row.names = FALSE, na="")

