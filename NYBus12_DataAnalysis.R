library(tidyverse)
library(data.table)
library(chron)


MTA_Dec1712_New <- fread("C:\\Rdata\\Bussiness_Analytics\\MTA_Dec1712_TD.csv",  
               select = c("RecordedAtTime", "DirectionRef", "PublishedLineName", "Delay",
                          "DistOriCurr", "DistOriDest"),stringsAsFactors = FALSE)

nrow(MTA_Dec1712_New)  #4581067 rows


##Focus on buses in each boroughs(Not include express lines and shuttle bus)
##############################################################################################
## Bus Lines starting with B, running in Brooklyn ##########################################
BusB <- dplyr::filter(MTA_Dec1712_New, grepl("B", MTA_Dec1712_New$PublishedLineName))
BusB <- dplyr::filter(BusB, !grepl("Bx|M|Q|S79", BusB$PublishedLineName))
BusB
names(table(BusB$PublishedLineName))
NumberB <- length(names(table(BusB$PublishedLineName)))

## Statistical Analysis: Bus delay time
BusB_Delay <- aggregate(Delay ~ PublishedLineName, FUN=mean, data = BusB)
BusB_Delay$Delay <- round(BusB_Delay$Delay/60, 2)
summary(BusB_Delay$Delay)

BusB_Delay[order(-BusB_Delay$Delay),]
BusB_AverageDelay <- round(mean(BusB_Delay$Delay),2)

##############################################################################################

##Bus Lines starting with Bx, running in Bronx 
BusBx <- dplyr::filter(MTA_Dec1712_New, grepl("Bx", MTA_Dec1712_New$PublishedLineName))
BusBx
names(table(BusBx$PublishedLineName))
NumberBx <- length(names(table(BusBx$PublishedLineName)))

## Statistical Analysis: Bus delay time
BusBx_Delay <- aggregate(Delay ~ PublishedLineName, FUN=mean, data = BusBx)
BusBx_Delay$Delay <- round(BusBx_Delay$Delay/60, 2)
summary(BusBx_Delay$Delay)

BusBx_Delay[order(-BusBx_Delay$Delay),]
BusBx_AverageDelay <- round(mean(BusBx_Delay$Delay),2)


##############################################################################################

##Bus Lines starting with M, running in Manhattan 
BusM <- dplyr::filter(MTA_Dec1712_New, grepl("M", MTA_Dec1712_New$PublishedLineName))
BusM
names(table(BusM$PublishedLineName))
NumberM <- length(names(table(BusM$PublishedLineName)))

## Statistical Analysis: Bus delay time
BusM_Delay <- aggregate(Delay ~ PublishedLineName, FUN=mean, data = BusM)
BusM_Delay$Delay <- round(BusM_Delay$Delay/60, 2)
summary(BusM_Delay$Delay)

BusM_Delay[order(-BusM_Delay$Delay),]
BusM_AverageDelay <- round(mean(BusM_Delay$Delay),2)

##############################################################################################

##Bus Lines starting with Q, running in Queens 
BusQ <- dplyr::filter(MTA_Dec1712_New, grepl("Q", MTA_Dec1712_New$PublishedLineName))
BusQ
names(table(BusQ$PublishedLineName))
NumberQ <- length(names(table(BusQ$PublishedLineName)))

## Statistical Analysis: Bus delay time
BusQ_Delay <- aggregate(Delay ~ PublishedLineName, FUN=mean, data = BusQ)
BusQ_Delay$Delay <- round(BusQ_Delay$Delay/60, 2)
summary(BusQ_Delay$Delay)

BusQ_Delay[order(-BusQ_Delay$Delay),]
BusQ_AverageDelay <- round(mean(BusQ_Delay$Delay),2)


##############################################################################################
##Bus Lines starting with S, running in Staten Island 
BusS <- dplyr::filter(MTA_Dec1712_New, grepl("S", MTA_Dec1712_New$PublishedLineName))
BusS <- dplyr::filter(BusS, !grepl("B44|B46|Bx|M|Q", BusS$PublishedLineName))
BusS
nrow(BusS)
length(BusS)
BusSTable <- table(BusS$PublishedLineName)

sort(as.numeric(BusSTable))
summary(sort(as.numeric(BusSTable)))

names(BusSTable)
NumberS <- length(names(BusSTable))

BusS_Delay <- aggregate(Delay ~ PublishedLineName, FUN=mean, data = BusS)
BusS_Delay$Delay <- round(BusS_Delay$Delay/60, 2)
summary(BusS_Delay$Delay)

BusS_Delay[order(-BusS_Delay$Delay),]
BusS_AverageDelay <- round(mean(BusS_Delay$Delay),2)


##Statistical Analysis: calcaulate distance of bus trips and plot boxplot/bar chart
BusS_Dist<- aggregate(DistOriDest ~ PublishedLineName, FUN=mean, data=BusS)
BusS_Dist$DistOriDest <- round(BusS_Dist$DistOriDest,2)
summary(BusS_Dist$DistOriDest)

windows(8,6)
ggplot(BusS_Dist, aes(x = reorder(PublishedLineName, - DistOriDest), 
                      y = DistOriDest, 
                      fill = factor(BusS_Dist$PublishedLineName))) +
  geom_bar(stat = "identity", width = 0.5) +
  geom_text(aes(label = BusS_Dist$DistOriDest),position=position_dodge(width=0.5),
            hjust=0.5, vjust = -0.5, colour="black") +
  
  labs(
    x = "Bus Lines in Staten Island",
    y = "The Bus Route Length(KM)",
    title = "The Bus Route Length"
  ) + 
  theme(plot.title = element_text(hjust = 0.5),legend.position = 'none')


##Statistical Analysis: calculate distance of bus drived and plot boxplot/bar chart
BusS_DistCurr <- aggregate(DistOriCurr ~ PublishedLineName, FUN=mean, data=BusS)
BusS_DistCurr$DistOriCurr <- round(BusS_DistCurr$DistOriCurr,2)
summary(BusS_DistCurr$DistOriCurr)

windows(8,6)
ggplot(BusS_DistCurr, aes(x = reorder(PublishedLineName, - DistOriCurr), 
                      y = DistOriCurr, 
                      fill = factor(BusS_DistCurr$PublishedLineName))) +
  geom_bar(stat = "identity", width = 0.5) +
  geom_text(aes(label = BusS_DistCurr$DistOriCurr),position=position_dodge(width=0.5),
            hjust=0.5, vjust = -0.5, colour="black") +
  
  labs(
    x = "Bus Lines in Staten Island",
    y = "Distance from the Starting Point to the Current Location(KM)",
    title = "How Far the Bus Drived"
  ) + 
  theme(plot.title = element_text(hjust = 0.5),legend.position = 'none')

##############################################################################################
## Average delay time for SBS bus
BusSBS <- dplyr::filter(MTA_Dec1712_New, grepl("-SBS", MTA_Dec1712_New$PublishedLineName))
BusSBS_Delay <- aggregate(Delay ~ PublishedLineName, FUN=mean, data = BusSBS)
BusSBS_Delay$Delay <- round(BusSBS_Delay$Delay/60, 2)
summary(BusSBS_Delay$Delay)

BusSBS_Delay[order(-BusSBS_Delay$Delay),]
BusSBS_AverageDelay <- round(mean(BusSBS_Delay$Delay),2)   # 4.86 minutes
BusSBS_MedianDelay <- round(median(BusSBS_Delay$Delay),2)  # 4.58 minutes

## Average delay time for bus without SBS
BusNoSBS <- dplyr::filter(MTA_Dec1712_New, !grepl("-SBS", MTA_Dec1712_New$PublishedLineName))
BusNoSBS_Delay <- aggregate(Delay ~ PublishedLineName, FUN=mean, data = BusNoSBS)
BusNoSBS_Delay$Delay <- round(BusNoSBS_Delay$Delay/60, 2)
summary(BusNoSBS_Delay$Delay)

BusNoSBS_Delay[order(-BusNoSBS_Delay$Delay),]
BusNoSBS_AverageDelay <- round(mean(BusNoSBS_Delay$Delay),2)    # 4.78 minutes
BusNoSBS_MedianDelay <- round(median(BusNoSBS_Delay$Delay),2)   # 4.3 minutes

##############################################################################################
##############################################################################################
## Visualize the number of bus lines in 5 boroughs
BusLineName <- c("Brooklyn", "Bronx","Manhattan", "Queens", "Staten Island")
BusLineCount <- c(NumberB, NumberBx,NumberM, NumberQ, NumberS)

BusLines <- data.frame(BusLineName, BusLineCount)

summary(BusLines$BusLineCount)

##Bar Graph about Number of Bus Lines in 5 boroughs
ggplot(BusLines, aes(x = BusLineName, y = BusLineCount, fill = factor(BusLines$BusLineName))) +
  geom_bar(stat = "identity", width = 0.5, position="dodge") +
  geom_text(aes(label = BusLines$BusLineCount),position=position_dodge(width=0.5),
            hjust=0.5, vjust = -0.5, colour="black") +
  scale_fill_manual(values = c( "orange", "Red", "blue", "purple", "green")) +
  ylim(0,55) +
  labs(
    x = "Boroughs",
    y = "Number of Bus Lines",
    title = "Number of Bus Lines in Five Boroughs"
  ) + 
  theme(plot.title = element_text(hjust = 0.5),legend.position = 'none') +
  theme(axis.text.x = element_text(size = 11))

## Plot about Number of Bus Lines in 5 boroughs
ggplot(BusLines, aes(x = BusLineName, y = BusLineCount)) +
  geom_point(shape = 16, size = 3.5, color = "blue") + 
  geom_line(group = 1, size = 0.8, linetype = "solid",
            color = c("blue")) +
  geom_label(label = BusLines$BusLineCount,label.size = 0.08, 
             label.padding = unit(0.3, "lines"),
             color = ifelse(BusLines$BusLineCount >= 50, "red", "black")
             ) +
  ylim(30,58) +
  labs(
    x = "Boroughs",
    y = "Number of Bus Lines",
    title = "Number of Bus Lines in Five Boroughs"
  ) + 
  theme(plot.title = element_text(hjust = 0.5),legend.position = 'none')


##############################################################################################
## Visualize the average delay time in 5 boroughs
BusAverageDelay <- c(BusB_AverageDelay, BusBx_AverageDelay, BusM_AverageDelay,
                     BusQ_AverageDelay, BusS_AverageDelay)

BusAverageDelayFrame <- data.frame(BusLineName, BusAverageDelay)

##Scatterplot about average delay time in 5 boroughs
ggplot(BusAverageDelayFrame, aes(x = BusLineName, y = BusAverageDelay)) +
  geom_point(shape = 16, size = 3.5, color = "red") + 
  
  geom_line(group = 1, size = 0.8, linetype = "solid",
            color = c("orange")) +
  
  geom_label(label = BusAverageDelayFrame$BusAverageDelay, label.size = 0.08, 
             label.padding = unit(0.3, "lines"),
             color = ifelse(BusAverageDelayFrame$BusAverageDelay >= 5, "red", "black")) +
  
  ylim(4.3,5.4) +
  labs(
    x = "Boroughs",
    y = "Average Delay Time(Minutes)",
    title = "Average Delay Time in Five Boroughs"
  ) + 
  theme(plot.title = element_text(hjust = 0.5),legend.position = 'none') +
  theme(axis.text.x = element_text(size = 11))

#############################################################################################
## Plot boxplots on average delay time in 5 boroughs
windows(6,6)

par(mfrow=c(1,5))

par(cex.axis=2)

boxplot(BusBx$Delay/60, data = BusBx, col = "green", ylim = c(-230, 330),
        xlab="Bronx",
        ylab="Delay Time(Minutes)")

boxplot(BusB$Delay/60, data = BusB, col = "orange", ylim = c(-230, 330),
        xlab="Brooklyn")

boxplot(BusM$Delay/60, data = BusM, col = "red", ylim = c(-230, 330),
        xlab="Manhattan")

boxplot(BusQ$Delay/60, data = BusQ, col = "blue", ylim = c(-230, 330),
        xlab="Queens")

boxplot(BusS$Delay/60, data = BusS, col = "skyblue", ylim = c(-230, 330),
        xlab="Staten Island")

par(mfrow=c(1,1))

#############################################################################################
## Plot boxplots on the distance from the starting point to the current location, 
## and the bus route length side by side
windows(6,6)

par(mfrow=c(1,2))
boxplot(MTA_Dec1712_New$DistOriCurr, data = MTA_Dec1712_New, ylim = c(0,22),
        col = "orange", xlab="The Distance from the Starting Point \n to the Current Location",
        ylab="Distance(KM)")
text(y = boxplot.stats(MTA_Dec1712_New$DistOriCurr)$stats, 
     labels = boxplot.stats(MTA_Dec1712_New$DistOriCurr)$stats, x = 1.35)

boxplot(MTA_Dec1712_New$DistOriDest, data = MTA_Dec1712_New, ylim = c(0,22),
        col = "blue", xlab="The Bus Route Length",
        ylab="Distance(KM)")
text(y = boxplot.stats(MTA_Dec1712_New$DistOriDest)$stats, 
     labels = boxplot.stats(MTA_Dec1712_New$DistOriDest)$stats, x = 1.35)
par(mfrow=c(1,1))

#summary(MTA_Dec1712_New$DistOriCurr)
#summary(MTA_Dec1712_New$DistOriDest)

#############################################################################################
## Visualize relationship between how far the bus drived and the delay time
## Based on Records between 3:00 and 23:00

windows(6,6)

## Based on Records between 3:00 to 23:00
ggplot(MTA_Dec1712_New, aes(x = DistOriCurr, y = Delay/60)) +
  geom_point(shape = 16, size = 2, color = "black", alpha = 0.4) + 
  geom_smooth(method = "lm") + 
  labs(
    x = "Distance from the Starting Point to the Current Location(KM)",
    y = "Delay Time(Minutes)",
    title = "Based on Records between 3:00 and 23:00" ) + 
  theme(plot.title = element_text(hjust = 0.5),legend.position = 'none')

## Based on Records between 17:00 and 19:00
MTA_Dec1712_New_Around18 <- filter(MTA_Dec1712_New, hours(RecordedAtTime) >= 17 & hours(RecordedAtTime) < 19)

windows(6,6)
ggplot(MTA_Dec1712_New_Around18, aes(x = DistOriCurr, y = Delay/60)) +
  geom_point(shape = 16, size = 2, color = "orange", alpha = 0.4) + 
  geom_smooth(method = "lm") + 
  labs(
    x = "Distance from the Starting Point to the Current Location(KM)",
    y = "Delay Time(Minutes)",
    title = "Based on Records between 17:00 and 19:00") + 
  theme(plot.title = element_text(hjust = 0.5),legend.position = 'none')

#############################################################################################
## Visualize relationship between the bus route length and the delay time
## Based on Records between 3:00 and 23:00
windows(6,6)
ggplot(MTA_Dec1712_New, aes(x = DistOriDest, y = Delay/60)) +
  geom_point(shape = 16, size = 2, color = "black", alpha = 0.4) + 
  geom_smooth(method = "lm") + 
  #ylim(30,56) +
  labs(
    x = "The Bus Route Length(KM)",
    y = "Delay Time(Minutes)",
    title = "Based on Records between 3:00 and 23:00"
  ) + 
  theme(plot.title = element_text(hjust = 0.5),legend.position = 'none')

## Based on Records between 17:00 and 19:00
windows(6,6)
ggplot(MTA_Dec1712_New_Around18, aes(x = DistOriDest, y = Delay/60)) +
  geom_point(shape = 16, size = 2, color = "orange", alpha = 0.4) + 
  geom_smooth(method = "lm") + 
  #ylim(30,56) +
  labs(
    x = "The Bus Route Length(KM)",
    y = "Delay Time(Minutes)",
    title = "Based on Records between 17:00 and 19:00"
  ) + 
  theme(plot.title = element_text(hjust = 0.5),legend.position = 'none')

#############################################################################################
##Correlation Analysis
cor_value <- cor(MTA_Dec1712_New$Delay, MTA_Dec1712_New$DistOriCurr, method="spearman")
cor(MTA_Dec1712_New$Delay, MTA_Dec1712_New$DistOriDest, method="spearman")

test_value <- cor_value * sqrt((nrow(MTA_Dec1712_New)-2)/(1-(cor_value)^2))   #460.73

#############################################################################################
##Linear Regression Analysis
MTA_Dec1712_New.lmfit <- lm(Delay ~ DistOriCurr + DistOriDest, data = MTA_Dec1712_New)
summary(MTA_Dec1712_New.lmfit)


#############################################################################################
##Analyze relationship between record time and delay 
MTA_Dec1712_New$RecordedAtTime <- as.POSIXct(MTA_Dec1712_New$RecordedAtTime,
                                  format = "%Y-%m-%d %H:%M:%S",
                                  tz = "GMT")

##Group BusS by Days and Hours according to "RecordedAtTime". 
summary.MTA_Dec1712_New <- MTA_Dec1712_New %>%
  group_by(weekdays(RecordedAtTime), hours(RecordedAtTime)) %>%
  summarise(mean(Delay))  %>%
  ungroup

names(summary.MTA_Dec1712_New) <- c("DayOfWeek", "Hour", "Delay")

day_of_week <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
                 "Saturday", "Sunday")

plot.df <- data.frame(NULL)

for (d in day_of_week) {
  for (h in (0:23)) 
  {
    plot.df <- bind_rows(plot.df, filter(summary.MTA_Dec1712_New, DayOfWeek == d, Hour == h))
  }
}

plot.df$Delay <- round(plot.df$Delay/60, 2)

##Plot average delay time in week
windows(8,6)
ggplot(plot.df, aes(x = 1:nrow(plot.df), y = Delay)) +
  geom_line(color = "red", size = 1.0) +
  labs(title = "Average Delay Time of All Bus Lines", 
       x = "Day of Week (December 2017)",
       y = "Average Delay Time (Minutes)") +
  scale_x_continuous(breaks = seq(1, nrow(plot.df), nrow(plot.df) / 7),
                     labels = day_of_week) + 
  theme(plot.title = element_text(hjust = 0.5))


##Plot average delay time in each day
hours_in_day <- c("3:00", "4:00", "5:00", "6:00", "7:00", "8:00", "9:00", "10:00", "11:00", "12:00",
                  "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00")


PlotDaysDelay <- function(df, title, xlabel) 
{
  windows(8,4)
  ggplot(df, aes(x = 1:nrow(df), y = Delay)) +
    geom_line(color = "red", size = 1.0) +
    labs(title = title, 
         x = xlabel,
         y = "Average Delay Time(Minutes)") +
    scale_x_continuous(breaks = seq(1, nrow(df), nrow(df) / 20),
                       labels = paste0(hours_in_day, "")) +
    theme(plot.title = element_text(hjust = 0.5))
  
}

##plot average delay time in Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
Monday.df <- dplyr::filter(plot.df, grepl("Monday", plot.df$DayOfWeek))
PlotDaysDelay(Monday.df, "Average Delay Time on Moday", "Monday")

Tuesday.df <- dplyr::filter(plot.df, grepl("Tuesday", plot.df$DayOfWeek))
PlotDaysDelay(Tuesday.df, "Average Delay Time on Tuesday", "Tuesday")

Wednesday.df <- dplyr::filter(plot.df, grepl("Wednesday", plot.df$DayOfWeek))
PlotDaysDelay(Wednesday.df, "Average Delay Time on Wednesday", "Wednesday")

Thursday.df <- dplyr::filter(plot.df, grepl("Thursday", plot.df$DayOfWeek))
PlotDaysDelay(Thursday.df, "Average Delay Time on Thursday", "Thursday")

Friday.df <- dplyr::filter(plot.df, grepl("Friday", plot.df$DayOfWeek))
PlotDaysDelay(Friday.df, "Average Delay Time on Friday", "Friday")

Saturday.df <- dplyr::filter(plot.df, grepl("Saturday", plot.df$DayOfWeek))
PlotDaysDelay(Saturday.df, "Average Delay Time on Saturday", "Saturday")

Sunday.df <- dplyr::filter(plot.df, grepl("Sunday", plot.df$DayOfWeek))
PlotDaysDelay(Sunday.df, "Average Delay Time on Sunday", "Sunday")

