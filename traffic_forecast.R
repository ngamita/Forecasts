# Simple script to use
# Default ts() package to forecast traffic count. 
# Dataset: traffic_data.csv

# Author: 'Richard Ngamta', 'ngamita@gmail.com'

# check for directory, else create one. 
if(!file('traffic')){
  #print('hello')
  dir.create('traffic')
}

# Load the forecasting and time series packages. 
require(forecast)
require(xts)

# Set wd to 'traffic'
setwd('traffic/')

# Download the traffic_data.csv from dropbox.
fileUrl <- 'https://www.dropbox.com/s/cbufz4f0rd11tl1/traffic_data.csv'
download.file(fileUrl, destfile='traffic_data.csv', method='wget') # Use method='curl' non *nix 

# Load data into R memory/data frame. df == data frame, csv and got a header. 
traffic_df <- read.csv('traffic_data.csv', sep=',', header=TRUE)

# Check if loaded fine. 
head(traffic_df)

# Format the date, to R readable date and
# not Char strings.
traffic_df$datetime = as.Date(traffic_df$datetime,format="%Y-%m-%d")

# Convert to xts
traffic_df_xts = xts(x=traffic_df$count, order.by=traffic_df$datetime)

# We need to get a start date from data, i got (68)
# How did i do that. Check next
# > head(traffic_df)
# > as.POSIXlt(i = "2014-03-10", origin="2014-03-10")$yday
##    [1] 68
# Add one since that starts at "0" and convert to normal ts()
traffic_df_ts = ts(traffic_df_xts, freq=365, start=c(2014, 68))
png('Traffic_forecast.png')
plot(forecast(ets(traffic_df_ts), 1), main="Traffic Forecast")
dev.off()


# Ignore the frequenxy warnings.
# Check the downloaded plot in same folder/dir. 
# Note from graphs that 2014.4 means "day number 365 * 0.4" (day 146 in the year).
# So actual date is run > as.Date(146, origin="2014-03-10")
# Answer: "2014-08-03"
# This is just the default method, using othee methods lile ARIMA, works better. 