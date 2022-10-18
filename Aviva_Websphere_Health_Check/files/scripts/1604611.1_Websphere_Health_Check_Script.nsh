#!/bin/nsh
:> /tmp/Websphere-output.txt
EMAILDL=$2
EMAILID=$3
EMAIL_SUBJECT="Websphere health check report"
input_file=//ukncsaviv226.via.novonet/var/WebSphere/input_server_list.txt

touch /c/tmp/Websphere-status.txt
touch /c/tmp/Websphere-status1.txt
echo "JVMNAME,Status,APPNAME,HOSTNAME" > /c/tmp/Websphere-status.txt
echo "JVMNAME,Status,APPNAME,HOSTNAME" > /c/tmp/Websphere-status1.txt

#echo "Email ID is : $EMAIL"

for i in `cat $input_file`
do
servername=$i
echo "Servername is - $servername"
touch //$servername/tmp/Websphere-output.txt
chmod 777 //$servername/tmp/Websphere-output.txt

echo "Running the WebSphere-Monitor script on $servername..."

if [[ "${servername}" = "auvlud1prapp97.avivagroup.com" ]] || [[ "${servername}" = "auvlud1prapp98.avivagroup.com" ]] 
then
     nexec $servername "su - svcicnihsprd -c '/app/Monitoring_Scripts/WebSphere-Monitor/WebSphere-Monitor.sh >/tmp/Websphere-output.txt'"
	 echo "Redirecting the errorlog output to tmp file....."
     #cat //$servername/tmp/websphere_nagios_err.log >> //$servername/tmp/Websphere-output.txt
     cat //$servername/tmp/Websphere-output.txt
elif [[ "${servername}" = "auvlud1prapp99.avivagroup.com" ]] || [[ "{$servername}" = "{auvlud1prap100.avivagroup.com}" ]] || [[ "${servername}" = "auvlud1prap101.avivagroup.com" ]] 
then
     nexec $servername "su - svcicnwasprd -c '/app/MONITORING_SCRIPTS/WebSphere-Monitor/WebSphere-Monitor.sh >/tmp/Websphere-output.txt'"
	 echo "Redirecting the errorlog output to tmp file....."
     #cat //$servername/tmp/websphere_nagios_err.log >> //$servername/tmp/Websphere-output.txt
     cat //$servername/tmp/Websphere-output.txt
else
   	 nexec $servername "su - nxwaspr -c '/home/users/nxwaspr/WebSphere-Monitor/WebSphere-Monitor.sh >/tmp/Websphere-output.txt'"
	 echo "Redirecting the errorlog output to tmp file....."
     #cat //$servername/tmp/websphere_nagios_err.log >> //$servername/tmp/Websphere-output.txt
     cat //$servername/tmp/Websphere-output.txt

fi

#nexec $servername //$servername/home/users/nxwaswpr/WebSphere-Monitor/WebSphere-Monitor.sh &> //$servername/tmp/Websphere-output.txt
#nexec $servername "su - nxwaspr -c '/home/users/nxwaspr/WebSphere-Monitor/WebSphere-Monitor.sh >/tmp/Websphere-output.txt'"
#cat //$servername/tmp/Websphere-output.txt


#MDM=`grep 'reported OK' //$servername/tmp/Websphere-output.txt |grep 'MDM'| grep -e 'C1_S1' -e 'C1_S2' -e 'C2_S1' -e 'C3_S1' -e 'C4_S1' | awk -F " " '{print $(NF -2) }'`
MDMOK=`grep 'reported OK' //$servername/tmp/Websphere-output.txt |grep 'MDM'| grep UK_PRD | grep -v HTTP| grep -v ICN |grep -e 'C1_S1' -e 'C1_S2' -e 'C2_S1' -e 'C3_S1' -e 'C4_S1' | awk -F " " '{print $(NF -2) }'`

MDMNOTOK=`grep 'JVMERROR' //$servername/tmp/Websphere-output.txt |grep 'MDM'| grep -e 'C1_S1' -e 'C1_S2' -e 'C2_S1' -e 'C3_S1' -e 'C4_S1'|cut -f1 -d' '`

MDMWeb=`grep 'IHS is running' //$servername/tmp/Websphere-output.txt |grep 'UK_PRD'| grep -e 'HTTP' -e 'HTTP1' -e 'HTTP2'|awk '{ print $NF }'`

MDMWeb1=`grep 'JVMERROR' //$servername/tmp/Websphere-output.txt |grep 'UK_PRD'| grep -e 'HTTP' -e 'HTTP1' -e 'HTTP2' | grep 'IHS_ICN_APS' |cut -f1 -d' '`

MDMIHS=`grep 'IHSERR' //$servername/tmp/Websphere-output.txt |grep 'UK_PRD'| grep -e 'HTTP' -e 'HTTP1' -e 'HTTP2'|awk '{ print $NF }'`

TLMOK=`grep 'reported OK' //$servername/tmp/Websphere-output.txt |grep 'UKLTLM'| grep -e 'C1_S1' -e 'C1_S2' -e 'C2_S1' -e 'C3_S1' -e 'C4_S1' | awk -F " " '{print $(NF -2) }'`

TLMNOTOK=`grep 'JVMERROR' //$servername/tmp/Websphere-output.txt |grep 'UKLTLM'| grep -e 'C1_S1' -e 'C1_S2' -e 'C2_S1' -e 'C3_S1' -e 'C4_S1'|cut -f1 -d' '`

TLMIHS=`grep 'IHSERR' //$servername/tmp/Websphere-output.txt |grep 'UKLTLM' |grep -e 'C1_S1' -e 'C1_S2' -e 'C2_S1' -e 'C3_S1' -e 'C4_S1' | awk -F " " '{print $(NF -2) }'`

NQOK=`grep 'reported OK' //$servername/tmp/Websphere-output.txt |grep 'UKLNET'| grep -e 'C1_S1' -e 'C1_S2' -e 'C2_S1' -e 'C3_S1' -e 'C4_S1' | awk -F " " '{print $(NF -2) }'`

NQNOTOK=`grep 'JVMERROR' //$servername/tmp/Websphere-output.txt |grep 'UKLNET'| grep -e 'C1_S1' -e 'C1_S2' -e 'C2_S1' -e 'C3_S1' -e 'C4_S1'|cut -f1 -d' '`

NQWeb=`grep 'IHS is running' //$servername/tmp/Websphere-output.txt |grep 'UKLNET'|awk '{print $NF}'`

NQIHS=`grep 'IHSERR' //$servername/tmp/Websphere-output.txt |grep 'UKLNET'|grep 'UKLNET'|awk '{print $NF}'`
	
SASOK=`grep 'reported OK' //$servername/tmp/Websphere-output.txt|grep 'UKHSA1'| grep -e 'C1_S1' -e 'C2_S1' -e 'C3_S1' -e 'C4_S1' |awk -F " " '{print $(NF -2) }'`

SASNOTOK=`grep 'JVMERROR' //$servername/tmp/Websphere-output.txt |grep 'UKHSA1'| grep -e 'C1_S1' -e 'C2_S1' -e 'C3_S1' -e 'C4_S1' |cut -f1 -d' '`

SASWeb=`grep 'IHS is running' //$servername/tmp/Websphere-output.txt |grep 'UKHSA1'|awk '{print $NF}'`

SASIHS=`grep 'IHSERR' //$servername/tmp/Websphere-output.txt |grep 'UKHSA1'|awk '{print $NF}'`
	
HawkeyeOK=`grep 'reported OK' //$servername/tmp/Websphere-output.txt |grep 'UKGHAW'| grep 'C1_S1' -e 'C1_S2' -e 'C2_S1' -e 'C3_S1' -e 'C4_S1' | grep -e 'WAS1' -e 'WAS2'| awk -F " " '{print $(NF -2) }'`

HawkeyeNOTOK=`grep 'JVMERROR' //$servername/tmp/Websphere-output.txt |grep 'UKGHAW'| grep 'C1_S1' -e 'C1_S2' -e 'C2_S1' -e 'C3_S1' -e 'C4_S1'| grep -e 'WAS1' -e 'WAS2'|cut -f1 -d' '`

HawkeyeWeb=`grep 'IHS is running' //$servername/tmp/Websphere-output.txt |grep 'UKGHAW'|awk '{print $NF}'`

HawkeyeIHS=`grep 'IHSERR' //$servername/tmp/Websphere-output.txt |grep 'UKGHAW'|awk '{print $NF}'`

GWPCOK=`grep 'reported OK' //$servername/tmp/Websphere-output.txt |grep 'UKGGPC'| grep -e 'C1_S1' -e 'C1_S2' -e 'C2_S1' -e 'C3_S1' -e 'C4_S1' | awk -F " " '{print $(NF -2) }'`

GWPCNOTOK=`grep 'JVMERROR' //$servername/tmp/Websphere-output.txt |grep 'UKGGPC'| grep -e 'C1_S1' -e 'C1_S2' -e 'C2_S1' -e 'C3_S1' -e 'C4_S1'|cut -f1 -d' '`

GWPCWeb=`grep 'IHS is running' //$servername/tmp/Websphere-output.txt |grep 'UKGGPC'|awk '{print $NF}'`

GWPCIHS=`grep 'IHSERR' //$servername/tmp/Websphere-output.txt |grep 'UKGGPC'|awk '{print $NF}'`
	
ICNOK=`grep 'server1' //$servername/tmp/Websphere-output.txt | grep 'reported OK'|awk -F " " '{print $(NF -2) }'`

ICNNOTOK=`grep 'JVMERROR' //$servername/tmp/Websphere-output.txt |grep 'server1' | cut -f1 -d' '`

ICNWeb=`grep 'IHS is running' //$servername/tmp/Websphere-output.txt |grep 'httpd'|awk '{print $NF}'`

ICNIHS=`grep 'IHSERR' //$servername/tmp/Websphere-output.txt |grep 'httpd'|awk '{print $NF}'`
	
echo "Capturing the JVM details for next steps...."

for JVM in $MDMOK
do
echo "$JVM,OK,MDM,$servername" >> /c/tmp/Websphere-status.txt
done

for JVM in $MDMNOTOK
do
echo "$JVM,NOT_OK,MDM,$servername" >> /c/tmp/Websphere-status1.txt
done

for JVM in $MDMWeb
do
echo "$JVM,IHS_RUNNING,MDM,$servername" >> /c/tmp/Websphere-status.txt
done

for JVM in $MDMWeb1
do
echo "$JVM,NOT_OK,MDM,$servername" >> /c/tmp/Websphere-status1.txt
done

for JVM in $MDMIHS
do
echo "$JVM,NOT_OK,MDM,$servername" >> /c/tmp/Websphere-status1.txt
done

for JVM in $TLMOK
do
echo "$JVM,OK,TLM,$servername" >> /c/tmp/Websphere-status.txt
done

for JVM in $TLMNOTOK
do
echo "$JVM,NOT_OK,TLM,$servername" >> /c/tmp/Websphere-status.txt
done

for JVM in $TLMIHS
do
echo "$JVM,NOT_OK,TLM,$servername" >> /c/tmp/Websphere-status1.txt
done

for JVM in $NQOK
do
echo "$JVM,OK,NQ,$servername" >> /c/tmp/Websphere-status.txt
done

for JVM in $NQNOTOK
do
echo "$JVM,NOT_OK,NQ,$servername" >> /c/tmp/Websphere-status1.txt
done

for JVM in $NQWeb
do
echo "$JVM,IHS_Running,NQ,$servername" >> /c/tmp/Websphere-status.txt
done

for JVM in $NQIHS
do
echo "$JVM,NOT_OK,NQ,$servername" >> /c/tmp/Websphere-status1.txt
done

for JVM in $SASOK
do
echo "$JVM,OK,SAS,$servername" >> /c/tmp/Websphere-status.txt
done

for JVM in $SASNOTOK
do
echo "$JVM,NOT_OK,SAS,$servername" >> /c/tmp/Websphere-status1.txt
done

for JVM in $SASWeb
do
echo "$JVM,IHS_Running,SAS,$servername" >> /c/tmp/Websphere-status.txt
done

for JVM in $SASIHS
do
echo "$JVM,NOT_OK,SAS,$servername" >> /c/tmp/Websphere-status1.txt
done

for JVM in $HawkeyeOK
do
echo "$JVM,OK,Hawkeye,$servername" >> /c/tmp/Websphere-status.txt
done

for JVM in $HawkeyeNOTOK
do
echo "$JVM,NOT_OK,Hawkeye,$servername" >> /c/tmp/Websphere-status1.txt
done

for JVM in $HawkeyeWeb
do
echo "$JVM,IHS_Running,Hawkeye,$servername" >> /c/tmp/Websphere-status.txt
done

for JVM in $HawkeyeIHS
do
echo "$JVM,NOT_OK,Hawkeye,$servername" >> /c/tmp/Websphere-status1.txt
done

for JVM in $GWPCOK
do
echo "$JVM,OK,GWPC,$servername" >> /c/tmp/Websphere-status.txt
done

for JVM in $GWPCNOTOK
do
echo "$JVM,NOT_OK,GWPC,$servername" >> /c/tmp/Websphere-status1.txt
done

for JVM in $GWPCWeb
do
echo "$JVM,IHS_Running,GWPC,$servername" >> /c/tmp/Websphere-status.txt
done

for JVM in $GWPCIHS
do
echo "$JVM,NOT_OK,GWPC,$servername" >> /c/tmp/Websphere-status1.txt
done

for JVM in $ICNOK
do
echo "$JVM,OK,ICN,$servername" >> /c/tmp/Websphere-status.txt
done

for JVM in $ICNNOTOK
do
echo "$JVM,NOT_OK,ICN,$servername" >> /c/tmp/Websphere-status1.txt
done

for JVM in $ICNWeb
do
echo "$JVM,IHS_Running,ICN,$servername" >> /c/tmp/Websphere-status.txt
done

for JVM in $ICNIHS
do
echo "$JVM,NOT_OK,ICN,$servername" >> /c/tmp/Websphere-status1.txt
done

done

echo "Converting from txt to CSV ......."
sed 's/ \+/,/g' /c/tmp/Websphere-status.txt > /c/tmp/Websphere-output.csv
sed 's/ \+/,/g' /c/tmp/Websphere-status1.txt > /c/tmp/Websphere-output2.csv
#sed 's/ \+/,/g' /c/tmp/Websphere-status2.txt > /c/tmp/Websphere-output3.csv

echo "Sorting the CSV file by application status ...."
#head -n 1 /c/tmp/Websphere-output.csv && tail -n+2 /c/tmp/Websphere-output.csv | sort -t ',' -k3 > /c/tmp/Websphere-output.csv
head -n 1 /c/tmp/Websphere-output.csv > /c/tmp/Websphere-output1.csv
tail -n+2 /c/tmp/Websphere-output.csv | sort -t ',' -k3 >> /c/tmp/Websphere-output1.csv
head -n 1 /c/tmp/Websphere-output2.csv > /c/tmp/Websphere-output3.csv
tail -n+2 /c/tmp/Websphere-output2.csv | sort -t ',' -k3 >> /c/tmp/Websphere-output3.csv

echo "Converting the output from CSV to HTML......"

cat <<EOF > /c/tmp/WebsphereHealthReport1.html
<!DOCTYPE html>
<html>
<head>
<h4>JVM's with OK Status </h4>
<style>
table, th, td {
border: 1px solid black;
border-collapse: collapse;
}
th {background-color: yellow}
</style>
</head>
<body>
EOF

awk -F, 'BEGIN{print "<table>";}
NR==1 { cell="th" ; }
{ print "<tr>";
for(i=1;i<=NF;i++) printf "<%s>%s</%s>",cell,$i,cell ;
print "</tr>" ; cell="td" }
END{print "</table>"}' /c/tmp/Websphere-output1.csv >> /c/tmp/WebsphereHealthReport1.html
echo "</body>" >> /c/tmp/WebsphereHealthReport1.html
echo "</html>" >> /c/tmp/WebsphereHealthReport1.html

echo " converting csv to html2.."
cat <<EOF > /c/tmp/WebsphereHealthReport2.html
<!DOCTYPE html>
<html>
<head>
<h4>JVM's with NOT_OK status </h4>
<style>
table, th, td {
border: 1px solid black;
border-collapse: collapse;
}
th {background-color: yellow}
</style>
</head>
<body>
EOF

awk -F, 'BEGIN{print "<table>";}
NR==1 { cell="th" ; }
{ print "<tr>";
for(i=1;i<=NF;i++) printf "<%s>%s</%s>",cell,$i,cell ;
print "</tr>" ; cell="td" }
END{print "</table>"}' /c/tmp/Websphere-output3.csv >> /c/tmp/WebsphereHealthReport2.html
echo "</body>" >> /c/tmp/WebsphereHealthReport2.html
echo "</html>" >> /c/tmp/WebsphereHealthReport2.html

echo "Add two html tables.."
#powershell.exe -command "(Get-Content "c:\tmp\WebsphereHealthReport.html") + (Get-Content "c:\tmp\WebsphereHealthReport2.html") | Set-Content "c:\tmp\Webspherecombined.html""
cat /tmp/WebsphereHealthReport2.html >> /tmp/WebsphereHealthReport.html && cat /tmp/WebsphereHealthReport1.html >> /tmp/WebsphereHealthReport.html
echo "Sending the HTML report on email..... "

#blcli_execute Email sendMailWithAttachment bsaserverautomation@atos.net "$EMAIL" "$EMAIL_SUBJECT" "find below document" "/c/tmp" "WebsphereHealthReport.html"
blcli_execute Email sendMailWithAttachment bsaserverautomation@atos.net "$EMAILID" "$EMAIL_SUBJECT" "find below document" "/c/tmp" "WebsphereHealthReport.html"
blcli_execute Email sendMailWithAttachment bsaserverautomation@atos.net "$EMAILDL" "$EMAIL_SUBJECT" "find below document" "/c/tmp" "WebsphereHealthReport.html"


echo "Clearing the temporary supporting files"

sleep 30
> /c/tmp/Websphere-status.txt
> /c/tmp/Websphere-status1.txt
> /c/tmp/WebsphereHealthReport.html
> /c/tmp/Websphere-output1.csv
> /c/tmp/Websphere-output3.csv
