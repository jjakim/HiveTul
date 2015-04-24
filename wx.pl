#
# Get the weather from a local wx station via weatherunderground
#
curl --retry 5 http://api.wunderground.com/weatherstation/WXCurrentObXML.asp?ID=$WX_ID > /tmp/wx.xml
temp_f=`grep temp_f /tmp/wx.xml | grep  -o "[0-9]*\.[0-9]*"`
temp_c=`grep temp_c /tmp/wx.xml | grep  -o "[0-9]*\.[0-9]*"`
relative_humidity=`grep relative_humidity /tmp/wx.xml | grep  -o "[0-9]*"`
wind_dir=`grep wind_dir /tmp/wx.xml | grep -o "[A-Z]*"`
wind_mph=`grep wind_mph /tmp/wx.xml | grep  -o "[0-9]*\.[0-9]*"`
wind_gust_mph=`grep wind_gust_mph /tmp/wx.xml |  grep  -o "[0-9]*\.[0-9]*"`
pressure_mb=`grep pressure_mb /tmp/wx.xml |  grep  -o "[0-9]*\.[0-9]*"`
dewpoint_f=`grep dewpoint_f /tmp/wx.xml |  grep  -o "[0-9]*\.[0-9]*"`
#solar_radiation=`grep solar_radiation /tmp/wx.xml |  grep  -o "[0-9]*"`
precip_1hr_in=`grep precip_1hr_in /tmp/wx.xml |  grep  -o "[0-9]*\.[0-9]*"`
precip_today_in=`grep precip_today_in /tmp/wx.xml |  grep  -o "[0-9]*\.[0-9]*"`
#\