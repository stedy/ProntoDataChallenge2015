###############################################################################
# growthPlot.R
#
# Attempts to display weekly growth in ridership for the selected df subset

if (FALSE) {

  dataList <- list(df=df)
  infoList <- list()
  textList <- list(dayLabels=c('Mon','Tue','Wed','Thu','Fri','Sat','Sun'),
                   monthLabels=c('Nov','Dec','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct'))

}

growthPlot <- function(dataList, infoList, textList) {
  
  # ----- Style ---------------------------------------------------------------

  # Overall
  spreadFactor <- 5
  col_text <- 'gray40'
  font <- 2
  
  # Timeseries
  lwd <- 6
  col_weekday <- 'gray70'
  col_weekend <- 'palevioletred1'
  colors <- c(rep(col_weekday,5),rep(col_weekend,2))

  # Vertical month lines
  lty_vert <- 3
  lwd_vert <- 3
  col_vert <- 'gray70'
  
  # Horizontal eye guides
  lty_hor <- 1
  lwd_hor <- 2
  col_hor <- 'gray95'
  
  # Labels
  label_hadj <- 0.6
  
  # ----- Data Preparation ----------------------------------------------------
  
  # Get dataframe from the dataList
  df <- dataList$df

  # Create a table of # of rides
  tbl <- table(df$weeksSinceStart,df$dayOfWeek)
  
  
  # Create an X axis
  week <- seq(lubridate::ymd('2014-10-13',tz='America/Los_Angeles'),
              lubridate::ymd('2015-10-13',tz='America/Los_Angeles'),
              by="weeks")

  # Get appropriate limits
  maxValue <- max(tbl)
  
  # ----- Plot ----------------------------------------------------------------
  
  # Create a blank plot with the proper limits
  plot(tbl[,1] ~ week, col='transparent',
       ylim=c(0, maxValue*spreadFactor*1.05),
       axes=FALSE,
       xlab='', ylab='')
  
  # Add vertical grid lines at the first Monday the month
  newMonthIndex <- which(diff(lubridate::month(week)) != 0)
  newMonthMonday <- week[newMonthIndex]
  abline(v=newMonthMonday, lty=lty_vert, lwd=lwd_vert, col=col_vert)

  # Add ~20 horizontal grid lines to guide the eye
  ypos <- seq(par('usr')[3],par('usr')[4],length.out=20)
  abline(h=ypos, lty=lty_hor, lwd=lwd_hor, col=col_hor)
  
  # Add dayOfWeek lines, each offset a little 
  offset <- (maxValue/7) * (spreadFactor)
  for (i in 1:7) {
    value <- tbl[,i] + (7-i)*offset
    points(value[1:52] ~ week[1:52], type='s', col=colors[i], lwd=lwd)
    # Add  a shifted line with 'S' to get a horizontal line for the last complete week
    points(value[1:52] ~ week[2:53], type='S', col=colors[i], lwd=lwd)
    # Annotate
    text(week[1], value[1], textList$dayLabels[i], pos=2, font=font, col=col_text, xpd=NA)
  }
  
  
  # ---- Annotations ----------------------------------------------------------
  
  # X axis
  xpos <- newMonthMonday
  ypos <- label_hadj * (par('usr')[3]) # Note that usr[3] is a negative value
  text(xpos, ypos, textList$monthLabels, pos=4, font=font, col=col_text)
  
}